USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_OMM_VETERINARY_DISEASE_SET]    Script Date: 5/30/2019 7:15:45 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Name: USP_OMM_VETERINARY_DISEASE_SET
--
-- Description:	Inserts or updates veterinary "case" for the avian and livestock veterinary disease 
-- report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Doug Albanese    04/24/2018 Initial release.
-- ================================================================================================
ALTER PROCEDURE [dbo].[USP_OMM_VETERINARY_DISEASE_SET] (
	@LanguageID							NVARCHAR(50),
	@VeterinaryDiseaseReportID			BIGINT = NULL,
	@FarmID								BIGINT = NULL,
	@FarmMasterID						BIGINT = NULL,
	@FarmOwnerID						BIGINT = NULL, 
	@DiseaseID							BIGINT = NULL,
	@PersonEnteredByID					BIGINT = NULL,
	@PersonReportedByID					BIGINT = NULL,
	@PersonInvestigatedByID				BIGINT = NULL,
	@SiteID								BIGINT = NULL,
	@ReportDate							DATETIME = NULL,
	@AssignedDate						DATETIME = NULL,
	@InvestigationDate					DATETIME = NULL,
	@EIDSSFieldAccessionID				NVARCHAR(200) = NULL,
	@RowStatus							INT = NULL,
	@ReportedByOrganizationID			BIGINT = NULL,
	@InvestigatedByOrganizationID		BIGINT = NULL,
	@ReportTypeID						BIGINT = NULL,
	@ClassificationTypeID				BIGINT = NULL,
	@OutbreakID							BIGINT = NULL,
	@EnteredDate						DATETIME = NULL,
	@EIDSSReportID						NVARCHAR(200) = NULL,
	@StatusTypeID						BIGINT = NULL,
	@MonitoringSessionID				BIGINT = NULL,
	@ReportCategoryTypeID				BIGINT = NULL,
	@FarmTotalAnimalQuantity			INT = NULL,
	@FarmSickAnimalQuantity				INT = NULL,
	@FarmDeadAnimalQuantity				INT = NULL,
	@OriginalVeterinaryDiseaseReportID	BIGINT = NULL,
	@FarmEpidemiologicalObservationID	BIGINT = NULL,
	@ControlMeasuresObservationID		BIGINT = NULL,
	@HerdsOrFlocks						NVARCHAR(MAX) = NULL,
	@Species							NVARCHAR(MAX) = NULL,
	@ClinicalInformation				NVARCHAR(MAX) = NULL,
	@AnimalsInvestigations				NVARCHAR(MAX) = NULL,
	@Contacts							NVARCHAR(MAX) = NULL,
	@Vaccinations						NVARCHAR(MAX) = NULL,
	@Samples							NVARCHAR(MAX) = NULL,
	@PensideTests						NVARCHAR(MAX) = NULL,
	@LabTests							NVARCHAR(MAX) = NULL,
	@TestInterpretations				NVARCHAR(MAX) = NULL,
	@ReportLogs							NVARCHAR(MAX) = NULL,
	@idfReportedByOffice				BIGINT = NULL,
	@idfPersonReportedBy				BIGINT = NULL,
	@idfReceivedByOffice				BIGINT = NULL,
	@idfReceivedByPerson				BIGINT = NULL,
	@IsPrimaryCaseFlag					INT = 0,
	@OutbreakCaseStatusId				BIGINT = NULL,
	@OutbreakCaseClassificationID		BIGINT = NULL,
	@idfsCountry						BIGINT = NULL,
	@idfsRegion							BIGINT = NULL,
	@idfsRayon							BIGINT = NULL,
	@idfsSettlementType					BIGINT = NULL,
	@idfsSettlement						BIGINT = NULL,
	@strStreetName						NVARCHAR(200)= NULL,
	@strHouse							NVARCHAR(200)= NULL,
	@strBuilding						NVARCHAR(200)= NULL,
	@strApartment						NVARCHAR(200)= NULL,
	@strPostCode						NVARCHAR(200) = NULL,
    @dblLatitude						FLOAT = NULL,
    @dblLongitude						FLOAT = NULL,
	@CaseMonitoring						NVARCHAR(MAX) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		DECLARE @outbreakLocation	BIGINT = NULL
		DECLARE @ReturnCode			INT = 0;
		DECLARE @ReturnMessage		NVARCHAR(MAX) = 'SUCCESS';

		DECLARE @SupressSelect		TABLE (
				ReturnCode			INT,
				ReturnMessage		NVARCHAR(MAX)
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
			@ReadOnlyIndicator BIT = 0,
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
			@ActionRequired NVARCHAR(200) = NULL;


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
			SpeciesTypeID BIGINT NOT NULL,
			HerdID BIGINT NOT NULL,
			SickAnimalQuantity INT NULL,
			TotalAnimalQuantity INT NULL,
			DeadAnimalQuantity INT NULL,
			StartOfSignsDate DATETIME2 NULL,
			AverageAge NVARCHAR(200) NULL,
			ObservationID BIGINT NULL,
			Comments NVARCHAR(2000) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL,
			idfHerdActual BIGINT NOT NULL
		);

		DECLARE @ClinicalInformationTemp TABLE (
			langId NVARCHAR(200) NULL,
			idfHerd BIGINT NOT NULL,
			Herd NVARCHAR(200) NULL,
			idfsClinical BIGINT NOT NULL,
			idfsSpeciesType BIGINT NULL,
			SpeciesType NVARCHAR(200) NULL,
			idfsStatus BIGINT NULL,
			idfsInvestigationPerformed BIGINT NULL
		);

		DECLARE @ContactsTemp TABLE (
			idfContactCasePerson BIGINT NULL,
			idfHumanActual BIGINT,
			ContactName NVARCHAR(200),
			ContactRelationshipTypeID BIGINT NULL,
			Relation NVARCHAR(200),
			DateOfLastContact DATETIME2,
			PlaceOfLastContact NVARCHAR(200),
			ContactStatusId BIGINT NULL,
			ContactStatus NVARCHAR(200),
			Comments NVARCHAR(200),
			ContactType NVARCHAR(200),
			idfsPersonContactType  BIGINT NULL
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
			RowAction CHAR(1) NULL,
			idfsClinical BIGINT NULL,
			idfHerd BIGINT NULL,
			strHerdCode NVARCHAR(200) NULL,
			strSpeciesType NVARCHAR(200) NULL,
			Age BIGINT NULL,
			strAge NVARCHAR(200) NULL,
			idfSex BIGINT NULL,
			strSex NVARCHAR(200) NULL,
			idfStatus BIGINT NULL,
			strStatus NVARCHAR(200) NULL,
			strNote NVARCHAR(200) NULL
		);

		DECLARE @VaccinationsTemp TABLE (
			VaccinationID BIGINT NOT NULL,
			Species NVARCHAR(200) NULL,
			VaccinationTypeID BIGINT NULL,
			RouteTypeID BIGINT NULL,
			DiseaseID BIGINT NULL,
			VaccinationDate DATETIME2 NULL,
			Manufacturer NVARCHAR(200) NULL,
			LotNumber NVARCHAR(200) NULL,
			NumberVaccinated INT NULL,
			Comments NVARCHAR(2000) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL,
			[Name] NVARCHAR(200) NULL,
			SpeciesID BIGINT NULL,
			[Type] NVARCHAR(200) NULL,
			[Route] NVARCHAR(200) NULL
		);

		DECLARE @SamplesTemp TABLE (
			SampleID BIGINT NOT NULL,
			SampleTypeID BIGINT NULL,
			SpeciesID BIGINT NULL,
			FieldId NVARCHAR(200) NULL,
			strAnimalID NVARCHAR(200) NULL,
			AnimalID BIGINT NULL,
			MonitoringSessionID BIGINT NULL,
			SampleStatusTypeID BIGINT NULL,
			CollectionDate DATETIME2 NULL,
			CollectedByOrganizationID BIGINT NULL,
			CollectedByPersonID BIGINT NULL,
			SentDate DATETIME2 NULL,
			SentToOrganizationID BIGINT NULL,
			EIDSSLocalOrFieldSampleID NVARCHAR(200) NULL,
			Comments NVARCHAR(200) NULL,
			SiteID BIGINT NOT NULL,
			EnteredDate DATETIME2 NULL,
			BirdStatusTypeID BIGINT NULL, 
			RowStatus INT NOT NULL,
			RowAction CHAR(1) NULL,
			[Type] NVARCHAR(200) NULL,
			Species NVARCHAR(200) NULL,
			BirdStatus NVARCHAR(200) NULL,
			CollectedByOrganization NVARCHAR(200) NULL,
			CollectedByPerson NVARCHAR(200) NULL,
			SentToOrganization NVARCHAR(200) NULL
		);

		DECLARE @PensideTestsTemp TABLE (
			idfVetPensideTest BIGINT NOT NULL,
			FieldSampleId NVARCHAR(200) NOT NULL,
			idfSampleType BIGINT NULL,
			SampleType NVARCHAR(200) NULL,
			idfSpecies BIGINT NULL,
			Species NVARCHAR(200) NULL,
			strAnimalId NVARCHAR(200) NULL,
			idfTestName BIGINT NULL,
			TestName NVARCHAR(200) NULL,
			idfResult BIGINT NOT NULL,
			Result NVARCHAR(200) NULL,
			intRowStatus INT NOT NULL,
			RowAction CHAR(1) NULL
		);

		DECLARE @LabTestsTemp TABLE (
			idfLabTest BIGINT NULL,
			LabSampleId NVARCHAR(200) NULL,
			SampleType NVARCHAR(200) NULL,
			FieldSampleId NVARCHAR(200) NULL,
			strAnimalId NVARCHAR(200) NULL,
			AnimalId NVARCHAR(200) NULL,
			Species NVARCHAR(200) NULL,
			idfSpecies BIGINT NULL,
			TestDisease NVARCHAR(200) NULL,
			idfTestDisease BIGINT NULL,
			TestName NVARCHAR(200) NULL,
			idfTestName BIGINT NULL,
			TestCategory NVARCHAR(200) NULL,
			idfTestCategory BIGINT NULL,
			TestStatus NVARCHAR(200) NULL,
			ResultDate DATETIME2,
			ResultObservation NVARCHAR(200) NULL,
			idfResultObservcvation BIGINT NULL,
			intRowStatus INT
		);

		--DECLARE @TestInterpretationsTemp TABLE (
		--	TestInterpretationID BIGINT NOT NULL,
		--	DiseaseID BIGINT NULL,
		--	InterpretedStatusTypeID BIGINT NULL,
		--	ValidatedByOrganizationID BIGINT NULL,
		--	ValidatedByPersonID BIGINT NULL,
		--	InterpretedByOrganizationID BIGINT NULL,
		--	InterpretedByPersonID BIGINT NULL,
		--	TestID BIGINT NOT NULL,
		--	ValidatedStatusIndicator BIT NULL,
		--	ReportSessionCreatedIndicator BIT NULL,
		--	ValidatedComment NVARCHAR(200) NULL,
		--	InterpretedComment NVARCHAR(200) NULL,
		--	ValidatedDate DATETIME2 NULL,
		--	InterpretedDate DATETIME2 NULL,
		--	ReadOnlyIndicator BIT NOT NULL, 
		--	RowStatus INT NOT NULL,
		--	RowAction CHAR(1) NULL
		--);

		--DECLARE @ReportLogsTemp TABLE (
		--	VeterinaryDiseaseReportLogID BIGINT NOT NULL,
		--	LogStatusTypeID BIGINT NULL,
		--	LoggedByPersonID BIGINT NULL,
		--	LogDate DATETIME2 NULL,
		--	ActionRequired NVARCHAR(200) NULL,
		--	Comments NVARCHAR(1000) NULL,
		--	RowStatus INT NOT NULL,
		--	RowAction CHAR(1) NULL
		--);

		BEGIN TRANSACTION;
		INSERT INTO @HerdsOrFlocksTemp
		SELECT *
		FROM OPENJSON(@HerdsOrFlocks) WITH (
			idfHerd BIGINT,
			idfHerdActual BIGINT,
			strHerdCode NVARCHAR(200),
			intSickAnimalQty INT,
			intTotalAnimalQty INT,
			intDeadAnimalQty INT,
			Comments NVARCHAR(2000),
			intRowStatus INT,
			RowAction CHAR(1)
		);
		
		INSERT INTO @SpeciesTemp
		SELECT *
		FROM OPENJSON(@Species) WITH (
			idfSpecies BIGINT,
			idfSpeciesActual BIGINT,
			idfsSpeciesType BIGINT,
			idfHerd BIGINT,
			intSickAnimalQty INT,
			intTotalAnimalQty INT,
			intDeadAnimalQty INT,
			datStartOfSignsDate DATETIME2,
			intAverageAge NVARCHAR(200),
			ObservationId BIGINT,
			strNote NVARCHAR(2000),
			intRowStatus INT,
			RowAction CHAR(1),
			idfHerdActual BIGINT
		);

		INSERT INTO @ClinicalInformationTemp
		SELECT *
		FROM OPENJSON(@ClinicalInformation) WITH (
			langId NVARCHAR(200),
			idfHerd BIGINT,
			Herd NVARCHAR(200),
			idfsClinical BIGINT,
			idfsSpeciesType BIGINT,
			SpeciesType NVARCHAR(200),
			idfsStatus BIGINT,
			idfsInvestigationPerformed BIGINT
		);

		INSERT INTO @AnimalsTemp
		SELECT *
		FROM OPENJSON(@AnimalsInvestigations) WITH (
			AnimalId BIGINT,
			idfAnimalGenderTypeID BIGINT,
			idfAnimalConditionType BIGINT,
			AnimalAgeTypeId BIGINT,
			idfsSpeciesType BIGINT,
			ObservationId BIGINT,
			strAnimalId NVARCHAR(200),
			AnimalName NVARCHAR(200),
			Color NVARCHAR(200),
			AnimalDescription NVARCHAR(200),
			RowStatus INT,
			RowAction CHAR(1),
			idfsClinical BIGINT,
			idfHerd BIGINT,
			HerdCode NVARCHAR(200),
			SpeciesType NVARCHAR(200),
			ddlVetAge BIGINT,
			Age NVARCHAR(200),
			ddlVetSex BIGINT,
			Sex NVARCHAR(200),
			idfStatus BIGINT,
			Status NVARCHAR(200),
			Note NVARCHAR(200)
		);

		INSERT INTO @ContactsTemp
		SELECT *
		FROM OPENJSON(@Contacts) WITH (
			idfContactCasePerson BIGINT,
			idfHumanActual BIGINT,
			ContactName NVARCHAR(200),
			ContactRelationshipTypeID BIGINT,
			Relation NVARCHAR(200),
			DateOfLastContact DATETIME2,
			PlaceOfLastContact NVARCHAR(200),
			ContactStatusId BIGINT,
			ContactStatus NVARCHAR(200),
			Comments NVARCHAR(200),
			ContactType NVARCHAR(200),
			idfsPersonContactType  BIGINT
		);


		INSERT INTO @VaccinationsTemp
		SELECT *
		FROM OPENJSON(@Vaccinations) WITH (
			idfVetVaccination BIGINT,
			Species NVARCHAR(200),
			idfType BIGINT,
			idfRoute BIGINT,
			idfDisease BIGINT,
			[Date] DATETIME2,
			Manufacturer NVARCHAR(200),
			LotNumber NVARCHAR(200),
			NumberVaccinated INT,
			Comments NVARCHAR(2000),
			RowStatus INT,
			RowAction CHAR(1),
			[Name] NVARCHAR(200),
			idfSpecies BIGINT,
			[Type] NVARCHAR(200),
			[Route] NVARCHAR(200)
		);

		INSERT INTO @SamplesTemp
		SELECT *
		FROM OPENJSON(@Samples) WITH (
			idfVetSample BIGINT,
			idfVetSampleTypeID BIGINT,
			idfSpeciesID BIGINT,
			FieldId NVARCHAR(200),
			strAnimalID NVARCHAR(200),
			AnimalID BIGINT,
			idfMonitoringSessionID BIGINT,
			idfSampleStatusTypeId BIGINT,
			datCollectionDate DATETIME2,
			idfCollectedByOrganizationID BIGINT,
			idfCollectedByPersonID BIGINT,
			datSentDate DATETIME2,
			idfSentToOrganizationID BIGINT,
			strFieldSampleId NVARCHAR(200),
			Comments NVARCHAR(200),
			idfSiteId BIGINT,
			datEnteredDate DATETIME2,
			idfBirdStatusTypeID BIGINT, 
			intRowStatus INT,
			RowAction CHAR(1),
			[Type] NVARCHAR(200),
			Species NVARCHAR(200),
			BirdStatus NVARCHAR(200),
			CollectedByOrganization NVARCHAR(200),
			CollectedByPerson NVARCHAR(200),
			SentToOrganization NVARCHAR(200)
		);

		INSERT INTO @PensideTestsTemp
		SELECT *
		FROM OPENJSON(@PensideTests) WITH (
			idfVetPensideTest BIGINT,
			FieldSampleId NVARCHAR(200),
			idfSampleType BIGINT,
			SampleType NVARCHAR(200),
			idfSpecies BIGINT,
			Species NVARCHAR(200),
			strAnimalId NVARCHAR(200),
			idfTestName BIGINT,
			TestName NVARCHAR(200),
			idfResult BIGINT,
			Result NVARCHAR(200),
			intRowStatus INT,
			RowAction CHAR(1)
		);

		INSERT INTO @LabTestsTemp
		SELECT *
		FROM OPENJSON(@LabTests) WITH (
			idfLabTest BIGINT,
			LabSampleId NVARCHAR(200),
			SampleType NVARCHAR(200),
			FieldSampleId NVARCHAR(200),
			strAnimalId NVARCHAR(200),
			AnimalId NVARCHAR(200),
			Species NVARCHAR(200) ,
			idfSpecies BIGINT,
			TestDisease NVARCHAR(200),
			idfTestDisease BIGINT,
			TestName NVARCHAR(200),
			idfTestName BIGINT,
			TestCategory NVARCHAR(200),
			idfTestCategory BIGINT,
			TestStatus NVARCHAR(200),
			ResultDate DATETIME2,
			ResultObservation NVARCHAR(200),
			idfResultObservcvation BIGINT,
			intRowStatus INT
		);
		--INSERT INTO @TestInterpretationsTemp
		--SELECT *
		--FROM OPENJSON(@TestInterpretations) WITH (
		--	TestInterpretationID BIGINT,
		--	DiseaseID BIGINT,
		--	InterpretedStatusTypeID BIGINT,
		--	ValidatedByOrganizationID BIGINT,
		--	ValidatedByPersonID BIGINT,
		--	InterpretedByOrganizationID BIGINT,
		--	InterpretedByPersonID BIGINT,
		--	TestID BIGINT,
		--	ValidatedStatusIndicator BIT,
		--	ReportSessionCreatedIndicator BIT,
		--	ValidatedComment NVARCHAR(200),
		--	InterpretedComment NVARCHAR(200),
		--	ValidatedDate DATETIME2,
		--	InterpretedDate DATETIME2,
		--	ReadOnlyIndicator BIT, 
		--	RowStatus INT,
		--	RowAction CHAR(1)
		--);

		SELECT 
			TOP 1
			@outbreakLocation = idfGeoLocationShared
		FROM 
			tlbGeolocationShared
		WHERE
			(idfsCountry = @idfsCountry OR @idfsCountry IS NULL) AND
			(idfsRayon = @idfsRayon OR @idfsRayon IS NULL) AND
			(idfsRegion = @idfsRegion OR @idfsRegion IS NULL) AND
			(idfsSettlement = @idfsSettlement OR @idfsSettlement IS NULL) 

		IF @outbreakLocation = NULL or @outbreakLocation IS NULL
			BEGIN
				--INSERT INTO @SupressSelect
					EXEC dbo.USP_GBL_GEOLOCATION_SET @outbreakLocation OUTPUT,
								NULL,
								NULL,
								@idfsCountry,
								@idfsRegion,
								@idfsRayon,
								@idfsSettlement,
								NULL,
								@dblLatitude,
								@dblLongitude,
								NULL,
								null,
								null,
								null,
								null,
								null,
								1
				----INSERT INTO @SupressSelect
				--EXEC dbo.USP_GBL_ADDRESS_SET 	@outbreakLocation OUTPUT,
				--			null,
				--			null,
				--			null,
				--			@idfsCountry,
				--			@idfsRegion,
				--			@idfsRayon,
				--			@idfsSettlement,
				--			@strApartment,
				--			@strBuilding,
				--			@strStreetName,
				--			@strHouse,
				--			@strPostCode,
				--			null,
				--			null,
				--			@dblLatitude,
				--			@dblLongitude,
				--			null,
				--			null,
				--			null,
				--			null,
				--			null,
				--			@returnCode,
				--			@ReturnMessage
				/* In this case, supression causes the variable, @outbreakLocation, to be null.*/
				SELECT 
					TOP 1
					@outbreakLocation = idfGeoLocation
				FROM 
					tlbGeolocation
				WHERE
					(idfsCountry = @idfsCountry OR @idfsCountry IS NULL) AND
					(idfsRayon = @idfsRayon OR @idfsRayon IS NULL) AND
					(idfsRegion = @idfsRegion OR @idfsRegion IS NULL) AND
					(idfsSettlement = @idfsSettlement OR @idfsSettlement IS NULL) 

			END
		
		IF NOT EXISTS (
				SELECT *
				FROM dbo.tlbVetCase
				WHERE idfVetCase = @VeterinaryDiseaseReportID
					AND intRowStatus = 0
				)
		BEGIN
			IF @ReportCategoryTypeID = 10012004 --Avian
				BEGIN
					UPDATE dbo.tlbFarmActual SET 
						intAvianTotalAnimalQty = @TotalAnimalQuantity, 
						intAvianSickAnimalQty = @SickAnimalQuantity, 
						intAvianDeadAnimalQty = @DeadAnimalQuantity,
						idfFarmAddress = @outbreakLocation
					WHERE idfFarmActual = @FarmMasterID;

					--INSERT INTO @SupressSelect
					EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
						@FarmTotalAnimalQuantity,
						@FarmSickAnimalQuantity,
						@FarmDeadAnimalQuantity,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						@FarmID OUTPUT;

				END
				ELSE --Livestock
				BEGIN
					UPDATE dbo.tlbFarmActual SET 
						intLivestockTotalAnimalQty = @TotalAnimalQuantity, 
						intLivestockSickAnimalQty = @SickAnimalQuantity, 
						intLivestockDeadAnimalQty = @DeadAnimalQuantity,
						idfFarmAddress = @outbreakLocation
					WHERE idfFarmActual = @FarmMasterID;

					--INSERT INTO @SupressSelect
					EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
						NULL,
						NULL,
						NULL,
						@FarmTotalAnimalQuantity,
						@FarmSickAnimalQuantity,
						@FarmDeadAnimalQuantity,
						NULL,
						NULL,
						@FarmID OUTPUT;
				END
			
				INSERT INTO @SupressSelect
				EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbVetCase',
					@VeterinaryDiseaseReportID OUTPUT;

				INSERT INTO @SupressSelect
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
					idfsCaseType,
					idfReceivedByOffice,
					idfReceivedByPerson
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
					@ReportCategoryTypeID,
					@idfReceivedByOffice,
					@idfReceivedByPerson
					);
			END	
		ELSE
			BEGIN
				IF @ReportCategoryTypeID = 10012004 --Avian
				BEGIN
					--INSERT INTO @SupressSelect
					EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
						@TotalAnimalQuantity,
						@SickAnimalQuantity,
						@DeadAnimalQuantity,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						@FarmID OUTPUT;
				END
				ELSE --Livestock
				BEGIN
					--INSERT INTO @SupressSelect
					EXECUTE dbo.USSP_VET_FARM_COPY @FarmMasterID,
						NULL,
						NULL,
						NULL,
						@TotalAnimalQuantity,
						@SickAnimalQuantity,
						@DeadAnimalQuantity,
						NULL,
						NULL,
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
		
		WHILE EXISTS ( SELECT * FROM @HerdsOrFlocksTemp )
		BEGIN
			SELECT 
				TOP 1 @RowID = HerdID,
				@HerdID = HerdID,
				@EIDSSHerdID = EIDSSHerdID,
				@HerdMasterID = HerdMasterID,
				@EIDSSHerdID = EIDSSHerdID,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM 
				@HerdsOrFlocksTemp;

			UPDATE @AnimalsTemp
			SET idfHerd = @HerdID
			WHERE strHerdCode = @EIDSSHerdID;

			IF @HerdMasterID < 0
				BEGIN
					SET @RowAction = 'I'
					INSERT INTO @SupressSelect
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

			INSERT INTO @SupressSelect
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
			SET idfHerdActual = @HerdMasterID, HerdId= @HerdID
			WHERE HerdID = @RowID;


			UPDATE @AnimalsTemp
			SET idfHerd = @HerdID
			WHERE idfHerd = @RowID;

			DELETE
			FROM @HerdsOrFlocksTemp
			WHERE HerdMasterID = @RowID;
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
				@HerdMasterID = idfHerdActual,
				@StartOfSignsDate = CONVERT(DATETIME, StartOfSignsDate),
				@AverageAge = AverageAge,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @SpeciesTemp;

			IF @SpeciesMasterID < 0
				BEGIN
					SET @RowAction = 'I'
					INSERT INTO @SupressSelect
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
				
			INSERT INTO @SupressSelect
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

			IF @AnimalID < 0
				BEGIN
					SET @RowAction = 'I'
				END

			INSERT INTO @SupressSelect
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
				@VaccinationDate = CONVERT(DATETIME, VaccinationDate),
				@Manufacturer = Manufacturer,
				@LotNumber = LotNumber,
				@NumberVaccinated = NumberVaccinated,
				@Comments = Comments,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @VaccinationsTemp;

			IF @VaccinationID < 0
				BEGIN
					SET @RowAction = 'I'
				END

			INSERT INTO @SupressSelect
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

		--Temp
		SET @SampleStatusTypeID = -1

		select * from @SamplesTemp
		/*
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
				@CollectionDate = CONVERT(DATETIME, CollectionDate),
				@SentDate = CONVERT(DATETIME, SentDate),
				@EIDSSLocalOrFieldSampleID = EIDSSLocalOrFieldSampleID,
				@SampleStatusTypeID = SampleStatusTypeID,
				@EnteredDate = CONVERT(DATETIME, EnteredDate),
				@Comments = Comments,
				@SiteID = SiteID,
				@RowStatus = RowStatus,
				@SentToOrganizationID = SentToOrganizationID,
				@BirdStatusTypeID = BirdStatusTypeID, 
				@RowAction = RowAction
			FROM @SamplesTemp;



			IF @SampleID < 0
				BEGIN
					SET @RowAction = 'I'
				END

			INSERT INTO @SupressSelect
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
			SET FieldSampleId = @SampleID
			WHERE FieldSampleId = @RowID;

			UPDATE @LabTestsTemp
			SET FieldSampleId = @SampleID
			WHERE FieldSampleId = @RowID;

			DELETE
			FROM @SamplesTemp
			WHERE SampleID = @RowID;
		END;
		*/
		/*
		
		--WHILE EXISTS (
		--		SELECT *
		--		FROM @PensideTestsTemp
		--		)
		--BEGIN

		----needs to be rewritten for Outbreak Vet Disease

		--	SELECT TOP 1 @RowID = idfVetPensideTest,
		--		@PensideTestID = idfVetPensideTest,
		--		@SampleID = FieldSampleId,
		--		@PensideTestResultTypeID = PensideTestResultTypeID,
		--		@PensideTestNameTypeID = PensideTestNameTypeID,
		--		@RowStatus = RowStatus,
		--		@TestedByPersonID = TestedByPersonID,
		--		@TestedByOrganizationID = TestedByOrganizationID,
		--		@DiseaseID = DiseaseID,
		--		@TestDate = TestDate,
		--		@PensideTestCategoryTypeID = PensideTestCategoryTypeID,
		--		@RowAction = RowAction
		--	FROM @PensideTestsTemp;

		--	INSERT INTO @SupressSelect
		--	EXECUTE dbo.USSP_VET_PENSIDE_TEST_SET @LanguageID,
		--		@PensideTestID OUTPUT,
		--		@SampleID,
		--		@PensideTestResultTypeID,
		--		@PensideTestNameTypeID,
		--		@TestedByPersonID,
		--		@TestedByOrganizationID,
		--		@DiseaseID,
		--		@TestDate,
		--		@PensideTestCategoryTypeID,
		--		@RowStatus,
		--		@RowAction;

		--	DELETE
		--	FROM @PensideTestsTemp
		--	WHERE idfVetPensideTest = @RowID;
		--END;

		--WHILE EXISTS (
		--		SELECT *
		--		FROM @LabTestsTemp
		--		)
		--BEGIN
		--	SELECT TOP 1 @RowID = TestID,
		--		@TestID = TestID,
		--		@TestNameTypeID = TestNameTypeID,
		--		@TestCategoryTypeID = TestCategoryTypeID,
		--		@TestResultTypeID = TestResultTypeID,
		--		@TestStatusTypeID = TestStatusTypeID,
		--		@DiseaseID = DiseaseID,
		--		@SampleID = SampleID,
		--		@Comments = Comments,
		--		@RowStatus = RowStatus,
		--		@StartedDate = StartedDate,
		--		@ResultDate = ResultDate,
		--		@TestedByOrganizationID = TestedByOrganizationID,
		--		@TestedByPersonID = TestedByPersonID,
		--		@ResultEnteredByOrganizationID = ResultEnteredByOrganizationID,
		--		@ResultEnteredByPersonID = ResultEnteredByPersonID,
		--		@ValidatedByOrganizationID = ValidatedByOfficeID,
		--		@ValidatedByPersonID = ValidatedByPersonID,
		--		@ReadOnlyIndicator = ReadOnlyIndicator,
		--		@NonLaboratoryTestIndicator = NonLaboratoryTestIndicator,
		--		@ExternalTestIndicator = ExternalTestIndicator,
		--		@PerformedByOrganizationID = PerformedByOrganizationID,
		--		@ReceivedDate = ReceivedDate,
		--		@ContactPersonName = ContactPersonName,
		--		@RowAction = RowAction
		--	FROM @LabTestsTemp;

		--	INSERT INTO @SupressSelect
		--	EXECUTE dbo.USSP_GBL_TEST_SET @LanguageID,
		--		@TestID OUTPUT,
		--		@TestNameTypeID,
		--		@TestCategoryTypeID,
		--		@TestResultTypeID,
		--		@TestStatusTypeID,
		--		@DiseaseID,
		--		@SampleID,
		--		NULL,
		--		NULL,
		--		NULL,
		--		@Comments,
		--		@RowStatus,
		--		@StartedDate,
		--		@ResultDate,
		--		@TestedByOrganizationID,
		--		@TestedByPersonID,
		--		@ResultEnteredByOrganizationID,
		--		@ResultEnteredByPersonID,
		--		@ValidatedByOrganizationID,
		--		@ValidatedByPersonID,
		--		@ReadOnlyIndicator,
		--		@NonLaboratoryTestIndicator,
		--		@ExternalTestIndicator,
		--		@PerformedByOrganizationID,
		--		@ReceivedDate,
		--		@ContactPersonName,
		--		@RowAction;

		--	UPDATE @TestInterpretationsTemp
		--	SET TestID = @TestID
		--	WHERE TestID = @RowID;

		--	DELETE
		--	FROM @LabTestsTemp
		--	WHERE TestID = @RowID;
		--END;

		--WHILE EXISTS (
		--		SELECT *
		--		FROM @TestInterpretationsTemp
		--		)
		--BEGIN
		--	SELECT TOP 1 @RowID = TestInterpretationID,
		--		@TestInterpretationID = TestInterpretationID,
		--		@DiseaseID = DiseaseID,
		--		@InterpretedStatusTypeID = InterpretedStatusTypeID,
		--		@ValidatedByOrganizationID = ValidatedByOrganizationID,
		--		@ValidatedByPersonID = ValidatedByPersonID,
		--		@InterpretedByOrganizationID = InterpretedByOrganizationID,
		--		@InterpretedByPersonID = InterpretedByPersonID,
		--		@TestID = TestID,
		--		@ValidatedStatusIndicator = ValidatedStatusIndicator,
		--		@ValidatedComment = ValidatedComment,
		--		@InterpretedComment = InterpretedComment,
		--		@ValidatedDate = ValidatedDate,
		--		@InterpretedDate = InterpretedDate,
		--		@RowStatus = RowStatus,
		--		@ReadOnlyIndicator = ReadOnlyIndicator,
		--		@RowAction = RowAction
		--	FROM @TestInterpretationsTemp;

		--	INSERT INTO @SupressSelect
		--	EXECUTE dbo.USSP_GBL_TEST_INTERPRETATION_SET @LanguageID,
		--		@TestInterpretationID OUTPUT,
		--		@DiseaseID,
		--		@InterpretedStatusTypeID,
		--		@ValidatedByOrganizationID,
		--		@ValidatedByPersonID,
		--		@InterpretedByOrganizationID,
		--		@InterpretedByPersonID,
		--		@TestID,
		--		@ValidatedStatusIndicator,
		--		NULL,
		--		@ValidatedComment,
		--		@InterpretedComment,
		--		@ValidatedDate,
		--		@InterpretedDate,
		--		@RowStatus,
		--		@ReadOnlyIndicator,
		--		@RowAction;

		--	DELETE
		--	FROM @TestInterpretationsTemp
		--	WHERE TestInterpretationID = @RowID;
		--END;

		--WHILE EXISTS (
		--		SELECT *
		--		FROM @ReportLogsTemp
		--		)
		--BEGIN
		--	SELECT TOP 1 @RowID = VeterinaryDiseaseReportLogID,
		--		@VeterinaryDiseaseReportLogID = VeterinaryDiseaseReportLogID,
		--		@StatusTypeID = LogStatusTypeID,
		--		@LoggedByPersonID = LoggedByPersonID,
		--		@LogDate = LogDate,
		--		@ActionRequired = ActionRequired,
		--		@Comments = Comments,
		--		@RowStatus = RowStatus,
		--		@RowAction = RowAction
		--	FROM @ReportLogsTemp;

		--	EXECUTE dbo.USSP_VET_DISEASE_REPORT_LOG_SET @LanguageID,
		--		@VeterinaryDiseaseReportLogID,
		--		@LogStatusTypeID,
		--		@VeterinaryDiseaseReportID,
		--		@LoggedByPersonID,
		--		@LogDate,
		--		@ActionRequired,
		--		@Comments,
		--		@RowStatus,
		--		@RowAction;

		--	DELETE
		--	FROM @ReportLogsTemp
		--	WHERE VeterinaryDiseaseReportLogID = @RowID;
		--END;
			*/
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