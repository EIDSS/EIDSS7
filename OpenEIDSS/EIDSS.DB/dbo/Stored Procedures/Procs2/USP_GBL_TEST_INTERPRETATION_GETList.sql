-- ================================================================================================
-- Name: USP_GBL_TEST_INTERPRETATION_GETList
--
-- Description:	Get test interpretation list for the disease reports and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- Stephen Long     04/18/2019 Updated for the API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_TEST_INTERPRETATION_GETList] (
	@LanguageID NVARCHAR(50),
	@HumanDiseaseReportID BIGINT = NULL,
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@VectorSessionID BIGINT = NULL,
	@TestID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT tv.idfTestValidation AS TestInterpretationID,
			tv.idfsDiagnosis AS DiseaseID,
			diagnosis.Name AS DiseaseName,
			tv.idfsInterpretedStatus AS InterpretedStatusTypeID,
			interpretedStatus.name AS InterpretedStatusTypeName,
			tv.idfValidatedByOffice AS ValidatedByOrganizationID,
			validatedByOfficeSite.strSiteName AS ValidatedByOrganizationName,
			tv.idfValidatedByPerson AS ValidatedByPersonID,
			ISNULL(validatedByPerson.strFamilyName, N'') + ISNULL(' ' + validatedByPerson.strFirstName, '') + ISNULL(' ' + validatedByPerson.strSecondName, '') AS ValidatedByPersonName,
			tv.idfInterpretedByOffice AS InterpretedByOrganizationID,
			interpretedByOfficeSite.strSiteName AS InterpretedByOrganizationName,
			tv.idfInterpretedByPerson AS InterpretedByPersonID,
			ISNULL(interpretedByPerson.strFamilyName, N'') + ISNULL(' ' + interpretedByPerson.strFirstName, '') + ISNULL(' ' + interpretedByPerson.strSecondName, '') AS InterpretedByPersonName,
			tv.idfTesting AS TestID,
			tv.blnValidateStatus AS ValidatedStatusIndicator,
			tv.blnCaseCreated AS ReportSessionCreatedIndicator,
			tv.strValidateComment AS ValidatedComment,
			tv.strInterpretedComment AS InterpretedComment,
			tv.datValidationDate AS ValidatedDate,
			tv.datInterpretationDate AS InterpretedDate,
			tv.blnReadOnly AS ReadOnlyIndicator,
			t.idfMaterial AS SampleID,
			m.strFieldBarCode AS EIDSSLocalOrFieldSampleID,
			m.strBarCode AS EIDSSLaboratorySampleID,
			sampleType.strSampleCode AS SampleTypeName,
			s.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			a.idfAnimal AS AnimalID,
			a.strAnimalCode AS EIDSSAnimalID,
			t.idfsTestName AS TestNameTypeID,
			testName.name AS TestNameTypeName,
			t.idfsTestCategory AS TestCategoryTypeID,
			testCategory.name AS TestCategoryTypeName,
			t.idfsTestResult AS TestResultTypeID,
			testResult.name AS TestResultTypeName,
			f.idfFarm AS FarmID,
			f.strFarmCode AS EIDSSFarmID,
			tv.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbTestValidation tv
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfTesting = tv.idfTesting
		LEFT JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = t.idfMaterial
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = m.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
				AND a.intRowStatus = 0
		LEFT JOIN dbo.tlbHerd AS h
			ON h.idfHerd = s.idfHerd
				AND h.intRowStatus = 0
		LEFT JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
				AND f.intRowStatus = 0
		LEFT JOIN dbo.trtSampleType AS sampleType
			ON sampleType.idfsSampleType = m.idfsSampleType
				AND sampleType.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS validatedByOffice
			ON validatedByOffice.idfOffice = tv.idfValidatedByOffice
				AND validatedByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS validatedByOfficeSite
			ON validatedByOfficeSite.idfsSite = validatedByOffice.idfsSite
				AND validatedByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS interpretedByOffice
			ON interpretedByOffice.idfOffice = tv.idfInterpretedByOffice
				AND interpretedByOffice.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS interpretedByOfficeSite
			ON interpretedByOfficeSite.idfsSite = interpretedByOffice.idfsSite
				AND interpretedByOfficeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS interpretedByPerson
			ON interpretedByPerson.idfPerson = tv.idfInterpretedByPerson
				AND interpretedByPerson.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS validatedByPerson
			ON validatedByPerson.idfPerson = tv.idfValidatedByPerson
				AND validatedByPerson.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000106) AS interpretedStatus
			ON interpretedStatus.idfsReference = tv.idfsInterpretedStatus
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS diagnosis
			ON diagnosis.idfsReference = t.idfsDiagnosis
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000097) AS testName
			ON testName.idfsReference = t.idfsTestName
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000095) AS testCategory
			ON testCategory.idfsReference = t.idfsTestCategory
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS testResult
			ON testResult.idfsReference = t.idfsTestResult
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
				(t.idfTesting = @TestID)
				OR (@TestID IS NULL)
				)
			AND tv.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
