
-- ============================================================================
-- Name: USSP_VCT_MONITORINGSESSIONTOSAMPLETYPE_DEL
-- Description:	Sets a monitoring session to sample type record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/30/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORINGSESSIONTOSAMPLETYPE_DEL]
(	 
	@MonitoringSessionToSampleType		BIGINT
)
AS

DECLARE @returnCode						INT = 0;
DECLARE @returnMsg						NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE							dbo.MonitoringSessionToSampleType
		SET								intRowStatus = 1
		WHERE							MonitoringSessionToSampleType = @MonitoringSessionToSampleType; 

		SELECT							@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		BEGIN 
			THROW;

			SELECT						@returnCode, @returnMsg;
		END
	END CATCH
END

