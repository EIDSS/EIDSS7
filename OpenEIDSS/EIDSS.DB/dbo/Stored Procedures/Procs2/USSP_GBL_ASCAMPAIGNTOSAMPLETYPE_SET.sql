

-- ============================================================================
-- Name: USSP_GBL_ASCAMPAIGNTOSAMPLETYPE_SET
-- Description:	Inserts or updates campaign to sample type for the 
-- veterinary module monitoring session set up and edit use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/30/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_ASCAMPAIGNTOSAMPLETYPE_SET]
(
	@LangID								NVARCHAR(50), 
	@CampaignToSampleTypeUID			BIGINT OUTPUT,
	@idfCampaign						BIGINT,
    @intOrder							INT,
	@intRowStatus						INT, 
    @idfsSpeciesType					BIGINT = NULL,
	@strMaintenanceFlag					NVARCHAR(20) = NULL, 
	@idfsSampleType						BIGINT = NULL, 
	@intPlannedNumber					INT = NULL, 
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
			EXEC						dbo.USP_GBL_NEXTKEYID_GET 'CampaignToSampleType', @CampaignToSampleTypeUID OUTPUT;

			INSERT INTO					dbo.CampaignToSampleType
			(
										CampaignToSampleTypeUID,
										idfCampaign,
										intOrder,
										intRowStatus,
										idfsSpeciesType,
										strMaintenanceFlag, 
										idfsSampleType, 
										intPlannedNumber
           )
			VALUES
           (
										@CampaignToSampleTypeUID,
										@idfCampaign,
										@intOrder, 
										@intRowStatus, 
										@idfsSpeciesType, 
										@strMaintenanceFlag, 
										@idfsSampleType, 
										@intPlannedNumber
			);
			END
		ELSE
			BEGIN
			UPDATE						dbo.CampaignToSampleType
			SET 
										idfCampaign = @idfCampaign, 
										intOrder = @intOrder, 
										intRowStatus = @intRowStatus, 
										idfsSpeciesType = @idfsSpeciesType, 
										strMaintenanceFlag = @strMaintenanceFlag, 
										idfsSampleType = @idfsSampleType, 
										intPlannedNumber = @intPlannedNumber 
			WHERE						CampaignToSampleTypeUID = @CampaignToSampleTypeUID;
			END

		SELECT							@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		THROW;

		SELECT							@returnCode, @returnMsg;
	END CATCH
END
