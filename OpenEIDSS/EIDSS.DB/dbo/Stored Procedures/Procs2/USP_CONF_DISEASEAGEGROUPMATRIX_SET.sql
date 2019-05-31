-- =========================================================================================
-- NAME: USP_CONF_DISEASEAGEGROUPMATRIX_SET
-- DESCRIPTION: Creates a vector type to collection method relationship

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/04/2019	Initial Release
--
-- exec USP_CONF_DISEASEAGEGROUPMATRIX_SET NULL, 780170000000, 15300001100
-- =========================================================================================
ALTER PROCEDURE USP_CONF_DISEASEAGEGROUPMATRIX_SET
(
	@idfDiagnosisAgeGroupToDiagnosis BIGINT = NULL,
	@idfsDiagnosis BIGINT,
	@idfsDiagnosisAgeGroup BIGINT
)
AS

DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))

BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND intRowStatus = 0) AND @idfDiagnosisAgeGroupToDiagnosis IS NULL) AND (EXISTS(SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND idfDiagnosisAgeGroupToDiagnosis <> @idfDiagnosisAgeGroupToDiagnosis AND intRowStatus = 0) AND @idfDiagnosisAgeGroupToDiagnosis IS NOT NULL)
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfDiagnosisAgeGroupToDiagnosis = (SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND intRowStatus = 0)
		END
		ELSE IF EXISTS(SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND intRowStatus = 1)
		BEGIN
			UPDATE trtDiagnosisAgeGroupToDiagnosis SET intRowStatus = 0 WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup
			SELECT @idfDiagnosisAgeGroupToDiagnosis = (SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup AND intRowStatus = 0)
		END
		ELSE
		BEGIN			
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtDiagnosisAgeGroupToDiagnosis', @idfDiagnosisAgeGroupToDiagnosis OUTPUT;

			INSERT INTO trtDiagnosisAgeGroupToDiagnosis (idfDiagnosisAgeGroupToDiagnosis, idfsDiagnosis, idfsDiagnosisAgeGroup, intRowStatus) VALUES (@idfDiagnosisAgeGroupToDiagnosis, @idfsDiagnosis, @idfsDiagnosisAgeGroup, 0)
			INSERT INTO trtDiagnosisAgeGroupToDiagnosisToCP (idfDiagnosisAgeGroupToDiagnosis, idfCustomizationPackage) VALUES ( @idfDiagnosisAgeGroupToDiagnosis, dbo.FN_GBL_CustomizationPackage_GET())
		END
	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfDiagnosisAgeGroupToDiagnosis 'idfDiagnosisAgeGroupToDiagnosis'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END