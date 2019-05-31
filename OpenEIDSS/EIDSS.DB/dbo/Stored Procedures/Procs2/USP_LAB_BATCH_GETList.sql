
-- ================================================================================================
-- Name: USP_LAB_BATCH_GETList
--
-- Description:	Get laboratory batch list for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/10/2018 Initial release.
-- Stephen Long     12/19/2018 Added pagination logic.
-- Stephen Long     01/25/2019 Changed where clause to look at batch test row status instead of 
--                             test.
-- Stephen Long     02/01/2019 Added sample disease reference join and removed the vector 
--                             surveillance session joins as they are no longer needed.
-- Stephen Long     02/19/2019 Removed positive and negative control and reagent lot numbers.
--                             Added organization ID parameter.
-- Stephen Long     03/25/2019 Added the overall batch test test name type ID and name.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_BATCH_GETList] (
	@LanguageID NVARCHAR(50),
	@UserID BIGINT = NULL,
	@OrganizationID BIGINT = NULL, 
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

		WITH Favorites
		AS (
			SELECT SampleID = UserPref.value('@SampleID', 'BIGINT')
			FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
			)
		SELECT b.idfBatchTest AS BatchTestID,
			CASE 
				WHEN f.SampleID IS NULL
					THEN 0
				ELSE 1
				END AS FavoriteIndicator,
			b.strBarcode AS EIDSSBatchTestID,
			b.idfsBatchStatus AS BatchStatusTypeID,
			batchStatusType.name AS BatchStatusTypeName,
			b.idfPerformedByOffice AS BatchTestPerformedByOrganizationID, 
			b.idfPerformedByPerson AS BatchTestPerformedByPersonID, 
			b.idfsTestName AS BatchTestTestNameTypeID, 
			batchTestTestNameType.name AS BatchTestTestNameTypeName, 
			t.idfTesting AS TestID,
			t.idfsTestName AS TestNameTypeID,
			t.idfsTestCategory AS TestCategoryTypeID,
			t.idfsTestResult AS TestResultTypeID,
			t.idfsTestStatus AS TestStatusTypeID,
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
			m.idfMaterial AS SampleID,
			t.intTestNumber AS TestNumber,
			t.strNote AS Note,
			t.datStartedDate AS StartedDate,
			t.datConcludedDate AS ResultDate,
			t.idfTestedByOffice AS TestedByOrganizationID,
			t.idfTestedByPerson AS TestedByPersonID,
			t.idfResultEnteredByOffice AS ResultEnteredByOrganizationID,
			t.idfResultEnteredByPerson AS ResultEnteredByPersonID,
			t.idfValidatedByOffice AS ValidatedByOrganizationID,
			t.idfValidatedByPerson AS ValidatedByPersonID,
			t.blnReadOnly AS ReadOnlyIndicator,
			t.blnNonLaboratoryTest AS NonLaboratoryTestIndicator,
			t.blnExternalTest AS ExternalTestIndicator,
			t.idfPerformedByOffice AS PerformedByOrganizationID,
			t.datReceivedDate AS ReceivedDate,
			t.strContactPerson AS ContactPersonName,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
			sampleType.name AS SampleTypeName,
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
			m.strBarcode AS EIDSSLaboratorySampleID,
			testNameType.name AS TestNameTypeName,
			testStatusType.name AS TestStatusTypeName,
			testResultType.name AS TestResultTypeName,
			testCategoryType.name AS TestCategoryTypeName,
			m.datAccession AS AccessionDate,
			functionalArea.name AS FunctionalAreaName,
			m.idfsAccessionCondition AS SampleStatusTypeID,
			(CASE WHEN m.blnAccessioned = 0 THEN 'Un-accessioned' WHEN m.idfsSampleStatus IS NULL THEN accessionConditionType.name WHEN m.idfsSampleStatus = 10015007 THEN accessionConditionType.name ELSE sampleStatusType.name END) AS AccessionConditionOrSampleStatusTypeName, 
			m.strCondition AS AccessionComment,
			a.strAnimalCode AS EIDSSAnimalID,
			b.TestRequested,
			b.idfObservation AS ObservationID,
			b.idfPerformedByPerson AS PerformedByPersonID,
			b.datPerformedDate AS PerformedDate,
			b.datValidatedDate AS ValidationDate,
			b.idfsSite AS SiteID,
			t.intRowStatus AS RowStatus,
			'' AS RowAction,
			0 AS RowSelectionIndicator
		FROM dbo.tlbBatchTest b
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfBatchTest = b.idfBatchTest
		LEFT JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = t.idfMaterial
		LEFT JOIN Favorites AS f
			ON m.idfMaterial = f.SampleID
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
			ON msDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS batchTestTestNameType
			ON batchTestTestNameType.idfsReference = b.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testNameType
			ON testNameType.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000001) AS testStatusType
			ON testStatusType.idfsReference = t.idfsTestStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResultType
			ON testResultType.idfsReference = t.idfsTestResult
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000095) AS testCategoryType
			ON testCategoryType.idfsReference = t.idfsTestCategory
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000001) AS batchStatusType
			ON batchStatusType.idfsReference = b.idfsBatchStatus
		WHERE ((b.idfPerformedByOffice = @OrganizationID) OR (@OrganizationID IS NULL))
			AND (b.intRowStatus = 0)
		GROUP BY b.idfBatchTest,
			b.strBarcode,
			b.idfsBatchStatus,
			batchStatusType.name, 
			b.idfPerformedByOffice, 
			b.idfPerformedByPerson, 
			b.idfsTestName,
			batchTestTestNameType.name, 
			m.idfMaterial,
			t.idfTesting,
			t.idfsTestName,
			t.idfsTestCategory,
			t.idfsTestResult,
			t.idfsTestStatus,
			t.idfBatchTest,
			t.intTestNumber,
			t.strNote,
			t.datStartedDate,
			t.datConcludedDate,
			t.idfTestedByOffice,
			t.idfTestedByPerson,
			t.idfResultEnteredByOffice,
			t.idfResultEnteredByPerson,
			t.idfValidatedByOffice,
			t.idfValidatedByPerson,
			t.blnReadOnly,
			t.blnNonLaboratoryTest,
			t.blnExternalTest,
			t.idfPerformedByOffice,
			t.datReceivedDate,
			t.strContactPerson,
			t.intRowStatus,
			f.SampleID,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			sampleType.name,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			m.strBarcode,
			testNameType.name,
			t.idfsTestStatus,
			testStatusType.name,
			t.datStartedDate,
			t.idfsTestResult,
			testResultType.name,
			t.datConcludedDate,
			t.idfsTestCategory,
			testCategoryType.name,
			m.datAccession,
			functionalArea.name,
			m.idfsAccessionCondition,
			accessionConditionType.name,
			m.idfsSampleStatus, 
			sampleStatusType.name, 
			m.strCondition,
			a.strAnimalCode,
			m.blnAccessioned,
			m.idfMonitoringSession,
			ms.idfMonitoringSession,
			ms.SessionCategoryID,
			m.idfHumanCase,
			m.idfVectorSurveillanceSession,
			m.idfVetCase,
			m.DiseaseID, 
			b.TestRequested,
			b.idfObservation,
			b.idfPerformedByPerson,
			b.datPerformedDate,
			b.datValidatedDate,
			b.idfsSite,
			sampleDisease.idfsReference, 
			sampleDisease.name, 
			msDisease.idfsReference, 
			msDisease.name, 
			hdrDisease.idfsReference,
			hdrDisease.name,
			vdrDisease.idfsReference,
			vdrDisease.name
		ORDER BY b.strBarcode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;