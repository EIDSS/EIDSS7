-- =========================================================================================================
-- NAME: USP_CONF_DISEASELABTESTMATRIX_SET
-- DESCRIPTION: Creates a Disease to lab test matrix
-- AUTHOR: Ricky Moss
-- 
-- REVISION HISTORY
--
-- Name:				Date			Description of Change
-- ----------------------------------------------------------
-- Ricky Moss			04/08/2019		Initial Release
-- Ricky Moss			04/26/2019      Check for duplicates
--
-- EXEC USP_CONF_DISEASELABTESTMATRIX_SET NULL, 784170000000,781420000000,6618590000000,10095001
-- =========================================================================================================
ALTER PROCEDURE USP_CONF_DISEASELABTESTMATRIX_SET
(
	@idfTestForDisease BIGINT = NULL,
	@idfsDiagnosis BIGINT,
	@idfsSampleType BIGINT,
	@idfsTestName BIGINT,
	@idfsTestCategory BIGINT
)
AS
	DECLARE @returnCode	   INT = 0  
	DECLARE	@returnMsg	   NVARCHAR(max) = 'SUCCESS' 
	DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
		IF ((EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType = @idfsSampleType AND idfsTestCategory = @idfsTestCategory AND idfsTestCategory = @idfsTestCategory AND idfsTestName = @idfsTestName AND intRowStatus = 0) AND @idfTestForDisease IS NULL)) OR  ((EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType = @idfsSampleType AND idfsTestCategory = @idfsTestCategory AND idfsTestCategory = @idfsTestCategory AND idfsTestName = @idfsTestName AND idfTestForDisease <> @idfTestForDisease AND intRowStatus = 0) AND @idfTestForDisease IS NOT NULL))
			OR (EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType= @idfsSampleType AND idfsTestCategory = @idfsTestCategory AND idfsTestCategory = @idfsTestCategory AND idfsTestName = @idfsTestName AND idfTestForDisease <> @idfTestForDisease AND intRowStatus = 0) AND @idfTestForDisease IS NOT NULL)
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF (EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType = @idfsSampleType AND idfsTestCategory = @idfsTestCategory AND idfsTestCategory = @idfsTestCategory AND idfsTestName = @idfsTestName AND intRowStatus = 1) AND @idfTestForDisease IS NULL)
		BEGIN
			UPDATE trtTestForDisease SET intRowStatus = 0 WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType = @idfsSampleType AND idfsTestCategory = @idfsTestCategory AND idfsTestCategory = @idfsTestCategory AND idfsTestName = @idfsTestName AND intRowStatus = 1
			SELECT @idfTestForDisease = (SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND idfsSampleType = @idfsSampleType AND idfsTestCategory = @idfsTestCategory AND idfsTestCategory = @idfsTestCategory AND idfsTestName = @idfsTestName AND intRowStatus = 1) 
		END
		ELSE IF (EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfTestForDisease = @idfTestForDisease AND intRowStatus = 0) AND @idfTestForDisease IS NOT NULL)
		BEGIN
			UPDATE trtTestForDisease SET idfsDiagnosis = @idfsDiagnosis, idfsSampleType = @idfsSampleType, idfsTestCategory = @idfsTestCategory, idfsTestName = @idfsTestName WHERE idfTestForDisease = @idfTestForDisease
		END
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtTestForDisease', @idfTestForDisease OUTPUT

			INSERT INTO trtTestForDisease (idfTestForDisease, idfsDiagnosis, idfsSampleType, idfsTestName, idfsTestCategory) VALUES (@idfTestForDisease, @idfsDiagnosis, @idfsSampleType, @idfsTestName, @idfsTestCategory)
			INSERT INTO trtTestForDiseaseToCP (idfTestForDisease, idfCustomizationPackage) VALUES (@idfTestForDisease, dbo.FN_GBL_CustomizationPackage_GET())
		END
		SELECT @returnCode 'returnCode', @returnMsg 'returnMessage', @idfTestForDisease 'idfTestForDisease'
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END