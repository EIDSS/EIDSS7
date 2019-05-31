
--##SUMMARY Returns the list of veterinary case.  
--##SUMMARY Used by VetCaseList form.  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 28.11.2009   
  
--##REMARKS UPDATED BY: Vorobiev E.  
--##REMARKS Date: 07.07.2011  

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013
  
--##RETURNS Doesn't use  
  
  
/*  
--Example of a call of procedure:  
SELECT * FROM fn_VetCase_SelectList ('en') where (fn_VetCase_SelectList.idfsCaseProgressStatus = 10109002)  
  
*/  
  
  
CREATE              Function [dbo].[fn_VetCase_SelectList](  
  @LangID as nvarchar(50) --##PARAM @LangID  - language ID  
)  
RETURNS TABLE  
--returns @res table  (  
-- idfCase    bigint,  
-- datAssignedDate   datetime,   
-- datEnteringDate   datetime,    
-- strCaseID    nvarchar(200),   
-- datReportDate   datetime,   
-- datInvestigationDate datetime,  
-- idfsShowDiagnosis   bigint,  
-- idfsTentativeDiagnosis bigint,  
-- idfsTentativeDiagnosis1 bigint,  
-- idfsTentativeDiagnosis2 bigint,  
-- idfsFinalDiagnosis  bigint,  
-- idfsCaseClassification   bigint,    
-- DiagnosisName   nvarchar(200),   
-- CaseStatusName   nvarchar(200),   
-- strCaseType    nvarchar(200),  
-- idfsCaseType   bigint,  
-- idfAddress     bigint,  
-- AddressName    nvarchar(1000),  
-- idfFarm     bigint,  
-- FarmName    nvarchar(200),   
-- idfGeoLocation   bigint,  
-- idfsAvianFarmType  bigint,  
-- idfsAvianProductionType bigint,  
-- idfsFarmCategory  bigint,  
-- idfsOwnershipStructure bigint,  
-- idfsMovementPattern  bigint,  
-- idfsIntendedUse   bigint,  
-- idfsGrazingPattern  bigint,  
-- idfsLivestockProductionType bigint,  
-- strInternationalName nvarchar(200),  
-- strNationalName   nvarchar(200),  
-- strFarmCode    nvarchar(200),  
-- strFax     nvarchar(200),  
-- strEmail    nvarchar(200),  
-- strContactPhone   nvarchar(200),  
-- strOwnerFirstName  nvarchar(200),  
-- strOwnerMiddleName  nvarchar(200),  
-- strOwnerLastName  nvarchar(200),  
-- intSickAnimalQty  int,  
-- intTotalAnimalQty  int,  
-- intDeadAnimalQty  int  
--  
--     )  
as  
--begin  
  
--declare @TypePer int  
--set @TypePer = dbo.fn_ObjectTypePermission('objVetCase', null, 'ObjectOperationRead')  
--insert into @res   
 
RETURN   
select   tlbVetCase.idfVetCase AS idfCase,   
    tlbVetCase.datAssignedDate,   
    tlbVetCase.datEnteredDate ,    
    tlbVetCase.strCaseID,   
    tlbVetCase.datReportDate,   
    tlbVetCase.datInvestigationDate,  
    tlbVetCase.idfsShowDiagnosis,  
    ISNULL(tlbVetCase.datFinalDiagnosisDate,(SELECT Max(d)
		FROM (VALUES (tlbVetCase.datTentativeDiagnosis2Date), (tlbVetCase.datTentativeDiagnosis1Date), (tlbVetCase.datTentativeDiagnosisDate)) AS dates(d))) as datDiagnosisDate,
    tlbVetCase.idfsTentativeDiagnosis,  
    tlbVetCase.idfsTentativeDiagnosis1,  
    tlbVetCase.idfsTentativeDiagnosis2,  
    tlbVetCase.idfsFinalDiagnosis, 
    tlbVetCase.idfPersonEnteredBy,  
    tlbVetCase.idfsCaseClassification,    
    tlbVetCase.idfsCaseProgressStatus,  
    ISNULL(tlbVetCase.idfsCaseReportType,4578940000002) AS idfsCaseReportType, --passive as default  
    CaseReportType.[name] as strCaseReportType,  
    DiagnosisRef.name as FinalDiagnosisName,   
    ISNULL(Diagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) as DiagnosisName,   
    CaseStatus.name as CaseStatusName,   
    CaseClassification.name as CaseClassificationName,   
    CaseType.[name] as strCaseType,  
    tlbVetCase.idfsCaseType,  
    nullif(tlbVetCase.idfsCaseType,0) as idfsCaseTypeNullable,
	tlbVetCase.uidOfflineCaseID,
    tlbFarm.idfFarmAddress as idfAddress,  
    ISNULL(ref_Settlement.[name] + ', ', '')+ISNULL(ref_Rayon.[name] + ', ', '')+ref_Region.[name] AS AddressName,
    tlbGeoLocation.idfsCountry,  
    tlbGeoLocation.idfsRegion,  
    tlbGeoLocation.idfsRayon,  
    tlbGeoLocation.idfsSettlement,  
    tlbFarm.idfFarm,  
    IsNull(tlbFarm.strNationalName, tlbFarm.strInternationalName) as FarmName,   
    tlbFarm.idfsAvianFarmType,  
    tlbFarm.idfsAvianProductionType,  
    tlbFarm.idfsFarmCategory,  
    tlbFarm.idfsOwnershipStructure,  
    tlbFarm.idfsMovementPattern,  
    tlbFarm.idfsIntendedUse,  
    tlbFarm.idfsGrazingPattern,  
    tlbFarm.idfsLivestockProductionType,  
    tlbFarm.strInternationalName,  
    tlbFarm.strNationalName,  
    tlbFarm.strFarmCode,  
    tlbFarm.strFax,  
    tlbFarm.strEmail,  
    tlbFarm.strContactPhone,  
    farmOwner.strFirstName as strOwnerFirstName,  
    farmOwner.strSecondName as strOwnerMiddleName,  
    farmOwner.strLastName as strOwnerLastName,  
    CASE WHEN tlbVetCase.idfsCaseType= 10012004/*avian*/ THEN tlbFarm.intAvianSickAnimalQty ELSE  tlbFarm.intLivestockSickAnimalQty END AS  intSickAnimalQty ,  
    CASE WHEN tlbVetCase.idfsCaseType= 10012004/*avian*/ THEN tlbFarm.intAvianTotalAnimalQty ELSE  tlbFarm.intLivestockTotalAnimalQty END AS  intTotalAnimalQty ,  
    CASE WHEN tlbVetCase.idfsCaseType= 10012004/*avian*/ THEN tlbFarm.intAvianDeadAnimalQty ELSE  tlbFarm.intLivestockDeadAnimalQty END AS  intDeadAnimalQty,
	tlbVetCase.idfsSite           
   
from   (  
 tlbVetCase 
 left join dbo.fnReferenceRepair(@LangID,19000011) as CaseClassification --'rftCaseClassification'  
 on   tlbVetCase.idfsCaseClassification = CaseClassification.idfsReference  
 left join dbo.fnReferenceRepair(@LangID,19000111) as CaseStatus --'rftCaseProgressStatus'  
 on   tlbVetCase.idfsCaseProgressStatus = CaseStatus.idfsReference  
 left join dbo.fnReferenceRepair(@LangID,19000012) as CaseType --'rftCaseType'  
 on   tlbVetCase.idfsCaseType = CaseType.idfsReference   
 left join	dbo.fnReferenceRepair(@LangID, 19000019) as DiagnosisRef		--'rftDiagnosis'
 on	  tlbVetCase.idfsFinalDiagnosis = DiagnosisRef.idfsReference
    )  
  
inner join tlbFarm  
on   tlbFarm.idfFarm = tlbVetCase.idfFarm  
   AND tlbFarm.intRowStatus = 0  
left join tlbHuman farmOwner
on farmOwner.idfHuman = tlbFarm.idfHuman
left join tlbGeoLocation  
on   tlbGeoLocation.idfGeoLocation = tlbFarm.idfFarmAddress  
left join fnGisReferenceRepair(@LangID, 19000003) as ref_Region
on ref_Region.idfsReference = tlbGeoLocation.idfsRegion
  
left join fnGisReferenceRepair(@LangID, 19000002) as ref_Rayon
on ref_Rayon.idfsReference = tlbGeoLocation.idfsRayon

left join fnGisReferenceRepair(@LangID, 19000004) as ref_Settlement
on ref_Settlement.idfsReference = tlbGeoLocation.idfsSettlement
left join dbo.fnReferenceRepair(@LangID,19000144) as CaseReportType   
on   ISNULL(tlbVetCase.idfsCaseReportType,4578940000002) = CaseReportType.idfsReference  
  
--JOIN fnGetPermissionOnVetCase(NULL, NULL) GetPermission ON  
-- GetPermission.idfVetCase = tlbVetCase.idfVetCase  
-- AND GetPermission.intPermission = 2  
LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis Diagnosis
on tlbVetCase.idfVetCase = Diagnosis.idfVetCase AND Diagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()
where tlbVetCase.intRowStatus = 0  
		and (dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								and oa_diag_user_deny.idfsObjectID in (tlbVetCase.idfsFinalDiagnosis, tlbVetCase.idfsTentativeDiagnosis,tlbVetCase.idfsTentativeDiagnosis1, tlbVetCase.idfsTentativeDiagnosis2)
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
								and oa_diag_group_deny.idfsObjectID  in (tlbVetCase.idfsFinalDiagnosis, tlbVetCase.idfsTentativeDiagnosis,tlbVetCase.idfsTentativeDiagnosis1, tlbVetCase.idfsTentativeDiagnosis2)
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
								and oa_site_user_deny.idfsObjectID = tlbVetCase.idfsSite
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
								and oa_site_group_deny.idfsObjectID = tlbVetCase.idfsSite
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)
  
  
  

