--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Function called by SP 
/*
----testing code:
----related fact data from
select * from fn_HumanCase_SelectList ('en')
*/
--=====================================================================================================

CREATE	function	[dbo].[fn_HumanCase_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)
returns table

return
select			tlbHumanCase.idfHumanCase AS idfCase,
				ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) as idfsDiagnosis,
				Diagnosis.[name] as DiagnosisName,
				ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus) AS idfsCaseStatus,
				tlbHumanCase.idfsCaseProgressStatus,
				CaseStatus.[name] as CaseStatusName,
				CaseProgressStatus.[name] as CaseProgressStatusName,
				tlbHumanCase.datEnteredDate,
				tlbHumanCase.strCaseID,
				tlbHumanCase.idfsSite,
				tlbHumanCase.datCompletionPaperFormDate,
				tlbHumanCase.strLocalIdentifier,
				tlbHumanCase.idfPersonEnteredBy,
				tlbHumanCase.idfHuman,
				tlbHuman.strLastName,
				tlbHuman.strFirstName,
				tlbHuman.strSecondName,
				dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as PatientName,
				tlbHuman.datDateofBirth,
				tlbHumanCase.intPatientAge,
				tlbHumanCase.idfsHumanAgeType,
				IsNull(	str(tlbHumanCase.intPatientAge) + 
						' (' + HumanAgeType.[name] + ')', '') as Age,
				tlbHuman.idfCurrentResidenceAddress as idfAddress, --needed for OutbreakDetail form
				tlbHumanCase.idfPointGeoLocation as idfGeoLocation,
				ISNULL(CurrentResidenceAddress.name, CurrentResidenceAddress.strDefault) AS GeoLocationName,
				tlbHumanCase.idfEpiObservation,
				tlbHumanCase.idfCSObservation,
			    tlbHumanCase.idfsTentativeDiagnosis,
			    tlbHumanCase.idfsInitialCaseStatus,
				CRA.idfsSettlement, 
				CRA.idfsRegion, 
				CRA.idfsRayon, 
				CRA.idfsCountry,
				location.idfsRayon as idfsLocationOfExposureRayon,
				location.idfsRegion as idfsLocationOfExposureRegion,
				tlbHumanCase.datFinalCaseClassificationDate,
				tlbHuman.idfsPersonIDType,
				tlbHuman.strPersonID

from			(
	tlbHumanCase
	left join	dbo.fnReferenceRepair(@LangID, 19000042) as HumanAgeType
	on			HumanAgeType.idfsReference = tlbHumanCase.idfsHumanAgeType
	left join	dbo.fnReferenceRepair(@LangID, 19000019) as Diagnosis		--'rftDiagnosis'
	on			Diagnosis.idfsReference = ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis)
	left join	dbo.fnReferenceRepair(@LangID,19000111) as CaseProgressStatus --'rftCaseProgressStatus'
	on			CaseProgressStatus.idfsReference = tlbHumanCase.idfsCaseProgressStatus
	left join	dbo.fnReferenceRepair(@LangID, 19000011) as CaseStatus	--'rftCaseStatus'
	on			CaseStatus.idfsReference = ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus)
				)
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0

LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) CurrentResidenceAddress ON
	CurrentResidenceAddress.idfGeoLocation = tlbHuman.idfCurrentResidenceAddress

LEFT JOIN dbo.tlbGeoLocation CRA ON
   tlbHuman.idfCurrentResidenceAddress  = CRA.idfGeoLocation
LEFT JOIN dbo.tlbGeoLocation location ON
   tlbHumanCase.idfPointGeoLocation  = location.idfGeoLocation

--JOIN fnGetPermissionOnHumanCase(NULL, NULL) GetPermission ON
--	GetPermission.idfHumanCase = tlbHumanCase.idfHumanCase
--	AND GetPermission.intPermission = 2
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()
WHERE	tlbHumanCase.intRowStatus = 0
		and (dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								and oa_diag_user_deny.idfsObjectID = isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis)
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
					where		oa_diag_group_deny.intPermission = 1					-- deny
								and oa_diag_group_deny.idfsObjectID = isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis)
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
								and oa_site_user_deny.idfsObjectID = tlbHumanCase.idfsSite
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
								and oa_site_group_deny.idfsObjectID = tlbHumanCase.idfsSite
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)





