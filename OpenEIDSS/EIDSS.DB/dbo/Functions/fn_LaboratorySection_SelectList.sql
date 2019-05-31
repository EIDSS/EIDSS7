

/*
	select * from fn_LaboratorySection_SelectList('en')
*/

create function [dbo].[fn_LaboratorySection_SelectList](@LangID as nvarchar(50))
returns table 
as
return

select 
	isnull(smp.idfTesting, smp.idfMaterial) as ID,
	smp.idfTesting,
	smp.idfMaterial,
	isnull(smp.idfHumanCase, isnull(smp.idfVector, isnull(smp.idfAnimal, smp.idfSpecies))) as idfSpeciesVectorInfo,
	isnull(smp.idfHumanCase, isnull(smp.idfVetCase, isnull(smp.idfMonitoringSession, smp.idfVectorSurveillanceSession))) as idfCaseOrSession,
	isnull(smp.idfsSampleStatus,-1) as idfsSampleStatus,
	smp.datSampleStatusDate,
	smp.idfsSampleType,
	
	isnull(smp.idfsDiagnosis, smp.idfsShowDiagnosis) as idfsDiagnosis,
	smp.idfsShowDiagnosis as idfsShowDiagnosis,
	smp.idfsVetFinalDiagnosis as idfsVetFinalDiagnosis,
	--isnull(smp.tstDiagnosisName, smp.DiagnosisName) as strDiagnosisName,
	CAST('' as nvarchar(64)) as strDiagnosisName,
	smp.idfRootMaterial,	
	smp.idfParentMaterial,
	smp.strParentMaterial,
	smp.idfHuman,
	smp.idfSpecies,
	smp.idfAnimal,
	smp.idfHumanCase,
	smp.idfVetCase,
	smp.idfMonitoringSession,
	smp.idfMainTest,
	smp.idfVectorSurveillanceSession,
	smp.idfVector,
	smp.idfDestroyedByPerson,
	smp.strBarcode,
	smp.strFieldBarcode,
	smp.datFieldCollectionDate,
	smp.datFieldSentDate,
	smp.strCalculatedCaseID, 
	smp.strCalculatedHumanName, 
	smp.idfAccesionByPerson,
	smp.idfsAccessionCondition,
	smp.datAccession,
	smp.datEnteringDate,
	smp.datDestructionDate,
	smp.idfSendToOffice,
	smp.idfSubdivision,
	smp.idfInDepartment,
	smp.idfsCaseType,
	smp.intCaseHACode,
	smp.idfFieldCollectedByOffice,
	smp.idfFieldCollectedByPerson,
	smp.idfsDestructionMethod,
	smp.strSampleNote,
	smp.strCondition,
	isnull(smp.idfsSampleKind,-1) as idfsSampleKind,
	smp.idfMarkedForDispositionByPerson,
	smp.intTestCount,

	smp.idfSendToOfficeOut,
	smp.bExternalOffice,
	smp.idfSendByPerson,
	smp.datSendDate,

	smp.strCalculatedHumanName as HumanName, 
	CASE WHEN smp.idfHumanCase IS NOT NULL THEN smp.strCalculatedHumanName ELSE NULL END as strPatientName,
	CASE WHEN smp.idfHumanCase IS NULL THEN smp.strCalculatedHumanName ELSE NULL END as strFarmOwner,
	smp.idfsCountry,
	smp.idfsRegion,
	CAST('' as nvarchar(64)) as strRegion,
	smp.idfsRayon,
	CAST('' as nvarchar(64)) as strRayon,
	smp.idfsSettlement,

	smp.idfsTestName,
	smp.idfsTestCategory,
	smp.idfsTestStatus,
	smp.idfsTestResult,

	smp.datStartedDate,
	smp.datConcludedDate,
	
	smp.idfObservation,
	smp.strNote,
	smp.idfTestedByOffice,
	smp.idfTestedByPerson,
	smp.idfResultEnteredByOffice,
	smp.idfResultEnteredByPerson,
	smp.idfValidatedByOffice,
	smp.idfValidatedByPerson,
	smp.blnNonLaboratoryTest,
	isnull(smp.blnExternalTest, 0) as blnExternalTest,
	smp.datReceivedDate,
	smp.idfPerformedByOffice,
	smp.strContactPerson,
	smp.idfsFormTemplate,
	
	smp.strBatchID,


	CAST('' as nvarchar(64)) as strDepartmentName,
	CAST('' as nvarchar(64)) as strSampleStatus,
	CAST('' as nvarchar(64)) as strSampleName,
	CAST('' as nvarchar(64)) as strSampleConditionReceivedStatus,
	CAST('' as nvarchar(64)) as strTestName,
	CAST('' as nvarchar(64)) as strTestStatus,
	CAST('' as nvarchar(64)) as strTestResult,
	CAST('' as nvarchar(64)) as strTestCategory,
	
	ISNULL(CAST(-1 as bigint),0) AS idfsLaboratorySection,
	
	ISNULL(CAST(0 as bit),0) as bTestDeleted,
	ISNULL(CAST(0 as bit),0) as bTestInserted,
	ISNULL(CAST(0 as bit),0) as bTestInsertedFirst,
	ISNULL(CAST(0 as bit),0) as bFilterTestByDiagnosis,
	
	CAST(0 as int) as intNewSample,
	CAST(null as bigint) as idfsSampleTypeFiltered,
	CAST(null as nvarchar(200))as strComments,
	CAST(null as nvarchar(200))as strReason
	
from (
	select 
		tlbMaterial.idfMaterial,
		tlbMaterial.idfRootMaterial,
		tlbMaterial.idfParentMaterial,
		tlbMaterialParent.strBarcode as strParentMaterial,
		tlbMaterial.idfHuman,
		tlbMaterial.idfSpecies,
		tlbMaterial.idfAnimal,
		tlbMaterial.idfHumanCase,
		tlbMaterial.idfVetCase,
		tlbMaterial.idfMonitoringSession,
		tlbMaterial.idfMainTest,
		tlbMaterial.idfVectorSurveillanceSession,
		tlbMaterial.idfVector,
		tlbMaterial.idfDestroyedByPerson,
		tlbMaterial.idfsSampleStatus,
		tlbMaterial.datSampleStatusDate,
		tlbMaterial.idfsAccessionCondition,
		tlbMaterial.idfsSampleType,
		tlbMaterial.strBarcode,
		tlbMaterial.strFieldBarcode,
		tlbMaterial.strCalculatedCaseID,
		tlbMaterial.strCalculatedHumanName,
		tlbMaterial.datFieldCollectionDate,
		tlbMaterial.datFieldSentDate,
		tlbMaterial.datAccession,
		tlbMaterial.datEnteringDate,
		tlbMaterial.datDestructionDate,
		tlbMaterial.idfAccesionByPerson,
		tlbMaterial.idfSendToOffice,
		tlbMaterial.idfSubdivision,
		tlbMaterial.idfInDepartment,
		tlbMaterial.idfFieldCollectedByOffice,
		tlbMaterial.idfFieldCollectedByPerson,
		tlbMaterial.idfsDestructionMethod,
		tlbMaterial.strNote as strSampleNote,
		tlbMaterial.strCondition as strCondition,
		tlbMaterial.idfsSampleKind,
		tlbMaterial.idfMarkedForDispositionByPerson,
		
		cast((select COUNT(*) from tlbTesting where tlbTesting.idfMaterial = tlbMaterial.idfMaterial and tlbTesting.intRowStatus = 0 and tlbTesting.blnNonLaboratoryTest = 0) as int)
			AS intTestCount,
			
		CASE 
			WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
			WHEN tlbVectorSurveillanceSession.idfVectorSurveillanceSession IS NOT NULL THEN 10012006
			WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN 10012005
			ELSE tlbVetCase.idfsCaseType
		END AS idfsCaseType,

		CAST(CASE 
			when	tlbHumanCase.idfHumanCase IS NOT NULL	-- Human
				then	2
			when	IsNull(tlbVetCase.idfsCaseType, 0) = 10012003	-- Livestock
				then	32
			when	IsNull(tlbVetCase.idfsCaseType, 0) = 10012004	-- Avian
				then	64
			when	tlbMonitoringSession.idfMonitoringSession is not null	-- Livestock	/*Active Surveillance*/
				then	32
			when	tlbVectorSurveillanceSession.idfVectorSurveillanceSession is not null	-- Vector
				then	128
			else		0
		END as int) AS intCaseHACode,
		
		COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis) AS idfsShowDiagnosis,
		--(CASE 
		--	WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN AsDiagnosis.name COLLATE DATABASE_DEFAULT 
		--	WHEN tlbVetCase.idfVetCase IS NOT NULL THEN ISNULL(VetDiagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) COLLATE DATABASE_DEFAULT 
		--	ELSE Diagnosis.name COLLATE DATABASE_DEFAULT 
		--END)  as DiagnosisName,
		tlbVetCase.idfsFinalDiagnosis as idfsVetFinalDiagnosis,
		
		tlbTransferOUT.idfSendToOffice as idfSendToOfficeOut,
		CAST(CASE 
			when	tstSite.idfsSite IS NULL then 1
			else	0
		END as bit) AS bExternalOffice,
		tlbTransferOUT.idfSendByPerson,
		tlbTransferOUT.datSendDate,
		
		tlbGeoLocation.idfsCountry,
		tlbGeoLocation.idfsRegion,
		tlbGeoLocation.idfsRayon,
		tlbGeoLocation.idfsSettlement,
		
		tlbTesting.idfTesting,
		tlbTesting.idfsTestName,
		tlbTesting.idfsTestCategory,
		tlbTesting.idfsTestStatus,
		tlbTesting.idfsTestResult,
		tlbTesting.idfObservation,
		tlbTesting.strNote,
		tlbTesting.idfTestedByOffice,
		tlbTesting.idfTestedByPerson,
		tlbTesting.idfResultEnteredByOffice,
		tlbTesting.idfResultEnteredByPerson,
		tlbTesting.idfValidatedByOffice,
		tlbTesting.idfValidatedByPerson,
		tlbTesting.blnNonLaboratoryTest,
		tlbTesting.blnExternalTest,
		tlbTesting.datReceivedDate,
		tlbTesting.idfPerformedByOffice,
		tlbTesting.strContactPerson,
		tlbTesting.datStartedDate,
		tlbTesting.datConcludedDate,
		tlbObservation.idfsFormTemplate,

		tlbTesting.idfsDiagnosis,
		--tstDiagnosis.name as tstDiagnosisName,
		
		tlbBatchTest.strBarcode as strBatchID
		
		
	from tlbMaterial
	--with(index(IX_tlbMaterial_datSampleStatusDate))
		left join	tlbMonitoringSession
		on			tlbMonitoringSession.idfMonitoringSession=tlbMaterial.idfMonitoringSession
		left join	tlbVetCase 
		on			tlbVetCase.idfVetCase = tlbMaterial.idfVetCase
					AND tlbVetCase.intRowStatus = 0
		left join	tlbHumanCase
		on			tlbHumanCase.idfHumanCase = tlbMaterial.idfHumanCase
					AND tlbHumanCase.intRowStatus = 0
		left join	tlbHuman HumanFromCase
		on			HumanFromCase.idfHuman = tlbHumanCase.idfHuman
		
		left join	tlbVectorSurveillanceSession
		on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
		
		left join	tlbAnimal
		on			tlbMaterial.idfAnimal = tlbAnimal.idfAnimal
		left join	tlbSpecies
		ON			tlbSpecies.idfSpecies = isnull(tlbMaterial.idfSpecies, tlbAnimal.idfSpecies)
		left join	tlbHerd
		on			tlbHerd.idfHerd = tlbSpecies.idfHerd
					AND tlbHerd.intRowStatus = 0
		LEFT JOIN	tlbFarm 
		ON			tlbFarm.idfFarm = tlbHerd.idfFarm			   
					AND tlbFarm.intRowStatus = 0

		left join	dbo.tlbVector
		on			tlbMaterial.idfVector = tlbVector.idfVector
					
		left join	tlbGeoLocation
		on			isnull(isnull(HumanFromCase.idfCurrentResidenceAddress, tlbFarm.idfFarmAddress), tlbVector.idfLocation) = tlbGeoLocation.idfGeoLocation
					
		--left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis 
		--on			Diagnosis.idfsReference = COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis)

		--left join   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
		--on			tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  

		--left join 	dbo.vwAsSessionDiagnosis AsDiagnosis
		--ON			AsDiagnosis.idfMonitoringSession = tlbMonitoringSession.idfMonitoringSession and dbo.fnGetLanguageCode(@LangID) = AsDiagnosis.idfsLanguage

		left join	tlbMaterial tlbMaterialParent
		ON			tlbMaterial.idfParentMaterial = tlbMaterialParent.idfMaterial
		
		left join	tlbTransferOutMaterial
		on			tlbTransferOutMaterial.idfMaterial=tlbMaterial.idfMaterial and
					tlbTransferOutMaterial.intRowStatus=0
		left join	tlbTransferOUT
		on			tlbTransferOUT.idfTransferOut=tlbTransferOutMaterial.idfTransferOut and
					tlbTransferOUT.intRowStatus=0
		left join	tlbOffice
		on			tlbOffice.idfOffice=tlbTransferOUT.idfSendToOffice and
					tlbOffice.intRowStatus=0
		left join	tstSite
		on			tstSite.idfOffice = tlbOffice.idfOffice and 
					tstSite.intRowStatus = 0
		
		left join	tlbTesting
		on			tlbTesting.idfMaterial = tlbMaterial.idfMaterial
					and tlbTesting.blnNonLaboratoryTest = 0
					and tlbTesting.intRowStatus = 0
		left join	dbo.tlbBatchTest
		on			tlbBatchTest.idfBatchTest = tlbTesting.idfBatchTest
		left join	tlbObservation 
		on			tlbObservation.idfObservation = tlbTesting.idfObservation
		--left join	fnReferenceRepair(@LangID, 19000019 ) tstDiagnosis 
		--on			tstDiagnosis.idfsReference = tlbTesting.idfsDiagnosis
		
	where
		tlbMaterial.intRowStatus = 0
		and tlbMaterial.blnReadOnly = 0
		and isnull(tlbMaterial.idfsSampleType,0) not in (10320001) -- samples with Unknown sample type shall not be displayed in the Laboratory Section
		and isnull(tlbMaterial.idfsSampleStatus,0) not in (10015002, 10015008) -- deleted samples shall not be displayed in the Laboratory Section
		and isnull(tlbMaterial.idfsAccessionCondition,0) != 10108003 -- rejected samples shall not be displayed in the Laboratory Section
		and (isnull(tlbMaterial.idfsSampleStatus,0) = 0 or tlbMaterial.idfsCurrentSite = dbo.fnSiteID()) -- show all unaccessioned and accessioned in current site
	) smp
	
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()

where	(dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					left     join tlbMonitoringSessionToDiagnosis asd
					on			asd.idfMonitoringSession = smp.idfMonitoringSession
								and asd.intRowStatus = 0
					left join  dbo.tlbPensideTest pt
						inner join trtPensideTestTypeToTestResult tr
						on			pt.idfsPensideTestName = tr.idfsPensideTestName
									and pt.idfsPensideTestResult = tr.idfsPensideTestResult
									and pt.intRowStatus = 0
									and tr.intRowStatus = 0
									and tr.blnIndicative = 1
					on			pt.idfMaterial = smp.idfMaterial and not smp.idfVectorSurveillanceSession is null
								and pt.intRowStatus = 0
								left join tlbTesting t
					on			t.idfMaterial = smp.idfMaterial and not smp.idfVectorSurveillanceSession is null
								and t.intRowStatus = 0
					left join  tlbVectorSurveillanceSessionSummary vsss 
						inner Join	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
						On			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
									and vssd.intRowStatus = 0
					on			vsss.idfVectorSurveillanceSession = smp.idfVectorSurveillanceSession
								and vsss.intRowStatus = 0
					left join	tlbHumanCase
					on			tlbHumanCase.idfHumanCase=smp.idfHumanCase
								AND tlbHumanCase.intRowStatus = 0
					left join	tlbVetCase
					on			tlbVetCase.idfVetCase=smp.idfVetCase
								AND tlbVetCase.intRowStatus = 0
					left join	tlbMonitoringSession
					on			tlbMonitoringSession.idfMonitoringSession=smp.idfMonitoringSession
								AND tlbMonitoringSession.intRowStatus = 0
					left join	tlbVectorSurveillanceSession
					on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession=smp.idfVectorSurveillanceSession
								AND tlbVectorSurveillanceSession.intRowStatus = 0
								
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								AND  (	(not smp.idfHuman is NULL  and oa_diag_user_deny.idfsObjectID = isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis))
										OR
										(not smp.idfVetCase is NULL and oa_diag_user_deny.idfsObjectID in (tlbVetCase.idfsFinalDiagnosis, tlbVetCase.idfsTentativeDiagnosis,tlbVetCase.idfsTentativeDiagnosis1, tlbVetCase.idfsTentativeDiagnosis2))
										OR
										(not smp.idfMonitoringSession is NULL and oa_diag_user_deny.idfsObjectID = asd.idfsDiagnosis)
										OR
										(not smp.idfVectorSurveillanceSession is NULL
											 and (oa_diag_user_deny.idfsObjectID  = pt.idfsDiagnosis
													or  oa_diag_user_deny.idfsObjectID  = t.idfsDiagnosis
													or oa_diag_user_deny.idfsObjectID  =  vssd.idfsDiagnosis))
								)
								and oa_diag_user_deny.idfsObjectOperation = 10059003	-- Read
								and oa_diag_user_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_diag_user_deny.intRowStatus = 0
						)
			and not exists	(
					select		*
					from		tstObjectAccess oa_diag_group_deny
					inner join	tlbEmployeeGroupMember egm_diag_group_deny
					on			egm_diag_group_deny.idfEmployee = ut.idfPerson
								and egm_diag_group_deny.intRowStatus = 0
								and oa_diag_group_deny.idfActor = egm_diag_group_deny.idfEmployeeGroup
					inner join	tlbEmployee eg_diag_group_deny
					on			eg_diag_group_deny.idfEmployee = egm_diag_group_deny.idfEmployeeGroup
								and eg_diag_group_deny.intRowStatus = 0
					left     join tlbMonitoringSessionToDiagnosis asd
					on			asd.idfMonitoringSession = smp.idfMonitoringSession
								and asd.intRowStatus = 0
					left join  dbo.tlbPensideTest pt
						inner join trtPensideTestTypeToTestResult tr
						on			pt.idfsPensideTestName = tr.idfsPensideTestName
									and pt.idfsPensideTestResult = tr.idfsPensideTestResult
									and pt.intRowStatus = 0
									and tr.intRowStatus = 0
									and tr.blnIndicative = 1
					on			pt.idfMaterial = smp.idfMaterial and not smp.idfVectorSurveillanceSession is null
								and pt.intRowStatus = 0
								left join tlbTesting t
					on			t.idfMaterial = smp.idfMaterial and not smp.idfVectorSurveillanceSession is null
								and t.intRowStatus = 0
					left join  tlbVectorSurveillanceSessionSummary vsss 
						inner Join	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
						On			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
									and vssd.intRowStatus = 0
					on			vsss.idfVectorSurveillanceSession = smp.idfVectorSurveillanceSession
								and vsss.intRowStatus = 0
					left join	tlbHumanCase
					on			tlbHumanCase.idfHumanCase=smp.idfHumanCase
								AND tlbHumanCase.intRowStatus = 0
					left join	tlbVetCase
					on			tlbVetCase.idfVetCase=smp.idfVetCase
								AND tlbVetCase.intRowStatus = 0
					left join	tlbMonitoringSession
					on			tlbMonitoringSession.idfMonitoringSession=smp.idfMonitoringSession
								AND tlbMonitoringSession.intRowStatus = 0
					left join	tlbVectorSurveillanceSession
					on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession=smp.idfVectorSurveillanceSession
								AND tlbVectorSurveillanceSession.intRowStatus = 0
					where		oa_diag_group_deny.intPermission = 1					-- deny
								AND  (	(not smp.idfHuman is NULL  and oa_diag_group_deny.idfsObjectID = isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis))
										OR
										(not smp.idfVetCase is NULL and oa_diag_group_deny.idfsObjectID in (tlbVetCase.idfsFinalDiagnosis, tlbVetCase.idfsTentativeDiagnosis,tlbVetCase.idfsTentativeDiagnosis1, tlbVetCase.idfsTentativeDiagnosis2))
										OR
										(not smp.idfMonitoringSession is NULL and oa_diag_group_deny.idfsObjectID = asd.idfsDiagnosis)
										OR
										(not smp.idfVectorSurveillanceSession is NULL
											 and (oa_diag_group_deny.idfsObjectID  = pt.idfsDiagnosis
													or  oa_diag_group_deny.idfsObjectID  = t.idfsDiagnosis
													or oa_diag_group_deny.idfsObjectID  =  vssd.idfsDiagnosis))
								)
								and oa_diag_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_diag_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_diag_group_deny.intRowStatus = 0
						)
					)
				)

		and (dbo.fnSiteDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_site_user_deny
					left join	tlbHumanCase
					on			tlbHumanCase.idfHumanCase=smp.idfHumanCase
								AND tlbHumanCase.intRowStatus = 0
					left join	tlbVetCase
					on			tlbVetCase.idfVetCase=smp.idfVetCase
								AND tlbVetCase.intRowStatus = 0
					left join	tlbMonitoringSession
					on			tlbMonitoringSession.idfMonitoringSession=smp.idfMonitoringSession
								AND tlbMonitoringSession.intRowStatus = 0
					left join	tlbVectorSurveillanceSession
					on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession=smp.idfVectorSurveillanceSession
								AND tlbVectorSurveillanceSession.intRowStatus = 0
					where		oa_site_user_deny.intPermission = 1						-- deny
								and oa_site_user_deny.idfActor = ut.idfPerson
								and oa_site_user_deny.idfsObjectID = CASE 
									WHEN not smp.idfHuman is NULL THEN tlbHumanCase.idfsSite
									WHEN not smp.idfVetCase is NULL THEN tlbVetCase.idfsSite
									WHEN not smp.idfMonitoringSession is NULL THEN tlbMonitoringSession.idfsSite
									WHEN not smp.idfVectorSurveillanceSession is NULL THEN tlbVectorSurveillanceSession.idfsSite
									ELSE 0 
									END
								and oa_site_user_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_user_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_user_deny.intRowStatus = 0
						)
		and not exists	(
					select		*
					from		tstObjectAccess oa_site_group_deny
					left join	tlbHumanCase
					on			tlbHumanCase.idfHumanCase=smp.idfHumanCase
								AND tlbHumanCase.intRowStatus = 0
					left join	tlbVetCase
					on			tlbVetCase.idfVetCase=smp.idfVetCase
								AND tlbVetCase.intRowStatus = 0
					left join	tlbMonitoringSession
					on			tlbMonitoringSession.idfMonitoringSession=smp.idfMonitoringSession
								AND tlbMonitoringSession.intRowStatus = 0
					left join	tlbVectorSurveillanceSession
					on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession=smp.idfVectorSurveillanceSession
								AND tlbVectorSurveillanceSession.intRowStatus = 0
					inner join	tlbEmployeeGroupMember egm_site_group_deny
					on			egm_site_group_deny.idfEmployee = ut.idfPerson
								and oa_site_group_deny.idfActor = egm_site_group_deny.idfEmployeeGroup
								and egm_site_group_deny.intRowStatus = 0
					inner join	tlbEmployee eg_site_group_deny
					on			eg_site_group_deny.idfEmployee = egm_site_group_deny.idfEmployeeGroup
								and eg_site_group_deny.intRowStatus = 0
					where		oa_site_group_deny.intPermission = 1					-- deny
								and oa_site_group_deny.idfsObjectID = CASE 
									WHEN not smp.idfHuman is NULL THEN tlbHumanCase.idfsSite
									WHEN not smp.idfVetCase is NULL THEN tlbVetCase.idfsSite
									WHEN not smp.idfMonitoringSession is NULL THEN tlbMonitoringSession.idfsSite
									WHEN not smp.idfVectorSurveillanceSession is NULL THEN tlbVectorSurveillanceSession.idfsSite
									ELSE 0 
									END
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)


