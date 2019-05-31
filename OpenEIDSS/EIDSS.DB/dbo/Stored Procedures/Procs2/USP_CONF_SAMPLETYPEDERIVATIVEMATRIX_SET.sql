ALTER PROCEDURE USP_CONF_SAMPLETYPEDERIVATIVEMATRIX_SET
(
	@idfDerivativeForSampleType BIGINT = NULL,
	@idfsSampleType BIGINT,
	@idfsDerivativeType BIGINT
)
AS
DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
DECLARE @returnCode					BIGINT = 0;
DECLARE @SupressSelect TABLE
( 
	retrunCode int,
	returnMessage varchar(200)
)
BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND intRowStatus = 0) AND @idfDerivativeForSampleType IS NULL) OR (EXISTS(SELECT idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND idfDerivativeForSampleType <> @idfDerivativeForSampleType AND intRowStatus = 0) AND @idfDerivativeForSampleType IS NOT NULL)
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfDerivativeForSampleType = (SELECT idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND intRowStatus = 0)
		END
		ELSE IF(EXISTS(SELECT idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND intRowStatus = 1) AND @idfDerivativeForSampleType IS NULL)
		BEGIN
			UPDATE trtDerivativeForSampleType SET intRowStatus = 0  WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND intRowStatus = 1
			SELECT @idfDerivativeForSampleType =(SELECT idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND intRowStatus = 1)
		END
		ELSE IF(EXISTS(SELECT idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsDerivativeType = @idfsDerivativeType AND idfsSampleType = @idfsSampleType AND idfDerivativeForSampleType = @idfDerivativeForSampleType AND intRowStatus = 0) AND @idfDerivativeForSampleType IS NOT NULL)
		BEGIN
			UPDATE trtDerivativeForSampleType SET idfsDerivativeType = @idfsDerivativeType, idfsSampleType = @idfsSampleType WHERE idfDerivativeForSampleType = @idfDerivativeForSampleType AND intRowStatus = 0
		END
		ELSE
		BEGIN		
		    INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtDerivativeForSampleType', @idfDerivativeForSampleType OUTPUT;

			INSERT INTO trtDerivativeForSampleType (idfDerivativeForSampleType, idfsSampleType, idfsDerivativeType, intRowStatus) VALUES (@idfDerivativeForSampleType, @idfsSampleType, @idfsDerivativeType, 0)
			INSERT INTO trtDerivativeForSampleTypeToCP (idfDerivativeForSampleType, idfCustomizationPackage) VALUES (@idfDerivativeForSampleType, dbo.FN_GBL_CustomizationPackage_GET())
		END
			SELECT @returnCode 'returnCode', @returnMsg 'returnMessage', @idfDerivativeForSampleType 'idfDerivativeForSampleType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END