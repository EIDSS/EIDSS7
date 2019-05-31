
--=====================================================================================================
-- Author:		Phil Shaffer
-- Description:	Takes an HACode and breaks it down into a CSV with the names of the bitmasks that make it up.
--
-- 1) If @HACode = NULL returns NULL
-- 2) If @HACode = 0 returns corresponding entry from [trtHACodeList] table (i.e "None")
-- 3) A string of [intHACode] values that matched a bitwise AND with @HACode (e.g. 34 => "Human,Livestock").
-- 4) Names of [intHACode] values returned in the string are in ascending order of the [intHACode] values.
-- 5) This implementation will only execute on SQL Server 2017 or greater due to use of function "STRING_AGG".
-- 6) If passed an invalid @HACode that doesn't match any of the bitmasks, return the value of none (i.e. "None").
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Philip Shaffer	2018/09/27 Created for EIDSS 7.0.
-- Ricky Moss		2019/02/09	Added space after comma
-- 
-- Test Code:
-- declare @LangID nvarchar(50) = N'en';
-- declare @HACode int = -1; -- any bitwise OR'd values from table [trtHACodeList]. Value -1 will match all. Value NULL will return NULL.
-- select dbo.FN_GBL_HACodeNames_ToCSV(@LangID, @HACode);
-- 
--=====================================================================================================

CREATE FUNCTION [dbo].[FN_GBL_HACodeNames_ToCSV]
(
	@LangID		NVARCHAR(50),
	@HACode		BIGINT
)
RETURNS NVARCHAR(4000)
AS
BEGIN

DECLARE
@CSV				NVARCHAR(4000) = N'', -- size string returned by STRING_AGG
@LanguageCode		BIGINT = dbo.fnGetLanguageCode(@LangID);

	-- if passed a null, we return a null result
	IF (@HACode IS NULL) return NULL;

	-- if not passed a zero, we process the list
	IF (@HACode <> 0)
	BEGIN

		WITH cteOrderedResults([intHACode], [strDisplayText]) as
		(
			SELECT TOP 100 PERCENT 
				hcl.[intHACode],
				COALESCE(snt.[strTextString], br.[strDefault]) as [strDisplayText]
			FROM [dbo].[trtHACodeList] as hcl
			INNER JOIN [dbo].[trtBaseReference] as br
				ON hcl.[idfsCodeName] = br.[idfsBaseReference]
			LEFT OUTER JOIN [dbo].[trtStringNameTranslation] as snt
				ON hcl.[idfsCodeName] = snt.[idfsBaseReference]
				AND snt.[idfsLanguage] = @LanguageCode
			WHERE
				(hcl.[intHACode] <> 0)
				AND ((@HACode & hcl.[intHACode]) = hcl.[intHACode])
			ORDER BY hcl.[intHACode] ASC
		)

		SELECT @CSV = STRING_AGG([strDisplayText], N', ')
		FROM cteOrderedResults;	-- needed CTE to get ordered result set due to AGGREGATE function

		-- do we have a valid result to return?
		IF (@CSV IS NOT NULL AND LEN(@CSV) > 0)
			RETURN @CSV; -- yes

	END

	-- if we got to here, then we need to return the display text for HACode zero (i.e. "None").
	SELECT TOP 1
		@CSV = COALESCE(snt.[strTextString], br.[strDefault])
	FROM [dbo].[trtHACodeList] as hcl
	INNER JOIN [dbo].[trtBaseReference] as br
		ON hcl.[idfsCodeName] = br.[idfsBaseReference]
	LEFT OUTER JOIN [dbo].[trtStringNameTranslation] as snt
		ON hcl.[idfsCodeName] = snt.[idfsBaseReference]
		AND snt.[idfsLanguage] = @LanguageCode
	WHERE
		hcl.[intHACode] = 0;

	RETURN @CSV;

END
