-- ================================================================================================
-- Name: USP_GBL_SAMPLE_GETList
--
-- Description:	Get sample list for the disease reports, sessions and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/14/2019 Updated field names, and added dbo schema in front of function 
--                             calls.
-- Stephen Long     04/28/2019 Changed from root sample ID to parent sample ID for aliquots/
--                             derivatives.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_SAMPLE_GETList] (
	@LanguageID NVARCHAR(50),
	@HumanDiseaseReportID BIGINT = NULL,
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@ParentSampleID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@VectorSessionID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT m.idfMaterial AS SampleID,
			m.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			m.idfRootMaterial AS RootSampleID,
			m.idfParentMaterial AS OriginalSampleID,
			m.idfHuman AS HumanID,
			ISNULL(h.strLastName, N'') + ISNULL(' ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') AS HumanName,
			m.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			m.idfAnimal AS AnimalID,
			a.strAnimalCode AS EIDSSAnimalID,
			a.idfsAnimalGender AS AnimalGenderTypeID,
			animalGender.name AS AnimalGenderTypeName,
			a.idfsAnimalAge AS AnimalAgeTypeID,
			animalAge.name AS AnimalAgeTypeName,
			a.strColor AS AnimalColor,
			m.idfMonitoringSession AS MonitoringSessionID,
			m.idfFieldCollectedByPerson AS CollectedByPersonID,
			ISNULL(fieldCollectedByPerson.strFamilyName, N'') + ISNULL(' ' + fieldCollectedByPerson.strFirstName, '') + ISNULL(' ' + fieldCollectedByPerson.strSecondName, '') AS CollectedByPersonName,
			m.idfFieldCollectedByOffice AS CollectedByOrganizationID,
			fieldCollectedByOfficeSite.strSiteName AS CollectedByOrganizationName,
			m.idfMainTest AS MainTestID,
			t.intTestNumber AS TestNumber,
			m.datFieldCollectionDate AS CollectionDate,
			m.datFieldSentDate AS SentDate,
			m.strFieldBarcode AS EIDSSLocalOrFieldSampleID,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
			m.idfVectorSurveillanceSession AS VectorSessionID,
			m.idfVector AS VectorID,
			m.idfSubdivision AS FreezerID,
			fs.strNameChars AS FreezerName,
			m.idfsSampleStatus AS SampleStatusTypeID,
			sampleStatus.name AS SampleStatusTypeName,
			m.idfInDepartment AS FunctionalAreaID,
			departmentOfficeSite.strSiteName AS FunctionalAreaName,
			m.idfDestroyedByPerson AS DestroyedByPersonID,
			ISNULL(destroyedByPerson.strFamilyName, N'') + ISNULL(' ' + destroyedByPerson.strFirstName, '') + ISNULL(' ' + destroyedByPerson.strSecondName, '') AS DestroyedByPersonName,
			m.datEnteringDate AS EnteredDate,
			m.datDestructionDate AS DestructionDate,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.strNote AS Comments,
			m.idfsSite AS SiteID,
			materialSite.strSiteName AS SiteName,
			m.intRowStatus AS RowStatus,
			m.idfSendToOffice AS SentToOrganizationID,
			sendToOfficeSite.strSiteName AS SentToOrganizationName,
			m.blnReadOnly AS ReadOnlyIndicator,
			m.idfsBirdStatus AS BirdStatusTypeID,
			birdStatus.name AS BirdStatusTypeName,
			m.idfHumanCase AS HumanDiseaseReportID,
			m.idfVetCase AS VeterinaryDiseaseReportID,
			m.datAccession AS AccessionDate,
			m.idfsAccessionCondition AS AccessionConditionTypeID,
			accessionCondition.name AS AccessionConditionTypeName,
			m.strCondition AS AccessionComment,
			m.idfAccesionByPerson AS AccessionByPersonID,
			ISNULL(accessionByPerson.strFamilyName, N'') + ISNULL(' ' + accessionByPerson.strFirstName, '') + ISNULL(' ' + accessionByPerson.strSecondName, '') AS AccessionByPersonName,
			m.idfsDestructionMethod AS DestructionMethodTypeID,
			destructionMethod.name AS DestructionMethodTypeName,
			m.idfsCurrentSite AS CurrentSiteID,
			currentSite.strSiteName AS CurrentSiteName,
			m.idfsSampleKind AS SampleKindTypeID,
			sampleKind.name AS SampleKindTypeName,
			m.blnAccessioned AS AccessionedIndicator,
			m.blnShowInCaseOrSession AS ShowInReportSessionListIndicator,
			m.blnShowInLabList AS ShowInLaboratoryListIndicator,
			m.blnShowInDispositionList AS ShowInDispositionListIndicator,
			m.blnShowInAccessionInForm AS ShowInAccessionListIndicator,
			m.idfMarkedForDispositionByPerson AS MarkedForDispositionByPersonID,
			ISNULL(markedForDispositionByPerson.strFamilyName, N'') + ISNULL(' ' + markedForDispositionByPerson.strFirstName, '') + ISNULL(' ' + markedForDispositionByPerson.strSecondName, '') AS MarkedForDispositionByPersonName,
			m.datOutOfRepositoryDate AS OutOfRepositoryDate,
			m.datSampleStatusDate AS SampleStatusDate,
			m.DiseaseID,
			f.idfFarm AS FarmID,
			f.strFarmCode AS EIDSSFarmID,
			'R' AS RowAction
		FROM dbo.tlbMaterial m
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfTesting = m.idfMainTest
				AND t.intRowStatus = 0
		LEFT JOIN dbo.tlbHuman AS h
			ON h.idfHuman = m.idfHuman
				AND h.intRowStatus = 0
		LEFT JOIN dbo.tlbFreezerSubdivision AS fs
			ON fs.idfSubdivision = m.idfSubdivision
				AND fs.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS fieldCollectedByOffice
			ON fieldCollectedByOffice.idfOffice = m.idfFieldCollectedByOffice
				AND fieldCollectedByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS fieldCollectedByOfficeSite
			ON fieldCollectedByOfficeSite.idfsSite = fieldCollectedByOffice.idfsSite
				AND fieldCollectedByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
				AND d.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS departmentOffice
			ON departmentOffice.idfOffice = d.idfOrganization
				AND departmentOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS departmentOfficeSite
			ON departmentOfficeSite.idfsSite = departmentOffice.idfsSite
				AND departmentOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS materialSite
			ON materialSite.idfsSite = m.idfsSite
				AND materialSite.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS sendToOffice
			ON sendToOffice.idfOffice = m.idfSendToOffice
				AND sendToOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS sendToOfficeSite
			ON sendToOfficeSite.idfsSite = sendToOffice.idfsSite
				AND sendToOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS currentSite
			ON currentSite.idfsSite = m.idfsCurrentSite
				AND currentSite.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS fieldCollectedByPerson
			ON fieldCollectedByPerson.idfPerson = m.idfFieldCollectedByPerson
				AND fieldCollectedByPerson.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS destroyedByPerson
			ON destroyedByPerson.idfPerson = m.idfDestroyedByPerson
				AND destroyedByPerson.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS accessionByPerson
			ON accessionByPerson.idfPerson = m.idfAccesionByPerson
				AND accessionByPerson.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS markedForDispositionByPerson
			ON markedForDispositionByPerson.idfPerson = m.idfMarkedForDispositionByPerson
				AND markedForDispositionByPerson.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatus
			ON sampleStatus.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000006) AS birdStatus
			ON birdStatus.idfsReference = m.idfsBirdStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionCondition
			ON accessionCondition.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000157) AS destructionMethod
			ON destructionMethod.idfsReference = m.idfsDestructionMethod
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000158) AS sampleKind
			ON sampleKind.idfsReference = m.idfsSampleKind
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = m.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
				AND a.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000005) AS animalAge
			ON animalAge.idfsReference = a.idfsAnimalAge
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000007) AS animalGender
			ON animalGender.idfsReference = a.idfsAnimalGender
		LEFT JOIN dbo.tlbHerd AS hd
			ON hd.idfHerd = s.idfHerd
				AND h.intRowStatus = 0
		LEFT JOIN dbo.tlbFarm AS f
			ON f.idfFarm = hd.idfFarm
				AND f.intRowStatus = 0
		WHERE (
				(m.idfHumanCase = @HumanDiseaseReportID)
				OR (@HumanDiseaseReportID IS NULL)
				)
			AND (
				(m.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND (
				(m.idfParentMaterial = @ParentSampleID)
				OR (@ParentSampleID IS NULL)
				)
			AND (
				(m.idfMonitoringSession = @MonitoringSessionID)
				OR (@MonitoringSessionID IS NULL)
				)
			AND (
				(m.idfVectorSurveillanceSession = @VectorSessionID)
				OR (@VectorSessionID IS NULL)
				)
			AND m.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
GO


