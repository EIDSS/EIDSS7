-- ================================================================================================
-- Name: USSP_LAB_SAMPLE_SET
--
-- Description:	Inserts or updates sample records for various laboratory module use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/08/2018 Initial release.
-- Stephen Long		01/24/2019 Added storage box place to support the location in the freezer 
--                             subdivision.  Changed freezer ID to freezer subdivision ID.
-- Stephen Long     01/30/2019 Added disease ID parameter and to insert/update statements.
-- Stephen Long     02/21/2019 Added root sample ID and sample kind type ID.
-- Stephen Long     03/08/2019 Added row action 'D' for aliquot/derivative, so new lab sample ID 
--                             is not created, rather a number or country decides on a customized 
--                             method.
-- Stephen Long     03/28/2019 Added parameter @EIDSSLaboratorySampleID for aliquots/derivatives. 
--                             These are assigned in the EIDSS application from the derived off of
--                             the original (parent) sample ID.
-- Stephen Long     04/16/2019 Added copy of human master to human for new sample records.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_LAB_SAMPLE_SET] (
	@LanguageID NVARCHAR(50),
	@SampleID BIGINT OUTPUT,
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
	@CollectionDate DATETIME = NULL,
	@CollectedByPersonID BIGINT = NULL,
	@CollectedByOrganizationID BIGINT = NULL,
	@SentDate DATETIME = NULL,
	@SentToOrganizationID BIGINT = NULL,
	@EIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@EIDSSLaboratorySampleID NVARCHAR(200) = NULL, 
	@SiteID BIGINT,
	@FunctionalAreaID BIGINT = NULL,
	@FreezerSubdivisionID BIGINT = NULL,
	@StorageBoxPlace NVARCHAR(200) = NULL,
	@EnteredDate DATETIME = NULL,
	@OutOfRepositoryDate DATETIME = NULL,
	@MarkedForDispositionByPersonID BIGINT = NULL,
	@DestructionDate DATETIME = NULL,
	@DestructionMethodTypeID BIGINT = NULL,
	@DestroyedByPersonID BIGINT = NULL,
	@ReadOnlyIndicator BIT,
	@AccessionDate DATETIME = NULL,
	@AccessionConditionTypeID BIGINT = NULL,
	@AccessionByPersonID BIGINT = NULL,
	@SampleStatusTypeID BIGINT = NULL,
	@PreviousSampleStatusTypeID BIGINT = NULL,
	@AccessionComment NVARCHAR(200) = NULL,
	@Note NVARCHAR(500) = NULL,
	@CurrentSiteID BIGINT = NULL,
	@SampleKindTypeID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@RowStatus INT,
	@RowAction CHAR
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @NewHumanID BIGINT = NULL, 
			@ReturnCode INT = 0, 
			@ReturnMessage NVARCHAR(MAX) = 'SUCCESS';

		IF @RowAction = 'I' -- Standard insert
			OR @RowAction = 'C' -- Insert and accession (LUC01)
			OR @RowAction = 'Q' -- Create aliquot/derivative and accession (LUC02)
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbMaterial',
				@idfsKey = @SampleID OUTPUT;

			IF @RowAction <> 'Q' -- Non-aliquot/derivative record; standard sample record.
			BEGIN
				SET @OriginalSampleID = @SampleID;
			END;

			--Local/field sample EIDSS ID. Only system assign when user leaves blank.
			IF @EIDSSLocalFieldSampleID IS NULL
				OR @EIDSSLocalFieldSampleID = ''
			BEGIN
				EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Sample Field Barcode',
					@NextNumberValue = @EIDSSLocalFieldSampleID OUTPUT,
					@InstallationSite = NULL;
			END

			IF @RowAction = 'C' --New record that will be accessioned at the same time.
			BEGIN
				EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Sample',
					@NextNumberValue = @EIDSSLaboratorySampleID OUTPUT,
					@InstallationSite = NULL;
			END

			IF @RowAction = 'I' OR @RowAction = 'C'
			BEGIN
				EXECUTE dbo.USP_HUM_COPYHUMANACTUALTOHUMAN @HumanID, @NewHumanID OUTPUT, @ReturnCode OUTPUT, @ReturnMessage OUTPUT;
			END;

			INSERT INTO dbo.tlbMaterial (
				idfMaterial,
				idfsSampleType,
				idfRootMaterial,
				idfParentMaterial,
				idfHuman,
				idfSpecies,
				idfAnimal,
				idfVector,
				idfMonitoringSession,
				idfVectorSurveillanceSession,
				idfHumanCase,
				idfVetCase,
				datFieldCollectionDate,
				idfFieldCollectedByPerson,
				idfFieldCollectedByOffice,
				datFieldSentDate,
				idfSendToOffice,
				strFieldBarcode,
				strBarcode,
				idfsSite,
				idfInDepartment,
				idfSubdivision,
				StorageBoxPlace,
				datEnteringDate,
				datOutOfRepositoryDate,
				idfMarkedForDispositionByPerson,
				datDestructionDate,
				idfsDestructionMethod,
				idfDestroyedByPerson,
				blnReadOnly,
				datAccession,
				idfsAccessionCondition,
				idfAccesionByPerson,
				idfsSampleStatus,
				strCondition,
				strNote,
				idfsCurrentSite,
				idfsSampleKind,
				PreviousSampleStatusID,
				DiseaseID,
				intRowStatus
				)
			VALUES (
				@SampleID,
				@SampleTypeID,
				@SampleID,
				@OriginalSampleID,
				@NewHumanID,
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
				@AccessionComment,
				@Note,
				@CurrentSiteID,
				@SampleKindTypeID,
				@PreviousSampleStatusTypeID,
				@DiseaseID,
				0
				);
		END;
		ELSE
		BEGIN
			--Sample is being accessioned, so get the next lab sample code allowing the user the option to print the barcode.
			IF @RowAction = 'A' --Update and accession (LUC01)
			BEGIN
				EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Sample',
					@NextNumberValue = @EIDSSLaboratorySampleID OUTPUT,
					@InstallationSite = NULL;

				UPDATE dbo.tlbMaterial
				SET idfsSampleType = @SampleTypeID,
					idfRootMaterial = @RootSampleID,
					idfParentMaterial = @OriginalSampleID,
					idfHuman = @HumanID,
					idfSpecies = @SpeciesID,
					idfAnimal = @AnimalID,
					idfMonitoringSession = @MonitoringSessionID,
					idfFieldCollectedByPerson = @CollectedByPersonID,
					idfFieldCollectedByOffice = @CollectedByOrganizationID,
					datFieldCollectionDate = @CollectionDate,
					datFieldSentDate = @SentDate,
					strFieldBarcode = @EIDSSLocalFieldSampleID,
					idfVectorSurveillanceSession = @VectorSessionID,
					idfVector = @VectorID,
					idfSubdivision = @FreezerSubdivisionID,
					StorageBoxPlace = @StorageBoxPlace,
					idfsSampleStatus = @SampleStatusTypeID,
					idfInDepartment = @FunctionalAreaID,
					idfDestroyedByPerson = @DestroyedByPersonID,
					datEnteringDate = @EnteredDate,
					datDestructionDate = @DestructionDate,
					strBarcode = @EIDSSLaboratorySampleID,
					strNote = @Note,
					idfsSite = @SiteID,
					idfsCurrentSite = @CurrentSiteID,
					idfsSampleKind = @SampleKindTypeID,
					intRowStatus = @RowStatus,
					idfSendToOffice = @SentToOrganizationID,
					blnReadOnly = @ReadOnlyIndicator,
					idfHumanCase = @HumanDiseaseReportID,
					idfVetCase = @VeterinaryDiseaseReportID,
					datAccession = @AccessionDate,
					idfsAccessionCondition = @AccessionConditionTypeID,
					strCondition = @AccessionComment,
					idfAccesionByPerson = @AccessionByPersonID,
					idfsDestructionMethod = @DestructionMethodTypeID,
					idfMarkedForDispositionByPerson = @MarkedForDispositionByPersonID,
					datOutOfRepositoryDate = @OutOfRepositoryDate,
					PreviousSampleStatusID = @PreviousSampleStatusTypeID,
					DiseaseID = @DiseaseID
				WHERE idfMaterial = @SampleID;
			END
			ELSE
			BEGIN
				UPDATE dbo.tlbMaterial
				SET idfsSampleType = @SampleTypeID,
					idfRootMaterial = @RootSampleID,
					idfParentMaterial = @OriginalSampleID,
					idfHuman = @HumanID,
					idfSpecies = @SpeciesID,
					idfAnimal = @AnimalID,
					idfMonitoringSession = @MonitoringSessionID,
					idfFieldCollectedByPerson = @CollectedByPersonID,
					idfFieldCollectedByOffice = @CollectedByOrganizationID,
					datFieldCollectionDate = @CollectionDate,
					datFieldSentDate = @SentDate,
					strFieldBarcode = @EIDSSLocalFieldSampleID,
					idfVectorSurveillanceSession = @VectorSessionID,
					idfVector = @VectorID,
					idfSubdivision = @FreezerSubdivisionID,
					StorageBoxPlace = @StorageBoxPlace,
					idfsSampleStatus = @SampleStatusTypeID,
					idfInDepartment = @FunctionalAreaID,
					idfDestroyedByPerson = @DestroyedByPersonID,
					datEnteringDate = @EnteredDate,
					datDestructionDate = @DestructionDate,
					strNote = @Note,
					idfsSite = @SiteID,
					idfsCurrentSite = @CurrentSiteID,
					idfsSampleKind = @SampleKindTypeID,
					intRowStatus = @RowStatus,
					idfSendToOffice = @SentToOrganizationID,
					blnReadOnly = @ReadOnlyIndicator,
					idfHumanCase = @HumanDiseaseReportID,
					idfVetCase = @VeterinaryDiseaseReportID,
					datAccession = @AccessionDate,
					idfsAccessionCondition = @AccessionConditionTypeID,
					strCondition = @AccessionComment,
					idfAccesionByPerson = @AccessionByPersonID,
					idfsDestructionMethod = @DestructionMethodTypeID,
					idfMarkedForDispositionByPerson = @MarkedForDispositionByPersonID,
					datOutOfRepositoryDate = @OutOfRepositoryDate,
					PreviousSampleStatusID = @PreviousSampleStatusTypeID,
					DiseaseID = @DiseaseID
				WHERE idfMaterial = @SampleID;
			END;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO


