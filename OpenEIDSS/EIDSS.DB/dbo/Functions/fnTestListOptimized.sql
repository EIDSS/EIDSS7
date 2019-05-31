



--##SUMMARY Returns list of all tests performed on any site.
--##REMARKS Author: Vdovin.
--##REMARKS Create date: 01.10.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

-- select * from fnTestListOptimized('en')


CREATE function [dbo].[fnTestListOptimized](@LangID as nvarchar(50))
returns table
as
return
select			
				tlbTesting.idfTesting,--used anyway
				tlbTesting.idfsTestName,--needed
				tlbTesting.idfObservation,
				tlbTesting.idfsTestCategory,
				tlbTesting.idfsTestStatus,
				tlbTesting.idfsTestResult,
				tlbTesting.datStartedDate,
				tlbTesting.idfsDiagnosis,
				tlbTesting.idfMaterial,

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
				tlbObservation.idfsFormTemplate,
				
/*				
	@datConcludedDate as datetime,
*/				
				ISNULL(tlbTesting.datConcludedDate, tlbBatchTest.datValidatedDate) as datConcludedDate,

				TestName.[name] as TestName,
				TestResult.[name] as TestResult,
				Category.name as TestCategory,
				Diagnosis.name as DiagnosisName,

				tlbBatchTest.idfBatchTest,

				tlbBatchTest.strBarcode as BatchTestCode,
				tlbBatchTest.datPerformedDate,
				tlbBatchTest.idfsBatchStatus,
				StatusType.[name] as [Status],

				tlbMaterial.strBarcode,
				tlbMaterial.idfsSite,
				st.name as strSampleName,
				tlbMaterial.strCalculatedCaseID as CaseID, 
				tlbMaterial.idfsSampleType,
				ISNULL(tlbHumanCase.idfHumanCase, tlbVetCase.idfVetCase) AS idfCase,
				CASE 
					WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
					ELSE tlbVetCase.idfsCaseType
				END AS idfsCaseType, --required for private data hiding
				--the fields below are needed for test events generation from batch
				--when we select test to batch, we should know to which owber it belongs
				tlbMaterial.idfHumanCase, 
				tlbMaterial.idfVetCase,
				tlbMaterial.idfMonitoringSession,
				tlbMaterial.idfVectorSurveillanceSession,
				--
				Department.name as DepartmentName,
				tlbMaterial.datFieldCollectionDate,
				tlbMaterial.datAccession,
				tlbMaterial.strFieldBarcode,
				tlbMaterial.strCalculatedHumanName as HumanName, 
				COALESCE (Animal.AnimalName, tlbVector.strVectorID) as AnimalName,
				CASE WHEN idfsCaseType = 10012001 THEN tlbMaterial.strCalculatedHumanName ELSE NULL END as strPatientName,
				CASE WHEN idfsCaseType = 10012003 OR idfsCaseType = 10012004 THEN tlbMaterial.strCalculatedHumanName ELSE NULL END as strFarmOwner   
from		tlbTesting

inner join	tlbMaterial
on			tlbMaterial.idfMaterial=tlbTesting.idfMaterial

inner join	dbo.fnReferenceRepair(@LangID,19000087) st --rftSampleType
on			st.idfsReference = tlbMaterial.idfsSampleType

left join	tlbHumanCase
on			tlbHumanCase.idfHumanCase=tlbMaterial.idfHumanCase
			AND tlbHumanCase.intRowStatus = 0
left join	tlbVetCase
on			tlbVetCase.idfVetCase=tlbMaterial.idfVetCase
			AND tlbVetCase.intRowStatus = 0
left join	tlbMonitoringSession
on			tlbMonitoringSession.idfMonitoringSession=tlbMaterial.idfMonitoringSession
			AND tlbMonitoringSession.intRowStatus = 0
left join	tlbVectorSurveillanceSession
on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession=tlbMaterial.idfVectorSurveillanceSession
			AND tlbVectorSurveillanceSession.intRowStatus = 0

left join	tlbBatchTest
on			tlbTesting.idfBatchTest=tlbBatchTest.idfBatchTest
left join	tlbObservation 
on			tlbObservation.idfObservation = tlbTesting.idfObservation

left join	fnAnimalList(@LangID) Animal
on			tlbMaterial.idfAnimal=Animal.idfParty
			or tlbMaterial.idfSpecies = Animal.idfParty

left join	tlbVector
on			tlbVector.idfVector = tlbMaterial.idfVector
			and tlbVector.intRowStatus = 0

left join	fnDepartment(@LangID) Department
on			Department.idfDepartment=tlbMaterial.idfInDepartment

inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestName --rftTestName
on			TestName.idfsReference = tlbTesting.idfsTestName

left join	fnReferenceRepair(@LangID, 19000096 ) TestResult --rftTestResult
on			TestResult.idfsReference = tlbTesting.idfsTestResult

left join	fnReferenceRepair(@LangID, 19000095 ) Category --rftTestForDiseaseType
on			Category.idfsReference = tlbTesting.idfsTestCategory

left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis --rftTestForDiseaseType
on			Diagnosis.idfsReference = tlbTesting.idfsDiagnosis

left join	dbo.fnReferenceRepair(@LangID, 19000001 ) StatusType --rftActivityStatus
on			StatusType.idfsReference = tlbTesting.idfsTestStatus

LEFT JOIN dbo.trtObjectTypeToObjectType ot ON
	ot.idfsRelatedObjectType = 10060012
	AND ot.idfsParentObjectType = 10060009
	
--JOIN fnGetPermissionOnSample(NULL, NULL) GetPermission ON
--	GetPermission.idfMaterial = tlbMaterial.idfMaterial
--	AND CASE
--			WHEN ot.idfsStatus = 10107003 
--				THEN ISNULL(GetPermission.intPermission, 2)
--			ELSE 2
--		END = 2
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()
		
where		tlbTesting.intRowStatus=0
			and IsNull(tlbTesting.blnNonLaboratoryTest, 0) <> 1
			and IsNull(tlbTesting.blnReadOnly, 0) <> 1
			and IsNull(tlbTesting.blnExternalTest, 0) <> 1
			and tlbMaterial.blnShowInLabList = 1
			and tlbMaterial.idfsCurrentSite = dbo.fnSiteID()
			and (dbo.fnDiagnosisDenied() = 0 OR (
					not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					left     join tlbMonitoringSessionToDiagnosis asd
					on			asd.idfMonitoringSession = tlbMaterial.idfMonitoringSession
								and asd.intRowStatus = 0
					left join  dbo.tlbPensideTest pt
						inner join trtPensideTestTypeToTestResult tr
						on			pt.idfsPensideTestName = tr.idfsPensideTestName
									and pt.idfsPensideTestResult = tr.idfsPensideTestResult
									and pt.intRowStatus = 0
									and tr.intRowStatus = 0
									and tr.blnIndicative = 1
					on			pt.idfMaterial = tlbMaterial.idfMaterial and not tlbMaterial.idfVectorSurveillanceSession is null
								and pt.intRowStatus = 0
								left join tlbTesting t
					on			t.idfMaterial = tlbMaterial.idfMaterial and not tlbMaterial.idfVectorSurveillanceSession is null
								and t.intRowStatus = 0
					left join  tlbVectorSurveillanceSessionSummary vsss 
						inner Join	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
						On			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
									and vssd.intRowStatus = 0
					on			vsss.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
								and vsss.intRowStatus = 0
								
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								AND  (	(not tlbMaterial.idfHuman is NULL  and oa_diag_user_deny.idfsObjectID = isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis))
										OR
										(not tlbMaterial.idfVetCase is NULL and oa_diag_user_deny.idfsObjectID in (tlbVetCase.idfsFinalDiagnosis, tlbVetCase.idfsTentativeDiagnosis,tlbVetCase.idfsTentativeDiagnosis1, tlbVetCase.idfsTentativeDiagnosis2))
										OR
										(not tlbMaterial.idfMonitoringSession is NULL and oa_diag_user_deny.idfsObjectID = asd.idfsDiagnosis)
										OR
										(not tlbMaterial.idfVectorSurveillanceSession is NULL
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
					on			asd.idfMonitoringSession = tlbMaterial.idfMonitoringSession
								and asd.intRowStatus = 0
					left join  dbo.tlbPensideTest pt
						inner join trtPensideTestTypeToTestResult tr
						on			pt.idfsPensideTestName = tr.idfsPensideTestName
									and pt.idfsPensideTestResult = tr.idfsPensideTestResult
									and pt.intRowStatus = 0
									and tr.intRowStatus = 0
									and tr.blnIndicative = 1
					on			pt.idfMaterial = tlbMaterial.idfMaterial and not tlbMaterial.idfVectorSurveillanceSession is null
								and pt.intRowStatus = 0
								left join tlbTesting t
					on			t.idfMaterial = tlbMaterial.idfMaterial and not tlbMaterial.idfVectorSurveillanceSession is null
								and t.intRowStatus = 0
					left join  tlbVectorSurveillanceSessionSummary vsss 
						inner Join	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
						On			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
									and vssd.intRowStatus = 0
					on			vsss.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
								and vsss.intRowStatus = 0
					where		oa_diag_group_deny.intPermission = 1					-- deny
								AND  (	(not tlbMaterial.idfHuman is NULL  and oa_diag_group_deny.idfsObjectID = isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis))
										OR
										(not tlbMaterial.idfVetCase is NULL and oa_diag_group_deny.idfsObjectID in (tlbVetCase.idfsFinalDiagnosis, tlbVetCase.idfsTentativeDiagnosis,tlbVetCase.idfsTentativeDiagnosis1, tlbVetCase.idfsTentativeDiagnosis2))
										OR
										(not tlbMaterial.idfMonitoringSession is NULL and oa_diag_group_deny.idfsObjectID = asd.idfsDiagnosis)
										OR
										(not tlbMaterial.idfVectorSurveillanceSession is NULL
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
					where		oa_site_user_deny.intPermission = 1						-- deny
								and oa_site_user_deny.idfActor = ut.idfPerson
								and oa_site_user_deny.idfsObjectID = CASE 
									WHEN not tlbMaterial.idfHuman is NULL THEN tlbHumanCase.idfsSite
									WHEN not tlbMaterial.idfVetCase is NULL THEN tlbVetCase.idfsSite
									WHEN not tlbMaterial.idfMonitoringSession is NULL THEN tlbMonitoringSession.idfsSite
									WHEN not tlbMaterial.idfVectorSurveillanceSession is NULL THEN tlbVectorSurveillanceSession.idfsSite
									ELSE 0 
									END
								and oa_site_user_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_user_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_user_deny.intRowStatus = 0
						)
			and not exists	(
					select		*
					from		tstObjectAccess oa_site_group_deny
					inner join	tlbEmployeeGroupMember egm_site_group_deny
					on			egm_site_group_deny.idfEmployee = ut.idfPerson
								and oa_site_group_deny.idfActor = egm_site_group_deny.idfEmployeeGroup
								and egm_site_group_deny.intRowStatus = 0
					inner join	tlbEmployee eg_site_group_deny
					on			eg_site_group_deny.idfEmployee = egm_site_group_deny.idfEmployeeGroup
								and eg_site_group_deny.intRowStatus = 0
					where		oa_site_group_deny.intPermission = 1					-- deny
								and oa_site_group_deny.idfsObjectID = CASE 
									WHEN not tlbMaterial.idfHuman is NULL THEN tlbHumanCase.idfsSite
									WHEN not tlbMaterial.idfVetCase is NULL THEN tlbVetCase.idfsSite
									WHEN not tlbMaterial.idfMonitoringSession is NULL THEN tlbMonitoringSession.idfsSite
									WHEN not tlbMaterial.idfVectorSurveillanceSession is NULL THEN tlbVectorSurveillanceSession.idfsSite
									ELSE 0 
									END
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)






