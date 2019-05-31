
-- ================================================================================================
-- Name: USP_LAB_SAMPLE_GETDetail
--
-- Description:	Get sample detail for the edit a sample use case LUC11.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     09/05/2018 Initial release.
-- Stephen Long     01/25/2019 Added previous sample status type.
-- Stephen Long     01/30/2019 Added sample disease reference join, and removed the vector 
--                             surveillance session joins as they are not needed.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_SAMPLE_GETDetail] (
	@LanguageID NVARCHAR(50),
	@SampleID BIGINT = NULL
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT m.idfMaterial AS SampleID,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.idfRootMaterial AS RootSampleID,
			m.idfParentMaterial AS OriginalSampleID,
			originalLabSample.strBarcode AS OriginalLaboratorySampleEIDSSID,
			m.idfsSampleType AS SampleTypeID,
			sampleType.name AS SampleTypeName,
			m.idfHuman AS HumanID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
			m.idfSpecies AS SpeciesID,
			m.idfAnimal AS AnimalID,
			a.strAnimalCode AS EIDSSAnimalID,
			m.idfVector AS VectorID,
			'' AS PatientSpeciesVectorInformation,
			m.idfMonitoringSession AS MonitoringSessionID,
			m.idfVectorSurveillanceSession AS VectorSessionID,
			m.idfHumanCase AS HumanDiseaseReportID,
			m.idfVetCase AS VeterinaryDiseaseReportID,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			(
				CASE 
					WHEN (
							NOT ISNULL(m.idfMonitoringSession, '') = ''
							AND ms.SessionCategoryID = '10169001'
							)
						THEN 'Human'
					WHEN (
							NOT ISNULL(m.idfMonitoringSession, '') = ''
							AND ms.SessionCategoryID = '10169002'
							)
						THEN 'Veterinary'
					WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
						THEN 'Human'
					WHEN (NOT ISNULL(m.idfVetCase, '') = '')
						THEN 'Veterinary'
					WHEN (NOT ISNULL(m.idfVectorSurveillanceSession, '') = '')
						THEN 'Vector'
					ELSE ''
					END
				) AS ReportSessionTypeName,
			IIF((
					SELECT COUNT(t2.idfTesting)
					FROM dbo.tlbTesting t2
					WHERE (
							t2.idfsTestResult = 807990000000
							OR t2.idfsTestResult = 808040000000
							)
						AND t2.idfMaterial = m.idfMaterial
					) IS NULL, 0, 1) AS TestCompletedIndicator,
			(
				CASE 
					WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '')
						THEN msDisease.idfsReference
					WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
						THEN hdrDisease.idfsReference
					WHEN (NOT ISNULL(m.idfVetCase, '') = '')
						THEN vdrDisease.idfsReference
					WHEN (NOT ISNULL(m.DiseaseID, '') = '')
						THEN sampleDisease.idfsReference
					ELSE ''
					END
				) AS DiseaseIDList,
			(
				CASE 
					WHEN (NOT ISNULL(m.idfMonitoringSession, '') = '')
						THEN msDisease.name
					WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
						THEN hdrDisease.name
					WHEN (NOT ISNULL(m.idfVetCase, '') = '')
						THEN vdrDisease.name
					WHEN (NOT ISNULL(m.DiseaseID, '') = '')
						THEN sampleDisease.name
					ELSE ''
					END
				) AS DiseaseName,
			m.idfInDepartment AS FunctionalAreaID,
			functionalArea.name AS FunctionalAreaName,
			m.idfSubdivision AS FreezerSubdivisionID,
			m.StorageBoxPlace,
			m.datFieldCollectionDate AS FieldCollectionDate,
			m.idfFieldCollectedByPerson AS FieldCollectedByPersonID,
			ISNULL(fieldCollectedByPerson.strFamilyName, N'') + ISNULL(' ' + fieldCollectedByPerson.strFirstName, '') + ISNULL(' ' + fieldCollectedByPerson.strSecondName, '') AS FieldCollectedByPersonName,
			m.idfFieldCollectedByOffice AS FieldCollectedByOrganizationID,
			fieldCollectedByOfficeSite.strSiteName AS FieldCollectedByOrganizationName,
			m.datFieldSentDate AS FieldSentDate,
			m.idfSendToOffice AS FieldSentToOrganizationID,
			sendToOfficeSite.strSiteName AS FieldSentToOrganizationName,
			m.idfsSite AS SiteID,
			m.strFieldBarcode AS EIDSSLocalFieldSampleID,
			CASE 
				WHEN m.strBarcode IS NULL
					THEN m.strFieldBarcode
				ELSE m.strBarcode
				END AS EIDSSLaboratoryOrLocalFieldSampleID,
			m.datEnteringDate AS EnteredDate,
			m.datOutOfRepositoryDate AS OutOfRepositoryDate,
			m.idfMarkedForDispositionByPerson AS MarkedForDispositionByPersonID,
			m.blnReadOnly AS ReadOnlyIndicator,
			m.blnAccessioned AS AccessionIndicator,
			m.datAccession AS AccessionDate,
			m.idfsAccessionCondition AS AccessionConditionTypeID,
			(
				CASE 
					WHEN m.blnAccessioned = 0
						THEN 'Un-accessioned'
					WHEN m.idfsSampleStatus IS NULL
						THEN accessionConditionType.name
					WHEN m.idfsSampleStatus = '10015007'
						THEN accessionConditionType.name
					ELSE sampleStatusType.name
					END
				) AS AccessionConditionOrSampleStatusTypeName,
			m.idfAccesionByPerson AS AccessionByPersonID,
			m.idfsSampleStatus AS SampleStatusTypeID,
			m.strCondition AS AccessionComment,
			m.idfsDestructionMethod AS DestructionMethodTypeID,
			destructionMethodType.name AS DestructionMethodTypeName,
			m.datDestructionDate AS DestructionDate,
			m.idfDestroyedByPerson AS DestroyedByPersonID,
			COUNT(t.idfTesting) AS TestsCount,
			IIF(COUNT(t.idfTesting) > 0, 1, 0) AS TestAssignedIndicator,
			COUNT(tom.idfMaterial) AS TransferCount,
			m.strNote AS Note,
			m.idfsCurrentSite AS CurrentSiteID,
			m.idfsBirdStatus AS BirdStatusTypeID,
			m.idfMainTest AS MainTestID,
			m.idfsSampleKind AS SampleKindTypeID,
			m.PreviousSampleStatusID AS PreviousSampleStatusTypeID,
			m.intRowStatus AS RowStatus
		FROM dbo.tlbMaterial m
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbMaterial AS originalLabSample
			ON originalLabSample.idfMaterial = m.idfParentMaterial
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
		LEFT JOIN dbo.tlbHumanCase AS hc
			ON hc.idfHumanCase = m.idfHumanCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS hdrDisease
			ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS vdrDisease
			ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS sampleDisease
			ON sampleDisease.idfsReference = m.DiseaseID
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = m.idfMonitoringSession
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS msDisease
			ON msDisease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.tlbCampaign AS c
			ON c.idfCampaign = ms.idfCampaign
		LEFT JOIN dbo.tlbTransferOutMaterial AS tom
			ON tom.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbTransferOUT AS tro
			ON tro.idfTransferOut = tom.idfTransferOut
		LEFT JOIN dbo.tlbFreezerSubdivision AS fs
			ON fs.idfSubdivision = m.idfSubdivision
		LEFT JOIN dbo.tlbPerson AS fieldCollectedByPerson
			ON fieldCollectedByPerson.idfPerson = m.idfFieldCollectedByPerson
		LEFT JOIN dbo.tlbOffice AS fieldCollectedByOffice
			ON fieldCollectedByOffice.idfOffice = m.idfFieldCollectedByOffice
		LEFT JOIN dbo.tstSite AS fieldCollectedByOfficeSite
			ON fieldCollectedByOfficeSite.idfsSite = fieldCollectedByOffice.idfsSite
		LEFT JOIN dbo.tlbOffice AS sendToOffice
			ON sendToOffice.idfOffice = m.idfSendToOffice
		LEFT JOIN dbo.tstSite AS sendToOfficeSite
			ON sendToOfficeSite.idfsSite = sendToOffice.idfsSite
		LEFT JOIN dbo.tstSite AS currentSite
			ON currentSite.idfsSite = m.idfsCurrentSite
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.tstSite AS materialSite
			ON materialSite.idfsSite = m.idfsSite
		LEFT JOIN dbo.tlbPerson AS destroyedByPerson
			ON destroyedByPerson.idfPerson = m.idfDestroyedByPerson
		LEFT JOIN dbo.tlbPerson AS accessionByPerson
			ON accessionByPerson.idfPerson = m.idfAccesionByPerson
		LEFT JOIN dbo.tlbPerson AS markedForDispositionByPerson
			ON markedForDispositionByPerson.idfPerson = m.idfMarkedForDispositionByPerson
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000157) AS destructionMethodType
			ON destructionMethodType.idfsReference = m.idfsDestructionMethod
		WHERE m.idfMaterial = @SampleID
			AND m.intRowStatus = 0
		GROUP BY m.idfMaterial,
			m.idfRootMaterial,
			m.idfParentMaterial,
			m.idfsSampleType,
			sampleType.name,
			originalLabSample.strBarcode,
			m.idfMonitoringSession,
			m.strFieldBarcode,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			m.idfVectorSurveillanceSession,
			m.idfHuman,
			m.idfSpecies,
			m.idfAnimal,
			m.idfVector,
			m.idfInDepartment,
			functionalArea.name,
			m.strBarcode,
			m.idfHumanCase,
			m.idfVetCase,
			m.datFieldCollectionDate,
			m.idfFieldCollectedByOffice,
			fieldCollectedByOfficeSite.strSiteName,
			m.idfFieldCollectedByPerson,
			fieldCollectedByPerson.strFamilyName,
			fieldCollectedByPerson.strFirstName,
			fieldCollectedByPerson.strSecondName,
			m.datFieldSentDate,
			m.idfSendToOffice,
			sendToOfficeSite.strSiteName,
			m.datEnteringDate,
			m.datDestructionDate,
			m.datOutOfRepositoryDate,
			m.idfMarkedForDispositionByPerson,
			m.datAccession,
			m.idfsAccessionCondition,
			accessionConditionType.name,
			m.idfsSampleStatus,
			sampleStatusType.name,
			m.strCondition,
			m.idfsDestructionMethod,
			destructionMethodType.name,
			m.idfDestroyedByPerson,
			m.idfAccesionByPerson,
			m.idfSubdivision,
			m.StorageBoxPlace,
			a.strAnimalCode,
			m.blnAccessioned,
			m.blnReadOnly,
			ms.idfMonitoringSession,
			ms.SessionCategoryID,
			m.strNote,
			m.idfsSite,
			m.idfsCurrentSite,
			m.idfsBirdStatus,
			m.idfMainTest,
			m.idfsSampleKind,
			m.PreviousSampleStatusID,
			m.DiseaseID,
			m.intRowStatus,
			sampleDisease.idfsReference,
			sampleDisease.name,
			msDisease.idfsReference,
			msDisease.name,
			hdrDisease.idfsReference,
			hdrDisease.name,
			vdrDisease.idfsReference,
			vdrDisease.name;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;