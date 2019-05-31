



--##SUMMARY Returns list of all samples performed on any site.
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

-- select * from fnSampleListOptimized('en')


CREATE function [dbo].[fnSampleListOptimized](@LangID as nvarchar(50))
returns table
as
return
select			
				tlbMaterial.idfMaterial,
				tlbMaterial.idfInDepartment,
				tlbMaterial.idfsSampleStatus,
				tlbMaterial.idfMonitoringSession,
				tlbMaterial.idfVectorSurveillanceSession,
				(CASE 
					WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN AsDiagnosis.name COLLATE DATABASE_DEFAULT 
					WHEN tlbVetCase.idfVetCase IS NOT NULL THEN
					--This is workaround for task 13229 (Vet case final diagnosis shall be displayed in bold), affects to desktop only
					ISNULL(N'<b>'+ Diagnosis.name+ N'</b>, ', N'') + ISNULL(VetDiagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) COLLATE DATABASE_DEFAULT 
					ELSE Diagnosis.name COLLATE DATABASE_DEFAULT 
				END)  as DiagnosisName,  
				tlbMaterial.strBarcode,
				st.name as strSampleName,
				COALESCE (tlbHumanCase.strCaseID,tlbVetCase.strCaseID,tlbMonitoringSession.strMonitoringSessionID,tlbVectorSurveillanceSession.strSessionID) as CaseID,
				Department.name as DepartmentName,
				tlbMaterial.datFieldCollectionDate,
				tlbMaterial.strFieldBarcode,
				tlbMaterial.strCalculatedHumanName as HumanName, 
				tlbMaterial.idfsSampleType,
				COALESCE (Animal.AnimalName, tlbVector.strVectorID) as AnimalName,
				Animal.idfsSpeciesType, 
				tlbFarm.strNationalName,
				ISNULL(tlbHumanCase.idfHumanCase, tlbVetCase.idfVetCase) AS idfCase,
				COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) AS idfsShowDiagnosis,
				tlbVetCase.idfsTentativeDiagnosis,
				tlbVetCase.idfsTentativeDiagnosis1,
				tlbVetCase.idfsTentativeDiagnosis2,
				tlbVetCase.idfsFinalDiagnosis,
				CASE 
					WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
					ELSE tlbVetCase.idfsCaseType
				END AS idfsCaseType, --required for private data hiding
				case	
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
				end	as HACode,

				ISNULL(Tests.TestsCount,0) TestsCount,
				tlbMaterial.datAccession ,
				tlbMaterial.idfsAccessionCondition,
				CASE WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN tlbMaterial.strCalculatedHumanName ELSE NULL END as strPatientName,
				CASE WHEN tlbVetCase.idfVetCase IS NOT NULL THEN tlbMaterial.strCalculatedHumanName ELSE NULL END as strFarmOwner
from		tlbMaterial
			
inner join	dbo.fnReferenceRepair(@LangID,19000087) st--rftSampleType
on			st.idfsReference = tlbMaterial.idfsSampleType
left join	tlbMonitoringSession
on			tlbMonitoringSession.idfMonitoringSession=tlbMaterial.idfMonitoringSession
left join	tlbVectorSurveillanceSession
on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession=tlbMaterial.idfVectorSurveillanceSession

LEFT JOIN tlbVetCase ON
	tlbVetCase.idfVetCase = tlbMaterial.idfVetCase
	AND tlbVetCase.intRowStatus = 0
LEFT JOIN tlbHumanCase ON
	tlbHumanCase.idfHumanCase = tlbMaterial.idfHumanCase
	AND tlbHumanCase.intRowStatus = 0
	
left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis --rftTestForDiseaseType
on			Diagnosis.idfsReference = COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsFinalDiagnosis)

LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
on tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  
	
LEFT JOIN 	dbo.vwAsSessionDiagnosis AsDiagnosis
	ON AsDiagnosis.idfMonitoringSession = tlbMonitoringSession.idfMonitoringSession and dbo.fnGetLanguageCode(@LangID) = AsDiagnosis.idfsLanguage
	
LEFT JOIN tlbFarm ON
	tlbFarm.idfFarm = tlbVetCase.idfFarm
	AND tlbFarm.intRowStatus = 0


left join	fnAnimalList(@LangID) Animal
on			tlbMaterial.idfAnimal=Animal.idfParty
			or tlbMaterial.idfSpecies = Animal.idfParty

left join	tlbVector
on			tlbVector.idfVector = tlbMaterial.idfVector
			and tlbVector.intRowStatus = 0

left join	fnDepartment(@LangID) Department
on			Department.idfDepartment=tlbMaterial.idfInDepartment

left join
			(
			select		tlbTesting.idfMaterial, COUNT(*) as TestsCount
			from		tlbTesting
			where		tlbTesting.intRowStatus=0
						and IsNull(tlbTesting.blnReadOnly, 0) <> 1
			group by	tlbTesting.idfMaterial
			) Tests 
on			Tests.idfMaterial = tlbMaterial.idfMaterial

--JOIN fnGetPermissionOnSample(NULL, NULL) GetPermission ON
--	GetPermission.idfMaterial = tlbMaterial.idfMaterial
--	AND GetPermission.intPermission = 2
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()
		
where		tlbMaterial.blnShowInLabList = 1
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

