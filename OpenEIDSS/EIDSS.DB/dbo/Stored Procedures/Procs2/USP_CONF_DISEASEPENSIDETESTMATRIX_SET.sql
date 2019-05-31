-- =========================================================================================
-- NAME: USP_CONF_DISEASEPENSIDETESTMATRIX_SET
-- DESCRIPTION: Creates a disease to penside test relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		02/26/2019	Initial Release
--
-- exec USP_CONF_DISEASEPENSIDETESTMATRIX_SET NULL, 784230000000, 6619000000000
-- =========================================================================================
CREATE PROCEDURE USP_CONF_DISEASEPENSIDETESTMATRIX_SET
(
	@idfPensideTestForDisease BIGINT = NULL,
	@idfsDiagnosis BIGINT,
	@idfsPensideTestName BIGINT
)
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))

BEGIN
	BEGIN TRY
		IF EXISTS(SELECT idfPensideTestForDisease FROM trtPensideTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsPensideTestName = @idfsPensideTestName AND intRowStatus = 0) AND @idfPensideTestForDisease IS NULL
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF EXISTS(SELECT idfPensideTestForDisease FROM trtPensideTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsPensideTestName = @idfsPensideTestName AND intRowStatus = 1) AND @idfPensideTestForDisease IS NOT NULL
		BEGIN
			UPDATE trtPensideTestForDisease SET intRowStatus = 0 WHERE idfsDiagnosis = @idfsDiagnosis AND idfsPensideTestName = @idfsPensideTestName
		END
		ELSE
		BEGIN			
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtPensideTestForDisease', @idfPensideTestForDisease OUTPUT;

			INSERT INTO trtPensideTestForDisease (idfPensideTestForDisease, idfsPensideTestName, idfsDiagnosis, intRowStatus) VALUES (@idfPensideTestForDisease, @idfsPensideTestName, @idfsDiagnosis, 0)
			INSERT INTO trtPensideTestForDiseaseToCP (idfPensideTestForDisease, idfCustomizationPackage) VALUES ( @idfPensideTestForDisease, dbo.FN_GBL_CustomizationPackage_GET())
		END
	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfPensideTestForDisease 'idfPensideTestForDisease'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END