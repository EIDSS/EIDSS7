
-- ================================================================================================
-- Name: USP_LAB_TEST_SEARCH_GETCount
--
-- Description:	Get laboratory tests count for the various lab use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/21/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TEST_SEARCH_GETCount] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL,
	@SearchString NVARCHAR(2000) = NULL
	)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbTransferOutMaterial AS tom
			ON tom.idfMaterial = m.idfMaterial
		LEFT JOIN dbo.tlbTransferOUT AS tro
			ON tro.idfTransferOut = tom.idfTransferOut
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
		LEFT JOIN dbo.tlbDepartment AS d
			ON d.idfDepartment = m.idfInDepartment
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000164) AS functionalArea
			ON functionalArea.idfsReference = d.idfsDepartmentName
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
		LEFT JOIN dbo.tlbOffice AS testedByOffice
			ON testedByOffice.idfOffice = t.idfTestedByOffice
		LEFT JOIN dbo.tstSite AS testedByOfficeSite
			ON testedByOfficeSite.idfsSite = testedByOffice.idfsSite
		LEFT JOIN dbo.tlbOffice AS resultEnteredByOffice
			ON resultEnteredByOffice.idfOffice = t.idfResultEnteredByOffice
		LEFT JOIN dbo.tstSite AS resultEnteredByOfficeSite
			ON resultEnteredByOfficeSite.idfsSite = resultEnteredByOffice.idfsSite
		LEFT JOIN dbo.tlbPerson AS testedByPerson
			ON testedByPerson.idfPerson = t.idfTestedByPerson
		LEFT JOIN dbo.tlbPerson AS resultEnteredByPerson
			ON resultEnteredByPerson.idfPerson = t.idfResultEnteredByPerson
		LEFT JOIN dbo.tstUserTable AS u
			ON u.idfPerson = t.idfResultEnteredByPerson
		LEFT JOIN dbo.tstSite AS targetSite
			ON targetSite.idfsSite = u.idfsSite
		LEFT JOIN dbo.tlbPerson AS validatedByPerson
			ON validatedByPerson.idfPerson = t.idfValidatedByPerson
		LEFT JOIN dbo.tlbOffice AS performedByOffice
			ON performedByOffice.idfOffice = t.idfPerformedByOffice
		LEFT JOIN dbo.tstSite AS performedByOfficeSite
			ON performedByOfficeSite.idfsSite = performedByOffice.idfsSite
		WHERE (t.intRowStatus = 0)
			AND (m.idfsSampleType <> 10320001)
			AND (m.intRowStatus = 0)
			AND (
				(
					m.idfSendToOffice = @OrganizationID
					OR tro.idfSendFromOffice = @OrganizationID
					OR tro.idfSendToOffice = @OrganizationID
					)
				OR (@OrganizationID IS NULL)
				)
			AND (
				m.strBarcode LIKE '%' + @SearchString + '%'
				OR m.strFieldBarcode LIKE '%' + @SearchString + '%'
				OR m.strCalculatedCaseID LIKE '%' + @SearchString + '%'
				OR m.strCalculatedHumanName LIKE '%' + @SearchString + '%'
				OR m.strNote LIKE '%' + @SearchString + '%'
				OR tro.strBarcode LIKE '%' + @SearchString + '%'
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode,
		@returnMsg;
END;
