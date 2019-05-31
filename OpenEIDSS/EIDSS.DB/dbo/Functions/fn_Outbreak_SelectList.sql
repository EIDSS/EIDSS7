




--##SUMMARY Returns the list of outbreaks.
--##SUMMARY Used by OutbreakList form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.12.2009
--##REMARKS Update date: 29.11.2011 (Olga Mirnaya)

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:
SELECT * FROM fn_Outbreak_SelectList ('en')

*/


CREATE    Function fn_Outbreak_SelectList(
	@LangID as nvarchar(50)--##PARAM @LangID  - language ID
)
returns table 
as
return
select		tlbOutbreak.idfOutbreak, 
			tlbOutbreak.strOutbreakID,
			tlbOutbreak.datStartDate, 
			tlbOutbreak.datFinishDate,
			ISNULL(Diagnosis.[name], DiagnosisAsGroup.[name]) as strDiagnosisOrDiagnosisGroup,
			tlbOutbreak.idfsDiagnosisOrDiagnosisGroup,
			ISNULL(DiagnosisAsGroup.[name], DiagnosisGroup.[name]) as strDiagnosisGroup,
			ISNULL(dg.idfsDiagnosisGroup, tlbOutbreak.idfsDiagnosisOrDiagnosisGroup) as idfsDiagnosisGroup,
			OutbreakStatus.[name] as strOutbreakStatus,
			tlbOutbreak.idfsOutbreakStatus,
			tlbOutbreak.idfGeoLocation,			
			dbo.fnCreateGeoLocationString	(
									@LangID,
									GeoLocation.idfsGeoLocationType, 
									GeoLocation.Country,
									GeoLocation.Region,
									GeoLocation.Rayon,
									GeoLocation.Latitude,
									GeoLocation.Longitude,
									GeoLocation.PostalCode,
									GeoLocation.SettlementType,
									GeoLocation.Settlement,
									GeoLocation.Street,
									GeoLocation.House,
									GeoLocation.Building,
									GeoLocation.Appartment,
									GeoLocation.Alignment,
									GeoLocation.Distance,
									blnForeignAddress,
									strForeignAddress
											) as strGeoLocationName, 
			CASE WHEN (NOT Patient.idfHuman IS NULL) THEN dbo.fnConcatFullName(Patient.strLastName, Patient.strFirstName, Patient.strSecondName) 
				 WHEN (NOT FarmOwner.idfHuman IS NULL) THEN dbo.fnConcatFullName(FarmOwner.strLastName, FarmOwner.strFirstName, FarmOwner.strSecondName) 
				 ELSE N'' END  as strPatientName,  
    dbo.fnConcatFullName(Patient.strLastName, Patient.strFirstName, Patient.strSecondName) as strHumanPatientName,
    dbo.fnConcatFullName(FarmOwner.strLastName, FarmOwner.strFirstName, FarmOwner.strSecondName)   as strFarmOwner
from	(	
	tlbOutbreak 

	left join	dbo.fnReferenceRepair(@LangID,19000019) as Diagnosis --'rftDiagnosis'
	on			tlbOutbreak.idfsDiagnosisOrDiagnosisGroup = Diagnosis.idfsReference
	left join	dbo.fnReferenceRepair(@LangID,19000156) as DiagnosisAsGroup --'rftDiagnosisGroup'
	on			tlbOutbreak.idfsDiagnosisOrDiagnosisGroup = DiagnosisAsGroup.idfsReference

    left join   trtDiagnosisToDiagnosisGroup as dg
	on			dg.idfsDiagnosis = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
	left join	dbo.fnReferenceRepair(@LangID,19000156) as DiagnosisGroup --'rftDiagnosisGroup'
	on			dg.idfsDiagnosisGroup = DiagnosisGroup.idfsReference

	left join	dbo.fnReferenceRepair(@LangID,19000063) as OutbreakStatus --'rftOutbreakStatus'
	on			tlbOutbreak.idfsOutbreakStatus = OutbreakStatus.idfsReference
		)
	left join	fnGeoLocationAsRow(@LangID) as GeoLocation
	on			GeoLocation.idfGeoLocation = tlbOutbreak.idfGeoLocation
	
	left join  tlbHumanCase 
		inner join		tlbHuman as Patient
		on				Patient.idfHuman = tlbHumanCase.idfHuman
						and Patient.intRowStatus = 0
	on  		tlbHumanCase.idfHumanCase = tlbOutbreak.idfPrimaryCaseOrSession
				AND tlbHumanCase.intRowStatus = 0
				
	left join	tlbVetCase 
		inner join	tlbFarm
		on			tlbFarm.idfFarm = tlbVetCase.idfFarm
					and tlbFarm.intRowStatus = 0
		left join	tlbHuman as FarmOwner
		on			FarmOwner.idfHuman = tlbFarm.idfHuman
					and FarmOwner.intRowStatus = 0
	on			tlbVetCase.idfVetCase = tlbOutbreak.idfPrimaryCaseOrSession
				AND tlbVetCase.intRowStatus = 0
	
	--JOIN fnGetPermissionOnOutbreak(NULL, NULL) GetPermission ON
	--	GetPermission.idfOutbreak = tlbOutbreak.idfOutbreak
	--	AND GetPermission.intPermission = 2					
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()
		
where
				tlbOutbreak.intRowStatus = 0
		and (dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					left join   trtDiagnosisToDiagnosisGroup as dg1
					on			dg1.idfsDiagnosisGroup = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
								and dg1.intRowStatus = 0
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								and (oa_diag_user_deny.idfsObjectID = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
								or	oa_diag_user_deny.idfsObjectID = dg1.idfsDiagnosis)
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
					left join   trtDiagnosisToDiagnosisGroup as dg1
					on			dg1.idfsDiagnosisGroup = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
								and dg1.intRowStatus = 0
					where		oa_diag_group_deny.intPermission = 1					-- deny
								and (oa_diag_group_deny.idfsObjectID = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
								or	oa_diag_group_deny.idfsObjectID = dg1.idfsDiagnosis)
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
								and oa_site_user_deny.idfsObjectID = tlbOutbreak.idfsSite
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
								and oa_site_group_deny.idfsObjectID = tlbOutbreak.idfsSite
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)













