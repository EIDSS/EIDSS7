-- =========================================================================================
-- NAME: USP_CONF_DISEASEAGEGROUPMATRIX_GETLIST
-- DESCRIPTION: Returns a list of disease to age group relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/06/2019	Initial Release
--
-- exec USP_CONF_DISEASEAGEGROUPMATRIX_GETLIST'en', 780170000000
-- exec USP_CONF_DISEASEAGEGROUPMATRIX_GETLIST'en', 780171000000
-- =========================================================================================
CREATE PROCEDURE USP_CONF_DISEASEAGEGROUPMATRIX_GETLIST
(
	@LangId NVARCHAR(10),
	@idfsDiagnosis BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT idfDiagnosisAgeGroupToDiagnosis, idfsDiagnosis, dbr.strDefault AS strDiseaseDefault, dbr.name as strDiseaseName, dagd.idfsDiagnosisAgeGroup, dagbr.strDefault as strAgeGroupDefault, dagbr.name as strAgeGroupName  FROM trtDiagnosisAgeGroupToDiagnosis dagd
		JOIN dbo.FN_GBL_ReferenceRepair(@LangId, 19000019) dbr
		ON dagd.idfsDiagnosis = dbr.idfsReference AND dagd.intRowStatus = 0
		JOIN dbo.FN_GBL_ReferenceRepair(@LangId, 19000146) dagbr
		ON dagd.idfsDiagnosisAgeGroup = dagbr.idfsReference AND dagd.intRowStatus = 0
		WHERE dagd.idfsDiagnosis = @idfsDiagnosis
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END