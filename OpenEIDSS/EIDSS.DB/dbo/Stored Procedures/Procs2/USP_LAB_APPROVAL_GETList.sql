
-- ================================================================================================
-- Name: USP_LAB_APPROVAL_GETList
--
-- Description:	Get laboratory approval list for the various lab use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/03/2018 Initial release.
-- Stephen Long     12/19/2018 Added pagination logic.
-- Stephen Long     01/25/2019 Added previous sample and test status types.
-- Stephen Long     01/30/2019 Added sample disease reference join and removed the vector 
--                             surveillance session joins as they are no longer needed.
-- Stephen Long     02/19/2019 Split out selects between sample and test and added test deletion 
--                             as one of the options.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_APPROVAL_GETList] (
	@LanguageID NVARCHAR(50),
	@SiteID BIGINT = NULL,
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

		SELECT (
				CASE 
					WHEN m.idfsSampleStatus = 10015002
						THEN 'Sample Deletion'
					WHEN m.idfsSampleStatus = 10015003
						THEN 'Sample Destruction'
					END
				) AS ActionRequested,
			m.idfMaterial AS SampleID,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			a.strAnimalCode AS EIDSSAnimalID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
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
			NULL AS TestID,
			NULL AS TestNameTypeID,
			NULL AS TestCategoryTypeID,
			NULL AS TestResultTypeID,
			NULL AS TestStatusTypeID,
			NULL AS TestNameTypeName,
			NULL AS TestStatusTypeName,
			NULL AS TestResultTypeName,
			m.datAccession AS AccessionDate,
			m.idfsAccessionCondition AS SampleStatusTypeID,
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
			NULL AS ResultDate,
			m.PreviousSampleStatusID AS PreviousSampleStatusTypeID,
			NULL AS PreviousTestStatusTypeID,
			m.intRowStatus AS RowStatus,
			'' AS RowAction,
			0 AS RowSelectionIndicator
		FROM dbo.tlbMaterial m
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS sampleDisease
			ON sampleDisease.idfsReference = m.DiseaseID
		LEFT JOIN dbo.tlbHumanCase AS hc
			ON hc.idfHumanCase = m.idfHumanCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS hdrDisease
			ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS vdrDisease
			ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = m.idfMonitoringSession
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS msDisease
			ON msDisease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		WHERE (
				(m.idfsSampleStatus = 10015002) --Marked for deletion 
				OR (m.idfsSampleStatus = 10015003) --Marked for destruction
				) 
			AND (m.idfsCurrentSite = @SiteID)
			AND (m.intRowStatus = 0)
		
		UNION
		
		SELECT (
				CASE 
					WHEN t.idfsTestStatus = 10001004
						THEN 'Validation'
					WHEN t.idfsTestStatus = 10001007
						THEN 'Test Deletion'
					END
				) AS ActionRequested,
			m.idfMaterial AS SampleID,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
			a.strAnimalCode AS EIDSSAnimalID,
			m.strCalculatedHumanName AS PatientFarmOwnerName,
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
			t.idfTesting AS TestID,
			t.idfsTestName AS TestNameTypeID,
			t.idfsTestCategory AS TestCategoryTypeID,
			t.idfsTestResult AS TestResultTypeID,
			t.idfsTestStatus AS TestStatusTypeID,
			testNameType.name AS TestNameTypeName,
			testStatusType.name AS TestStatusTypeName,
			testResultType.name AS TestResultTypeName,
			m.datAccession AS AccessionDate,
			m.idfsAccessionCondition AS SampleStatusTypeID,
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
			t.datConcludedDate AS ResultDate,
			m.PreviousSampleStatusID AS PreviousSampleStatusTypeID,
			t.PreviousTestStatusID AS PreviousTestStatusTypeID,
			m.intRowStatus AS RowStatus,
			'' AS RowAction,
			0 AS RowSelectionIndicator
		FROM dbo.tlbTesting t
		INNER JOIN dbo.tlbMaterial AS m
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS sampleDisease
			ON sampleDisease.idfsReference = m.DiseaseID
		LEFT JOIN dbo.tlbHumanCase AS hc
			ON hc.idfHumanCase = m.idfHumanCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS hdrDisease
			ON hdrDisease.idfsReference = hc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS vdrDisease
			ON vdrDisease.idfsReference = vc.idfsFinalDiagnosis
		LEFT JOIN dbo.tlbMonitoringSession AS ms
			ON ms.idfMonitoringSession = m.idfMonitoringSession
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS msDisease
			ON msDisease.idfsReference = ms.idfsDiagnosis
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
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
		WHERE (
				(t.idfsTestStatus = 10001004) --Preliminary 
				OR (t.idfsTestStatus = 10001007) --Marked for deletion 
				) 
			AND (m.idfsCurrentSite = @SiteID)
			AND (m.intRowStatus = 0)
			AND (t.intRowStatus = 0)
		GROUP BY m.idfMaterial,
			t.idfTesting,
			m.idfsSampleStatus,
			t.idfsTestName,
			t.idfsTestCategory,
			t.idfsTestResult,
			t.idfsTestStatus,
			t.datConcludedDate,
			m.intRowStatus,
			m.PreviousSampleStatusID,
			t.PreviousTestStatusID,
			sampleType.name,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			m.strBarcode,
			a.strAnimalCode, 
			testNameType.name,
			testStatusType.name,
			testResultType.name,
			m.datAccession,
			m.blnAccessioned,
			m.idfsAccessionCondition,
			accessionConditionType.name,
			m.idfsSampleStatus,
			sampleStatusType.name,
			m.strCondition,
			m.idfMonitoringSession,
			ms.idfMonitoringSession,
			ms.SessionCategoryID,
			m.idfHumanCase,
			m.idfVectorSurveillanceSession,
			m.idfVetCase,
			m.DiseaseID,
			sampleDisease.idfsReference,
			sampleDisease.name,
			msDisease.idfsReference,
			msDisease.name,
			hdrDisease.idfsReference,
			hdrDisease.name,
			vdrDisease.idfsReference,
			vdrDisease.name
		ORDER BY m.strCalculatedCaseID OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;