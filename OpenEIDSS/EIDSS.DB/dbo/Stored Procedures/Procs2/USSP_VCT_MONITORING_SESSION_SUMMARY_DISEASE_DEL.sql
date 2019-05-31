
-- ============================================================================
-- Name: USSP_VCT_MONITORINGSESSIONSUMMARY_DIAGNOSIS_DEL
-- Description:	Sets a monitoring session summary diagnosis record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORINGSESSIONSUMMARY_DIAGNOSIS_DEL]
(	 
	@idfMonitoringSessionSummary	BIGINT, 
	@idfsDiagnosis					BIGINT
)
AS

DECLARE @returnCode					INT = 0;
DECLARE @returnMsg					NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE						dbo.tlbMonitoringSessionSummaryDiagnosis
		SET							intRowStatus = 1
		WHERE						idfMonitoringSessionSummary = @idfMonitoringSessionSummary 
		AND							idfsDiagnosis = @idfsDiagnosis; 

		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
			THROW;

			SELECT					@returnCode, @returnMsg;
	END CATCH
END


