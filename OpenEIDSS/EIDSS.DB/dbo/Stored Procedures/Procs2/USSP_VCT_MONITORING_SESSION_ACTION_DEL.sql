
-- ============================================================================
-- Name: USSP_VCT_MONITORINGSESSION_ACTION_DEL
--
-- Description:	Sets a monitoring session action record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORINGSESSION_ACTION_DEL]
(	 
	@idfMonitoringSessionAction		BIGINT
)
AS

DECLARE @returnCode					INT = 0;
DECLARE @returnMsg					NVARCHAR(max) = 'SUCCESS';

BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE						dbo.tlbMonitoringSessionAction
		SET							intRowStatus = 1
		WHERE						idfMonitoringSessionAction = @idfMonitoringSessionAction; 

		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
			THROW;

			SELECT					@returnCode, @returnMsg;
	END CATCH
END


