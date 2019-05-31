-- ================================================================================================
-- Name: USP_VCT_CAMPAIGN_SET
--
-- Description: Insert/update active surveillance campaign record for the human and veterinary 
-- modules.
--          
-- Revision History:
-- Name               Date       Change Detail
-- ------------------ ---------- -----------------------------------------------------------------
-- Stephen Long       04/30/2019 Initial release for API.
-- Stephen Long       05/07/2019 Added audit user name and monitoring sessions parameters.
--
-- Testing code:
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_CAMPAIGN_SET] (
	@LanguageID NVARCHAR(50),
	@CampaignID BIGINT,
	@CampaignTypeID BIGINT,
	@CampaignStatusTypeID BIGINT,
	@CampaignDateStart DATETIME,
	@CampaignDateEnd DATETIME,
	@EIDSSCampaignID NVARCHAR(50),
	@CampaignName NVARCHAR(200),
	@CampaignAdministrator NVARCHAR(200),
	@Conclusion NVARCHAR(MAX),
	@DiseaseID BIGINT,
	@SiteID BIGINT,
	@CampaignCategoryTypeID BIGINT,
	@AuditUserName NVARCHAR(200), 
	@RowStatus INT, 
	@SpeciesToSampleTypeCombinations NVARCHAR(MAX), 
	@MonitoringSessions NVARCHAR(MAX)
	)
AS
BEGIN
	DECLARE @ReturnCode INT = 0
	DECLARE @ReturnMessage NVARCHAR(MAX) = 'SUCCESS'
	DECLARE @SuppressSelect TABLE (
		ReturnCode INT,
		ReturnMessage VARCHAR(200)
		)
	DECLARE @SpeciesTypeID BIGINT,
		@SampleTypeID BIGINT,
		@CampaignToSampleTypeID BIGINT,
		@OrderNumber INT,
		@PlannedNumber INT = NULL,
		@Comments NVARCHAR(500) = NULL,
		@RowID BIGINT = NULL,
		@RowAction CHAR(1) = NULL, 
		@MonitoringSessionID BIGINT = NULL;
	DECLARE @SpeciesToSampleTypeCombinationsTemp TABLE (
		CampaignToSampleTypeID BIGINT NOT NULL,
		SpeciesTypeID BIGINT NULL,
		SampleTypeID BIGINT NULL,
		OrderNumber INT NOT NULL,
		PlannedNumber INT,
		Comments NVARCHAR(MAX) NULL,
		RowStatus INT NOT NULL,
		RowAction CHAR(1)
		);
	DECLARE @MonitoringSessionsTemp TABLE (
		MonitoringSessionID BIGINT NOT NULL
	);

	BEGIN TRY
		BEGIN TRANSACTION

		INSERT INTO @SpeciesToSampleTypeCombinationsTemp
		SELECT *
		FROM OPENJSON(@SpeciesToSampleTypeCombinations) WITH (
				CampaignToSampleTypeID BIGINT,
				SpeciesTypeID BIGINT,
				SampleTypeID BIGINT,
				OrderNumber INT,
				PlannedNumber INT,
				Comments NVARCHAR(MAX),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @MonitoringSessionsTemp
		SELECT * 
		FROM OPENJSON(@MonitoringSessions) WITH (
				MonitoringSessionID BIGINT
		);

		IF NOT EXISTS (
				SELECT *
				FROM dbo.tlbCampaign
				WHERE idfCampaign = @CampaignID
					AND intRowStatus = 0
				)
		BEGIN
			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbCampaign',
				@CampaignID OUTPUT;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NextNumber_GET 'Active Surveillance Campaign',
				@EIDSSCampaignID OUTPUT,
				NULL;

			INSERT INTO dbo.tlbCampaign (
				idfCampaign,
				idfsCampaignType,
				idfsCampaignStatus,
				datCampaignDateStart,
				datCampaignDateEnd,
				strCampaignID,
				strCampaignName,
				strCampaignAdministrator,
				strConclusion,
				idfsDiagnosis,
				CampaignCategoryID, 
				AuditCreateUser,
				intRowStatus
				)
			VALUES (
				@CampaignID,
				@CampaignTypeID,
				@CampaignStatusTypeID,
				@CampaignDateStart,
				@CampaignDateEnd,
				@EIDSSCampaignID,
				@CampaignName,
				@CampaignAdministrator,
				@Conclusion,
				@DiseaseID,
				@CampaignCategoryTypeID,
				@AuditUserName,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbCampaign
			SET idfsCampaignType = @CampaignTypeID,
				idfsCampaignStatus = @CampaignStatusTypeID,
				datCampaignDateStart = @CampaignDateStart,
				datCampaignDateEnd = @CampaignDateEnd,
				strCampaignID = @EIDSSCampaignID,
				strCampaignName = @CampaignName,
				strCampaignAdministrator = @CampaignAdministrator,
				strConclusion = @Conclusion,
				idfsDiagnosis = @DiseaseID,
				CampaignCategoryID = @CampaignCategoryTypeID, 
				AuditUpdateUser = @AuditUserName, 
				intRowStatus = @RowStatus 
			WHERE idfCampaign = @CampaignID;
		END

		WHILE EXISTS (
				SELECT *
				FROM @SpeciesToSampleTypeCombinationsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = CampaignToSampleTypeID,
				@CampaignToSampleTypeID = CampaignToSampleTypeID,
				@OrderNumber = OrderNumber,
				@RowStatus = RowStatus,
				@SpeciesTypeID = SpeciesTypeID,
				@SampleTypeID = SampleTypeID,
				@PlannedNumber = PlannedNumber,
				@Comments = Comments,
				@RowAction = RowAction
			FROM @SpeciesToSampleTypeCombinationsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VCT_CAMPAIGN_TO_SAMPLE_TYPE_SET @LanguageID,
				@CampaignToSampleTypeID,
				@CampaignID,
				@OrderNumber,
				@RowStatus,
				@SpeciesTypeID,
				@SampleTypeID,
				@PlannedNumber,
				@Comments,
				@AuditUserName, 
				@RowAction;

			DELETE
			FROM @SpeciesToSampleTypeCombinationsTemp
			WHERE CampaignToSampleTypeID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @MonitoringSessionsTemp
				)
		BEGIN
			SELECT TOP 1 @MonitoringSessionID = MonitoringSessionID
			FROM @MonitoringSessionsTemp;

			UPDATE dbo.tlbMonitoringSession SET idfCampaign = @CampaignID
			WHERE idfMonitoringSession = @MonitoringSessionID;

			DELETE
			FROM @MonitoringSessionsTemp
			WHERE MonitoringSessionID = @MonitoringSessionID;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@CampaignID CampaignID,
			@EIDSSCampaignID EIDSSCampaignID;
	END TRY

	BEGIN CATCH
		IF @@Trancount > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@CampaignID CampaignID,
			@EIDSSCampaignID EIDSSCampaignID;

		THROW;
	END CATCH
END