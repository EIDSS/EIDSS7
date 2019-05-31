
-- ============================================================================
-- Name: USP_GBL_MATERIAL_GETList
-- Description:	Get material list for the disease reports and other use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
--exec USP_GBL_MATERIAL_GETList 'en', @idfVectorSurveillanceSession = 55
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_MATERIAL_GETList] 
(
	@LangID									NVARCHAR(50), 
	@idfHumanCase							BIGINT = NULL, 
	@idfVetCase								BIGINT = NULL, 
	@idfRootMaterial						BIGINT = NULL,
	@idfMonitoringSession					BIGINT = NULL,
	@idfVectorSurveillanceSession			BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT								m.idfMaterial, 
											m.idfsSampleType,
											sampleType.name AS SampleTypeName, 
											m.idfRootMaterial,
											m.idfParentMaterial,
											m.idfHuman,
											ISNULL(h.strLastName, N'') + ISNULL(' ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') AS HumanName,
											m.idfSpecies,
											speciesType.name AS SpeciesTypeName, 
											m.idfAnimal,
											a.strAnimalCode, 
											a.idfsAnimalGender,
											animalGender.name AS AnimalGenderTypeName, 
											a.idfsAnimalAge, 
											animalAge.name AS AnimalAgeTypeName, 
											a.strColor, 
											m.idfMonitoringSession,
											m.idfFieldCollectedByPerson,
											ISNULL(fieldCollectedByPerson.strFamilyName, N'') + ISNULL(' ' + fieldCollectedByPerson.strFirstName, '') + ISNULL(' ' + fieldCollectedByPerson.strSecondName, '') AS FieldCollectedByPersonName,
											m.idfFieldCollectedByOffice,
											fieldCollectedByOfficeSite.strSiteName AS FieldCollectedByOfficeSiteName, 
											m.idfMainTest,
											t.intTestNumber,
											m.datFieldCollectionDate,
											m.datFieldSentDate,
											m.strFieldBarcode, 
											m.strCalculatedCaseID,
											m.strCalculatedHumanName,
											m.idfVectorSurveillanceSession,
											m.idfVector,
											m.idfSubdivision,
											fs.strNameChars,
											m.idfsSampleStatus,
											sampleStatus.name AS SampleStatusTypeName, 
											m.idfInDepartment,
											departmentOfficeSite.strSiteName AS InDepartmentSiteName, 
											m.idfDestroyedByPerson,
											ISNULL(destroyedByPerson.strFamilyName, N'') + ISNULL(' ' + destroyedByPerson.strFirstName, '') + ISNULL(' ' + destroyedByPerson.strSecondName, '') AS DestroyedByPersonName,
											m.datEnteringDate,
											m.datDestructionDate,
											m.strBarcode,
											m.strNote,
											m.idfsSite,
											materialSite.strSiteName AS MaterialSiteName, 
											m.intRowStatus,
											m.idfSendToOffice,
											sendToOfficeSite.strSiteName AS SendToOfficeSiteName, 
											m.blnReadOnly,
											m.idfsBirdStatus,
											birdStatus.name AS BirdStatusTypeName, 
											m.idfHumanCase,
											m.idfVetCase,
											m.datAccession,
											m.idfsAccessionCondition,
											accessionCondition.name AS AccessionConditionTypeName, 
											m.strCondition,
											m.idfAccesionByPerson,
											ISNULL(accessionByPerson.strFamilyName, N'') + ISNULL(' ' + accessionByPerson.strFirstName, '') + ISNULL(' ' + accessionByPerson.strSecondName, '') AS AccessionByPersonName,
											m.idfsDestructionMethod,
											destructionMethod.name AS DestructionMethodTypeName, 
											m.idfsCurrentSite,
											currentSite.strSiteName AS CurrentSiteName, 
											m.idfsSampleKind,
											sampleKind.name AS SampleKindTypeName, 
											m.blnAccessioned,
											m.blnShowInCaseOrSession,
											m.blnShowInLabList,
											m.blnShowInDispositionList,
											m.blnShowInAccessionInForm,
											m.idfMarkedForDispositionByPerson,
											ISNULL(markedForDispositionByPerson.strFamilyName, N'') + ISNULL(' ' + markedForDispositionByPerson.strFirstName, '') + ISNULL(' ' + markedForDispositionByPerson.strSecondName, '') AS MarkedForDispositionByPersonName,
											m.datOutOfRepositoryDate,
											m.datSampleStatusDate,
											m.strMaintenanceFlag, 
											f.idfFarm,
											f.strFarmCode,  
											'R' AS RecordAction 
		FROM								dbo.tlbMaterial m 
		LEFT JOIN							dbo.tlbTesting AS t 
		ON									t.idfTesting = m.idfMainTest AND t.intRowStatus = 0
		LEFT JOIN							dbo.tlbHuman AS h 
		ON									h.idfHuman = m.idfHuman AND h.intRowStatus = 0
		LEFT JOIN							dbo.tlbFreezerSubdivision AS fs 
		ON									fs.idfSubdivision = m.idfSubdivision AND fs.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS fieldCollectedByOffice
		ON									fieldCollectedByOffice.idfOffice = m.idfFieldCollectedByOffice AND fieldCollectedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS fieldCollectedByOfficeSite
		ON									fieldCollectedByOfficeSite.idfsSite = fieldCollectedByOffice.idfsSite AND fieldCollectedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbDepartment AS d 
		ON									d.idfDepartment = m.idfInDepartment AND d.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS departmentOffice
		ON									departmentOffice.idfOffice = d.idfOrganization AND departmentOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS departmentOfficeSite
		ON									departmentOfficeSite.idfsSite = departmentOffice.idfsSite AND departmentOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS materialSite
		ON									materialSite.idfsSite = m.idfsSite AND materialSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS sendToOffice
		ON									sendToOffice.idfOffice = m.idfSendToOffice AND sendToOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS sendToOfficeSite
		ON									sendToOfficeSite.idfsSite = sendToOffice.idfsSite AND sendToOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS currentSite
		ON									currentSite.idfsSite = m.idfsCurrentSite AND currentSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS fieldCollectedByPerson 
		ON									fieldCollectedByPerson.idfPerson = m.idfFieldCollectedByPerson AND fieldCollectedByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS destroyedByPerson 
		ON									destroyedByPerson.idfPerson = m.idfDestroyedByPerson AND destroyedByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS accessionByPerson 
		ON									accessionByPerson.idfPerson = m.idfAccesionByPerson AND accessionByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS markedForDispositionByPerson 
		ON									markedForDispositionByPerson.idfPerson = m.idfMarkedForDispositionByPerson AND markedForDispositionByPerson.intRowStatus = 0
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000087) AS sampleType
		ON									sampleType.idfsReference = m.idfsSampleType 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000015) AS sampleStatus
		ON									sampleStatus.idfsReference = m.idfsSampleStatus 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000006) AS birdStatus
		ON									birdStatus.idfsReference = m.idfsBirdStatus 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000110) AS accessionCondition
		ON									accessionCondition.idfsReference = m.idfsAccessionCondition 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000157) AS destructionMethod
		ON									destructionMethod.idfsReference = m.idfsDestructionMethod 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000158) AS sampleKind
		ON									sampleKind.idfsReference = m.idfsSampleKind 
		LEFT JOIN							dbo.tlbSpecies AS s
		ON									s.idfSpecies = m.idfSpecies AND s.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON									speciesType.idfsReference = s.idfsSpeciesType 
		LEFT JOIN							dbo.tlbAnimal AS a
		ON									a.idfAnimal = m.idfAnimal AND a.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000005) AS animalAge
		ON									animalAge.idfsReference = a.idfsAnimalAge 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000007) AS animalGender
		ON									animalGender.idfsReference = a.idfsAnimalGender 
		LEFT JOIN							dbo.tlbHerd as hd 
		ON									hd.idfHerd = s.idfHerd AND h.intRowStatus = 0
		LEFT JOIN							dbo.tlbFarm AS f 
		ON									f.idfFarm = hd.idfFarm AND f.intRowStatus = 0
		WHERE								((m.idfHumanCase = @idfHumanCase) OR (@idfHumanCase IS NULL))
		AND									((m.idfVetCase = @idfVetCase) OR (@idfVetCase IS NULL))
		AND									((m.idfRootMaterial = @idfRootMaterial) OR (@idfRootMaterial IS NULL))
		AND									((m.idfMonitoringSession = @idfMonitoringSession) OR (@idfMonitoringSession IS NULL))
		AND									((m.idfVectorSurveillanceSession = @idfVectorSurveillanceSession) OR (@idfVectorSurveillanceSession IS NULL))
		AND									m.intRowStatus = 0;

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
