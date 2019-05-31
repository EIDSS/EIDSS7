
-- ============================================================================
-- Name: USP_GBL_TEST_VALIDATION_GETList
-- Description:	Get test validation list for the disease reports and other use 
-- cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_TEST_VALIDATION_GETList] 
(
	@LangID									NVARCHAR(50), 
	@idfHumanCase							BIGINT = NULL, 
	@idfVetCase								BIGINT = NULL, 
	@idfMonitoringSession					BIGINT = NULL,
	@idfVectorSurveillanceSession			BIGINT = NULL, 
	@idfTesting								BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT								tv.idfTestValidation, 
											tv.idfsDiagnosis, 
											diagnosis.Name AS DiagnosisName,
											tv.idfsInterpretedStatus,
											interpretedStatus.name AS InterpretedStatusTypeName, 
											tv.idfValidatedByOffice,
											validatedByOfficeSite.strSiteName AS ValidatedByOfficeSiteName, 
											tv.idfValidatedByPerson,
											ISNULL(validatedByPerson.strFamilyName, N'') + ISNULL(' ' + validatedByPerson.strFirstName, '') + ISNULL(' ' + validatedByPerson.strSecondName, '') AS ValidatedByPersonName,
											tv.idfInterpretedByOffice, 
											interpretedByOfficeSite.strSiteName AS InterpretedByOfficeSiteName, 
											tv.idfInterpretedByPerson,
											ISNULL(interpretedByPerson.strFamilyName, N'') + ISNULL(' ' + interpretedByPerson.strFirstName, '') + ISNULL(' ' + interpretedByPerson.strSecondName, '') AS InterpretedByPersonName,
											tv.idfTesting,
											tv.blnValidateStatus,
											tv.blnCaseCreated,
											tv.strValidateComment,
											tv.strInterpretedComment,
											tv.datValidationDate,
											tv.datInterpretationDate, 
											tv.intRowStatus,
											tv.blnReadOnly,
											tv.strMaintenanceFlag, 
											t.idfMaterial,
											m.strFieldBarCode,
											m.strBarCode, 
											sampleType.strSampleCode AS SampleTypeName, 
											s.idfSpecies, 
											speciesType.name AS SpeciesTypeName, 
											a.idfAnimal, 
											a.strAnimalCode, 
											t.idfsTestName,
											testName.name AS TestNameTypeName, 
											t.idfsTestCategory,
											testCategory.name AS TestCategoryTypeName, 
											t.idfsTestResult,
											testResult.name AS TestResultTypeName, 
											f.idfFarm,
											f.strFarmCode, 
											'R' AS RecordAction 
		FROM								dbo.tlbTestValidation tv 
		LEFT JOIN							dbo.tlbTesting AS t
		ON									t.idfTesting = tv.idfTesting 
		LEFT JOIN							dbo.tlbMaterial AS m
		ON									m.idfMaterial = t.idfMaterial 
		LEFT JOIN							dbo.tlbSpecies AS s 
		ON									s.idfSpecies = m.idfSpecies AND s.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON									speciesType.idfsReference = s.idfsSpeciesType 
		LEFT JOIN							dbo.tlbAnimal AS a 
		ON									a.idfAnimal = m.idfAnimal AND a.intRowStatus = 0 
		LEFT JOIN							dbo.tlbHerd AS h 
		ON									h.idfHerd = s.idfHerd AND h.intRowStatus = 0 
		LEFT JOIN							dbo.tlbFarm AS f 
		ON									f.idfFarm = h.idfFarm AND f.intRowStatus = 0 
		LEFT JOIN							dbo.trtSampleType AS sampleType
		ON									sampleType.idfsSampleType = m.idfsSampleType AND sampleType.intRowStatus = 0 
		LEFT JOIN							dbo.tlbOffice AS validatedByOffice
		ON									validatedByOffice.idfOffice = tv.idfValidatedByOffice AND validatedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS validatedByOfficeSite
		ON									validatedByOfficeSite.idfsSite = validatedByOffice.idfsSite AND validatedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS interpretedByOffice
		ON									interpretedByOffice.idfOffice = tv.idfInterpretedByOffice AND interpretedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS interpretedByOfficeSite
		ON									interpretedByOfficeSite.idfsSite = interpretedByOffice.idfsSite AND interpretedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS interpretedByPerson 
		ON									interpretedByPerson.idfPerson = tv.idfInterpretedByPerson AND interpretedByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS validatedByPerson 
		ON									validatedByPerson.idfPerson = tv.idfValidatedByPerson AND validatedByPerson.intRowStatus = 0
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000106) AS interpretedStatus
		ON									interpretedStatus.idfsReference = tv.idfsInterpretedStatus 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000019) AS diagnosis
		ON									diagnosis.idfsReference = t.idfsDiagnosis 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000097) AS testName
		ON									testName.idfsReference = t.idfsTestName 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000095) AS testCategory
		ON									testCategory.idfsReference = t.idfsTestCategory 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000096) AS testResult
		ON									testResult.idfsReference = t.idfsTestResult 
		WHERE								((m.idfHumanCase = @idfHumanCase) OR (@idfHumanCase IS NULL))
		AND									((m.idfVetCase = @idfVetCase) OR (@idfVetCase IS NULL))
		AND									((m.idfMonitoringSession = @idfMonitoringSession) OR (@idfMonitoringSession IS NULL))
		AND									((m.idfVectorSurveillanceSession = @idfVectorSurveillanceSession) OR (@idfVectorSurveillanceSession IS NULL))
		AND									((t.idfTesting = @idfTesting) OR (@idfTesting IS NULL))
		AND									tv.intRowStatus = 0;

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
