
-- ============================================================================
-- Name: USSP_VCT_MONITORINGSESSIONSUMMARY_SAMPLE_DEL
-- Description:	Sets a monitoring session summary sample record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORINGSESSIONSUMMARY_SAMPLE_DEL]
(	 
	@idfMonitoringSessionSummary	BIGINT, 
	@idfsSampleType					BIGINT
)
AS

DECLARE @returnCode					INT = 0;
DECLARE @returnMsg					NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE						dbo.tlbMonitoringSessionSummarySample
		SET							intRowStatus = 1
		WHERE						idfMonitoringSessionSummary = @idfMonitoringSessionSummary 
		AND							idfsSampleType = @idfsSampleType; 

		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		BEGIN 
			THROW;

			SELECT					@returnCode, @returnMsg;
		END

	END CATCH
END


