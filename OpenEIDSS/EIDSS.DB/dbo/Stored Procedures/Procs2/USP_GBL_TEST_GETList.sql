-- ================================================================================================
-- Name: USP_GBL_TEST_GETList
--
-- Description:	Get testing list for the disease reports, sessions and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- Stephen Long     04/18/2019 Updated for the API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_TEST_GETList] (
	@LanguageID NVARCHAR(50),
	@HumanDiseaseReportID BIGINT = NULL,
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@VectorSessionID BIGINT = NULL,
	@SampleID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT t.idfTesting AS TestID,
			t.idfsTestName AS TestNameTypeID,
			testName.name AS TestNameTypeName,
			t.idfsTestCategory AS TestCategoryTypeID,
			testCategory.name AS TestCategoryTypeName,
			t.idfsTestResult AS TestResultTypeID,
			testResult.name AS TestResultTypeName,
			t.idfsTestStatus AS TestStatusTypeID,
			testStatus.name AS TestStatusTypeName,
			t.idfsDiagnosis AS DiseaseID,
			diagnosis.Name AS DiseaseName,
			t.idfMaterial AS SampleID,
			m.strFieldBarCode AS EIDSSLocalOrFieldSampleID,
			m.strBarCode AS EIDSSLaboratorySampleID,
			sampleType.name AS SampleTypeName,
			s.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			a.idfAnimal AS AnimalID,
			a.strAnimalCode AS EIDSSAnimalID,
			t.idfBatchTest AS BatchTestID,
			t.idfObservation AS ObservationID, 
			t.intTestNumber AS TestNumber,
			t.strNote AS Comments,
			t.datStartedDate AS StartedDate,
			t.datConcludedDate AS ResultDate,
			t.idfTestedByOffice AS TestedByOrganizationID,
			testedByOfficeSite.strSiteName AS TestedByOrganizationName,
			t.idfTestedByPerson AS TestedByPersonID,
			ISNULL(testedByPerson.strFamilyName, N'') + ISNULL(' ' + testedByPerson.strFirstName, '') + ISNULL(' ' + testedByPerson.strSecondName, '') AS TestedByPersonName,
			t.idfResultEnteredByOffice AS ResultEnteredByOrganizationID,
			resultEnteredByOfficeSite.strSiteName AS ResultEnteredByOrganizationName,
			t.idfResultEnteredByPerson AS ResultEnteredByPersonID,
			ISNULL(resultEnteredByPerson.strFamilyName, N'') + ISNULL(' ' + resultEnteredByPerson.strFirstName, '') + ISNULL(' ' + resultEnteredByPerson.strSecondName, '') AS ResultEnteredByPersonName,
			t.idfValidatedByOffice AS ValidatedByOrganizationID,
			validatedByOfficeSite.strSiteName AS ValidatedByOrganizationName,
			t.idfValidatedByPerson AS ValidatedByPersonID,
			ISNULL(validatedByPerson.strFamilyName, N'') + ISNULL(' ' + validatedByPerson.strFirstName, '') + ISNULL(' ' + validatedByPerson.strSecondName, '') AS ValidatedByPersonName,
			t.blnReadOnly AS ReadOnlyIndicator,
			t.blnNonLaboratoryTest AS NonLaboratoryTestIndicator,
			t.blnExternalTest AS ExternalTestIndicator,
			t.idfPerformedByOffice AS PerformedByOrganizationID,
			performedByOfficeSite.strSiteName AS PerformedByOrganizationName,
			t.datReceivedDate AS ReceivedDate,
			t.strContactPerson AS ContactPersonName,
			f.idfFarm AS FarmID,
			f.strFarmCode AS EIDSSFarmID,
			t.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbTesting t
		LEFT JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = t.idfMaterial
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = m.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN dbo.tlbHerd AS h
			ON h.idfHerd = s.idfHerd
				AND h.intRowStatus = 0
		LEFT JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
				AND f.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
				AND a.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000087) AS sampleType
			ON sampleType.idfsReference = m.idfsSampleType
		LEFT JOIN dbo.tlbOffice AS testedByOffice
			ON testedByOffice.idfOffice = t.idfTestedByOffice
				AND testedByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS testedByOfficeSite
			ON testedByOfficeSite.idfsSite = testedByOffice.idfsSite
				AND testedByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS resultEnteredByOffice
			ON resultEnteredByOffice.idfOffice = t.idfResultEnteredByOffice
				AND resultEnteredByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS resultEnteredByOfficeSite
			ON resultEnteredByOfficeSite.idfsSite = resultEnteredByOffice.idfsSite
				AND resultEnteredByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS validatedByOffice
			ON validatedByOffice.idfOffice = t.idfValidatedByOffice
				AND validatedByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS validatedByOfficeSite
			ON validatedByOfficeSite.idfsSite = validatedByOffice.idfsSite
				AND validatedByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS performedByOffice
			ON performedByOffice.idfOffice = t.idfPerformedByOffice
				AND performedByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS performedByOfficeSite
			ON performedByOfficeSite.idfsSite = performedByOffice.idfsSite
				AND performedByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS testedByPerson
			ON testedByPerson.idfPerson = t.idfTestedByPerson
				AND testedByPerson.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS resultEnteredByPerson
			ON resultEnteredByPerson.idfPerson = t.idfResultEnteredByPerson
				AND resultEnteredByPerson.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS validatedByPerson
			ON validatedByPerson.idfPerson = t.idfValidatedByPerson
				AND validatedByPerson.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testName
			ON testName.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000095) AS testCategory
			ON testCategory.idfsReference = t.idfsTestCategory
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResult
			ON testResult.idfsReference = t.idfsTestResult
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000001) AS testStatus
			ON testStatus.idfsReference = t.idfsTestStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS diagnosis
			ON diagnosis.idfsReference = t.idfsDiagnosis
		WHERE (
				(m.idfHumanCase = @HumanDiseaseReportID)
				OR (@HumanDiseaseReportID IS NULL)
				)
			AND (
				(m.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND (
				(m.idfMonitoringSession = @MonitoringSessionID)
				OR (@MonitoringSessionID IS NULL)
				)
			AND (
				(m.idfVectorSurveillanceSession = @VectorSessionID)
				OR (@VectorSessionID IS NULL)
				)
			AND (
				(t.idfMaterial = @SampleID)
				OR (@SampleID IS NULL)
				)
			AND t.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
