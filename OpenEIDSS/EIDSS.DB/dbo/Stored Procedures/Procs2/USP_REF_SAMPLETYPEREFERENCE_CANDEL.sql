--=====================================================================================================
-- Author:		Ricky Moss.
-- Description:	Returns two (2) result sets.
--
-- 1) Checks to see if Sample type is currently referenced.
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/09/26 Initial Release
--
-- 
-- Test Code:
-- exec USP_REF_SAMPLETYPEREFERENCE_CANDEL 55615180000085
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_SAMPLETYPEREFERENCE_CANDEL]
@idfsSampleType BIGINT
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
		Declare @exists bit
		IF	EXISTS(select CampaignToSampleTypeUID from CampaignToSampleType where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSession from MonitoringSessionToSampleType where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR 			
			EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfCampaignToDiagnosis from tlbCampaignToDiagnosis where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSessionSummary from tlbMonitoringSessionSummarySample where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSessionToDiagnosis from tlbMonitoringSessionToDiagnosis where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR 			
			EXISTS(select idfMaterialForDisease from trtMaterialForDisease where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfTestForDisease from trtTestForDisease where idfsSampleType = @idfsSampleType and intRowStatus = 0) OR
			EXISTS(select idfMaterial from tlbMaterial where idfsSampleType = @idfsSampleType and intRowStatus = 0) 

			BEGIN
				Select @exists = 1

				Select @exists as CurrentlyInUse
			END
			ELSE
			BEGIN
				Select @exists = 0

				Select @exists as CurrentlyInUse

			END
		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
			BEGIN
			SET							@returnCode = ERROR_NUMBER();
			SET							@returnMsg = 
										'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
										+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
										+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
										+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
										+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
										+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT						@returnCode, @returnMsg;
		END
	END CATCH
END
