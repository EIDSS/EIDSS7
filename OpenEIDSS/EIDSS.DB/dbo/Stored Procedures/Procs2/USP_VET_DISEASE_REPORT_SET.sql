-- ================================================================================================
-- Name: USP_VET_DISEASE_REPORT_SET
--
-- Description:	Inserts or updates veterinary "case" for the avian and livestock veterinary disease 
-- report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/17/2019 Updated for API; use case updates.
-- Stephen Long     04/23/2019 Added updates for herd master and species master if new ones are 
--                             added to the farm during disease report creation.
-- Stephen Long     04/29/2019 Added related to veterinary disease report fields for use case VUC11 
--                             and VUC12.
-- Stephen Long     05/26/2019 Made corrections to farm copy observation ID and species table 
--                             observation ID for flexible form saving.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_REPORT_SET] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@FarmID BIGINT = NULL,
	@FarmMasterID BIGINT = NULL,
	@FarmOwnerID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@PersonEnteredByID BIGINT = NULL,
	@PersonReportedByID BIGINT = NULL,
	@PersonInvestigatedByID BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@ReportDate DATETIME = NULL,
	@AssignedDate DATETIME = NULL,
	@InvestigationDate DATETIME = NULL,
	@EIDSSFieldAccessionID NVARCHAR(200) = NULL,
	@RowStatus INT = NULL,
	@ReportedByOrganizationID BIGINT = NULL,
	@InvestigatedByOrganizationID BIGINT = NULL,
	@ReportTypeID BIGINT = NULL,
	@ClassificationTypeID BIGINT = NULL,
	@OutbreakID BIGINT = NULL,
	@EnteredDate DATETIME = NULL,
	@EIDSSReportID NVARCHAR(200) = NULL,
	@StatusTypeID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@ReportCategoryTypeID BIGINT = NULL,
	@FarmTotalAnimalQuantity INT = NULL,
	@FarmSickAnimalQuantity INT = NULL,
	@FarmDeadAnimalQuantity INT = NULL,
	@RelatedToVeterinaryDiseaseReportID BIGINT = NULL,
	@FarmEpidemiologicalObservationID BIGINT = NULL,
	@ControlMeasuresObservationID BIGINT = NULL,
	@HerdsOrFlocks NVARCHAR(MAX) = NULL,
	@Species NVARCHAR(MAX) = NULL,
	@Animals NVARCHAR(MAX) = NULL,
	@Vaccinations NVARCHAR(MAX) = NULL,
	@Samples NVARCHAR(MAX) = NULL,
	@PensideTests NVARCHAR(MAX) = NULL,
	@Tests NVARCHAR(MAX) = NULL,
	@TestInterpretations NVARCHAR(MAX) = NULL,
	@ReportLogs NVARCHAR(MAX) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnCode INT = 0;
		DECLARE @ReturnMessage NVARCHAR(MAX) = 'SUCCESS';
		DECLARE @SuppressSelect TABLE (
			ReturnCode INT,
			ReturnMessage NVARCHAR(MAX)
			);
		DECLARE @RowAction CHAR = NULL,
			@RowID BIGINT = NULL,
			@HerdID BIGINT = NULL,
			@HerdMasterID BIGINT = NULL,
			@EIDSSHerdID NVARCHAR(200) = NULL,
			@SickAnimalQuantity INT = NULL,
			@TotalAnimalQuantity INT = NULL,
			@DeadAnimalQuantity INT = NULL,
			@Comments NVARCHAR(2000) = NULL,
			@SpeciesID BIGINT = NULL,
			@SpeciesMasterID BIGINT = NULL,
			@SpeciesTypeID BIGINT = NULL,
			@StartOfSignsDate DATETIME = NULL,
			@AverageAge NVARCHAR(200) = NULL,
			@ObservationID BIGINT = NULL,
			@AnimalID BIGINT = NULL,
			@AnimalGenderTypeID BIGINT = NULL,
			@AnimalConditionTypeID BIGINT = NULL,
			@AnimalAgeTypeID BIGINT = NULL,
			@EIDSSAnimalID NVARCHAR(200) = NULL,
			@AnimalName NVARCHAR(200) = NULL,
			@Color NVARCHAR(200) = NULL,
			@AnimalDescription NVARCHAR(200) = NULL,
			@VaccinationID BIGINT,
			@VaccinationTypeID BIGINT = NULL,
			@RouteTypeID BIGINT = NULL,
			@VaccinationDate DATETIME = NULL,
			@Manufacturer NVARCHAR(200) = NULL,
			@LotNumber NVARCHAR(200) = NULL,
			@NumberVaccinated INT = NULL,
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
			@BirdStatusTypeID BIGINT = NULL,
			@PensideTestID BIGINT = NULL,
			@PensideTestResultTypeID BIGINT = NULL,
			@PensideTestNameTypeID BIGINT = NULL,
			@TestedByPersonID BIGINT = NULL,
			@TestedByOrganizationID BIGINT = NULL,
			@TestDate DATETIME = NULL,
			@PensideTestCategoryTypeID BIGINT = NULL,
			@TestID BIGINT = NULL,
			@TestNameTypeID BIGINT = NULL,
			@TestCategoryTypeID BIGINT = NULL,
			@TestResultTypeID BIGINT = NULL,
			@TestStatusTypeID BIGINT,
			@BatchTestID BIGINT = NULL,
			@StartedDate DATETIME = NULL,
			@ResultDate DATETIME = NULL,
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
			@VeterinaryDiseaseReportLogID BIGINT,
			@LogStatusTypeID BIGINT = NULL,
			@LoggedByPersonID BIGINT = NULL,
			@LogDate DATETIME = NULL,
			@ActionRequired NVARCHAR(200) = NULL,
			@VeterinaryDiseaseReportRelationshipID BIGINT = NULL;
		DECLARE @HerdsOrFlocksTemp TABLE (
			HerdID BIGINT NOT NULL,
			HerdMasterID BIGINT NOT NULL,
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
		DECLARE @VaccinationsTemp TABLE (
			VaccinationID BIGINT NOT NULL,
			SpeciesID BIGINT NULL,
			VaccinationTypeID BIGINT NULL,
			RouteTypeID BIGINT NULL,
			DiseaseID BIGINT NULL,
			VaccinationDate DATETIME NULL,
			Manufacturer NVARCHAR(200) NULL,
			LotNumber NVARCHAR(200) NULL,
			NumberVaccinated INT NULL,
			Comments NVARCHAR(2000) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
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
		DECLARE @PensideTestsTemp TABLE (
			PensideTestID BIGINT NOT NULL,
			SampleID BIGINT NOT NULL,
			PensideTestNameTypeID BIGINT NULL,
			PensideTestResultTypeID BIGINT NULL,
			PensideTestCategoryTypeID BIGINT NULL,
			TestedByPersonID BIGINT NULL,
			TestedByOrganizationID BIGINT NULL,
			DiseaseID BIGINT NULL,
			TestDate DATETIME NULL,
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
		DECLARE @ReportLogsTemp TABLE (
			VeterinaryDiseaseReportLogID BIGINT NOT NULL,
			LogStatusTypeID BIGINT NULL,
			LoggedByPersonID BIGINT NULL,
			LogDate DATETIME NULL,
			ActionRequired NVARCHAR(200) NULL,
			Comments NVARCHAR(1000) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
			);

		BEGIN TRANSACTION;

		INSERT INTO @HerdsOrFlocksTemp
		SELECT *
		FROM OPENJSON(@HerdsOrFlocks) WITH (
				HerdID BIGINT,
				HerdMasterID BIGINT,
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

		INSERT INTO @VaccinationsTemp
		SELECT *
		FROM OPENJSON(@Vaccinations) WITH (
				VaccinationID BIGINT,
				SpeciesID BIGINT,
				VaccinationTypeID BIGINT,
				RouteTypeID BIGINT,
				DiseaseID BIGINT,
				VaccinationDate DATETIME2,
				Manufacturer NVARCHAR(200),
				LotNumber NVARCHAR(200),
				NumberVaccinated INT,
				Comments NVARCHAR(2000),
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

		INSERT INTO @PensideTestsTemp
		SELECT *
		FROM OPENJSON(@PensideTests) WITH (
				PensideTestID BIGINT,
				SampleID BIGINT,
				PensideTestNameTypeID BIGINT,
				PensideTestResultTypeID BIGINT,
				PensideTestCategoryTypeID BIGINT,
				TestedByPersonID BIGINT,
				TestedByOrganizationID BIGINT,
				DiseaseID BIGINT,
				TestDate DATETIME2,
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

		INSERT INTO @ReportLogsTemp
		SELECT *
		FROM OPENJSON(@ReportLogs) WITH (
				VeterinaryDiseaseReportLogID BIGINT,
				LogStatusTypeID BIGINT,
				LoggedByPersonID BIGINT,
				LogDate DATETIME2,
				ActionRequired NVARCHAR(200),
				Comments NVARCHAR(1000),
				RowStatus INT,
				RowAction CHAR(1)
				);

		IF NOT EXISTS (
				SELECT *
				FROM dbo.tlbVetCase
				WHERE idfVetCase = @VeterinaryDiseaseReportID
					AND intRowStatus = 0
				)
		BEGIN
			IF @ReportCategoryTypeID = 10012004 --Avian
			BEGIN
				UPDATE dbo.tlbFarmActual
				SET intAvianTotalAnimalQty = @TotalAnimalQuantity,
					intAvianSickAnimalQty = @SickAnimalQuantity,
					intAvianDeadAnimalQty = @DeadAnimalQuantity
				WHERE idfFarmActual = @FarmMasterID;

				EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
					@FarmTotalAnimalQuantity,
					@FarmSickAnimalQuantity,
					@FarmDeadAnimalQuantity,
					NULL,
					NULL,
					NULL,
					NULL,
					@FarmEpidemiologicalObservationID, 
					@FarmID OUTPUT;
			END
			ELSE --Livestock
			BEGIN
				UPDATE dbo.tlbFarmActual
				SET intLivestockTotalAnimalQty = @TotalAnimalQuantity,
					intLivestockSickAnimalQty = @SickAnimalQuantity,
					intLivestockDeadAnimalQty = @DeadAnimalQuantity
				WHERE idfFarmActual = @FarmMasterID;

				EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
					NULL,
					NULL,
					NULL,
					@FarmTotalAnimalQuantity,
					@FarmSickAnimalQuantity,
					@FarmDeadAnimalQuantity,
					NULL,
					@FarmEpidemiologicalObservationID, 
					@FarmID OUTPUT;
			END

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbVetCase',
				@VeterinaryDiseaseReportID OUTPUT;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NextNumber_GET 'Vet Disease Report',
				@EIDSSReportID OUTPUT,
				NULL

			INSERT INTO dbo.tlbVetCase (
				idfVetCase,
				idfFarm,
				idfsFinalDiagnosis,
				idfPersonEnteredBy,
				idfPersonReportedBy,
				idfPersonInvestigatedBy,
				idfObservation,
				idfsSite,
				datReportDate,
				datAssignedDate,
				datInvestigationDate,
				datFinalDiagnosisDate,
				strTestNotes,
				strSummaryNotes,
				strClinicalNotes,
				strFieldAccessionID,
				idfsYNTestsConducted,
				intRowStatus,
				idfReportedByOffice,
				idfInvestigatedByOffice,
				idfsCaseReportType,
				strDefaultDisplayDiagnosis,
				idfsCaseClassification,
				idfOutbreak,
				datEnteredDate,
				strCaseID,
				idfsCaseProgressStatus,
				strSampleNotes,
				datModificationForArchiveDate,
				idfParentMonitoringSession,
				idfsCaseType
				)
			VALUES (
				@VeterinaryDiseaseReportID,
				@FarmID,
				@DiseaseID,
				@PersonEnteredByID,
				@PersonReportedByID,
				@PersonInvestigatedByID,
				@ControlMeasuresObservationID,
				@SiteID,
				@ReportDate,
				@AssignedDate,
				@InvestigationDate,
				NULL,
				NULL,
				NULL,
				NULL,
				@EIDSSFieldAccessionID,
				NULL,
				@RowStatus,
				@ReportedByOrganizationID,
				@InvestigatedByOrganizationID,
				@ReportTypeID,
				NULL,
				@ClassificationTypeID,
				@OutbreakID,
				@EnteredDate,
				@EIDSSReportID,
				@StatusTypeID,
				NULL,
				NULL,
				@MonitoringSessionID,
				@ReportCategoryTypeID
				);
		END
		ELSE
		BEGIN
			IF @ReportCategoryTypeID = 10012004 --Avian
			BEGIN
				EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
					@TotalAnimalQuantity,
					@SickAnimalQuantity,
					@DeadAnimalQuantity,
					NULL,
					NULL,
					NULL,
					NULL,
					@FarmEpidemiologicalObservationID, 
					@FarmID OUTPUT;
			END
			ELSE --Livestock
			BEGIN
				EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
					NULL,
					NULL,
					NULL,
					@TotalAnimalQuantity,
					@SickAnimalQuantity,
					@DeadAnimalQuantity,
					NULL,
					@FarmEpidemiologicalObservationID, 
					@FarmID OUTPUT;
			END

			UPDATE dbo.tlbVetCase
			SET idfFarm = @FarmID,
				idfsFinalDiagnosis = @DiseaseID,
				idfPersonEnteredBy = @PersonEnteredByID,
				idfPersonReportedBy = @PersonReportedByID,
				idfPersonInvestigatedBy = @PersonInvestigatedByID,
				idfsSite = @SiteID,
				datReportDate = @ReportDate,
				datAssignedDate = @AssignedDate,
				datInvestigationDate = @InvestigationDate,
				datFinalDiagnosisDate = NULL,
				strTestNotes = NULL,
				strSummaryNotes = NULL,
				strClinicalNotes = NULL,
				strFieldAccessionID = @EIDSSFieldAccessionID,
				idfsYNTestsConducted = NULL,
				intRowStatus = @RowStatus,
				idfReportedByOffice = @ReportedByOrganizationID,
				idfInvestigatedByOffice = @InvestigatedByOrganizationID,
				idfsCaseReportType = @ReportTypeID,
				idfsCaseClassification = @ClassificationTypeID,
				idfOutbreak = @OutbreakID,
				datEnteredDate = @EnteredDate,
				strCaseID = @EIDSSReportID,
				idfsCaseProgressStatus = @StatusTypeID,
				strSampleNotes = NULL,
				idfParentMonitoringSession = @MonitoringSessionID,
				idfsCaseType = @ReportCategoryTypeID
			WHERE idfVetCase = @VeterinaryDiseaseReportID;
		END;

		-- VUC11 and VUC12 - connected disease report logic.
		IF @RelatedToVeterinaryDiseaseReportID IS NOT NULL
		BEGIN
			IF NOT EXISTS (
					SELECT *
					FROM dbo.VetDiseaseReportRelationship
					WHERE VetDiseaseReportID = @VeterinaryDiseaseReportID
						AND intRowStatus = 0
					)
			BEGIN
				INSERT INTO @SuppressSelect
				EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'VetDiseaseReportRelationship',
					@VeterinaryDiseaseReportRelationshipID OUTPUT;

				INSERT INTO dbo.VetDiseaseReportRelationship (
					VetDiseaseReportRelnUID,
					VetDiseaseReportID,
					RelatedToVetDiseaseReportID,
					RelationshipTypeID,
					intRowStatus
					)
				VALUES (
					@VeterinaryDiseaseReportRelationshipID,
					@VeterinaryDiseaseReportID,
					@RelatedToVeterinaryDiseaseReportID,
					10503001,
					0
					);
			END;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @HerdsOrFlocksTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = HerdID,
				@HerdID = HerdID,
				@HerdMasterID = HerdMasterID,
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
				@ObservationID = ObservationID, 
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @SpeciesTemp;

			IF @SpeciesMasterID < 0
			BEGIN
				INSERT INTO @SuppressSelect
				EXECUTE dbo.USSP_VET_SPECIES_MASTER_SET @LanguageID,
					@SpeciesMasterID OUTPUT,
					@SpeciesTypeID,
					@HerdMasterID,
					@ObservationID,
					@StartOfSignsDate,
					@AverageAge,
					@SickAnimalQuantity,
					@TotalAnimalQuantity,
					@DeadAnimalQuantity,
					@Comments,
					@RowStatus,
					@RowAction;

				UPDATE @SpeciesTemp
				SET SpeciesMasterID = @SpeciesMasterID
				WHERE SpeciesMasterID = @SpeciesMasterID;
			END;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VET_SPECIES_SET @LanguageID,
				@SpeciesID OUTPUT,
				@SpeciesMasterID,
				@SpeciesTypeID,
				@HerdID,
				@ObservationID,
				@StartOfSignsDate,
				@AverageAge,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Comments,
				@RowStatus,
				@RowAction;

			UPDATE @AnimalsTemp
			SET SpeciesID = @SpeciesID
			WHERE SpeciesID = @RowID;

			UPDATE @VaccinationsTemp
			SET SpeciesID = @SpeciesID
			WHERE SpeciesID = @RowID;

			UPDATE @SamplesTemp
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
				@AnimalConditionTypeID = AnimalConditionTypeID,
				@AnimalAgeTypeID = AnimalAgeTypeID,
				@SpeciesID = SpeciesID,
				@ObservationID = ObservationID,
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
				@ObservationID,
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
				FROM @VaccinationsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = VaccinationID,
				@VaccinationID = VaccinationID,
				@SpeciesID = SpeciesID,
				@VaccinationTypeID = VaccinationTypeID,
				@RouteTypeID = RouteTypeID,
				@DiseaseID = DiseaseID,
				@VaccinationDate = VaccinationDate,
				@Manufacturer = Manufacturer,
				@LotNumber = LotNumber,
				@NumberVaccinated = NumberVaccinated,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @VaccinationsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VET_VACCINATION_SET @LanguageID,
				@VaccinationID OUTPUT,
				@VeterinaryDiseaseReportID,
				@SpeciesID,
				@VaccinationTypeID,
				@RouteTypeID,
				@DiseaseID,
				@VaccinationDate,
				@Manufacturer,
				@LotNumber,
				@NumberVaccinated,
				@Comments,
				@RowStatus,
				@RowAction;

			DELETE
			FROM @VaccinationsTemp
			WHERE VaccinationID = @RowID;
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
				@FarmOwnerID,
				@SpeciesID,
				@AnimalID,
				NULL,
				@MonitoringSessionID,
				NULL,
				NULL,
				@VeterinaryDiseaseReportID,
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

			UPDATE @PensideTestsTemp
			SET SampleID = @SampleID
			WHERE SampleID = @RowID;

			UPDATE @TestsTemp
			SET SampleID = @SampleID
			WHERE SampleID = @RowID;

			DELETE
			FROM @SamplesTemp
			WHERE SampleID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @PensideTestsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = PensideTestID,
				@PensideTestID = PensideTestID,
				@SampleID = SampleID,
				@PensideTestResultTypeID = PensideTestResultTypeID,
				@PensideTestNameTypeID = PensideTestNameTypeID,
				@RowStatus = RowStatus,
				@TestedByPersonID = TestedByPersonID,
				@TestedByOrganizationID = TestedByOrganizationID,
				@DiseaseID = DiseaseID,
				@TestDate = TestDate,
				@PensideTestCategoryTypeID = PensideTestCategoryTypeID,
				@RowAction = RowAction
			FROM @PensideTestsTemp;

			INSERT INTO @SuppressSelect
			EXECUTE dbo.USSP_VET_PENSIDE_TEST_SET @LanguageID,
				@PensideTestID OUTPUT,
				@SampleID,
				@PensideTestResultTypeID,
				@PensideTestNameTypeID,
				@TestedByPersonID,
				@TestedByOrganizationID,
				@DiseaseID,
				@TestDate,
				@PensideTestCategoryTypeID,
				@RowStatus,
				@RowAction;

			DELETE
			FROM @PensideTestsTemp
			WHERE PensideTestID = @RowID;
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
				FROM @ReportLogsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = VeterinaryDiseaseReportLogID,
				@VeterinaryDiseaseReportLogID = VeterinaryDiseaseReportLogID,
				@StatusTypeID = LogStatusTypeID,
				@LoggedByPersonID = LoggedByPersonID,
				@LogDate = LogDate,
				@ActionRequired = ActionRequired,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @ReportLogsTemp;

			EXECUTE dbo.USSP_VET_DISEASE_REPORT_LOG_SET @LanguageID,
				@VeterinaryDiseaseReportLogID,
				@LogStatusTypeID,
				@VeterinaryDiseaseReportID,
				@LoggedByPersonID,
				@LogDate,
				@ActionRequired,
				@Comments,
				@RowStatus,
				@RowAction;

			DELETE
			FROM @ReportLogsTemp
			WHERE VeterinaryDiseaseReportLogID = @RowID;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@VeterinaryDiseaseReportID VeterinaryDiseaseReportID,
			@EIDSSReportID EIDSSReportID;
	END TRY

	BEGIN CATCH
		IF @@Trancount > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@VeterinaryDiseaseReportID VeterinaryDiseaseReportID,
			@EIDSSReportID EIDSSReportID;

		THROW;
	END CATCH
END
