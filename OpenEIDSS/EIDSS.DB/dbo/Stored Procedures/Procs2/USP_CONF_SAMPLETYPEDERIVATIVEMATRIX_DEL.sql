CREATE PROCEDURE USP_CONF_SAMPLETYPEDERIVATIVEMATRIX_DEL
(
	@idfDerivativeForSampleType BIGINT,
	@deleteAnyway BIT = 0
)
AS
DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
DECLARE @returnCode					BIGINT = 0;
BEGIN
	BEGIN TRY
		UPDATE trtDerivativeForSampleType SET intRowStatus = 1 WHERE idfDerivativeForSampleType = @idfDerivativeForSampleType
		SELECT @returnCode 'returnCode', @returnMsg 'returnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END