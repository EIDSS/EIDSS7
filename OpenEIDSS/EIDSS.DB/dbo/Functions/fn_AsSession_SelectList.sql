



--##SUMMARY Returns list of AS sessions.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.06.2010

--##RETURNS Returns list of AS campaigns.



/*
--Example of function call:

SELECT * FROM fn_AsSession_SelectList ('ru')

*/


CREATE     Function fn_AsSession_SelectList(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return
SELECT tlbMonitoringSession.idfMonitoringSession
      ,[Status].name as strStatus
      ,idfsMonitoringSessionStatus
      ,Region.name as strRegion
      ,idfsRegion
      ,Rayon.name as strRayon
      ,idfsRayon
      ,Settlement.name as strSettlement
      ,idfsSettlement
      ,datEnteredDate
      ,idfPersonEnteredBy
      ,strMonitoringSessionID
	  ,NULL as strDisease-- Replace it with d.name if requirement occur
      ,tlbCampaign.strCampaignID
      ,tlbCampaign.strCampaignName
      ,tlbCampaign.datCampaignDateStart
      ,tlbCampaign.datCampaignDateEnd
      ,tlbCampaign.idfsCampaignType
	  ,datStartDate
      ,datEndDate
	  ,convert(uniqueidentifier, tlbMonitoringSession.strReservedAttribute) as uidOfflineCaseID
	  ,tlbMonitoringSession.idfsSite
  FROM tlbMonitoringSession
Left JOIN tlbCampaign 
	ON tlbMonitoringSession.idfCampaign = tlbCampaign.idfCampaign
		AND tlbCampaign.intRowStatus = 0
LEFT JOIN fnGisReference(@LangID,19000003) Region
	ON	Region.idfsReference = tlbMonitoringSession.idfsRegion
LEFT JOIN fnGisReference(@LangID,19000002) Rayon
	ON	Rayon.idfsReference = tlbMonitoringSession.idfsRayon
LEFT JOIN fnGisReference(@LangID,19000004) Settlement
	ON	Settlement.idfsReference = tlbMonitoringSession.idfsSettlement
LEFT JOIN fnReferenceRepair(@LangID,19000117) [Status]
	ON	[Status].idfsReference = tlbMonitoringSession.idfsMonitoringSessionStatus
--LEFT JOIN 	dbo.vwAsSessionDiagnosis d
--	ON d.idfMonitoringSession = tlbMonitoringSession.idfMonitoringSession and dbo.fnGetLanguageCode(@LangID) = d.idfsLanguage
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()

WHERE
	tlbMonitoringSession.intRowStatus = 0
		and (dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					inner     join tlbMonitoringSessionToDiagnosis asd
					on			tlbMonitoringSession.idfMonitoringSession = asd.idfMonitoringSession
								and asd.intRowStatus = 0
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								and oa_diag_user_deny.idfsObjectID = asd.idfsDiagnosis
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
					inner     join tlbMonitoringSessionToDiagnosis asd
					on			tlbMonitoringSession.idfMonitoringSession = asd.idfMonitoringSession
								and asd.intRowStatus = 0
					where		oa_diag_group_deny.intPermission = 1					-- deny
								and oa_diag_group_deny.idfsObjectID = asd.idfsDiagnosis
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
								and oa_site_user_deny.idfsObjectID = tlbMonitoringSession.idfsSite
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
								and oa_site_group_deny.idfsObjectID = tlbMonitoringSession.idfsSite
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)















