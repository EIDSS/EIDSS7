
-- ============================================================================
-- Name: USSP_VCT_MONITORINGSESSION_ACTION_SET
-- Description:	Inserts or updates monitoring session action for the veterinary 
-- module monitoring session enter and edit use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORINGSESSION_ACTION_SET]
(
	@LangID								NVARCHAR(50), 
	@idfMonitoringSessionAction			BIGINT OUTPUT,
    @idfMonitoringSession				BIGINT,
    @idfPersonEnteredBy					BIGINT,
    @idfsMonitoringSessionActionType	BIGINT,
    @idfsMonitoringSessionActionStatus	BIGINT,
    @datActionDate						DATETIME = NULL,
    @strComments						NVARCHAR(500) = NULL,
	@intRowStatus						INT, 
	@strMaintenanceFlag					NVARCHAR(20) = NULL, 
	@RecordAction						NCHAR(1) 
)
AS

DECLARE @returnCode						INT = 0;
DECLARE	@returnMsg						NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		IF @RecordAction = 'I' 
			BEGIN
			EXEC						dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSessionAction', @idfMonitoringSessionAction OUTPUT;

			INSERT INTO					dbo.tlbMonitoringSessionAction
			(
										idfMonitoringSessionAction,
										idfMonitoringSession,
										idfPersonEnteredBy,
										idfsMonitoringSessionActionType,
										idfsMonitoringSessionActionStatus,
										datActionDate,
										strComments,
										intRowStatus,
										strMaintenanceFlag
           )
			VALUES
           (
										@idfMonitoringSessionAction,
										@idfMonitoringSession,
										@idfPersonEnteredBy,
										@idfsMonitoringSessionActionType,
										@idfsMonitoringSessionActionStatus, 
										@datActionDate, 
										@strComments, 
										@intRowStatus, 
										@strMaintenanceFlag
			);
			END
		ELSE
			BEGIN
			UPDATE						dbo.tlbMonitoringSessionAction
			SET 
										idfMonitoringSessionAction = @idfMonitoringSessionAction, 
										idfMonitoringSession = @idfMonitoringSession, 
										idfPersonEnteredBy = @idfPersonEnteredBy, 
										idfsMonitoringSessionActionType = @idfsMonitoringSessionActionType, 
										idfsMonitoringSessionActionStatus = @idfsMonitoringSessionActionStatus, 
										datActionDate = @datActionDate, 
										strComments = @strComments, 
										intRowStatus = @intRowStatus, 
										strMaintenanceFlag = @strMaintenanceFlag 
			WHERE						idfMonitoringSessionAction = @idfMonitoringSessionAction;
			END

		SELECT							@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		THROW;

		SELECT							@returnCode, @returnMsg;
	END CATCH
END
