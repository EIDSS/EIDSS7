

-- ================================================================================================
-- Name: USP_LAB_FAVORITE_SEARCH_GETList
--
-- Description:	Get laboratory favorites list for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/21/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_FAVORITE_SEARCH_GETList] (
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

		SELECT m.idfMaterial AS SampleID,
			t.idfTesting AS TestID,
			m.strCalculatedCaseID AS EIDSSReportSessionID,
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
			m.idfRootMaterial AS RootSampleID,
			m.idfParentMaterial AS ParentSampleID,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.strFieldBarcode AS EIDSSLocalFieldSampleID,
			testNameType.name AS TestNameTypeName,
			t.idfsTestStatus AS TestStatusTypeID,
			testStatusType.name AS TestStatusTypeName,
			t.datStartedDate AS StartedDate,
			t.idfsTestResult AS TestResultTypeID,
			testResultType.name AS TestResultTypeName,
			t.datConcludedDate AS ResultDate,
			t.idfsTestCategory AS TestCategoryTypeID,
			testCategoryType.name AS TestCategoryTypeName,
			m.blnAccessioned AS AccessionedIndicator,
			m.datAccession AS AccessionDate,
			m.idfInDepartment AS FunctionalAreaID,
			functionalArea.name AS FunctionalAreaName,
			m.idfsAccessionCondition AS AccessionConditionTypeID,
			m.idfsSampleStatus AS SampleStatusTypeID, 
			(CASE WHEN m.blnAccessioned = 0 THEN 'Un-accessioned' WHEN m.idfsSampleStatus IS NULL THEN accessionConditionType.name WHEN m.idfsSampleStatus = 10015007 THEN accessionConditionType.name ELSE sampleStatusType.name END) AS AccessionConditionOrSampleStatusTypeName, 
			m.strCondition AS AccessionComment,
			a.strAnimalCode AS EIDSSAnimalID,
			'' AS RowAction,
			0 AS RowSelectionIndicator
		FROM dbo.tlbMaterial m
		INNER JOIN (
			SELECT SampleID = UserPref.value('@SampleID', 'bigint')
			FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
			) AS f
			ON m.idfMaterial = f.SampleID
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
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000157) AS destructionMethodType
			ON destructionMethodType.idfsReference = m.idfsDestructionMethod
		LEFT JOIN dbo.tlbFarm AS farm
			ON farm.idfFarm = vc.idfFarm
		LEFT JOIN dbo.tlbHerd AS herd
			ON herd.idfFarm = farm.idfFarm
		LEFT JOIN dbo.tlbSpecies AS species
			ON species.idfHerd = herd.idfHerd
		WHERE (m.intRowStatus = 0)
			AND ((m.idfSendToOffice = @OrganizationID OR tro.idfSendFromOffice = @OrganizationID OR tro.idfSendToOffice = @OrganizationID) OR (@OrganizationID IS NULL))
			AND (m.idfsSampleType <> 10320001)
			AND (m.strBarcode LIKE '%' + @SearchString + '%'
			OR m.strFieldBarcode LIKE '%' + @SearchString + '%'
			OR m.strCalculatedCaseID LIKE '%' + @SearchString + '%'
			OR m.strCalculatedHumanName LIKE '%' + @SearchString + '%'
			OR m.strNote LIKE '%' + @SearchString + '%'
			OR tro.strBarcode LIKE '%' + @SearchString + '%')
		GROUP BY m.idfMaterial,
			t.idfTesting,
			m.idfRootMaterial,
			m.idfParentMaterial,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			sampleType.name,
			m.strCalculatedCaseID,
			m.strCalculatedHumanName,
			m.strBarcode,
			m.strFieldBarcode,
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
			m.idfInDepartment,
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