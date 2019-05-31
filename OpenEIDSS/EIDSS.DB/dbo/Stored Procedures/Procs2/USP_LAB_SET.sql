-- ================================================================================================
-- Name: USP_LAB_SET
--
-- Description:	Inserts or updates samples, tests, test amendments, test 
-- interpretations, transfers, batches and approvals for the laboratory module 
-- use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     07/19/2018 Initial release.
-- Stephen Long		10/31/2018 Added the test amendments and transfers - LUC03 and LUC07.
-- Stephen Long		01/24/2019 Added box place availabilities parameter and updates.
-- Stephen Long     02/06/2019 Removed UserPreferenceID parameter; retrieved in the stored 
--                             procedure.  Replace temporary sample ID with the database ID 
--                             on new sample record that was also marked as a favorite. 
-- Stephen Long     02/09/2019 Corrected the JSON table name for EIDSSFieldSampleID to EIDSSLocal 
--                             FieldSampleID.
-- Stephen Long     02/19/2019 Modified for removed parameters from USSP_GBL_BATCH_TEST_SET and 
--                             added parameter to USSP_LAB_TRANSFER_SET.  Removed test 
--                             interpretation parameter.
-- Stephen Long     03/10/2019 Changed temp table field names for test amendement to sync up with 
--                             the API parameter names (LUC07).
-- Stephen Long     03/20/2019 Added row action on the batch test select from JSON variable. 
--                             Added check on Favorites parameter to only process if not null.
-- Stephen Long     04/17/2019 Update to use human master ID when registering new samples, and 
--                             copy over to human (similiar to how human disease report works).
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_SET] (
	@LanguageID NVARCHAR(50) = NULL,
	@Samples NVARCHAR(MAX) = NULL,
	@BatchTests NVARCHAR(MAX) = NULL,
	@Tests NVARCHAR(MAX) = NULL,
	@TestAmendments NVARCHAR(MAX) = NULL,
	@Transfers NVARCHAR(MAX) = NULL,
	@FreezerBoxLocationAvailabilities NVARCHAR(MAX) = NULL,
	@Notifications NVARCHAR(MAX) = NULL,
	@UserID BIGINT,
	@Favorites XML = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnCode INT = 0,
			@ReturnMessage NVARCHAR(MAX) = 'SUCCESS';
		DECLARE @SupressSelect TABLE (
			ReturnCode INT,
			ReturnMessage NVARCHAR(MAX),
			ID BIGINT
			);
		DECLARE @RowID BIGINT,
			@RowStatus INT,
			@RowAction CHAR(1),
			@SampleID BIGINT,
			@SampleTypeID BIGINT,
			@RootSampleID BIGINT = NULL,
			@OriginalSampleID BIGINT = NULL,
			@HumanID BIGINT = NULL,
			@SpeciesID BIGINT = NULL,
			@AnimalID BIGINT = NULL,
			@VectorID BIGINT = NULL,
			@MonitoringSessionID BIGINT = NULL,
			@VectorSessionID BIGINT = NULL,
			@HumanDiseaseReportID BIGINT = NULL,
			@VeterinaryDiseaseReportID BIGINT = NULL,
			@FunctionalAreaID BIGINT = NULL,
			@FreezerSubdivisionID BIGINT = NULL,
			@StorageBoxPlace NVARCHAR(200) = NULL,
			@CollectionDate DATETIME2 = NULL,
			@CollectedByPersonID BIGINT = NULL,
			@CollectedByOrganizationID BIGINT = NULL,
			@SentDate DATETIME2 = NULL,
			@EIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
			@EIDSSLaboratorySampleID NVARCHAR(200) = NULL, 
			@EnteredDate DATETIME2 = NULL,
			@OutOfRepositoryDate DATETIME2 = NULL,
			@MarkedForDispositionByPersonID BIGINT = NULL,
			@SentToOrganizationID BIGINT = NULL,
			@SiteID BIGINT = NULL,
			@CurrentSiteID BIGINT = NULL,
			@SampleKindTypeID BIGINT = NULL,
			@ReadOnlyIndicator BIT = NULL,
			@AccessionDate DATETIME2 = NULL,
			@AccessionConditionTypeID BIGINT = NULL,
			@AccessionByPersonID BIGINT = NULL,
			@SampleStatusTypeID BIGINT = NULL,
			@PreviousSampleStatusTypeID BIGINT = NULL,
			@AccessionComment NVARCHAR(200) = NULL,
			@DestructionMethodTypeID BIGINT = NULL,
			@DestructionDate DATETIME2 = NULL,
			@DestroyedByPersonID BIGINT = NULL,
			@Note NVARCHAR(500) = NULL,
			@BatchTestID BIGINT,
			@TestNameTypeID BIGINT = NULL,
			@BatchStatusTypeID BIGINT = NULL,
			@PerformedByOrganizationID BIGINT = NULL,
			@PerformedByPersonID BIGINT = NULL,
			@ValidatedByOrganizationID BIGINT = NULL,
			@ValidatedByPersonID BIGINT = NULL,
			@ObservationID BIGINT = NULL,
			@PerformedDate DATETIME2 = NULL,
			@ValidationDate DATETIME2 = NULL,
			@EIDSSBatchTestID NVARCHAR(200) = NULL,
			@ResultEnteredByPersonID BIGINT = NULL,
			@ResultEnteredByOrganizationID BIGINT = NULL,
			@TestRequested NVARCHAR(200) = NULL,
			@TestID BIGINT,
			@TestCategoryTypeID BIGINT = NULL,
			@TestResultTypeID BIGINT = NULL,
			@TestStatusTypeID BIGINT,
			@PreviousTestStatusTypeID BIGINT = NULL,
			@TestNumber INT = NULL,
			@StartedDate DATETIME2 = NULL,
			@ConcludedDate DATETIME2 = NULL,
			@TestedByPersonID BIGINT = NULL,
			@TestedByOrganizationID BIGINT = NULL,
			@NonLaboratoryTestIndicator BIT,
			@ExternalTestIndicator BIT = NULL,
			@ReceivedDate DATETIME2 = NULL,
			@ContactPersonName NVARCHAR(200) = NULL,
			@DiseaseID BIGINT = NULL,
			@FavoriteIndicator INT = NULL,
			@TestAmendmentID BIGINT,
			@AmendedByOrganizationID BIGINT = NULL,
			@AmendedByPersonID BIGINT = NULL,
			@AmendmentDate DATETIME2 = NULL,
			@OldTestResultTypeID BIGINT = NULL,
			@ChangedTestResultTypeID BIGINT = NULL,
			@OldNote NVARCHAR(500) = NULL,
			@ChangedNote NVARCHAR(500) = NULL,
			@ReasonForAmendment NVARCHAR(500),
			@TransferID BIGINT,
			@EIDSSTransferID NVARCHAR(200) = NULL,
			@TransferStatusTypeID BIGINT = NULL,
			@TransferredFromOrganizationID BIGINT = NULL,
			@TransferredToOrganizationID BIGINT = NULL,
			@SentByPersonID BIGINT = NULL,
			@TransferDate DATETIME2 = NULL,
			@BoxPlaceAvailability NVARCHAR(MAX),
			@NotificationID BIGINT,
			@NotificationObjectTypeID BIGINT = NULL,
			@NotificationTypeID BIGINT = NULL,
			@TargetSiteTypeID BIGINT = NULL,
			@NotificationObjectID BIGINT = NULL,
			@TargetUserID BIGINT = NULL,
			@TargetSiteID BIGINT = NULL,
			@Payload NVARCHAR(MAX) = NULL,
			@LoginSite BIGINT = NULL, 
			@NewHumanID BIGINT = NULL;
		DECLARE @SamplesTemp TABLE (
			SampleID BIGINT NOT NULL,
			SampleTypeID BIGINT NOT NULL,
			RootSampleID BIGINT NULL,
			OriginalSampleID BIGINT NULL,
			HumanID BIGINT NULL,
			SpeciesID BIGINT NULL,
			AnimalID BIGINT NULL,
			MonitoringSessionID BIGINT NULL,
			CollectedByPersonID BIGINT NULL,
			CollectedByOrganizationID BIGINT NULL,
			MainTestID BIGINT NULL,
			CollectionDate DATETIME2 NULL,
			SentDate DATETIME2 NULL,
			EIDSSLocalFieldSampleID NVARCHAR(200) NULL,
			VectorSessionID BIGINT NULL,
			VectorID BIGINT NULL,
			FreezerSubdivisionID BIGINT NULL,
			StorageBoxPlace NVARCHAR(200) NULL,
			SampleStatusTypeID BIGINT NULL,
			PreviousSampleStatusTypeID BIGINT NULL,
			FunctionalAreaID BIGINT NULL,
			DestroyedByPersonID BIGINT NULL,
			EnteredDate DATETIME2 NULL,
			DestructionDate DATETIME2 NULL,
			EIDSSLaboratorySampleID NVARCHAR(200) NULL,
			Note NVARCHAR(500) NULL,
			SiteID BIGINT NULL,
			RowStatus INT NOT NULL,
			SentToOrganizationID BIGINT NULL,
			ReadOnlyIndicator BIT NOT NULL,
			BirdStatusTypeID BIGINT NULL,
			HumanDiseaseReportID BIGINT NULL,
			VeterinaryDiseaseReportID BIGINT NULL,
			AccessionDate DATETIME2 NULL,
			AccessionConditionTypeID BIGINT NULL,
			AccessionComment NVARCHAR(200) NULL,
			AccessionByPersonID BIGINT NULL,
			DestructionMethodTypeID BIGINT NULL,
			CurrentSiteID BIGINT NULL,
			SampleKindTypeID BIGINT NULL,
			MarkedForDispositionByPersonID BIGINT NULL,
			OutOfRepositoryDate DATETIME2 NULL,
			DiseaseID BIGINT NULL,
			FavoriteIndicator INT NULL,
			RowAction CHAR NULL
			);
		DECLARE @BatchTestsTemp TABLE (
			BatchTestID BIGINT NOT NULL,
			TestNameTypeID BIGINT NULL,
			BatchStatusTypeID BIGINT NULL,
			PerformedByOrganizationID BIGINT NULL,
			PerformedByPersonID BIGINT NULL,
			ValidatedByOrganizationID BIGINT NULL,
			ValidatedByPersonID BIGINT NULL,
			ObservationID BIGINT NOT NULL,
			SiteID BIGINT NOT NULL,
			PerformedDate DATETIME2 NULL,
			ValidationDate DATETIME2 NULL,
			EIDSSBatchTestID NVARCHAR(200) NULL,
			RowStatus INT NOT NULL,
			ResultEnteredByPersonID BIGINT NULL,
			ResultEnteredByOrganizationID BIGINT NULL,
			TestRequested NVARCHAR(200) NULL,
			RowAction CHAR(1) NULL
			);
		DECLARE @TestsTemp TABLE (
			TestID BIGINT NOT NULL,
			TestNameTypeID BIGINT NULL,
			TestCategoryTypeID BIGINT NULL,
			TestResultTypeID BIGINT NULL,
			TestStatusTypeID BIGINT NOT NULL,
			PreviousTestStatusTypeID BIGINT NULL,
			DiseaseID BIGINT NOT NULL,
			SampleID BIGINT NULL,
			BatchTestID BIGINT NULL,
			ObservationID BIGINT NULL,
			TestNumber INT NULL,
			Note NVARCHAR(500) NULL,
			RowStatus INT NOT NULL,
			StartedDate DATETIME2 NULL,
			ConcludedDate DATETIME2 NULL,
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
			ReceivedDate DATETIME2 NULL,
			ContactPersonName NVARCHAR(200) NULL,
			RowAction CHAR NULL
			);
		DECLARE @TestAmendmentsTemp TABLE (
			TestAmendmentID BIGINT NOT NULL,
			TestID BIGINT NOT NULL,
			AmendedByOrganizationID BIGINT NULL,
			AmendedByPersonID BIGINT NULL,
			AmendmentDate DATETIME2 NULL,
			OldTestResultTypeID BIGINT NULL,
			ChangedTestResultTypeID BIGINT NULL,
			OldNote NVARCHAR(500) NULL,
			ChangedNote NVARCHAR(500) NULL,
			ReasonForAmendment NVARCHAR(500) NOT NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR NULL
			);
		DECLARE @TransfersTemp TABLE (
			TransferID BIGINT NOT NULL,
			SampleID BIGINT NOT NULL,
			EIDSSTransferID NVARCHAR(200) NULL,
			TransferStatusTypeID BIGINT NULL,
			TransferredFromOrganizationID BIGINT NULL,
			TransferredToOrganizationID BIGINT NULL,
			SentByPersonID BIGINT NULL,
			TransferDate DATETIME2 NULL,
			PurposeOfTransfer NVARCHAR(200) NULL,
			SiteID BIGINT NOT NULL,
			TestRequested NVARCHAR(200) NULL,
			RowStatus INT NOT NULL,
			RowAction CHAR NULL
			);
		DECLARE @FreezerBoxLocationAvailabilitiesTemp TABLE (
			FreezerSubdivisionID BIGINT NOT NULL,
			BoxPlaceAvailability NVARCHAR(MAX) NOT NULL
			);
		DECLARE @NotificationsTemp TABLE (
			NotificationID BIGINT NOT NULL,
			NotificationTypeID BIGINT NULL,
			UserID BIGINT NULL,
			NotificationObjectID BIGINT NULL,
			NotificationObjectTypeID BIGINT NULL,
			TargetUserID BIGINT NULL,
			TargetSiteID BIGINT NULL,
			TargetSiteTypeID BIGINT NULL,
			SiteID BIGINT NULL,
			Payload NVARCHAR(MAX) NULL,
			LoginSite BIGINT NULL
			);
		DECLARE @FavoritesString VARCHAR(MAX);

		BEGIN TRANSACTION;

		INSERT INTO @SamplesTemp
		SELECT *
		FROM OPENJSON(@Samples) WITH (
				SampleID BIGINT,
				SampleTypeID BIGINT,
				RootSampleID BIGINT,
				OriginalSampleID BIGINT,
				HumanID BIGINT,
				SpeciesID BIGINT,
				AnimalID BIGINT,
				MonitoringSessionID BIGINT,
				CollectedByPersonID BIGINT,
				CollectedByOrganizationID BIGINT,
				MainTestID BIGINT,
				CollectionDate DATETIME2,
				SentDate DATETIME2,
				EIDSSLocalFieldSampleID NVARCHAR(200),
				VectorSessionID BIGINT,
				VectorID BIGINT,
				FreezerSubdivisionID BIGINT,
				StorageBoxPlace NVARCHAR(200),
				SampleStatusTypeID BIGINT,
				PreviousSampleStatusTypeID BIGINT,
				FunctionalAreaID BIGINT,
				DestroyedByPersonID BIGINT,
				EnteredDate DATETIME2,
				DestructionDate DATETIME2,
				EIDSSLaboratorySampleID NVARCHAR(200),
				Note NVARCHAR(500),
				SiteID BIGINT,
				RowStatus INT,
				SentToOrganizationID BIGINT,
				ReadOnlyIndicator BIT,
				BirdStatusTypeID BIGINT,
				HumanDiseaseReportID BIGINT,
				VeterinaryDiseaseReportID BIGINT,
				AccessionDate DATETIME2,
				AccessionConditionTypeID BIGINT,
				AccessionComment NVARCHAR(200),
				AccessionByPersonID BIGINT,
				DestructionMethodTypeID BIGINT,
				CurrentSiteID BIGINT,
				SampleKindTypeID BIGINT,
				MarkedForDispositionByPersonID BIGINT,
				OutOfRepositoryDate DATETIME2,
				DiseaseID BIGINT,
				FavoriteIndicator INT,
				RowAction CHAR(1)
				);

		INSERT INTO @BatchTestsTemp
		SELECT *
		FROM OPENJSON(@BatchTests) WITH (
				BatchTestID BIGINT,
				TestNameTypeID BIGINT,
				BatchStatusTypeID BIGINT,
				PerformedByOrganizationID BIGINT,
				PerformedByPersonID BIGINT,
				ValidatedByOrganizationID BIGINT,
				ValidatedByPersonID BIGINT,
				ObservationID BIGINT,
				SiteID BIGINT,
				PerformedDate DATETIME2,
				ValidationDate DATETIME2,
				EIDSSBatchTestID NVARCHAR(200),
				RowStatus INT,
				ResultEnteredByPersonID BIGINT,
				ResultEnteredByOrganizationID BIGINT,
				TestRequested NVARCHAR(200),
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
				PreviousTestStatusTypeID BIGINT,
				DiseaseID BIGINT,
				SampleID BIGINT,
				BatchTestID BIGINT,
				ObservationID BIGINT,
				TestNumber INT,
				Note NVARCHAR(500),
				RowStatus INT,
				StartedDate DATETIME2,
				ConcludedDate DATETIME2,
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
				RowAction CHAR(1)
				);

		INSERT INTO @TestAmendmentsTemp
		SELECT *
		FROM OPENJSON(@TestAmendments) WITH (
				TestAmendmentID BIGINT,
				TestID BIGINT,
				AmendedByOrganizationID BIGINT,
				AmendedByPersonID BIGINT,
				AmendmentDate DATETIME2,
				OldTestResultTypeID BIGINT,
				ChangedTestResultTypeID BIGINT,
				OldNote NVARCHAR(500),
				ChangedNote NVARCHAR(500),
				ReasonForAmendment NVARCHAR(500),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @TransfersTemp
		SELECT *
		FROM OPENJSON(@Transfers) WITH (
				TransferID BIGINT,
				SampleID BIGINT,
				EIDSSTransferID NVARCHAR(200),
				TransferStatusTypeID BIGINT,
				TransferredFromOrganizationID BIGINT,
				TransferredToOrganizationID BIGINT,
				SentByPersonID BIGINT,
				TransferDate DATETIME2,
				PurposeOfTransfer NVARCHAR(200),
				SiteID BIGINT,
				TestRequested NVARCHAR(200),
				RowStatus INT,
				RowAction CHAR(1)
				);

		INSERT INTO @FreezerBoxLocationAvailabilitiesTemp
		SELECT *
		FROM OPENJSON(@FreezerBoxLocationAvailabilities) WITH (
				FreezerSubdivisionID BIGINT,
				BoxPlaceAvailability NVARCHAR(MAX)
				);

		INSERT INTO @NotificationsTemp
		SELECT *
		FROM OPENJSON(@Notifications) WITH (
				NotificationID BIGINT,
				NotificationTypeID BIGINT,
				UserID BIGINT,
				NotificationObjectID BIGINT,
				NotificationObjectTypeID BIGINT,
				TargetUserID BIGINT,
				TargetSiteID BIGINT,
				TargetSiteTypeID BIGINT,
				SiteID BIGINT,
				Payload NVARCHAR(MAX),
				LoginSite BIGINT
				);

		SET @FavoritesString = CONVERT(NVARCHAR(MAX), @Favorites, 1);

		WHILE EXISTS (
				SELECT *
				FROM @SamplesTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = SampleID,
				@SampleID = SampleID,
				@SampleTypeID = SampleTypeID,
				@OriginalSampleID = OriginalSampleID,
				@HumanID = HumanID,
				@SpeciesID = SpeciesID,
				@AnimalID = AnimalID,
				@VectorID = VectorID,
				@MonitoringSessionID = MonitoringSessionID,
				@VectorSessionID = VectorSessionID,
				@HumanDiseaseReportID = HumanDiseaseReportID,
				@VeterinaryDiseaseReportID = VeterinaryDiseaseReportID,
				@CollectionDate = CollectionDate,
				@CollectedByPersonID = CollectedByPersonID,
				@CollectedByOrganizationID = CollectedByOrganizationID,
				@SentDate = SentDate,
				@SentToOrganizationID = SentToOrganizationID,
				@EIDSSLocalFieldSampleID = EIDSSLocalFieldSampleID,
				@EIDSSLaboratorySampleID = EIDSSLaboratorySampleID, 
				@SiteID = SiteID,
				@FunctionalAreaID = FunctionalAreaID,
				@FreezerSubdivisionID = FreezerSubdivisionID,
				@StorageBoxPlace = StorageBoxPlace,
				@EnteredDate = EnteredDate,
				@OutOfRepositoryDate = OutOfRepositoryDate,
				@DestructionDate = DestructionDate,
				@DestructionMethodTypeID = DestructionMethodTypeID,
				@DestroyedByPersonID = DestroyedByPersonID,
				@ReadOnlyIndicator = ReadOnlyIndicator,
				@AccessionDate = AccessionDate,
				@AccessionConditionTypeID = AccessionConditionTypeID,
				@AccessionByPersonID = AccessionByPersonID,
				@SampleStatusTypeID = SampleStatusTypeID,
				@PreviousSampleStatusTypeID = PreviousSampleStatusTypeID,
				@AccessionComment = AccessionComment,
				@Note = Note,
				@CurrentSiteID = CurrentSiteID,
				@SampleKindTypeID = SampleKindTypeID,
				@MarkedForDispositionByPersonID = MarkedForDispositionByPersonID,
				@DiseaseID = DiseaseID,
				@FavoriteIndicator = FavoriteIndicator,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @SamplesTemp;

			EXECUTE dbo.USSP_LAB_SAMPLE_SET @LanguageID,
				@SampleID OUTPUT,
				@SampleTypeID,
				@RootSampleID,
				@OriginalSampleID,
				@HumanID,
				@SpeciesID,
				@AnimalID,
				@VectorID,
				@MonitoringSessionID,
				@VectorSessionID,
				@HumanDiseaseReportID,
				@VeterinaryDiseaseReportID,
				@CollectionDate,
				@CollectedByPersonID,
				@CollectedByOrganizationID,
				@SentDate,
				@SentToOrganizationID,
				@EIDSSLocalFieldSampleID,
				@EIDSSLaboratorySampleID, 
				@SiteID,
				@FunctionalAreaID,
				@FreezerSubdivisionID,
				@StorageBoxPlace,
				@EnteredDate,
				@OutOfRepositoryDate,
				@MarkedForDispositionByPersonID,
				@DestructionDate,
				@DestructionMethodTypeID,
				@DestroyedByPersonID,
				@ReadOnlyIndicator,
				@AccessionDate,
				@AccessionConditionTypeID,
				@AccessionByPersonID,
				@SampleStatusTypeID,
				@PreviousSampleStatusTypeID,
				@AccessionComment,
				@Note,
				@CurrentSiteID,
				@SampleKindTypeID,
				@DiseaseID,
				@RowStatus,
				@RowAction;

			UPDATE @TestsTemp
			SET SampleID = @SampleID
			WHERE SampleID = @RowID;

			UPDATE @TransfersTemp
			SET SampleID = @SampleID
			WHERE SampleID = @RowID;

			IF @FavoriteIndicator = 1
				SELECT @FavoritesString = REPLACE(@FavoritesString, @RowID, @SampleID);

			--POCO does not like the XML modify command; used string and replace for now.
			--SELECT @Favorites = @Favorites.modify('replace value of (/Favorites/Favorite/@SampleID[.=sql:variable("@RowID")])[1] with sql:variable("@SampleID")');

			IF @SampleID <> @RootSampleID
				AND (
					@RowAction = 'A'
					OR @RowAction = 'C' 
					)
			BEGIN
				DECLARE @TransferIDTemp AS BIGINT;

				SELECT @TransferIDTemp = tro.idfTransferOut
				FROM dbo.tlbTransferOutMaterial tom
				INNER JOIN dbo.tlbTransferOUT AS tro
					ON tro.idfTransferOut = tom.idfTransferOut
				WHERE tom.idfMaterial = @RootSampleID;

				UPDATE dbo.tlbTransferOUT
				SET idfsTransferStatus = '10001001'
				WHERE idfTransferOut = @TransferIDTemp;
			END;

			DELETE
			FROM @SamplesTemp
			WHERE SampleID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @BatchTestsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = BatchTestID,
				@BatchTestID = BatchTestID,
				@TestNameTypeID = TestNameTypeID,
				@BatchStatusTypeID = BatchStatusTypeID,
				@PerformedByOrganizationID = PerformedByOrganizationID,
				@PerformedByPersonID = PerformedByPersonID,
				@ValidatedByOrganizationID = ValidatedByOrganizationID,
				@ValidatedByPersonID = ValidatedByPersonID,
				@ObservationID = ObservationID,
				@SiteID = SiteID,
				@PerformedDate = PerformedDate,
				@ValidationDate = ValidationDate,
				@EIDSSBatchTestID = EIDSSBatchTestID,
				@RowStatus = RowStatus,
				@ResultEnteredByPersonID = ResultEnteredByPersonID,
				@ResultEnteredByOrganizationID = ResultEnteredByOrganizationID,
				@TestRequested = TestRequested,
				@RowAction = RowAction
			FROM @BatchTestsTemp;

			EXECUTE dbo.USSP_GBL_BATCH_TEST_SET @LanguageID,
				@BatchTestID OUTPUT,
				@TestNameTypeID,
				@BatchStatusTypeID,
				@PerformedByOrganizationID,
				@PerformedByPersonID,
				@ValidatedByOrganizationID,
				@ValidatedByPersonID,
				@ObservationID,
				@SiteID,
				@PerformedDate,
				@ValidationDate,
				@EIDSSBatchTestID,
				@RowStatus,
				@ResultEnteredByPersonID,
				@ResultEnteredByOrganizationID,
				@TestRequested,
				@RowAction;

			UPDATE @TestsTemp
			SET BatchTestID = @BatchTestID
			WHERE BatchTestID = @RowID;

			DELETE
			FROM @BatchTestsTemp
			WHERE BatchTestID = @RowID;
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
				@PreviousTestStatusTypeID = PreviousTestStatusTypeID,
				@DiseaseID = DiseaseID,
				@SampleID = SampleID,
				@BatchTestID = BatchTestID,
				@ObservationID = ObservationID,
				@TestNumber = TestNumber,
				@Note = Note,
				@RowStatus = RowStatus,
				@StartedDate = StartedDate,
				@ConcludedDate = ConcludedDate,
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

			EXECUTE dbo.USSP_LAB_TEST_SET @LanguageID,
				@TestID,
				@TestNameTypeID,
				@TestCategoryTypeID,
				@TestResultTypeID,
				@TestStatusTypeID,
				@PreviousTestStatusTypeID,
				@DiseaseID,
				@SampleID,
				@BatchTestID,
				@ObservationID,
				@TestNumber,
				@Note,
				@RowStatus,
				@StartedDate,
				@ConcludedDate,
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

			UPDATE @TestAmendmentsTemp
			SET TestID = @TestID
			WHERE TestID = @RowID;

			DELETE
			FROM @TestsTemp
			WHERE TestID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @TestAmendmentsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = TestAmendmentID,
				@TestAmendmentID = TestAmendmentID,
				@TestID = TestID,
				@AmendedByOrganizationID = AmendedByOrganizationID,
				@AmendedByPersonID = AmendedByPersonID,
				@AmendmentDate = AmendmentDate,
				@OldTestResultTypeID = OldTestResultTypeID,
				@ChangedTestResultTypeID = ChangedTestResultTypeID,
				@OldNote = OldNote,
				@ChangedNote = ChangedNote,
				@ReasonForAmendment = ReasonForAmendment,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @TestAmendmentsTemp;

			EXECUTE dbo.USSP_GBL_TEST_AMENDMENT_SET @LanguageID,
				@TestAmendmentID,
				@TestID,
				@AmendedByOrganizationID,
				@AmendedByPersonID,
				@AmendmentDate,
				@OldTestResultTypeID,
				@ChangedTestResultTypeID,
				@OldNote,
				@ChangedNote,
				@ReasonForAmendment,
				@RowStatus,
				@RowAction;

			DELETE
			FROM @TestAmendmentsTemp
			WHERE TestAmendmentID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @TransfersTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = TransferID,
				@TransferID = TransferID,
				@SampleID = SampleID,
				@EIDSSTransferID = EIDSSTransferID,
				@TransferStatusTypeID = TransferStatusTypeID,
				@TransferredFromOrganizationID = TransferredFromOrganizationID,
				@TransferredToOrganizationID = TransferredToOrganizationID,
				@SentByPersonID = SentByPersonID,
				@TransferDate = TransferDate,
				@Note = PurposeOfTransfer,
				@SiteID = SiteID,
				@TestRequested = TestRequested,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @TransfersTemp;

			EXECUTE dbo.USSP_LAB_TRANSFER_SET @LanguageID,
				@TransferID,
				@SampleID,
				@EIDSSTransferID,
				@TransferStatusTypeID,
				@TransferredFromOrganizationID,
				@TransferredToOrganizationID,
				@SentByPersonID,
				@SentDate,
				@Note,
				@SiteID,
				@TestRequested,
				@RowStatus,
				@RowAction;

			DELETE
			FROM @TransfersTemp
			WHERE TransferID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @FreezerBoxLocationAvailabilitiesTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = FreezerSubdivisionID,
				@FreezerSubdivisionID = FreezerSubdivisionID,
				@BoxPlaceAvailability = BoxPlaceAvailability
			FROM @FreezerBoxLocationAvailabilitiesTemp;

			UPDATE dbo.tlbFreezerSubdivision
			SET BoxPlaceAvailability = @BoxPlaceAvailability
			WHERE idfSubdivision = @FreezerSubdivisionID;

			DELETE
			FROM @FreezerBoxLocationAvailabilitiesTemp
			WHERE FreezerSubdivisionID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @NotificationsTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = NotificationID,
				@NotificationID = NotificationID,
				@NotificationTypeID = NotificationTypeID,
				@UserID = UserID,
				@NotificationObjectID = NotificationObjectID,
				@NotificationObjectTypeID = NotificationObjectTypeID,
				@TargetUserID = TargetUserID,
				@TargetSiteID = TargetSiteID,
				@TargetSiteTypeID = TargetSiteTypeID,
				@SiteID = SiteID,
				@Payload = Payload,
				@LoginSite = LoginSite
			FROM @NotificationsTemp;

			EXECUTE dbo.USP_GBL_NOTIFICATION_SET @LanguageID,
				@NotificationID,
				@NotificationTypeID,
				@UserID,
				@NotificationObjectID,
				@NotificationObjectTypeID,
				@TargetUserID,
				@TargetSiteID,
				@TargetSiteTypeID,
				@SiteID,
				@Payload,
				@LoginSite;

			DELETE
			FROM @NotificationsTemp
			WHERE NotificationID = @RowID;
		END;

		IF @Favorites IS NOT NULL
		BEGIN
			DECLARE @UserPreferenceID AS BIGINT;

			SELECT @UserPreferenceID = (
					SELECT UserPreferenceUID
					FROM dbo.UserPreference
					WHERE idfUserID = @UserID
						AND ModuleConstantID = 10508006
						AND intRowStatus = 0
					);

			IF @UserPreferenceID IS NULL
			BEGIN
				EXECUTE dbo.USP_GBL_NEXTKEYID_GET N'UserPreference',
					@UserPreferenceID OUTPUT;

				INSERT INTO dbo.UserPreference (
					UserPreferenceUID,
					idfUserID,
					ModuleConstantID,
					PreferenceDetail,
					intRowStatus,
					AuditCreateUser,
					AuditCreateDTM
					)
				VALUES (
					@UserPreferenceID,
					@UserID,
					10508006,
					@FavoritesString,
					0,
					'srvcEIDSS',
					GETDATE()
					);
			END
			ELSE
			BEGIN
				UPDATE dbo.UserPreference
				SET idfUserID = @UserID,
					PreferenceDetail = @FavoritesString,
					AuditUpdateUser = 'srvcEIDSS',
					AuditUpdateDTM = GETDATE()
				WHERE UserPreferenceUID = @UserPreferenceID;
			END
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END;
