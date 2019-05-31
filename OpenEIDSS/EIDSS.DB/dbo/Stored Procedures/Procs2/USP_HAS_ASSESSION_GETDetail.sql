 
--*************************************************************
-- Name 				: USP_HAS_ASSESSION_GETDetail
-- Description			: SELECTs data for Human Active Surveillance session
--                     
-- Author: M.Jessee
-- Revision History:
-- Name             Date		Change Detail
-- ---------------- ----------	-----------------------------------------------
-- Michael Jessee	05/10/2018	Initial release.
--
-- Michael Jessee	05/16/2018	added two fields to proc output via USP_ASS_ACTION_GETDetail: strActionRequired and MonitoringSessionType 
-- Joan Li          06/12/2018  fixed sampletypename and testing records set issue 
-- Mandar Kulkarni  06/27/2018  fixed returning diagnosis string value
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  ,@LangID varchar(50)
SET @idfMonitoringSession=126  
SET @LangID ='en'
EXECUTE USP_HAS_ASSESSION_GETDetail  @idfMonitoringSession  , @LangID
  
*/  
--*************************************************************  
 CREATE PROCEDURE [dbo].[USP_HAS_ASSESSION_GETDetail]
(  
	@idfMonitoringSession	AS BIGINT,--##PARAM @iidfMonitoringSession - AS session ID  
	@LangId					AS NVARCHAR(50)--##PARAM @LangID - language ID  
)  
AS  

DECLARE @returnMsg	VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN

	BEGIN TRY  	

				-- 0- Session  
				SELECT tb.idfMonitoringSession  
					  ,tb.idfsMonitoringSessionStatus  
					  ,tb.idfsCountry  
					  ,country.name AS strCountry
					  ,tb.idfsRegion  
					  ,region.name AS StrRegion
					  ,tb.idfsRayon  
					  ,rayon.name AS strRayon
					  ,tb.idfsSettlement  
					  ,settlement.name AS strSettlement
					  ,tb.idfPersonEnteredBy  
					  ,ISNULL(person.strFirstName, '') + ' ' + ISNULL(person.strFamilyName, '') AS Officer
					  ,tb.idfCampaign  
					  ,tb.idfsSite  
					  ,ts.strSiteName
					  ,tb.datEnteredDate  
					  ,tb.strMonitoringSessionID  
					  ,tb.datStartDate
					  ,tb.datEndDate
					  ,convert(uniqueidentifier, tb.strReservedAttribute) as uidOfflineCaseID
					  ,tc.strCampaignID  
					  ,tc.strCampaignName  
					  ,tc.idfsCampaignType  
					  ,CampaignType.name AS strCampaignType
					  ,tc.datCampaignDateStart  
					  ,tc.datCampaignDateEnd  
					  ,tb.datModificationForArchiveDate
					  ,tc.idfsDiagnosis
					  ,Diagnosis.name AS Diagnosis
				FROM dbo.tlbMonitoringSession  tb
				LEFT JOIN dbo.tlbCampaign  TC
				ON tc.idfCampaign = tb.idfCampaign  
				LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000116) CampaignType ON
							tc.idfsCampaignType = CampaignType.idfsReference
				LEFT JOIN dbo.MonitoringSessionToSampleType msts
				ON tb.idfMonitoringSession = msts.idfMonitoringSession
				LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000087) SampleType 
				ON SampleType.idfsReference = msts.idfsSampleType
				LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000086) SpeciesType 
				ON SpeciesType.idfsReference= SampleType.idfsReference
				LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000019) Diagnosis 
				ON Diagnosis.idfsReference= tc.idfsDiagnosis
				LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangID, 19000001) AS country 
				ON			country.idfsReference = tb.idfsCountry
				LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID, 19000002) AS rayon
				ON			rayon.idfsReference = tb.idfsRayon
				LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID, 19000003) AS region
				ON			region.idfsReference = tb.idfsRegion
				LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangID, 19000004) AS settlement 
				ON			settlement.idfsReference = tb.idfsSettlement
				LEFT JOIN dbo.tstSite ts
				ON			ts.idfsSite = tb.idfsSite
				LEFT JOIN	dbo.tlbPerson person 
				ON			person.idfPerson = tb.idfPersonEnteredBy
				WHERE  tb.idfMonitoringSession = @idfMonitoringSession  
				 AND tb.intRowStatus = 0  
  
				--1 Diagnosis  

				EXEC USP_ASS_DIAG_GETList  @idfMonitoringSession    
  
												----2 Farms  
												--SELECT idfFarm  
												--   ,tlbFarm.idfFarmActual as idfRootFarm  
												--	,strFarmCode  
												--	,strNationalName  
												--	,dbo.fnConcatFullName(tlbHuman.strLastName ,tlbHuman.strFirstName ,tlbHuman.strSecondName) as strOwnerName  
												--	,idfsOwnershipStructure  
												--	,idfsLivestockProductionType  
												--   ,tlbFarm.idfMonitoringSession 
												--   ,CAST (0 AS bit) AS blnNewFarm  
												--FROM tlbFarm  
												--LEFT OUTER JOIN tlbHuman   
												-- on tlbHuman.idfHuman=tlbFarm.idfHuman and  
												--	tlbHuman.intRowStatus = 0  
												--WHERE  
												-- tlbFarm.idfMonitoringSession = @idfMonitoringSession  
												-- and tlbFarm.intRowStatus = 0  
   
												----3 Farm Tree  
												--EXEC spASFarmTree_SelectDetail @idfMonitoringSession  
  
												----4 Animals  
												--EXEC spASSessionAnimals_SelectDetail @idfMonitoringSession  

				--5 Actions  

				EXECUTE USP_ASS_ACTION_GETDetail @idfMonitoringSession  

				-- 6 Monitoring Session Sameple Types

				SELECT		msts.MonitoringSessionToSampleType,
							msts.idfMonitoringSession,
							msts.idfsSpeciesType,
							SpeciesType.name As SpeciesType,
							msts.idfsSampleType,
							SampleType.name AS SampleType,
							msts.intOrder
				FROM		dbo.MonitoringSessionToSampleType msts
				INNER JOIN	dbo.tlbMonitoringSession ms ON
							ms.idfMonitoringSession = msts.idfMonitoringSession
				LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000087) SampleType ON
							SampleType.idfsReference = msts.idfsSampleType
				LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000086) SpeciesType ON
							SpeciesType.idfsReference= SampleType.idfsReference
				WHERE		ms.idfMonitoringSession = @idfMonitoringSession
				AND			msts.intRowStatus = 0
  
				-- 7 Material data for given monitoring sessoin

				SELECT		m.idfMaterial, 
							m.idfsSampleType,
							----sampleType.strSampleCode AS SampleTypeName, 
							SampleTypeName.name AS SampleTypeName,
							m.idfRootMaterial,
							m.idfParentMaterial,
							m.idfSpecies,
							speciesType.name AS SpeciesTypeName, 
							m.idfAnimal,
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
							OfficeName.name AS SendToOfficeSiteName, 
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
							t.idfTesting,
							t.idfsTestName,
							TestName.name AS StrTestName,
							t.idfsTestCategory,
							TestCategory.name AS strTestCategory,
							t.idfsTestResult, 
							TestResult.name AS strTestResult,
							t.datConcludedDate,
							'R' AS RecordAction 
					FROM			dbo.tlbMaterial m 
					LEFT JOIN		dbo.tlbTesting AS t 
					----ON				t.idfTesting = m.idfMainTest AND t.intRowStatus = 0
					ON t.idfmaterial=m.idfmaterial AND t.introwstatus=0
					LEFT JOIN		dbo.tlbFreezerSubdivision AS fs 
					ON				fs.idfSubdivision = m.idfSubdivision AND fs.intRowStatus = 0
					LEFT JOIN		dbo.tlbOffice AS fieldCollectedByOffice
					ON				fieldCollectedByOffice.idfOffice = m.idfFieldCollectedByOffice AND fieldCollectedByOffice.intRowStatus = 0
					LEFT JOIN		dbo.tstSite AS fieldCollectedByOfficeSite
					ON				fieldCollectedByOfficeSite.idfsSite = fieldCollectedByOffice.idfsSite AND fieldCollectedByOfficeSite.intRowStatus = 0
					LEFT JOIN		dbo.tlbDepartment AS d 
					ON				d.idfDepartment = m.idfInDepartment AND d.intRowStatus = 0
					LEFT JOIN		dbo.tlbOffice AS departmentOffice
					ON				departmentOffice.idfOffice = d.idfOrganization AND departmentOffice.intRowStatus = 0
					LEFT JOIN		dbo.tstSite AS departmentOfficeSite
					ON				departmentOfficeSite.idfsSite = departmentOffice.idfsSite AND departmentOfficeSite.intRowStatus = 0
					LEFT JOIN		dbo.tstSite AS materialSite
					ON				materialSite.idfsSite = m.idfsSite AND materialSite.intRowStatus = 0
					LEFT JOIN		dbo.tlbOffice AS sendToOffice
					ON				sendToOffice.idfOffice = m.idfSendToOffice AND sendToOffice.intRowStatus = 0
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangId,19000046) OfficeName
					ON				OfficeName.idfsReference = SendToOffice.idfsOfficeName AND sendToOffice.intRowStatus = 0
					--LEFT JOIN		dbo.tstSite AS sendToOfficeSite
					--ON				sendToOfficeSite.idfsSite = sendToOffice.idfsSite AND sendToOfficeSite.intRowStatus = 0
					LEFT JOIN		dbo.tstSite AS currentSite
					ON				currentSite.idfsSite = m.idfsCurrentSite AND currentSite.intRowStatus = 0
					LEFT JOIN		dbo.tlbPerson AS fieldCollectedByPerson 
					ON				fieldCollectedByPerson.idfPerson = m.idfFieldCollectedByPerson AND fieldCollectedByPerson.intRowStatus = 0
					LEFT JOIN		dbo.tlbPerson AS destroyedByPerson 
					ON				destroyedByPerson.idfPerson = m.idfDestroyedByPerson AND destroyedByPerson.intRowStatus = 0
					LEFT JOIN		dbo.tlbPerson AS accessionByPerson 
					ON				accessionByPerson.idfPerson = m.idfAccesionByPerson AND accessionByPerson.intRowStatus = 0
					LEFT JOIN		dbo.tlbPerson AS markedForDispositionByPerson 
					ON				markedForDispositionByPerson.idfPerson = m.idfMarkedForDispositionByPerson AND markedForDispositionByPerson.intRowStatus = 0
					LEFT JOIN		dbo.trtSampleType AS sampleType
					ON				sampleType.idfsSampleType = m.idfsSampleType AND sampleType.intRowStatus = 0 
					LEFT JOIN       dbo.FN_GBL_ReferenceRepair(@LangID,19000087) AS SampleTypeName   ----jl relink to get sampletype name
					ON				SampleTypeName.idfsReference =sampleType.idfsSampleType  ---jl relink to get sampletype name
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000015) AS sampleStatus
					ON				sampleStatus.idfsReference = m.idfsSampleStatus 
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000006) AS birdStatus
					ON				birdStatus.idfsReference = m.idfsBirdStatus 
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000110) AS accessionCondition
					ON				accessionCondition.idfsReference = m.idfsAccessionCondition 
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000157) AS destructionMethod
					ON				destructionMethod.idfsReference = m.idfsDestructionMethod 
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000158) AS sampleKind
					ON				sampleKind.idfsReference = m.idfsSampleKind 
					LEFT JOIN		dbo.tlbSpecies AS s
					ON				s.idfSpecies = m.idfSpecies AND s.intRowStatus = 0 
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
					ON				speciesType.idfsReference = s.idfsSpeciesType 
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000097) AS TestName
					ON				TestName.idfsReference = t.idfsTestName
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000095) AS TestCategory
					ON				TestCategory.idfsReference = t.idfsTestCategory
					LEFT JOIN		FN_GBL_ReferenceRepair(@LangID, 19000096) AS TestResult
					ON				TestResult.idfsReference = t.idfsTestResult
					WHERE			m.idfMonitoringSession = CASE ISNULL(@idfMonitoringSession,'') WHEN '' THEN m.idfMonitoringSession ELSE @idfMonitoringSession END
					AND				m.intRowStatus = 0;


				SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 
		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()
		SELECT @returnCode, @returnMsg
	END CATCH

END

