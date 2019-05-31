-- ================================================================================================
-- Name: USP_VCT_CAMPAIGN_DEL
--
-- Description: Deletes an active surveillance campaign record for use case VASUC08.
--          
-- Revision History:
-- Name               Date       Change Detail
-- ------------------ ---------- -----------------------------------------------------------------
-- Stephen Long       04/30/2019 Initial release for API.
-- Stephen Long       05/09/2019 Added monitoring session count check.
--
-- Testing code:
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_CAMPAIGN_DEL] (
	@LanguageID NVARCHAR(50),
	@CampaignID AS BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'Success',
			@ReturnCode INT = 0,
			@MonitoringSessionCount AS INT = 0;

		SELECT @MonitoringSessionCount = COUNT(*)
		FROM dbo.tlbMonitoringSession
		WHERE idfCampaign = @CampaignID
			AND intRowStatus = 0;

		IF @MonitoringSessionCount = 0
		BEGIN
			-- Delete child records for species and sample types.
			UPDATE dbo.CampaignToSampleType
			SET intRowStatus = 1
			WHERE idfCampaign = @CampaignID;

			UPDATE dbo.tlbCampaign
			SET intRowStatus = 1
			WHERE idfCampaign = @CampaignID;
		END;
		ELSE
		BEGIN
			SET @ReturnCode = 1;
			SET @ReturnMessage = 'Unable to delete this record as it contains dependent child objects.';
		END;

		IF @@TRANCOUNT > 0
			AND @returnCode = 0
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
