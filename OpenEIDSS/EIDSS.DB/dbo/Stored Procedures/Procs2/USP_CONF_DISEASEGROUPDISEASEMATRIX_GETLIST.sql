--=====================================================================================================
-- Name: USP_REF_DIAGNOSISREFERENCE_GETList @LangID
-- Description:	Returns list of diagnosis/disease references
--							
-- Author:		Philip Shaffer
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/18/2018  Initial Release
--
-- Test Code:
-- exec USP_CONF_DISEASEGROUPDISEASEMATRIX_GETLIST 'en', 51529030000000
-- exec USP_CONF_DISEASEGROUPDISEASEMATRIX_GETLIST 'en', 51529040000000
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_CONF_DISEASEGROUPDISEASEMATRIX_GETLIST]
(
	@LangId NVARCHAR(50),
	@idfsDiagnosisGroup BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT ddg.idfDiagnosisToDiagnosisGroup, ddg.idfsDiagnosisGroup, dgbr.strDefault, ddg.idfsDiagnosis, dbr.strDefault as strDiseaseDefault, dbr.name as strDiseaseName, ut.name as strUsingType, 
			   dbo.FN_GBL_HACodeNames_ToCSV(@LangId, dbr.[intHACode]) AS [strHACodeNames], dbr.intOrder  FROM trtDiagnosisToDiagnosisGroup ddg
		JOIN FN_GBL_Reference_GETList(@LangId, 19000019) dbr
		ON ddg.idfsDiagnosis = dbr.idfsReference
		JOIN trtDiagnosis d
		ON ddg.idfsDiagnosis = d.idfsDiagnosis
		JOIN dbo.FN_GBL_Reference_GETList(@LangId, 19000020) ut 
		ON d.idfsUsingType = ut.idfsReference
		JOIN dbo.FN_GBL_Reference_GETList(@LangId, 19000156) dgbr
		ON ddg.idfsDiagnosisGroup = dgbr.idfsReference
		WHERE ddg.intRowStatus = 0 AND idfsDiagnosisGroup = @idfsDiagnosisGroup
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END