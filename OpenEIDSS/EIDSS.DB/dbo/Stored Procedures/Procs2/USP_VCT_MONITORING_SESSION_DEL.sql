-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_DEL
--
-- Description:	Sets an active surveillance monitoring session record to "inactive".
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/02/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_DEL] (
	@LanguageID NVARCHAR(50) = NULL,
	@MonitoringSessionID BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'Success',
			@ReturnCode BIGINT = 0;

		BEGIN TRANSACTION;

		UPDATE dbo.tlbMonitoringSession
		SET intRowStatus = 1,
			datModificationForArchiveDate = GETDATE()
		WHERE idfMonitoringSession = @MonitoringSessionID;

		IF @@TRANCOUNT > 0
			COMMIT;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;
	END TRY

	BEGIN CATCH
		IF @@Trancount > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
GO