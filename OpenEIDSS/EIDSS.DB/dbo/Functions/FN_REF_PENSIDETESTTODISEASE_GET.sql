--=====================================================================================================
-- Name: FN_REF_PENSIDETESTTODISEASE_GET
-- Description:	Returns a string of comma separated penside test identifiers
--							
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		01/31/2018	Initial Release
-- Ricky Moss		02/08/2018	Added active condition
--
-- Test Code:
-- SELECT dbo.FN_REF_PENSIDETESTTODISEASE_GET('en', 6618330000000);
--=====================================================================================================

CREATE FUNCTION [dbo].[FN_REF_PENSIDETESTTODISEASE_GET]
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
	WITH results ([idfsPensideTest]) AS
	(
		SELECT ptfdbr.idfsReference
		FROM trtPensideTestForDisease ptfd
		JOIN FN_GBL_ReferenceRepair(@LangID,19000104) ptfdbr
		ON ptfd.idfsPensideTestName = ptfdbr.idfsReference AND ptfd.intRowStatus = 0
		WHERE idfsDiagnosis = @idfsDiagnosis AND ptfd.intRowStatus = 0
	)
	SELECT @CSV = STRING_AGG([idfsPensideTest], ',')
	FROM results;

	--IF @CSV IS NOT NULL AND LEN(@CSV) > 0
	-- RETURN @CSV;
END

RETURN @CSV;
END
