-- ================================================================================================
-- Name: USSP_VCT_CAMPAIGN_TO_SAMPLE_TYPE_SET
--
-- Description:	Inserts or updates campaign to sample type for the human and veterinary module 
-- active surveillance campaign set up and edit use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/30/2019 Initial release for API.
-- Stephen Long     05/07/2019 Added audit user name.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_CAMPAIGN_TO_SAMPLE_TYPE_SET] (
	@LanguageID NVARCHAR(50),
	@CampaignToSampleTypeID BIGINT,
	@CampaignID BIGINT,
	@OrderNumber INT,
	@RowStatus INT,
	@SpeciesTypeID BIGINT = NULL,
	@SampleTypeID BIGINT = NULL,
	@PlannedNumber INT = NULL,
	@Comments NVARCHAR(MAX) = NULL,
	@AuditUserName NVARCHAR(200), 
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'CampaignToSampleType',
				@CampaignToSampleTypeID OUTPUT;

			INSERT INTO dbo.CampaignToSampleType (
				CampaignToSampleTypeUID,
				idfCampaign,
				intOrder,
				intRowStatus,
				idfsSpeciesType,
				idfsSampleType,
				intPlannedNumber,
				Comment, 
				AuditCreateUser
				)
			VALUES (
				@CampaignToSampleTypeID,
				@CampaignID,
				@OrderNumber,
				@RowStatus,
				@SpeciesTypeID,
				@SampleTypeID,
				@PlannedNumber,
				@Comments,
				@AuditUserName
				);
		END;
		ELSE
		BEGIN
			UPDATE dbo.CampaignToSampleType
			SET idfCampaign = @CampaignID,
				intOrder = @OrderNumber,
				intRowStatus = @RowStatus,
				idfsSpeciesType = @SpeciesTypeID,
				idfsSampleType = @SampleTypeID,
				intPlannedNumber = @PlannedNumber, 
				Comment = @Comments, 
				AuditUpdateUser = @AuditUserName 
			WHERE CampaignToSampleTypeUID = @CampaignToSampleTypeID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
