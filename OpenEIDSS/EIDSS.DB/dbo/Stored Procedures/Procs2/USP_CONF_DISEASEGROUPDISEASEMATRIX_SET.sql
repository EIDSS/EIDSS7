-- =========================================================================================
-- NAME: USP_CONF_DISEASEGROUPDISEASEMATRIX_SET
-- DESCRIPTION: Creates a disease group to disease relationship

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/18/2019	Initial Release
-- Ricky Moss		04/26/2016  Check for Duplicates
--
-- exec USP_CONF_DISEASEGROUPDISEASEMATRIX_SET NULL, 51529030000000, 784230000000
-- =========================================================================================
ALTER PROCEDURE [dbo].[USP_CONF_DISEASEGROUPDISEASEMATRIX_SET]
(
	@idfDiagnosisToDiagnosisGroup BIGINT,
	@idfsDiagnosisGroup BIGINT,
	@idfsDiagnosis BIGINT
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT idfDiagnosisToDiagnosisGroup FROM trtDiagnosisToDiagnosisGroup WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisGroup = @idfsDiagnosisGroup AND intRowStatus = 0) AND @idfDiagnosisToDiagnosisGroup IS NULL) OR (EXISTS(SELECT idfDiagnosisToDiagnosisGroup FROM trtDiagnosisToDiagnosisGroup WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisGroup = @idfsDiagnosisGroup AND idfDiagnosisToDiagnosisGroup <> @idfDiagnosisToDiagnosisGroup AND intRowStatus = 0) AND @idfDiagnosisToDiagnosisGroup IS NOT NULL)
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfDiagnosisToDiagnosisGroup = (SELECT idfDiagnosisToDiagnosisGroup FROM trtDiagnosisToDiagnosisGroup WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisGroup = @idfsDiagnosisGroup AND intRowStatus = 0)
		END
		ELSE IF EXISTS(SELECT idfDiagnosisToDiagnosisGroup FROM trtDiagnosisToDiagnosisGroup WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisGroup = @idfsDiagnosisGroup AND intRowStatus = 1)
		BEGIN
			SELECT @idfDiagnosisToDiagnosisGroup = (SELECT idfDiagnosisToDiagnosisGroup FROM trtDiagnosisToDiagnosisGroup WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisGroup = @idfsDiagnosisGroup AND intRowStatus = 1)
			UPDATE trtDiagnosisToDiagnosisGroup SET intRowStatus = 0 WHERE idfsDiagnosis = @idfsDiagnosis AND idfsDiagnosisGroup = @idfsDiagnosisGroup
		END
		ELSE
		BEGIN			
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtDiagnosisToDiagnosisGroup', @idfDiagnosisToDiagnosisGroup OUTPUT;

			INSERT INTO trtDiagnosisToDiagnosisGroup (idfDiagnosisToDiagnosisGroup, idfsDiagnosis, idfsDiagnosisGroup, intRowStatus) VALUES (@idfDiagnosisToDiagnosisGroup, @idfsDiagnosis, @idfsDiagnosisGroup, 0)
			INSERT INTO trtDiagnosisToDiagnosisGroupToCP (idfDiagnosisToDiagnosisGroup, idfCustomizationPackage) VALUES ( @idfDiagnosisToDiagnosisGroup, dbo.FN_GBL_CustomizationPackage_GET())
		END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfDiagnosisToDiagnosisGroup 'idfDiagnosisToDiagnosisGroup'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END