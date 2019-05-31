
--*************************************************************
-- Name 				: USP_VCTS_LABTEST_GetList
-- Description			: Get Vector Lab Tests List
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  8/20/2018   Creation
--
-- Testing code:
/*
--Example of a call of procedure:
declare	@idfVector	bigint = 51
declare @idfVectorSurveillanceSession BIGINT = null
Declare @LangID AS VARCHAR(10) = 'en'

--select @idfVector = MAX(idfVector) from dbo.tlbVector

execute	USP_VCTS_LABTEST_GetList @idfVector, @idfVectorSurveillanceSession, @LangID
*/
--*************************************************************
CREATE PROCEDURE[dbo].[USP_VCTS_LABTEST_GetList]
(		
	@idfVector BIGINT,--##PARAM @idfVector - AS vector ID
	@idfVectorSurveillanceSession BIGINT,--##PARAM @idfVectorSurveillanceSession - AS session ID
	@LangID AS nvarchar(10)--##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

			SELECT							
										    m.idfMaterial, 
		                                    vss.idfsVSSessionSummary,
											m.idfVector,
											m.idfsSampleType,
											sampleType.name AS strSampleTypeName, 
											m.idfSpecies,
											SpeciesName.name AS strSpeciesName,
											m.idfFieldCollectedByPerson,
											ISNULL(fieldCollectedByPerson.strFamilyName, N'') + ISNULL(' ' + fieldCollectedByPerson.strFirstName, '') + ISNULL(' ' + fieldCollectedByPerson.strSecondName, '') AS FieldCollectedByPersonName,
											m.idfFieldCollectedByOffice,
											fieldCollectedByOfficeSite.strSiteName AS FieldCollectedByOfficeSiteName, 											
											m.datFieldCollectionDate,											
											m.strFieldBarcode as strFieldSampleID, 											
											m.idfVectorSurveillanceSession,
											m.idfVector,								
											m.strBarcode as strLabSampleID,											
											m.idfsSite,
											disease.name AS strDiseaseName, 
											testName.name AS strTestName, 
											testCategory.name AS strTestCategoryName, 
											testResult.name AS strTestResultName,
											idfTestedByOffice,
											testedByOffice.idfsOfficeName as strTestedByInstitutionName,
											idfTestedByPerson,
											ISNULL(testedByPerson.strFamilyName, N'') + ISNULL(' ' + testedByPerson.strFirstName, '') + ISNULL(' ' + testedByPerson.strSecondName, '') AS strTestedByPersonName,
											null as strAmendmentHistory											
		FROM								dbo.tlbMaterial m 
		INNER JOIN							dbo.tlbVectorSurveillanceSessionSummary AS vss 
		ON									vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession AND vss.intRowStatus = 0 
		LEFT JOIN							dbo.tlbVectorSurveillanceSessionSummaryDiagnosis AS vsssd 
		ON									vsssd.idfsVSSessionSummary = vss.idfsVSSessionSummary AND vsssd.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000019) AS disease
		ON									disease.idfsReference = vsssd.idfsDiagnosis
		LEFT JOIN							dbo.tlbTesting AS t
		ON									t.idfMaterial = m.idfMaterial AND t.intRowStatus = 0
		LEFT JOIN							dbo.tlbFreezerSubdivision AS fs 
		ON									fs.idfSubdivision = m.idfSubdivision AND fs.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS fieldCollectedByOffice
		ON									fieldCollectedByOffice.idfOffice = m.idfFieldCollectedByOffice AND fieldCollectedByOffice.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS fieldCollectedByOfficeSite
		ON									fieldCollectedByOfficeSite.idfsSite = fieldCollectedByOffice.idfsSite AND fieldCollectedByOfficeSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbDepartment AS d 
		ON									d.idfDepartment = m.idfInDepartment AND d.intRowStatus = 0 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000164) AS functionalArea
		ON									functionalArea.idfsReference = d.idfsDepartmentName   
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
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000110) AS accessionCondition
		ON									accessionCondition.idfsReference = m.idfsAccessionCondition 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000157) AS destructionMethod
		ON									destructionMethod.idfsReference = m.idfsDestructionMethod 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000158) AS sampleKind
		ON									sampleKind.idfsReference = m.idfsSampleKind 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000097) AS testName
		ON									testName.idfsReference = t.idfsTestName 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000095) AS testCategory
		ON									testCategory.idfsReference = t.idfsTestCategory 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000096) AS testResult
		ON									testResult.idfsReference = t.idfsTestResult
		LEFT JOIN							FN_GBL_REFERENCEREPAIR(@LangID,19000086) SpeciesName ON --rftSpeciesList
											SpeciesName.idfsReference=m.idfSpecies
		LEFT JOIN							dbo.tlbPerson AS testedByPerson 
		ON									testedByPerson.idfPerson = idfTestedByPerson AND testedByPerson.intRowStatus = 0
		LEFT JOIN							dbo.tlbOffice AS testedByOffice
		ON									testedByOffice.idfOffice = idfTestedByOffice AND testedByOffice.intRowStatus = 0
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000001) AS testStatus
		ON									testStatus.idfsReference = t.idfsTestStatus
		where								m.idfVector = @idfVector
		and									((m.idfVectorSurveillanceSession = @idfVectorSurveillanceSession) OR (@idfVectorSurveillanceSession IS NULL)) 
		AND									(m.intRowStatus = 0) 
		AND									(m.idfVectorSurveillanceSession IS NOT NULL) 

		
		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SET @returnCode = ERROR_NUMBER()
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
		
END
