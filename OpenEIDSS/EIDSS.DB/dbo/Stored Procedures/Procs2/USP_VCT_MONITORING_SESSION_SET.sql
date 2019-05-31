-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_SET
--
-- Description: Insert/update for monitoring session records for the human and veterinary modules.
--          
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Mandar Kulkarni            Initial release.
-- Stephen Long    05/07/2018 Added structured type parameters
-- Lamont Mitchell 01/23/2019 Added Aliased Columns, removed out from @MonitoringSessionID and moved 
--                            to end of Select
-- Stephen Long    04/30/2019 Modified for new API; removed maintenance flag.
-- Stephen Long    05/20/2019 Added disease combinations parameter and associated stored procedure 
--                            call USSP_VCT_MONITORING_SESSION_TO_DISEASE_SET.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_SET] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionID BIGINT,
	@MonitoringSessionStatusTypeID BIGINT = NULL,
	@CountryID BIGINT = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL,
	@SettlementID BIGINT = NULL,
	@EnteredByPersonID BIGINT = NULL,
	@CampaignID BIGINT = NULL,
	@CampaignName NVARCHAR(50),
	@CampaignTypeID BIGINT = NULL,
	@SiteID BIGINT,
	@EnteredDate DATETIME = NULL,
	@EIDSSSessionID NVARCHAR(50) = NULL,
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL,
	@CampaignStartDate DATETIME = NULL,
	@CampaignEndDate DATETIME = NULL,
	@DiseaseID BIGINT = NULL,
	@SessionCategoryTypeID BIGINT = NULL,
	@RowStatus INT,
	@AvianOrLivestock NVARCHAR(50),
	@DiseaseCombinations NVARCHAR(MAX),
	@Farms NVARCHAR(MAX),
	@HerdsOrFlocks NVARCHAR(MAX),
	@Species NVARCHAR(MAX),
	@Animals NVARCHAR(MAX),
	@SpeciesToSampleTypeCombinations NVARCHAR(MAX),
	@Samples NVARCHAR(MAX),
	@Tests NVARCHAR(MAX),
	@TestInterpretations NVARCHAR(MAX),
	@Actions NVARCHAR(MAX),
	@Summaries NVARCHAR(MAX),
	@AuditUserName NVARCHAR(200)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnCode INT = 0,
			@ReturnMessage NVARCHAR(MAX) = 'SUCCESS';
		DECLARE @SuppressSelect TABLE (
			ReturnCode INT,
			ReturnMessage VARCHAR(200)
			);
		DECLARE @RowID BIGINT = NULL,
			@RowAction NCHAR = NULL,
			@MonitoringSessionToDiseaseID BIGINT,
			@FarmID BIGINT,
			@FarmMasterID BIGINT,
			@EIDSSFarmID NVARCHAR(200) = NULL,
			@SickAnimalQuantity INT = NULL,
			@TotalAnimalQuantity INT = NULL,
			@DeadAnimalQuantity INT = NULL,
			@HerdID BIGINT,
			@HerdMasterID BIGINT = NULL,
			@EIDSSHerdID NVARCHAR(200) = NULL,
			@Note NVARCHAR(2000) = NULL,
			@RecordID BIGINT = NULL,
			@SpeciesID BIGINT,
			@SpeciesMasterID BIGINT = NULL,
			@SpeciesTypeID BIGINT,
			@StartOfSignsDate DATETIME = NULL,
			@AverageAge NVARCHAR(200) = NULL,
			@AnimalID BIGINT = NULL,
			@AnimalGenderTypeID BIGINT = NULL,
			@AnimalConditionTypeID BIGINT = NULL,
			@AnimalAgeTypeID BIGINT = NULL,
			@EIDSSAnimalID NVARCHAR(200) = NULL,
			@AnimalName NVARCHAR(200) = NULL,
			@Color NVARCHAR(200) = NULL,
			@AnimalDescription NVARCHAR(200) = NULL,
			@MonitoringSessionToSampleTypeID BIGINT,
			@OrderNumber INT,
			@SampleID BIGINT,
			@SampleTypeID BIGINT = NULL,
			@CollectedByPersonID BIGINT = NULL,
			@CollectedByOrganizationID BIGINT = NULL,
			@CollectionDate DATETIME = NULL,
			@SentDate DATETIME = NULL,
			@EIDSSLocalOrFieldSampleID NVARCHAR(200) = NULL,
			@SampleStatusTypeID BIGINT = NULL,
			@EIDSSLaboratorySampleID NVARCHAR(200) = NULL,
			@SentToOrganizationID BIGINT = NULL,
			@ReadOnlyIndicator BIT = NULL,
			@AccessionDate DATETIME = NULL,
			@AccessionConditionTypeID BIGINT = NULL,
			@AccessionComment NVARCHAR(200) = NULL,
			@AccessionByPersonID BIGINT = NULL,
			@BirdStatusTypeID BIGINT = NULL,
			@CurrentSiteID BIGINT = NULL,
			@TestID BIGINT,
			@TestNameTypeID BIGINT = NULL,
			@TestCategoryTypeID BIGINT = NULL,
			@TestResultTypeID BIGINT = NULL,
			@TestStatusTypeID BIGINT,
			@BatchTestID BIGINT = NULL,
			@TestNumber INT = NULL,
			@StartedDate DATETIME = NULL,
			@ResultDate DATETIME = NULL,
			@TestedByPersonID BIGINT = NULL,
			@TestedByOrganizationID BIGINT = NULL,
			@ResultEnteredByOrganizationID BIGINT = NULL,
			@ResultEnteredByPersonID BIGINT = NULL,
			@ValidatedByOrganizationID BIGINT = NULL,
			@ValidatedByPersonID BIGINT = NULL,
			@NonLaboratoryTestIndicator BIT,
			@ExternalTestIndicator BIT = NULL,
			@PerformedByOrganizationID BIGINT = NULL,
			@ReceivedDate DATETIME = NULL,
			@ContactPersonName NVARCHAR(200) = NULL,
			@TestInterpretationID BIGINT,
			@InterpretedStatusTypeID BIGINT = NULL,
			@InterpretedByOrganizationID BIGINT = NULL,
			@InterpretedByPersonID BIGINT = NULL,
			@TestingInterpretations BIGINT,
			@ValidatedStatusIndicator BIT = NULL,
			@ReportSessionCreatedIndicator BIT = NULL,
			@ValidatedComment NVARCHAR(200) = NULL,
			@InterpretedComment NVARCHAR(200) = NULL,
			@ValidatedDate DATETIME = NULL,
			@InterpretedDate DATETIME = NULL,
			@MonitoringSessionActionID BIGINT,
			@MonitoringSessionActionTypeID BIGINT,
			@MonitoringSessionActionStatusTypeID BIGINT,
			@ActionDate DATETIME = NULL,
			@Comments NVARCHAR(500) = NULL,
			@MonitoringSessionSummaryID BIGINT,
			@SampledAnimalsQuantity INT = NULL,
			@SamplesQuantity INT = NULL,
			@PositiveAnimalsQuantity INT = NULL;
		DECLARE @DiseaseCombinationsTemp TABLE (
			MonitoringSessionToDiseaseID BIGINT NOT NULL,
			DiseaseID BIGINT NOT NULL,
			SampleTypeID BIGINT NULL,
			SpeciesTypeID BIGINT NULL, 
			OrderNumber INT NOT NULL,
			RowStatus INT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @FarmsTemp TABLE (
			FarmID BIGINT NOT NULL,
			FarmMasterID BIGINT NOT NULL,
			EIDSSFarmID NVARCHAR(200) NULL,
			SickAnimalQuantity INT NULL,
			TotalAnimalQuantity INT NULL,
			DeadAnimalQuantity INT NULL,
			Comments NVARCHAR(2000) NULL,
			RowStatus INT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @HerdsOrFlocksTemp TABLE (
			HerdID BIGINT NOT NULL,
			HerdMasterID BIGINT NOT NULL,
			FarmID BIGINT NOT NULL,
			EIDSSHerdID NVARCHAR(200) NULL,
			SickAnimalQuantity INT NULL,
			TotalAnimalQuantity INT NULL,
			DeadAnimalQuantity INT NULL,
			Comments NVARCHAR(2000) NULL,
			RowStatus INT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @SpeciesTemp TABLE (
			SpeciesID BIGINT NOT NULL,
			SpeciesMasterID BIGINT NOT NULL,
			HerdID BIGINT NOT NULL,
			SpeciesTypeID BIGINT NOT NULL,
			SickAnimalQuantity INT NULL,
			TotalAnimalQuantity INT NULL,
			DeadAnimalQuantity INT NULL,
			StartOfSignsDate DATETIME NULL,
			AverageAge NVARCHAR(200) NULL,
			ObservationID BIGINT NULL,
			Comments NVARCHAR(2000) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @AnimalsTemp TABLE (
			AnimalID BIGINT NOT NULL,
			AnimalGenderTypeID BIGINT NULL,
			AnimalConditionTypeID BIGINT NULL,
			AnimalAgeTypeID BIGINT NULL,
			SpeciesID BIGINT NULL,
			ObservationID BIGINT NULL,
			EIDSSAnimalID NVARCHAR(200) NULL,
			AnimalName NVARCHAR(200) NULL,
			Color NVARCHAR(200) NULL,
			AnimalDescription NVARCHAR(200) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @SpeciesToSampleTypeCombinationsTemp TABLE (
			MonitoringSessionToSampleTypeID BIGINT NOT NULL,
			MonitoringSessionID BIGINT NOT NULL,
			SampleTypeID BIGINT NULL,
			SpeciesTypeID BIGINT NULL,
			OrderNumber INT NOT NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1)
			);
		DECLARE @SamplesTemp TABLE (
			SampleID BIGINT NOT NULL,
			SampleTypeID BIGINT NULL,
			SpeciesID BIGINT NULL,
			AnimalID BIGINT NULL,
			MonitoringSessionID BIGINT NULL,
			SampleStatusTypeID BIGINT NULL,
			CollectionDate DATETIME NULL,
			CollectedByOrganizationID BIGINT NULL,
			CollectedByPersonID BIGINT NULL,
			SentDate DATETIME NULL,
			SentToOrganizationID BIGINT NULL,
			EIDSSLocalOrFieldSampleID NVARCHAR(200) NULL,
			Comments NVARCHAR(200) NULL,
			SiteID BIGINT NOT NULL,
			EnteredDate DATETIME NULL,
			BirdStatusTypeID BIGINT NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @TestsTemp TABLE (
			TestID BIGINT NOT NULL,
			TestNameTypeID BIGINT NULL,
			TestCategoryTypeID BIGINT NULL,
			TestResultTypeID BIGINT NULL,
			TestStatusTypeID BIGINT NOT NULL,
			DiseaseID BIGINT NULL,
			SampleID BIGINT NULL,
			BatchTestID BIGINT NULL,
			ObservationID BIGINT NULL,
			TestNumber INT NULL,
			Comments NVARCHAR NULL,
			StartedDate DATETIME NULL,
			ResultDate DATETIME NULL,
			TestedByOrganizationID BIGINT NULL,
			TestedByPersonID BIGINT NULL,
			ResultEnteredByOrganizationID BIGINT NULL,
			ResultEnteredByPersonID BIGINT NULL,
			ValidatedByOrganizationID BIGINT NULL,
			ValidatedByPersonID BIGINT NULL,
			ReadOnlyIndicator BIT NOT NULL,
			NonLaboratoryTestIndicator BIT NOT NULL,
			ExternalTestIndicator BIT NULL,
			PerformedByOrganizationID BIGINT NULL,
			ReceivedDate DATETIME NULL,
			ContactPersonName NVARCHAR(200) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @TestInterpretationsTemp TABLE (
			TestInterpretationID BIGINT NOT NULL,
			DiseaseID BIGINT NULL,
			InterpretedStatusTypeID BIGINT NULL,
			ValidatedByOrganizationID BIGINT NULL,
			ValidatedByPersonID BIGINT NULL,
			InterpretedByOrganizationID BIGINT NULL,
			InterpretedByPersonID BIGINT NULL,
			TestID BIGINT NOT NULL,
			ValidatedStatusIndicator BIT NULL,
			ReportSessionCreatedIndicator BIT NULL,
			ValidatedComment NVARCHAR(200) NULL,
			InterpretedComment NVARCHAR(200) NULL,
			ValidatedDate DATETIME NULL,
			InterpretedDate DATETIME NULL,
			ReadOnlyIndicator BIT NOT NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @ActionsTemp TABLE (
			MonitoringSessionActionID BIGINT NOT NULL,
			MonitoringSessionID BIGINT NULL,
			PersonEnteredByID BIGINT NULL,
			MonitoringSessionActionTypeID BIGINT NULL,
			MonitoringSessionActionStatusTypeID BIGINT NULL,
			ActionDate DATETIME NULL,
			Comments NVARCHAR(500) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @SummariesTemp TABLE (
			MonitoringSessionSummaryID BIGINT NOT NULL,
			MonitoringSessionID BIGINT NOT NULL,
			FarmID BIGINT NOT NULL,
			SpeciesID BIGINT NULL,
			AnimalGenderTypeID BIGINT NULL,
			SampledAnimalsQuantity INT NULL,
			SamplesQuantity INT NULL,
			CollectionDate DATETIME NULL,
			PositiveAnimalsQuantity INT NULL,
			RowStatus INT NOT NULL,
			SampleTypeID BIGINT NULL,
			SampleCheckedIndicator BIT NULL,
			DiseaseID BIGINT NULL,
			RowAction CHAR(1) NULL
			);

		BEGIN TRANSACTION;

		INSERT INTO @DiseaseCombinationsTemp
		SELECT *
		FROM OPENJSON(@DiseaseCombinations) WITH (
				MonitoringSessionToDiseaseID BIGINT,
				DiseaseID BIGINT,
				SampleTypeID BIGINT, 
				SpeciesTypeID BIGINT, 
				OrderNumber INT,
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @FarmsTemp
		SELECT *
		FROM OPENJSON(@Farms) WITH (
				FarmID BIGINT,
				FarmMasterID BIGINT,
				EIDSSFarmID NVARCHAR(200),
				SickAnimalQuantity INT,
				TotalAnimalQuantity INT,
				DeadAnimalQuantity INT,
				Comments NVARCHAR(2000),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @HerdsOrFlocksTemp
		SELECT *
		FROM OPENJSON(@HerdsOrFlocks) WITH (
				HerdID BIGINT,
				HerdMasterID BIGINT,
				FarmID BIGINT,
				EIDSSHerdID NVARCHAR(200),
				SickAnimalQuantity INT,
				TotalAnimalQuantity INT,
				DeadAnimalQuantity INT,
				Comments NVARCHAR(2000),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @SpeciesTemp
		SELECT *
		FROM OPENJSON(@Species) WITH (
				SpeciesID BIGINT,
				SpeciesMasterID BIGINT,
				HerdID BIGINT,
				SpeciesTypeID BIGINT,
				SickAnimalQuantity INT,
				TotalAnimalQuantity INT,
				DeadAnimalQuantity INT,
				StartOfSignsDate DATETIME,
				AverageAge NVARCHAR(200),
				ObservationID BIGINT,
				Comments NVARCHAR(2000),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @AnimalsTemp
		SELECT *
		FROM OPENJSON(@Animals) WITH (
				AnimalID BIGINT,
				AnimalGenderTypeID BIGINT,
				AnimalConditionTypeID BIGINT,
				AnimalAgeTypeID BIGINT,
				SpeciesID BIGINT,
				ObservationID BIGINT,
				EIDSSAnimalID NVARCHAR(200),
				AnimalName NVARCHAR(200),
				Color NVARCHAR(200),
				AnimalDescription NVARCHAR(200),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @SpeciesToSampleTypeCombinationsTemp
		SELECT *
		FROM OPENJSON(@SpeciesToSampleTypeCombinations) WITH (
				MonitoringSessionToSampleTypeID BIGINT,
				MonitoringSessionID BIGINT,
				SampleTypeID BIGINT,
				SpeciesTypeID BIGINT,
				OrderNumber INT,
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @SamplesTemp
		SELECT *
		FROM OPENJSON(@Samples) WITH (
				SampleID BIGINT,
				SampleTypeID BIGINT,
				SpeciesID BIGINT,
				AnimalID BIGINT,
				MonitoringSessionID BIGINT,
				SampleStatusTypeID BIGINT,
				CollectionDate DATETIME2,
				CollectedByOrganizationID BIGINT,
				CollectedByPersonID BIGINT,
				SentDate DATETIME2,
				SentToOrganizationID BIGINT,
				EIDSSLocalOrFieldSampleID NVARCHAR(200),
				Comments NVARCHAR(200),
				SiteID BIGINT,
				EnteredDate DATETIME2,
				BirdStatusTypeID BIGINT,
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @TestsTemp
		SELECT *
		FROM OPENJSON(@Tests) WITH (
				TestID BIGINT,
				TestNameTypeID BIGINT,
				TestCategoryTypeID BIGINT,
				TestResultTypeID BIGINT,
				TestStatusTypeID BIGINT,
				DiseaseID BIGINT,
				SampleID BIGINT,
				BatchTestID BIGINT,
				ObservationID BIGINT,
				TestNumber INT,
				Comments NVARCHAR(500),
				StartedDate DATETIME2,
				ResultDate DATETIME2,
				TestedByOrganizationID BIGINT,
				TestedByPersonID BIGINT,
				ResultEnteredByOrganizationID BIGINT,
				ResultEnteredByPersonID BIGINT,
				ValidatedByOrganizationID BIGINT,
				ValidatedByPersonID BIGINT,
				ReadOnlyIndicator BIT,
				NonLaboratoryTestIndicator BIT,
				ExternalTestIndicator BIT,
				PerformedByOrganizationID BIGINT,
				ReceivedDate DATETIME2,
				ContactPersonName NVARCHAR(200),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @TestInterpretationsTemp
		SELECT *
		FROM OPENJSON(@TestInterpretations) WITH (
				TestInterpretationID BIGINT,
				DiseaseID BIGINT,
				InterpretedStatusTypeID BIGINT,
				ValidatedByOrganizationID BIGINT,
				ValidatedByPersonID BIGINT,
				InterpretedByOrganizationID BIGINT,
				InterpretedByPersonID BIGINT,
				TestID BIGINT,
				ValidatedStatusIndicator BIT,
				ReportSessionCreatedIndicator BIT,
				ValidatedComment NVARCHAR(200),
				InterpretedComment NVARCHAR(200),
				ValidatedDate DATETIME2,
				InterpretedDate DATETIME2,
				ReadOnlyIndicator BIT,
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @ActionsTemp
		SELECT *
		FROM OPENJSON(@Actions) WITH (
				MonitoringSessionActionID BIGINT,
				MonitoringSessionID BIGINT,
				PersonEnteredByID BIGINT,
				MonitoringSessionActionTypeID BIGINT,
				MonitoringSessionActionStatusTypeID BIGINT,
				ActionDate DATETIME2,
				Comments NVARCHAR(500),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @SummariesTemp
		SELECT *
		FROM OPENJSON(@Summaries) WITH (
				MonitoringSessionSummaryID BIGINT,
				MonitoringSessionID BIGINT,
				FarmID BIGINT,
				SpeciesID BIGINT,
				AnimalGenderTypeID BIGINT,
				SampledAnimalsQuantity INT,
				SamplesQuantity INT,
				CollectionDate DATETIME2,
				PositiveAnimalsQuantity INT,
				RowStatus INT,
				SampleTypeID BIGINT,
				SampleCheckedIndicator BIT,
				DiseaseID BIGINT,
				RowAction CHAR(1)
				);

		IF EXISTS (
				SELECT *
				FROM dbo.tlbMonitoringSession
				WHERE idfMonitoringSession = @MonitoringSessionID
				)
		BEGIN
			UPDATE dbo.tlbMonitoringSession
			SET idfsMonitoringSessionStatus = @MonitoringSessionStatusTypeID,
				idfsCountry = @CountryID,
				idfsRegion = @RegionID,
				idfsRayon = @RayonID,
				idfsSettlement = @SettlementID,
				idfPersonEnteredBy = @EnteredByPersonID,
				idfCampaign = @CampaignID,
				idfsSite = @SiteID,
				idfsDiagnosis = @DiseaseID,
				datEnteredDate = @EnteredDate,
				datStartDate = @StartDate,
				datEndDate = @EndDate,
				SessionCategoryID = @SessionCategoryTypeID,
				AuditUpdateUser = @AuditUserName
			WHERE idfMonitoringSession = @MonitoringSessionID;

			UPDATE dbo.tlbCampaign
			SET strCampaignName = @CampaignName,
				idfsCampaignType = @CampaignTypeID,
				datCampaignDateStart = @CampaignStartDate,
				datCampaignDateEnd = @CampaignEndDate
			WHERE idfCampaign = @CampaignID
		END
		ELSE
		BEGIN
			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSession',
				@MonitoringSessionID OUTPUT;

			EXECUTE dbo.USP_GBL_NextNumber_GET 'Active Surveillance Session',
				@EIDSSSessionID OUTPUT,
				NULL;

			INSERT INTO dbo.tlbMonitoringSession (
				idfMonitoringSession,
				idfsMonitoringSessionStatus,
				idfsCountry,
				idfsRegion,
				idfsRayon,
				idfsSettlement,
				idfPersonEnteredBy,
				idfCampaign,
				idfsSite,
				idfsDiagnosis,
				datEnteredDate,
				strMonitoringSessionID,
				datStartDate,
				datEndDate,
				SessionCategoryID,
				LegacySessionID,
				intRowStatus,
				AuditCreateUser
				)
			VALUES (
				@MonitoringSessionID,
				@MonitoringSessionStatusTypeID,
				@CountryID,
				@RegionID,
				@RayonID,
				@SettlementID,
				@EnteredByPersonID,
				@CampaignID,
				@SiteID,
				@DiseaseID,
				@EnteredDate,
				@EIDSSSessionID,
				@StartDate,
				@EndDate,
				@SessionCategoryTypeID,
				@AvianOrLivestock,
				0,
				@AuditUserName
				);
		END

		WHILE EXISTS (
				SELECT *
				FROM @DiseaseCombinationsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = MonitoringSessionToDiseaseID,
				@MonitoringSessionToDiseaseID = MonitoringSessionToDiseaseID,
				@DiseaseID = DiseaseID,
				@SampleTypeID = SampleTypeID, 
				@SpeciesTypeID = SpeciesTypeID, 
				@OrderNumber = OrderNumber,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @DiseaseCombinationsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VCT_MONITORING_SESSION_TO_DISEASE_SET @LanguageID,
				@MonitoringSessionToDiseaseID OUTPUT,
				@MonitoringSessionID,
				@DiseaseID,
				@OrderNumber,
				@RowStatus,
				@SpeciesTypeID,
				@SampleTypeID,
				@RowAction;

			DELETE
			FROM @DiseaseCombinationsTemp
			WHERE MonitoringSessionToDiseaseID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @FarmsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = FarmID,
				@FarmID = FarmID,
				@FarmMasterID = FarmMasterID,
				@EIDSSFarmID = EIDSSFarmID,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @FarmsTemp;

			IF @RowAction = 'D'
			BEGIN
				EXECUTE dbo.USSP_VET_FARM_DEL @FarmID;
			END
			ELSE
			BEGIN
				IF @RowAction = 'I'
				BEGIN
					IF @AvianOrLivestock = 'Avian'
					BEGIN
						EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
							@TotalAnimalQuantity,
							@SickAnimalQuantity,
							@DeadAnimalQuantity,
							NULL,
							NULL,
							NULL,
							@MonitoringSessionID,
							NULL, 
							@FarmID OUTPUT;
					END
					ELSE
					BEGIN
						EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
							NULL,
							NULL,
							NULL,
							@TotalAnimalQuantity,
							@SickAnimalQuantity,
							@DeadAnimalQuantity,
							@MonitoringSessionID,
							NULL, 
							@FarmID OUTPUT;
					END

					UPDATE @HerdsOrFlocksTemp
					SET FarmID = @FarmID
					WHERE FarmID = @RowID;

					UPDATE @SummariesTemp
					SET FarmID = @FarmID
					WHERE FarmID = @RowID;
				END
			END

			DELETE
			FROM @FarmsTemp
			WHERE FarmID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @HerdsOrFlocksTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = HerdID,
				@HerdID = HerdID,
				@HerdMasterID = HerdMasterID,
				@FarmID = FarmID,
				@EIDSSHerdID = EIDSSHerdID,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @HerdsOrFlocksTemp;

			IF @HerdMasterID < 0
			BEGIN
				INSERT INTO @SuppressSelect
				EXECUTE dbo.USSP_VET_HERD_MASTER_SET @LanguageID,
					@HerdMasterID OUTPUT,
					@FarmMasterID,
					@EIDSSHerdID OUTPUT,
					@SickAnimalQuantity,
					@TotalAnimalQuantity,
					@DeadAnimalQuantity,
					@Comments,
					@RowStatus,
					@RowAction;

				UPDATE @HerdsOrFlocksTemp
				SET HerdMasterID = @HerdMasterID,
					EIDSSHerdID = @EIDSSHerdID
				WHERE HerdMasterID = @HerdMasterID;
			END;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VET_HERD_SET @LanguageID,
				@HerdID OUTPUT,
				@HerdMasterID,
				@FarmID,
				@EIDSSHerdID,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Comments,
				@RowStatus,
				@RowAction;

			UPDATE @SpeciesTemp
			SET HerdID = @HerdID
			WHERE HerdID = @RowID;

			DELETE
			FROM @HerdsOrFlocksTemp
			WHERE HerdID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @SpeciesTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = SpeciesID,
				@SpeciesID = SpeciesID,
				@SpeciesMasterID = SpeciesMasterID,
				@SpeciesTypeID = SpeciesTypeID,
				@HerdID = HerdID,
				@StartOfSignsDate = StartOfSignsDate,
				@AverageAge = AverageAge,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @SpeciesTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VET_SPECIES_SET @LanguageID,
				@SpeciesID OUTPUT,
				@SpeciesMasterID,
				@SpeciesTypeID,
				@HerdID,
				@StartOfSignsDate,
				@AverageAge,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Note,
				@RowStatus,
				NULL,
				@RowAction;

			IF @AvianOrLivestock = 'Livestock'
			BEGIN
				UPDATE @AnimalsTemp
				SET SpeciesID = @SpeciesID
				WHERE SpeciesID = @RowID;
			END

			UPDATE @SamplesTemp
			SET SpeciesID = @SpeciesID
			WHERE SpeciesID = @RowID;

			UPDATE @SummariesTemp
			SET SpeciesID = @SpeciesID
			WHERE SpeciesID = @RowID;

			DELETE
			FROM @SpeciesTemp
			WHERE SpeciesID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @AnimalsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = AnimalID,
				@AnimalID = AnimalID,
				@AnimalGenderTypeID = AnimalGenderTypeID,
				@AnimalAgeTypeID = AnimalAgeTypeID,
				@SpeciesID = SpeciesID,
				@AnimalDescription = AnimalDescription,
				@EIDSSAnimalID = EIDSSAnimalID,
				@AnimalName = AnimalName,
				@Color = Color,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @AnimalsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VET_ANIMAL_SET @LanguageID,
				@AnimalID OUTPUT,
				@AnimalGenderTypeID,
				@AnimalConditionTypeID,
				@AnimalAgeTypeID,
				@SpeciesID,
				@AnimalDescription,
				@EIDSSAnimalID,
				@AnimalName,
				@Color,
				@RowStatus,
				@RowAction;

			UPDATE @SamplesTemp
			SET AnimalID = @AnimalID
			WHERE AnimalID = @RowID;

			DELETE
			FROM @AnimalsTemp
			WHERE AnimalID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @SpeciesToSampleTypeCombinationsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = MonitoringSessionToSampleTypeID,
				@MonitoringSessionToSampleTypeID = MonitoringSessionToSampleTypeID,
				@OrderNumber = OrderNumber,
				@RowStatus = RowStatus,
				@SpeciesTypeID = SpeciesTypeID,
				@SampleTypeID = SampleTypeID,
				@RowAction = RowAction
			FROM @SpeciesToSampleTypeCombinationsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VCT_MONITORING_SESSION_TO_SAMPLE_TYPE_SET @LanguageID,
				@MonitoringSessionToSampleTypeID,
				@MonitoringSessionID,
				@OrderNumber,
				@RowStatus,
				@SpeciesTypeID,
				@SampleTypeID,
				@RowAction;

			DELETE
			FROM @SpeciesToSampleTypeCombinationsTemp
			WHERE MonitoringSessionToSampleTypeID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @SamplesTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = SampleID,
				@SampleID = SampleID,
				@SampleTypeID = SampleTypeID,
				@SpeciesID = SpeciesID,
				@AnimalID = AnimalID,
				@MonitoringSessionID = MonitoringSessionID,
				@CollectedByPersonID = CollectedByPersonID,
				@CollectedByOrganizationID = CollectedByOrganizationID,
				@CollectionDate = CollectionDate,
				@SentDate = SentDate,
				@EIDSSLocalOrFieldSampleID = EIDSSLocalOrFieldSampleID,
				@SampleStatusTypeID = SampleStatusTypeID,
				@EnteredDate = EnteredDate,
				@Comments = Comments,
				@SiteID = SiteID,
				@RowStatus = RowStatus,
				@SentToOrganizationID = SentToOrganizationID,
				@BirdStatusTypeID = BirdStatusTypeID,
				@RowAction = RowAction
			FROM @SamplesTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_GBL_SAMPLE_SET @LanguageID,
				@SampleID OUTPUT,
				@SampleTypeID,
				NULL,
				NULL,
				NULL,
				@SpeciesID,
				@AnimalID,
				NULL,
				@MonitoringSessionID,
				NULL,
				NULL,
				NULL,
				@CollectionDate,
				@CollectedByPersonID,
				@CollectedByOrganizationID,
				@SentDate,
				@SentToOrganizationID,
				@EIDSSLocalOrFieldSampleID,
				@SiteID,
				@EnteredDate,
				@ReadOnlyIndicator,
				@SampleStatusTypeID,
				@Comments,
				@SiteID,
				@DiseaseID,
				@BirdStatusTypeID,
				@RowStatus,
				@RowAction;

			UPDATE @TestsTemp
			SET SampleID = @SampleID
			WHERE SampleID = @RowID;

			DELETE
			FROM @SamplesTemp
			WHERE SampleID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @TestsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = TestID,
				@TestID = TestID,
				@TestNameTypeID = TestNameTypeID,
				@TestCategoryTypeID = TestCategoryTypeID,
				@TestResultTypeID = TestResultTypeID,
				@TestStatusTypeID = TestStatusTypeID,
				@DiseaseID = DiseaseID,
				@SampleID = SampleID,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@StartedDate = StartedDate,
				@ResultDate = ResultDate,
				@TestedByOrganizationID = TestedByOrganizationID,
				@TestedByPersonID = TestedByPersonID,
				@ResultEnteredByOrganizationID = ResultEnteredByOrganizationID,
				@ResultEnteredByPersonID = ResultEnteredByPersonID,
				@ValidatedByOrganizationID = ValidatedByOrganizationID,
				@ValidatedByPersonID = ValidatedByPersonID,
				@ReadOnlyIndicator = ReadOnlyIndicator,
				@NonLaboratoryTestIndicator = NonLaboratoryTestIndicator,
				@ExternalTestIndicator = ExternalTestIndicator,
				@PerformedByOrganizationID = PerformedByOrganizationID,
				@ReceivedDate = ReceivedDate,
				@ContactPersonName = ContactPersonName,
				@RowAction = RowAction
			FROM @TestsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_GBL_TEST_SET @LanguageID,
				@TestID OUTPUT,
				@TestNameTypeID,
				@TestCategoryTypeID,
				@TestResultTypeID,
				@TestStatusTypeID,
				@DiseaseID,
				@SampleID,
				NULL,
				NULL,
				NULL,
				@Comments,
				@RowStatus,
				@StartedDate,
				@ResultDate,
				@TestedByOrganizationID,
				@TestedByPersonID,
				@ResultEnteredByOrganizationID,
				@ResultEnteredByPersonID,
				@ValidatedByOrganizationID,
				@ValidatedByPersonID,
				@ReadOnlyIndicator,
				@NonLaboratoryTestIndicator,
				@ExternalTestIndicator,
				@PerformedByOrganizationID,
				@ReceivedDate,
				@ContactPersonName,
				@RowAction;

			UPDATE @TestInterpretationsTemp
			SET TestID = @TestID
			WHERE TestID = @RowID;

			DELETE
			FROM @TestsTemp
			WHERE TestID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @TestInterpretationsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = TestInterpretationID,
				@TestInterpretationID = TestInterpretationID,
				@DiseaseID = DiseaseID,
				@InterpretedStatusTypeID = InterpretedStatusTypeID,
				@ValidatedByOrganizationID = ValidatedByOrganizationID,
				@ValidatedByPersonID = ValidatedByPersonID,
				@InterpretedByOrganizationID = InterpretedByOrganizationID,
				@InterpretedByPersonID = InterpretedByPersonID,
				@TestID = TestID,
				@ValidatedStatusIndicator = ValidatedStatusIndicator,
				@ValidatedComment = ValidatedComment,
				@InterpretedComment = InterpretedComment,
				@ValidatedDate = ValidatedDate,
				@InterpretedDate = InterpretedDate,
				@RowStatus = RowStatus,
				@ReadOnlyIndicator = ReadOnlyIndicator,
				@RowAction = RowAction
			FROM @TestInterpretationsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_GBL_TEST_INTERPRETATION_SET @LanguageID,
				@TestInterpretationID OUTPUT,
				@DiseaseID,
				@InterpretedStatusTypeID,
				@ValidatedByOrganizationID,
				@ValidatedByPersonID,
				@InterpretedByOrganizationID,
				@InterpretedByPersonID,
				@TestID,
				@ValidatedStatusIndicator,
				NULL,
				@ValidatedComment,
				@InterpretedComment,
				@ValidatedDate,
				@InterpretedDate,
				@RowStatus,
				@ReadOnlyIndicator,
				@RowAction;

			DELETE
			FROM @TestInterpretationsTemp
			WHERE TestInterpretationID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @ActionsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = MonitoringSessionActionID,
				@MonitoringSessionActionID = MonitoringSessionActionID,
				@EnteredByPersonID = PersonEnteredByID,
				@MonitoringSessionActionTypeID = MonitoringSessionActionTypeID,
				@MonitoringSessionActionStatusTypeID = MonitoringSessionActionStatusTypeID,
				@ActionDate = ActionDate,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @ActionsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VCT_MONITORING_SESSION_ACTION_SET @LanguageID,
				@MonitoringSessionActionID OUTPUT,
				@MonitoringSessionID,
				@EnteredByPersonID,
				@MonitoringSessionActionTypeID,
				@MonitoringSessionActionStatusTypeID,
				@ActionDate,
				@Comments,
				@RowStatus,
				@RowAction

			DELETE
			FROM @ActionsTemp
			WHERE MonitoringSessionActionID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @SummariesTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = MonitoringSessionSummaryID,
				@MonitoringSessionSummaryID = MonitoringSessionSummaryID,
				@FarmID = FarmID,
				@SpeciesID = SpeciesID,
				@AnimalGenderTypeID = AnimalGenderTypeID,
				@SampledAnimalsQuantity = SampledAnimalsQuantity,
				@SamplesQuantity = SamplesQuantity,
				@CollectionDate = CollectionDate,
				@PositiveAnimalsQuantity = PositiveAnimalsQuantity,
				@RowStatus = RowStatus,
				@DiseaseID = DiseaseID,
				@SampleTypeID = SampleTypeID,
				@RowAction = RowAction
			FROM @SummariesTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VCT_MONITORING_SESSION_SUMMARY_SET @LanguageID,
				@MonitoringSessionSummaryID OUTPUT,
				@MonitoringSessionID,
				@FarmID,
				@SpeciesID,
				@AnimalGenderTypeID,
				@SampledAnimalsQuantity,
				@SamplesQuantity,
				@CollectionDate,
				@PositiveAnimalsQuantity,
				@RowStatus,
				@DiseaseID,
				@SampleTypeID,
				@RowAction

			DELETE
			FROM @SummariesTemp
			WHERE MonitoringSessionSummaryID = @RowID;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@MonitoringSessionID MonitoringSessionID,
			@EIDSSSessionID EIDSSSessionID;
	END TRY

	BEGIN CATCH
		IF @@Trancount > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@MonitoringSessionID MonitoringSessionID,
			@EIDSSSessionID EIDSSSessionID;

		THROW;
	END CATCH
END
