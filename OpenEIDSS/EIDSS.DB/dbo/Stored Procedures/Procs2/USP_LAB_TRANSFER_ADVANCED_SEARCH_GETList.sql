

-- ================================================================================================
-- Name: USP_LAB_TRANSFER_ADVANCED_SEARCH_GETList
--
-- Description:	Get transferred advanced search list for the laboratory module use case LUC13.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/18/2019 Initial relase.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TRANSFER_ADVANCED_SEARCH_GETList] (
	@LanguageID NVARCHAR(50),
	@UserID BIGINT,
	@SiteID BIGINT,
	@ReportSessionType NVARCHAR(50) = NULL,
	@SurveillanceTypeID BIGINT = NULL,
	@SampleStatusTypeID NVARCHAR(MAX) = NULL,
	@AccessionedIndicator INT = NULL,
	@EIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@ExactMatchEIDSSLocalFieldSampleID NVARCHAR(200) = NULL,
	@EIDSSReportCampaignSessionID NVARCHAR(200) = NULL,
	@OrganizationSentToID BIGINT = NULL,
	@OrganizationTransferredToID BIGINT = NULL,
	@EIDSSTransferID NVARCHAR(200) = NULL,
	@ResultsReceivedFromID BIGINT = NULL,
	@AccessionDateFrom DATETIME = NULL,
	@AccessionDateTo DATETIME = NULL,
	@EIDSSLaboratorySampleID NVARCHAR(200) = NULL,
	@SampleTypeID BIGINT = NULL,
	@TestNameTypeID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@TestStatusTypeID BIGINT = NULL,
	@TestResultTypeID BIGINT = NULL,
	@TestResultDateFrom DATETIME = NULL,
	@TestResultDateTo DATETIME = NULL,
	@PatientName NVARCHAR(200) = NULL,
	@FarmOwnerName NVARCHAR(200) = NULL,
	@SpeciesTypeID BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

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

		DECLARE @CampaignID AS NVARCHAR(200);

		SET @CampaignID = NULL;

		--Campaign ID entered
		IF NOT @EIDSSReportCampaignSessionID IS NULL
			AND @EIDSSReportCampaignSessionID <> ''
		BEGIN
			IF (
					LEFT(@EIDSSReportCampaignSessionID, 1) = 'D'
					OR LEFT(@EIDSSReportCampaignSessionID, 3) = 'HSC'
					)
			BEGIN
				SET @CampaignID = @EIDSSReportCampaignSessionID;
				SET @EIDSSReportCampaignSessionID = NULL;
			END;
		END;

		WITH Favorites
		AS (
			SELECT SampleID = UserPref.value('@SampleID', 'BIGINT')
			FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
			)
		SELECT tr.idfTransferOut AS TransferID,
			tr.strBarcode AS EIDSSTransferID,
			m.idfMaterial AS TransferredOutSampleID,
			transferredInSample.idfMaterial AS TransferredInSampleID, 
			CASE 
				WHEN f.SampleID IS NULL
					THEN 0
				ELSE 1
				END AS FavoriteIndicator,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
			m.strBarcode AS EIDSSLaboratorySampleID,
			tr.idfSendToOffice AS TransferredToOrganizationID, 
			transferredToOrganization.[FullName] AS TransferredToOrganizationName,
			tr.idfSendFromOffice AS TransferredFromOrganizationID,
			transferredFromOrganization.[FullName] AS TransferredFromOrganizationName,
			tr.datSendDate AS TransferDate,
			tr.TestRequested,
			t.idfTesting AS TestID, 
			testNameType.name AS TestNameTypeName,
			t.idfsTestResult AS TestResultTypeID,
			testResultType.name AS TestResultTypeName,
			t.datConcludedDate AS ResultDate,
			t.strContactPerson AS ContactPersonName,
			m.strFieldBarcode AS EIDSSLocalFieldSampleID,
			sampleType.name AS SampleTypeName,
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
			m.datAccession AS AccessionDate,
			m.idfInDepartment AS FunctionalAreaID,
			functionalArea.name AS FunctionalAreaName,
			m.idfsAccessionCondition AS AccessionConditionTypeID, 
			m.idfsSampleStatus AS SampleStatusTypeID,
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
			m.strCondition AS AccessionComment,
			tr.strNote AS PurposeOfTransfer,
			tr.idfsSite AS SiteID,
			tr.idfSendByPerson AS SentByPersonID,
			ISNULL(sentByPerson.strFamilyName, N'') + ISNULL(' ' + sentByPerson.strFirstName, '') + ISNULL(' ' + sentByPerson.strSecondName, '') AS SentByPersonName,
			tr.idfsTransferStatus AS TransferStatusTypeID,
			tr.intRowStatus AS RowStatus,
			a.strAnimalCode AS EIDSSAnimalID,
			IIF((
					SELECT COUNT(t2.idfTesting)
					FROM dbo.tlbTesting t2
					WHERE t2.idfsTestStatus IN (10001003, 10001004, 10001005)
						AND t2.idfMaterial = m.idfMaterial
					) > 0, 1, 0) AS TestAssignedIndicator,
			(CASE WHEN transferredToOrganization.idfsSite IS NULL THEN 1 ELSE 0 END) AS NonEIDSSLaboratoryIndicator, 
			'' AS RowAction,
			0 AS RowSelectionIndicator
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbTransferOutMaterial AS tom
			ON tom.idfMaterial = m.idfMaterial
		INNER JOIN dbo.tlbTransferOUT AS tr
			ON tr.idfTransferOut = tom.idfTransferOut
		LEFT JOIN Favorites AS f
			ON m.idfMaterial = f.SampleID
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbMaterial AS transferredInSample 
			ON transferredInSample.idfMaterial = tom.idfMaterial 
			AND transferredInSample.intRowStatus = 0
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
		LEFT JOIN dbo.tlbFreezerSubdivision AS fs
			ON fs.idfSubdivision = m.idfSubdivision
		LEFT JOIN dbo.tlbPerson AS fieldCollectedByPerson
			ON fieldCollectedByPerson.idfPerson = m.idfFieldCollectedByPerson
		LEFT JOIN dbo.tlbOffice AS collectedByOffice
			ON collectedByOffice.idfOffice = m.idfFieldCollectedByOffice
		LEFT JOIN dbo.tstSite AS collectedByOfficeSite
			ON collectedByOfficeSite.idfsSite = collectedByOffice.idfsSite
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS transferredToOrganization
			ON transferredToOrganization.idfOffice = tr.idfSendToOffice
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS transferredFromOrganization
			ON transferredFromOrganization.idfOffice = tr.idfSendFromOffice
		LEFT JOIN dbo.tlbPerson AS sentByPerson
			ON sentByPerson.idfPerson = tr.idfSendByPerson
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
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testNameType
			ON testNameType.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResultType
			ON testResultType.idfsReference = t.idfsTestResult
		LEFT JOIN dbo.tlbFarm AS farm
			ON farm.idfFarm = vc.idfFarm
		LEFT JOIN dbo.tlbHerd AS herd
			ON herd.idfFarm = farm.idfFarm
		LEFT JOIN dbo.tlbSpecies AS species
			ON species.idfHerd = herd.idfHerd
		WHERE (
				(m.idfsSite = @SiteID)
				OR (@SiteID IS NULL)
				)
			AND (m.idfsSampleType <> 10320001)
			AND (
				(
					@ReportSessionType = 10012001
					AND m.idfHuman IS NOT NULL
					)
				OR (
					@ReportSessionType = 10012006
					AND m.idfVectorSurveillanceSession IS NOT NULL
					)
				OR (
					@ReportSessionType = 10012005
					AND m.idfVetCase IS NOT NULL
					)
				OR (@ReportSessionType IS NULL)
				)
			AND (
				(
					(@SurveillanceTypeID = 4578940000001)
					AND (
						m.idfMonitoringSession IS NOT NULL
						OR m.idfVectorSurveillanceSession IS NOT NULL
						)
					)
				OR (
					(@SurveillanceTypeID = 50815490000000)
					AND (
						m.idfHumanCase IS NOT NULL
						OR m.idfVetCase IS NOT NULL
						OR m.idfMonitoringSession IS NOT NULL
						OR m.idfVectorSurveillanceSession IS NOT NULL
						)
					)
				OR (
					(@SurveillanceTypeID = 4578940000002)
					AND (
						m.idfHumanCase IS NOT NULL
						OR m.idfVetCase IS NOT NULL
						)
					)
				OR (@SurveillanceTypeID IS NULL)
				)
			AND (
				(m.blnAccessioned = @AccessionedIndicator)
				OR (@AccessionedIndicator IS NULL)
				)
			AND (
				(m.idfsSampleStatus IN (@SampleStatusTypeID))
				OR (@SampleStatusTypeID IS NULL)
				)
			AND (
				(m.idfSendToOffice = @OrganizationSentToID)
				OR (@OrganizationSentToID IS NULL)
				)
			AND (
				(tr.idfSendToOffice = @OrganizationTransferredToID)
				OR (@OrganizationTransferredToID IS NULL)
				)
			AND (
				(t.idfTestedByOffice = @ResultsReceivedFromID)
				OR (@ResultsReceivedFromID IS NULL)
				)
			AND (
				(
					m.datAccession BETWEEN @AccessionDateFrom
						AND @AccessionDateTo
					)
				OR (
					@AccessionDateFrom IS NULL
					OR @AccessionDateTo IS NULL
					)
				)
			AND (
				(m.idfsSampleType = @SampleTypeID)
				OR (@SampleTypeID IS NULL)
				)
			AND (
				(t.idfsTestName = @TestNameTypeID)
				OR (@TestNameTypeID IS NULL)
				)
			AND (
				(hc.idfsFinalDiagnosis = @DiseaseID)
				OR (vc.idfsFinalDiagnosis = @DiseaseID)
				OR (m.DiseaseID = @DiseaseID)
				OR (ms.idfsDiagnosis = @DiseaseID)
				OR (@DiseaseID IS NULL)
				)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (
				(t.idfsTestResult = @TestResultTypeID)
				OR (@TestResultTypeID IS NULL)
				)
			AND (
				(species.idfsSpeciesType = @SpeciesTypeID)
				OR (@SpeciesTypeID IS NULL)
				)
			AND (
				(m.strFieldBarcode = @ExactMatchEIDSSLocalFieldSampleID)
				OR (@ExactMatchEIDSSLocalFieldSampleID IS NULL)
				)
			AND (
				(
					t.datConcludedDate BETWEEN @TestResultDateFrom
						AND @TestResultDateTo
					)
				OR (
					@TestResultDateFrom IS NULL
					OR @TestResultDateTo IS NULL
					)
				)
			AND (
				(m.strCalculatedCaseID LIKE '%' + @EIDSSReportCampaignSessionID + '%')
				OR (@EIDSSReportCampaignSessionID IS NULL)
				)
			AND (
				(m.strCalculatedHumanName LIKE '%' + @PatientName + '%')
				OR (@PatientName IS NULL)
				)
			AND (
				(m.strCalculatedHumanName LIKE '%' + @FarmOwnerName + '%')
				OR (@FarmOwnerName IS NULL)
				)
			AND (
				(c.strCampaignID LIKE '%' + @CampaignID + '%')
				OR (@CampaignID IS NULL)
				)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (m.intRowStatus = 0)
			AND (
				(m.strFieldBarcode LIKE '%' + @EIDSSLocalFieldSampleID + '%')
				OR (
					@EIDSSLocalFieldSampleID IS NULL
					OR @EIDSSLocalFieldSampleID = ''
					)
				)
			AND (
				(tr.strBarcode LIKE '%' + @EIDSSTransferID + '%')
				OR (
					@EIDSSTransferID IS NULL
					OR @EIDSSTransferID = ''
					)
				)
			AND (
				(m.strBarcode LIKE '%' + @EIDSSLaboratorySampleID + '%')
				OR (
					@EIDSSLaboratorySampleID IS NULL
					OR @EIDSSLaboratorySampleID = ''
					)
				)
		GROUP BY tr.idfTransferOut,
			tr.strBarcode,
			m.idfMaterial,
			transferredInSample.idfMaterial,
			f.SampleID,
			t.idfTesting, 
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			sampleType.name,
			m.strBarcode,
			transferredToOrganization.[FullName],
			transferredToOrganization.idfsSite,
			transferredFromOrganization.[FullName], 
			tr.datSendDate,
			testNameType.name,
			t.idfsTestResult,
			testResultType.name,
			t.datConcludedDate,
			t.strContactPerson,
			m.blnAccessioned,
			m.datAccession,
			m.idfInDepartment,
			functionalArea.name,
			m.idfsAccessionCondition,
			accessionConditionType.name,
			m.idfsSampleStatus,
			sampleStatusType.name,
			m.strFieldBarcode,
			m.strCondition,
			a.strAnimalCode,
			m.idfMonitoringSession,
			ms.idfMonitoringSession,
			ms.SessionCategoryID,
			m.idfHumanCase,
			m.idfVectorSurveillanceSession,
			m.idfVetCase,
			m.DiseaseID,
			tr.TestRequested,
			tr.strNote,
			tr.idfsSite,
			tr.idfSendByPerson,
			tr.datSendDate,
			tr.idfSendFromOffice,
			tr.idfSendToOffice,
			sentByPerson.strFamilyName,
			sentByPerson.strFirstName,
			sentByPerson.strSecondName,
			tr.idfsTransferStatus,
			tr.TestRequested, 
			tr.intRowStatus,
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
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;