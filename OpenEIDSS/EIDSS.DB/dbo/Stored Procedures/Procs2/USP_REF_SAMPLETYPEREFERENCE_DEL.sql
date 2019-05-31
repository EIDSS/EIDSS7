--=====================================================================================================
-- Author:		Ricky Moss.
-- Description:	Removes a sample type reference from the active list
--							
-- Revision History:
-- Name             Date		Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/09/26	Initial Release
-- Ricky Moss		12/12/2018	Removed return code and reference id variables
-- Ricky Moss		01/03/2018	Added the deleteAnyway parameter
--
-- Test Code:
-- exec USP_REF_SAMPLETYPEREFERENCE_DEL 55615180000085, 0
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_SAMPLETYPEREFERENCE_DEL]
(
	@idfsSampleType BIGINT,
	@deleteAnyway BIT
)
AS
BEGIN
DECLARE @returnMsg			NVARCHAR(max) = N'Success';
DECLARE @returnCode			BIGINT = 0;
DECLARE @inUse				BIT = 0
	BEGIN TRY
	IF (NOT EXISTS(select CampaignToSampleTypeUID from CampaignToSampleType where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfMonitoringSession from MonitoringSessionToSampleType where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND 			
		NOT EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfCampaignToDiagnosis from tlbCampaignToDiagnosis where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfMonitoringSessionSummary from tlbMonitoringSessionSummarySample where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfMonitoringSessionToDiagnosis from tlbMonitoringSessionToDiagnosis where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND 			
		NOT EXISTS(select idfMaterialForDisease from trtMaterialForDisease where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfTestForDisease from trtTestForDisease where idfsSampleType = @idfsSampleType and intRowStatus = 0) AND
		NOT EXISTS(select idfMaterial from tlbMaterial where idfsSampleType = @idfsSampleType and intRowStatus = 0))
		SELECT @inUse = 0
	ELSE
		SELECT @inUse = 1

	IF	@inUse = 0 OR @deleteAnyway = 1
	BEGIN	
		UPDATE trtSampleType SET intRowStatus = 1 
			WHERE idfsSampleType = @idfsSampleType
			and intRowStatus = 0

		UPDATE trtBaseReference SET intRowStatus = 1 
			WHERE idfsBaseReference = @idfsSampleType
			AND intRowStatus = 0

		UPDATE trtStringNameTranslation SET intRowStatus = 1
			WHERE idfsBaseReference = @idfsSampleType
	END
	ELSE
	BEGIN
		SELECT @returnCode = -1
		SELECT @returnMsg = 'IN USE'
	END

	Select @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' 
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END