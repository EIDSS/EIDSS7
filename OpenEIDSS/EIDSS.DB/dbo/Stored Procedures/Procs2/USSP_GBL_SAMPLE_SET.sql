-- ================================================================================================
-- Name: USSP_GBL_SAMPLE_SET
--
-- Description:	Inserts or updates sample records for various non-laboratory module use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/17/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_SAMPLE_SET] (
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
	@SiteID BIGINT,
	@EnteredDate DATETIME = NULL,
	@ReadOnlyIndicator BIT,
	@SampleStatusTypeID BIGINT = NULL,
	@Comments NVARCHAR(500) = NULL,
	@CurrentSiteID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@BirdStatusTypeID BIGINT = NULL, 
	@RowStatus INT,
	@RowAction CHAR
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbMaterial',
				@idfsKey = @SampleID OUTPUT;

			SET @OriginalSampleID = @SampleID;

			--Local/field sample EIDSS ID. Only system assign when user leaves blank.
			IF @EIDSSLocalFieldSampleID IS NULL
				OR @EIDSSLocalFieldSampleID = ''
			BEGIN
				EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Sample Field Barcode',
					@NextNumberValue = @EIDSSLocalFieldSampleID OUTPUT,
					@InstallationSite = NULL;
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
				idfsSite,
				datEnteringDate,
				blnReadOnly,
				idfsSampleStatus,
				strNote,
				idfsCurrentSite,
				DiseaseID,
				idfsBirdStatus,
				intRowStatus
				)
			VALUES (
				@SampleID,
				@SampleTypeID,
				@SampleID,
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
				@SiteID,
				@EnteredDate,
				@ReadOnlyIndicator,
				@SampleStatusTypeID,
				@Comments,
				@CurrentSiteID,
				@DiseaseID,
				@BirdStatusTypeID, 
				0
				);
		END;
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
				idfsSampleStatus = @SampleStatusTypeID,
				datEnteringDate = @EnteredDate,
				strNote = @Comments,
				idfsSite = @SiteID,
				idfsCurrentSite = @CurrentSiteID,
				intRowStatus = @RowStatus,
				idfSendToOffice = @SentToOrganizationID,
				blnReadOnly = @ReadOnlyIndicator,
				idfHumanCase = @HumanDiseaseReportID,
				idfVetCase = @VeterinaryDiseaseReportID,
				DiseaseID = @DiseaseID, 
				idfsBirdStatus = @BirdStatusTypeID 
			WHERE idfMaterial = @SampleID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
