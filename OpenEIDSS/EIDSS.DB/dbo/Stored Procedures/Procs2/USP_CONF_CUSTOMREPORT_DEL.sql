-- exec USP_CONF_CUSTOMREPORT_DEL 55540680000323, 6
CREATE PROCEDURE USP_CONF_CUSTOMREPORT_DEL
(
	@idfReportRows BIGINT,
	@deleteAnyway BIT
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		UPDATE trtReportRows SET intRowStatus = 1 WHERE idfReportRows = @idfReportRows
		SELECT @returnCode 'returnCode', @returnMsg 'returnMsg'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
