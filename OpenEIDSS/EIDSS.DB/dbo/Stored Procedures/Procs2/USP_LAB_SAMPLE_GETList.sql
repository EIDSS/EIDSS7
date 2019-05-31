
-- ================================================================================================
-- Name: USP_LAB_SAMPLE_GETList
--
-- Description:	Get sample list for the laboratory module use case LUC01.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     07/18/2018 Initial release.
-- Stephen Long	    12/19/2018 Added pagination logic.
-- Stephen Long     01/14/2019 Split out search functionality (where conditions) for better 
--                             performance on this procedure.
-- Stephen Long     01/30/2019 Added sample disease reference join and removed the vector 
--                             surveillance session joins as they are no longer needed.
-- Stephen Long     02/11/2019 Fix to the value used for the test completed indicator.  It was 
--                             using the wrong base reference value.
-- Stephen Long     02/21/2019 Changed field collection and field sent to collection and sent to 
--                             be consistent on naming.  Added parent sample ID to support the 
--                             edit transfer use case.
-- Stephen Long     03/28/2019 Removed test status 'Not Started' as criteria for the test assigned 
--                             indicator and test assigned count.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_SAMPLE_GETList] (
	@LanguageID NVARCHAR(50),
	@UserID BIGINT = NULL,
	@OrganizationID BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@SampleID BIGINT = NULL,
	@ParentSampleID BIGINT = NULL,
	@DaysFromAccessionDate INT,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @favorites XML;

		SET @favorites = (
				SELECT PreferenceDetail
				FROM dbo.UserPreference Laboratory
				WHERE idfUserID = @UserID
					AND ModuleConstantID = 10508006
					AND intRowStatus = 0
				);

		IF @SampleID IS NULL
			AND @ParentSampleID IS NULL
		BEGIN
			WITH Favorites
			AS (
				SELECT SampleID = UserPref.value('@SampleID', 'BIGINT')
				FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
				)
			SELECT m.idfMaterial AS SampleID,
				m.strBarcode AS EIDSSLaboratorySampleID,
				CASE 
					WHEN f.SampleID IS NULL
						THEN 0
					ELSE 1
					END AS FavoriteIndicator,
				m.idfRootMaterial AS RootSampleID,
				m.idfParentMaterial AS ParentSampleID,
				parentSample.strBarcode AS ParentEIDSSLaboratorySampleID,
				m.idfsSampleType AS SampleTypeID,
				sampleType.name AS SampleTypeName,
				m.idfHuman AS HumanID,
				m.strCalculatedHumanName AS PatientFarmOwnerName,
				m.idfSpecies AS SpeciesID,
				m.idfAnimal AS AnimalID,
				a.strAnimalCode AS EIDSSAnimalID,
				m.idfVector AS VectorID,
				(
					CASE 
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169001
								)
							THEN m.strCalculatedHumanName
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169002
								)
							THEN speciesType.name
						WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
							THEN m.strCalculatedHumanName
						WHEN (NOT ISNULL(m.idfVetCase, '') = '')
							THEN speciesType.name
						WHEN (NOT ISNULL(m.idfVectorSurveillanceSession, '') = '')
							THEN 'Vector'
						ELSE ''
						END
					) AS PatientSpeciesVectorInformation,
				m.idfMonitoringSession AS MonitoringSessionID,
				m.idfVectorSurveillanceSession AS VectorSessionID,
				m.idfHumanCase AS HumanDiseaseReportID,
				m.idfVetCase AS VeterinaryDiseaseReportID,
				m.strCalculatedCaseID AS EIDSSReportSessionID,
				(
					CASE 
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169001
								)
							THEN 'Human'
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169002
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
						WHERE t2.idfsTestStatus IN (
								10001001,
								10001006
								)
							AND t2.idfMaterial = m.idfMaterial
						) > 0, 1, 0) AS TestCompletedIndicator,
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
						ELSE NULL
						END
					) AS DiseaseID,
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
				m.datFieldCollectionDate AS CollectionDate,
				m.idfFieldCollectedByPerson AS CollectedByPersonID,
				ISNULL(collectedByPerson.strFamilyName, N'') + ISNULL(' ' + collectedByPerson.strFirstName, '') + ISNULL(' ' + collectedByPerson.strSecondName, '') AS CollectedByPersonName,
				m.idfFieldCollectedByOffice AS CollectedByOrganizationID,
				collectedByOrganization.FullName AS CollectedByOrganizationName,
				m.datFieldSentDate AS SentDate,
				m.idfSendToOffice AS SentToOrganizationID,
				sentToOrganization.FullName AS SentToOrganizationName,
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
				accessionConditionType.name AS AccessionConditionTypeName,
				m.datAccession AS AccessionDate,
				m.idfsAccessionCondition AS AccessionConditionTypeID,
				(
					CASE 
						WHEN m.blnAccessioned = 0
							THEN 'Un-accessioned'
						WHEN m.idfsSampleStatus IS NULL
							THEN accessionConditionType.name
						WHEN m.idfsSampleStatus = 10015007
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
				IIF((
						SELECT COUNT(t2.idfTesting)
						FROM dbo.tlbTesting t2
						WHERE t2.idfsTestStatus IN (
								10001003,
								10001004
								)
							AND t2.idfMaterial = m.idfMaterial
						) > 0, 1, 0) AS TestAssignedIndicator,
				(
					SELECT COUNT(NULLIF(t3.idfTesting, 0))
					FROM dbo.tlbTesting t3
					WHERE t3.idfsTestStatus IN (
							10001003,
							10001004
							)
						AND t3.idfMaterial = m.idfMaterial
					) AS TestAssignedCount,
				IIF(COUNT(tom.idfMaterial) > 0, 1, 0) AS TransferCount,
				m.strNote AS Note,
				m.idfsCurrentSite AS CurrentSiteID,
				m.idfsBirdStatus AS BirdStatusTypeID,
				m.idfMainTest AS MainTestID,
				m.idfsSampleKind AS SampleKindTypeID,
				m.PreviousSampleStatusID AS PreviousSampleStatusTypeID,
				m.intRowStatus AS RowStatus,
				'' AS RowAction,
				0 AS RowSelectionIndicator
			FROM dbo.tlbMaterial m
			LEFT JOIN Favorites AS f
				ON m.idfMaterial = f.SampleID
			LEFT JOIN dbo.tlbTesting AS t
				ON t.idfMaterial = m.idfMaterial
			LEFT JOIN dbo.tlbMaterial AS parentSample
				ON parentSample.idfMaterial = m.idfParentMaterial
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
			LEFT JOIN dbo.tlbPerson AS collectedByPerson
				ON collectedByPerson.idfPerson = m.idfFieldCollectedByPerson
			LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS collectedByOrganization
				ON collectedByOrganization.idfOffice = m.idfFieldCollectedByOffice
			LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS sentToOrganization
				ON sentToOrganization.idfOffice = m.idfSendToOffice
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
			LEFT JOIN dbo.tlbFarm AS farm
				ON farm.idfFarm = vc.idfFarm
			LEFT JOIN dbo.tlbHerd AS herd
				ON herd.idfFarm = farm.idfFarm
			LEFT JOIN dbo.tlbSpecies AS species
				ON species.idfHerd = herd.idfHerd
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
				ON speciesType.idfsReference = species.idfsSpeciesType
			WHERE (
					(m.idfsSampleType <> 10320001)
					AND (m.intRowStatus = 0)
					AND (
						((m.idfSendToOffice = @OrganizationID))
						OR (
							(
								m.idfsSite = @SiteID
								OR m.idfsCurrentSite = @SiteID
								)
							)
						)
					AND (
						(m.blnAccessioned = 0)
						OR (
							(
								m.blnAccessioned = 1
								AND GETDATE() <= DATEADD(DAY, @DaysFromAccessionDate, m.datAccession)
								)
							AND (
								(
									m.idfsSampleKind = 12675430000000
									AND EXISTS (
										SELECT t3.*
										FROM dbo.tlbTesting t3
										WHERE t3.idfsTestStatus = 10001001
											AND t3.intRowStatus = 0
										)
									)
								OR m.idfsSampleKind IS NULL
								)
							AND (
								(m.idfsSampleStatus = 10015007)
								OR (m.idfsSampleStatus IS NULL)
								)
							AND NOT EXISTS (
								SELECT t4.*
								FROM dbo.tlbTesting t4
								WHERE t4.idfMaterial = m.idfMaterial
									AND t4.idfsTestStatus IN (
										10001003,
										10001004
										)
									AND t4.intRowStatus = 0
								)
							)
						)
					)
			GROUP BY m.idfMaterial,
				m.idfRootMaterial,
				m.idfParentMaterial,
				f.SampleID,
				m.idfsSampleType,
				sampleType.name,
				parentSample.strBarcode,
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
				collectedByOrganization.FullName,
				m.idfFieldCollectedByPerson,
				collectedByPerson.strFamilyName,
				collectedByPerson.strFirstName,
				collectedByPerson.strSecondName,
				m.datFieldSentDate,
				m.idfSendToOffice,
				sentToOrganization.FullName,
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
				speciesType.name,
				sampleDisease.idfsReference,
				sampleDisease.name,
				msDisease.idfsReference,
				msDisease.name,
				hdrDisease.idfsReference,
				hdrDisease.name,
				vdrDisease.idfsReference,
				vdrDisease.name
			ORDER BY m.strBarcode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

			FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
		END
		ELSE
		BEGIN
			WITH Favorites
			AS (
				SELECT SampleID = UserPref.value('@SampleID', 'BIGINT')
				FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
				)
			SELECT m.idfMaterial AS SampleID,
				m.strBarcode AS EIDSSLaboratorySampleID,
				CASE 
					WHEN f.SampleID IS NULL
						THEN 0
					ELSE 1
					END AS FavoriteIndicator,
				m.idfRootMaterial AS RootSampleID,
				m.idfParentMaterial AS ParentSampleID,
				parentSample.strBarcode AS ParentEIDSSLaboratorySampleID,
				m.idfsSampleType AS SampleTypeID,
				sampleType.name AS SampleTypeName,
				m.idfHuman AS HumanID,
				m.strCalculatedHumanName AS PatientFarmOwnerName,
				m.idfSpecies AS SpeciesID,
				m.idfAnimal AS AnimalID,
				a.strAnimalCode AS EIDSSAnimalID,
				m.idfVector AS VectorID,
				(
					CASE 
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169001
								)
							THEN m.strCalculatedHumanName
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169002
								)
							THEN speciesType.name
						WHEN (NOT ISNULL(m.idfHumanCase, '') = '')
							THEN m.strCalculatedHumanName
						WHEN (NOT ISNULL(m.idfVetCase, '') = '')
							THEN speciesType.name
						WHEN (NOT ISNULL(m.idfVectorSurveillanceSession, '') = '')
							THEN 'Vector'
						ELSE ''
						END
					) AS PatientSpeciesVectorInformation,
				m.idfMonitoringSession AS MonitoringSessionID,
				m.idfVectorSurveillanceSession AS VectorSessionID,
				m.idfHumanCase AS HumanDiseaseReportID,
				m.idfVetCase AS VeterinaryDiseaseReportID,
				m.strCalculatedCaseID AS EIDSSReportSessionID,
				(
					CASE 
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169001
								)
							THEN 'Human'
						WHEN (
								NOT ISNULL(m.idfMonitoringSession, '') = ''
								AND ms.SessionCategoryID = 10169002
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
						WHERE t2.idfsTestStatus IN (
								10001001,
								10001006
								)
							AND t2.idfMaterial = m.idfMaterial
						) > 0, 1, 0) AS TestCompletedIndicator,
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
						ELSE NULL
						END
					) AS DiseaseID,
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
				m.datFieldCollectionDate AS CollectionDate,
				m.idfFieldCollectedByPerson AS CollectedByPersonID,
				ISNULL(collectedByPerson.strFamilyName, N'') + ISNULL(' ' + collectedByPerson.strFirstName, '') + ISNULL(' ' + collectedByPerson.strSecondName, '') AS CollectedByPersonName,
				m.idfFieldCollectedByOffice AS CollectedByOrganizationID,
				collectedByOrganization.FullName AS CollectedByOrganizationName,
				m.datFieldSentDate AS SentDate,
				m.idfSendToOffice AS SentToOrganizationID,
				sentToOrganization.FullName AS SentToOrganizationName,
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
				accessionConditionType.name AS AccessionConditionTypeName,
				m.datAccession AS AccessionDate,
				m.idfsAccessionCondition AS AccessionConditionTypeID,
				(
					CASE 
						WHEN m.blnAccessioned = 0
							THEN 'Un-accessioned'
						WHEN m.idfsSampleStatus IS NULL
							THEN accessionConditionType.name
						WHEN m.idfsSampleStatus = 10015007
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
				IIF((
						SELECT COUNT(t2.idfTesting)
						FROM dbo.tlbTesting t2
						WHERE t2.idfsTestStatus IN (
								10001003,
								10001004
								)
							AND t2.idfMaterial = m.idfMaterial
						) > 0, 1, 0) AS TestAssignedIndicator,
				(
					SELECT COUNT(NULLIF(t3.idfTesting, 0))
					FROM dbo.tlbTesting t3
					WHERE t3.idfsTestStatus IN (
							10001003,
							10001004
							)
						AND t3.idfMaterial = m.idfMaterial
					) AS TestAssignedCount,
				IIF(COUNT(tom.idfMaterial) > 0, 1, 0) AS TransferCount,
				m.strNote AS Note,
				m.idfsCurrentSite AS CurrentSiteID,
				m.idfsBirdStatus AS BirdStatusTypeID,
				m.idfMainTest AS MainTestID,
				m.idfsSampleKind AS SampleKindTypeID,
				m.PreviousSampleStatusID AS PreviousSampleStatusTypeID,
				m.intRowStatus AS RowStatus,
				'' AS RowAction,
				0 AS RowSelectionIndicator
			FROM dbo.tlbMaterial m
			LEFT JOIN Favorites AS f
				ON m.idfMaterial = f.SampleID
			LEFT JOIN dbo.tlbTesting AS t
				ON t.idfMaterial = m.idfMaterial
			LEFT JOIN dbo.tlbMaterial AS parentSample
				ON parentSample.idfMaterial = m.idfParentMaterial
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
			LEFT JOIN dbo.tlbPerson AS collectedByPerson
				ON collectedByPerson.idfPerson = m.idfFieldCollectedByPerson
			LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS collectedByOrganization
				ON collectedByOrganization.idfOffice = m.idfFieldCollectedByOffice
			LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS sentToOrganization
				ON sentToOrganization.idfOffice = m.idfSendToOffice
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
			LEFT JOIN dbo.tlbFarm AS farm
				ON farm.idfFarm = vc.idfFarm
			LEFT JOIN dbo.tlbHerd AS herd
				ON herd.idfFarm = farm.idfFarm
			LEFT JOIN dbo.tlbSpecies AS species
				ON species.idfHerd = herd.idfHerd
			LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
				ON speciesType.idfsReference = species.idfsSpeciesType
			WHERE (
					(m.idfMaterial = @SampleID)
					OR (@SampleID IS NULL)
					)
				AND (
					(m.idfParentMaterial = @ParentSampleID)
					OR (@ParentSampleID IS NULL)
					)
				AND (m.intRowStatus = 0)
			GROUP BY m.idfMaterial,
				m.idfRootMaterial,
				m.idfParentMaterial,
				f.SampleID,
				m.idfsSampleType,
				sampleType.name,
				parentSample.strBarcode,
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
				collectedByOrganization.FullName,
				m.idfFieldCollectedByPerson,
				collectedByPerson.strFamilyName,
				collectedByPerson.strFirstName,
				collectedByPerson.strSecondName,
				m.datFieldSentDate,
				m.idfSendToOffice,
				sentToOrganization.FullName,
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
				speciesType.name,
				sampleDisease.idfsReference,
				sampleDisease.name,
				msDisease.idfsReference,
				msDisease.name,
				hdrDisease.idfsReference,
				hdrDisease.name,
				vdrDisease.idfsReference,
				vdrDisease.name
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode,
		@returnMsg;
END;
