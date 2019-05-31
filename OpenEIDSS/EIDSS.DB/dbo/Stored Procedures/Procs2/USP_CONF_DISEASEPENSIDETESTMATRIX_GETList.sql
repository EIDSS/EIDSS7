-- =========================================================================================
-- NAME: USP_CONF_DISEASEPENSIDETESTMATRIX_GETList
-- DESCRIPTION: Returns a list of disease to penside test relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		02/25/2019	Initial Release
--
-- exec USP_CONF_DISEASEPENSIDETESTMATRIX_GETList 'en'
-- =========================================================================================
CREATE PROCEDURE USP_CONF_DISEASEPENSIDETESTMATRIX_GETList
(
	@LangID NVARCHAR(10)
)
AS
BEGIN
	BEGIN TRY
		SELECT idfPensideTestForDisease, idfsPensideTestName, ptdbr.name as strPensideTestName, ptd.idfsDiagnosis, dbr.name as strDisease FROM trtPensideTestForDisease ptd
		JOIN dbo.FN_GBL_ReferenceRepair(@LangID, 19000104) ptdbr
		ON ptd.idfsPensideTestName = ptdbr.idfsReference
		JOIN dbo.FN_GBL_ReferenceRepair(@LangID, 19000019) dbr
		ON ptd.idfsDiagnosis = dbr.idfsReference
		WHERE ptd.intRowStatus = 0
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END