CREATE PROCEDURE USP_CONF_REPORTDISEASEGROUPDISEASEMATRIX_SET
(
	@idfDiagnosisToGroupForReportType BIGINT,
	@idfsCustomReportType BIGINT,
	@idfsReportDiagnosisGroup BIGINT,
	@idfsDiagnosis BIGINT	
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
	INSERT INTO @SupressSelect
		EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtDiagnosisToGroupForReportType', @idfDiagnosisToGroupForReportType OUTPUT;
		
		INSERT INTO trtDiagnosisToGroupForReportType (idfDiagnosisToGroupForReportType, idfsCustomReportType, idfsReportDiagnosisGroup, idfsDiagnosis) VALUES (@idfDiagnosisToGroupForReportType, @idfsCustomReportType, @idfsReportDiagnosisGroup, @idfsDiagnosis)
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfDiagnosisToGroupForReportType 'idfDiagnosisToGroupForReportType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END