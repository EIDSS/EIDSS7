CREATE PROCEDURE USP_CONF_REPORTDISEASEGROUPDISEASEMATRIX_DEL
(
	@idfDiagnosisToGroupForReportType BIGINT,
	@deleteAnyway BIT = 0
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		UPDATE trtDiagnosisToGroupForReportType SET intRowStatus = 1 WHERE idfDiagnosisToGroupForReportType = @idfDiagnosisToGroupForReportType
		SELECT @returnCode 'returnCode', @returnMsg 'returnMsg'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END