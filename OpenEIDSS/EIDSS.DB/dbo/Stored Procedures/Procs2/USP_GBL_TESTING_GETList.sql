
-- ============================================================================
-- Name: USP_GBL_TESTING_GETList
-- Description:	Get testing list for the disease reports and other use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_TESTING_GETList] 
(
	@LangID									NVARCHAR(50), 
	@idfHumanCase							BIGINT = NULL, 
	@idfVetCase								BIGINT = NULL, 
	@idfMonitoringSession					BIGINT = NULL,
	@idfVectorSurveillanceSession			BIGINT = NULL, 
	@idfMaterial							BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT								t.idfTesting, 
											t.idfsTestName,
											testName.name AS TestNameTypeName, 
											t.idfsTestCategory,
											testCategory.name AS TestCategoryTypeName, 
											t.idfsTestResult,
											testResult.name AS TestResultTypeName, 
											t.idfsTestStatus,
											testStatus.name AS TestStatusTypeName, 
											t.idfsDiagnosis, 
											diagnosis.Name AS DiagnosisName,
											t.idfMaterial,
											m.strFieldBarCode,
											m.strBarCode, 
											sampleType.name AS SampleTypeName, 
											s.idfSpecies, 
											speciesType.name AS SpeciesTypeName, 
											a.idfAnimal, 
											a.strAnimalCode, 
											t.idfBatchTest,
											t.idfObservation,
											t.intTestNumber,
											t.strNote,
											t.intRowStatus,
											t.datStartedDate,
											t.datConcludedDate,
											t.idfTestedByOffice, 
											testedByOfficeSite.strSiteName AS TestedByOfficeSiteName, 
											t.idfTestedByPerson,
											ISNULL(testedByPerson.strFamilyName, N'') + ISNULL(' ' + testedByPerson.strFirstName, '') + ISNULL(' ' + testedByPerson.strSecondName, '') AS TestedByPersonName,
											t.idfResultEnteredByOffice,
											resultEnteredByOfficeSite.strSiteName AS ResultEnteredByOfficeSiteName, 
											t.idfResultEnteredByPerson,
											ISNULL(resultEnteredByPerson.strFamilyName, N'') + ISNULL(' ' + resultEnteredByPerson.strFirstName, '') + ISNULL(' ' + resultEnteredByPerson.strSecondName, '') AS ResultEnteredByPersonName,
											t.idfValidatedByOffice,
											validatedByOfficeSite.strSiteName AS ValidatedByOfficeSiteName, 
											t.idfValidatedByPerson,
											ISNULL(validatedByPerson.strFamilyName, N'') + ISNULL(' ' + validatedByPerson.strFirstName, '') + ISNULL(' ' + validatedByPerson.strSecondName, '') AS ValidatedByPersonName,
											t.blnReadOnly,
											t.blnNonLaboratoryTest,
											t.blnExternalTest,
											t.idfPerformedByOffice,
											performedByOfficeSite.strSiteName AS PerformedByOfficeSiteName, 
											t.datReceivedDate,
											t.strContactPerson,
											t.strMaintenanceFlag, 
											f.idfFarm,
											f.strFarmCode, 
											'R' AS RecordAction 
		FROM								dbo.tlbTesting t 
		LEFT JOIN							dbo.tlbMaterial AS m
		ON									m.idfMaterial = t.idfMaterial 
		LEFT JOIN							dbo.tlbSpecies AS s 
		ON									s.idfSpecies = m.idfSpecies AND s.intRowStatus = 0 
		LEFT JOIN							dbo.tlbHerd AS h 
		ON									h.idfHerd = s.idfHerd AND h.intRowStatus = 0 
		LEFT JOIN							dbo.tlbFarm AS f 
		ON									f.idfFarm = h.idfFarm AND f.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON									speciesType.idfsReference = s.idfsSpeciesType 
		LEFT JOIN							dbo.tlbAnimal AS a 
		ON									a.idfAnimal = m.idfAnimal AND a.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000087) AS sampleType
		ON									sampleType.idfsReference = m.idfsSampleType 
		LEFT JOIN							dbo.tlbOffice AS testedByOffice
		ON									testedByOffice.idfOffice = t.idfTestedByOffice AND testedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS testedByOfficeSite
		ON									testedByOfficeSite.idfsSite = testedByOffice.idfsSite AND testedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS resultEnteredByOffice
		ON									resultEnteredByOffice.idfOffice = t.idfResultEnteredByOffice AND resultEnteredByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS resultEnteredByOfficeSite
		ON									resultEnteredByOfficeSite.idfsSite = resultEnteredByOffice.idfsSite AND resultEnteredByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS validatedByOffice
		ON									validatedByOffice.idfOffice = t.idfValidatedByOffice AND validatedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS validatedByOfficeSite
		ON									validatedByOfficeSite.idfsSite = validatedByOffice.idfsSite AND validatedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS performedByOffice
		ON									performedByOffice.idfOffice = t.idfPerformedByOffice AND performedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS performedByOfficeSite
		ON									performedByOfficeSite.idfsSite = performedByOffice.idfsSite AND performedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS testedByPerson 
		ON									testedByPerson.idfPerson = t.idfTestedByPerson AND testedByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS resultEnteredByPerson 
		ON									resultEnteredByPerson.idfPerson = t.idfResultEnteredByPerson AND resultEnteredByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS validatedByPerson 
		ON									validatedByPerson.idfPerson = t.idfValidatedByPerson AND validatedByPerson.intRowStatus = 0
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000097) AS testName
		ON									testName.idfsReference = t.idfsTestName 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000095) AS testCategory
		ON									testCategory.idfsReference = t.idfsTestCategory 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000096) AS testResult
		ON									testResult.idfsReference = t.idfsTestResult 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000001) AS testStatus
		ON									testStatus.idfsReference = t.idfsTestStatus 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000019) AS diagnosis
		ON									diagnosis.idfsReference = t.idfsDiagnosis
		WHERE								((m.idfHumanCase = @idfHumanCase) OR (@idfHumanCase IS NULL))
		AND									((m.idfVetCase = @idfVetCase) OR (@idfVetCase IS NULL))
		AND									((m.idfMonitoringSession = @idfMonitoringSession) OR (@idfMonitoringSession IS NULL))
		AND									((m.idfVectorSurveillanceSession = @idfVectorSurveillanceSession) OR (@idfVectorSurveillanceSession IS NULL))
		AND									((t.idfMaterial = @idfMaterial) OR (@idfMaterial IS NULL))
		AND									t.intRowStatus = 0;

		SELECT								@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET								@returnCode = ERROR_NUMBER();
			SET								@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
											+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
											+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
											+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
											+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
											+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT							@returnCode, @returnMsg;
		END
	END CATCH;
END
