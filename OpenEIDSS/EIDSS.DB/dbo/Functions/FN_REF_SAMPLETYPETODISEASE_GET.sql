-- ====================================================================================================
-- Name: FN_REF_SAMPLETYPETODISEASE_GET
-- Description:	Returns a comma separated string of sample type identifiers associated with a disease
--							
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		01/30/2019  Initial Release
-- Ricky Moss		02/08/2019	Included active clause
--
-- Test Code:
-- SELECT dbo.[FN_REF_SAMPLETYPETODISEASE_GET]('en', 55540680000288);
-- ==================================================================================================

CREATE FUNCTION [dbo].[FN_REF_SAMPLETYPETODISEASE_GET]
(
	@LangID NVARCHAR(50),
	@idfsDiagnosis BIGINT
)
RETURNS NVARCHAR(4000)
AS
BEGIN
DECLARE @CSV NVARCHAR(4000) = '';

	IF @idfsDiagnosis IS NULL RETURN NULL;
	
	IF @idfsDiagnosis <> 0
	BEGIN
		WITH results ([idfsSampleType]) AS
		(
			SELECT DISTINCT(stbr.idfsReference) FROM trtMaterialForDisease md
			JOIN dbo.FN_GBL_Reference_List_GET(@LangID, 19000087) stbr ON md.idfsSampleType = stbr.idfsReference 
			where md.idfsDiagnosis = @idfsDiagnosis AND md.intRowStatus = 0
		)
		SELECT @CSV = STRING_AGG([idfsSampleType], ',')
		FROM results;
	END

	-- Return the result of the function
	RETURN @CSV;

END
