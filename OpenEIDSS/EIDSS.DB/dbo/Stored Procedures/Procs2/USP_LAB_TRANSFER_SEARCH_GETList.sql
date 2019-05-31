
-- ================================================================================================
-- Name: USP_LAB_TRANSFER_SEARCH_GETList
--
-- Description:	Get laboratory transfer list for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/21/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TRANSFER_SEARCH_GETList] (
	@LanguageID NVARCHAR(50),
	@UserID BIGINT = NULL,
	@OrganizationID BIGINT = NULL, 
	@SearchString NVARCHAR(2000),
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
					WHEN m.idfsSampleStatus = '10015007'
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
				AND tom.intRowStatus = 0
		INNER JOIN dbo.tlbTransferOUT AS tr
			ON tr.idfTransferOut = tom.idfTransferOut
				AND tr.intRowStatus = 0
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN Favorites AS f
			ON m.idfMaterial = f.SampleID
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
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS transferredToOrganization
			ON transferredToOrganization.idfOffice = tr.idfSendToOffice
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS transferredFromOrganization
			ON transferredFromOrganization.idfOffice = tr.idfSendFromOffice
		LEFT JOIN dbo.tlbPerson AS sentByPerson
			ON sentByPerson.idfPerson = tr.idfSendByPerson
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testNameType
			ON testNameType.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResultType
			ON testResultType.idfsReference = t.idfsTestResult
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000110) AS accessionConditionType
			ON accessionConditionType.idfsReference = m.idfsAccessionCondition
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000015) AS sampleStatusType
			ON sampleStatusType.idfsReference = m.idfsSampleStatus
		WHERE (m.intRowStatus = 0)
			AND ((m.idfSendToOffice = @OrganizationID OR tr.idfSendFromOffice = @OrganizationID OR tr.idfSendToOffice = @OrganizationID) OR (@OrganizationID IS NULL))
			AND (m.idfsSampleType <> '10320001')
			AND (m.strBarcode LIKE '%' + @SearchString + '%'
			OR m.strFieldBarcode LIKE '%' + @SearchString + '%'
			OR m.strCalculatedCaseID LIKE '%' + @SearchString + '%'
			OR m.strCalculatedHumanName LIKE '%' + @SearchString + '%'
			OR m.strNote LIKE '%' + @SearchString + '%'
			OR tr.strBarcode LIKE '%' + @SearchString + '%')
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
		ORDER BY tr.strBarcode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;