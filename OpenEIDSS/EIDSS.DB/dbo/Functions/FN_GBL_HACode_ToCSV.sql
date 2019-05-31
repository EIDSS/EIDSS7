
--=====================================================================================================
-- Author:		Phil Shaffer
-- Description:	Takes an HACode and breaks it down into a CSV
--
-- 1) If @HACode = NULL returns NULL
-- 2) If @HACode = 0 returns corresponding entry from [trtHACodeList] table (i.e "0")
-- 3) A string of [intHACode] values that matched a bitwise AND with @HACode (e.g. 34 => "2,32").
-- 4) [intHACode] values returned in the string are in ascending order.
-- 5) This implementation will only execute on SQL Server 2017 or greater due to use of function "STRING_AGG".
-- 6) If passed an invalid @HACode that doesn't match any of the bitmasks, return the value of none (i.e. "0").
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Philip Shaffer	2018/09/26 Created for EIDSS 7.0.
--
-- 
-- Test Code:
-- declare @LangID nvarchar(50) = N'en';
-- declare @HACode int = -1; -- any bitwise OR'd values from table [trtHACodeList]. Value -1 will match all. Value NULL will return NULL.
-- select dbo.FN_GBL_HACode_ToCSV(@LangID, @HACode);
-- 
--=====================================================================================================

CREATE FUNCTION [dbo].[FN_GBL_HACode_ToCSV]
(
	@LangID		NVARCHAR(50),
	@HACode		BIGINT
)
RETURNS NVARCHAR(4000)
AS
BEGIN

DECLARE
@CSV				NVARCHAR(4000) = N''; -- size string returned by STRING_AGG

	-- if passed a null, we return a null result
	IF (@HACode IS NULL) return NULL;

	-- if passed a zero, we return only a zero and avoid query overhead
	IF (@HACode = 0) return N'0'; 

	WITH cteOrderedResults([intHACode]) as
	(
		SELECT TOP 100 PERCENT 
			[intHACode]
		FROM [dbo].[trtHACodeList]
		WHERE
			([intHACode] <> 0)
			AND ((@HACode & [intHACode]) = [intHACode])
		ORDER BY [intHACode] ASC
	)

	SELECT @CSV = STRING_AGG(CAST([intHACode] as NVARCHAR(20)), N',')
	FROM cteOrderedResults;	-- needed CTE to get ordered result set due to AGGREGATE function

	-- if passed an invalid HACode that doesn't match any of the bitmap masks, then return 0 which is 'none'.
	IF (@CSV IS NULL OR LEN(@CSV) = 0)
		SET @CSV = N'0';

RETURN @CSV;

END
