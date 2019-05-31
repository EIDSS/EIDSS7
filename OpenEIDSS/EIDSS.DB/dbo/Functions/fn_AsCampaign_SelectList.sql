



--##SUMMARY Returns list of AS campaigns.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 10.06.2010

--##RETURNS Returns list of AS campaigns.



/*
select * from fn_AsCampaign_SelectList ('en')
*/


CREATE     Function fn_AsCampaign_SelectList(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return
SELECT c.idfCampaign
      ,CampaignType.name as strCampaignType
      ,idfsCampaignType
      ,CampaignStatus.name as strCampaignStatus
      ,idfsCampaignStatus
      ,datCampaignDateStart
      ,datCampaignDateEnd
      ,strCampaignID
      ,strCampaignName
      ,strCampaignAdministrator
	  ,c.idfsSite
FROM tlbCampaign c
LEFT JOIN fnReferenceRepair(@LangID,19000116) CampaignType  ON
	c.idfsCampaignType = CampaignType.idfsReference 
LEFT JOIN fnReferenceRepair(@LangID,19000115) CampaignStatus  ON
	c.idfsCampaignStatus = CampaignStatus.idfsReference 
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()
WHERE 
		c.intRowStatus = 0
		and (dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					inner     join tlbCampaignToDiagnosis cd
					on			c.idfCampaign = cd.idfCampaign
								and cd.intRowStatus = 0
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								and oa_diag_user_deny.idfsObjectID = cd.idfsDiagnosis
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
					left     join tlbCampaignToDiagnosis cd
					on			c.idfCampaign = cd.idfCampaign
								and cd.intRowStatus = 0
					where		oa_diag_group_deny.intPermission = 1					-- deny
								and oa_diag_group_deny.idfsObjectID = cd.idfsDiagnosis
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
								and oa_site_user_deny.idfsObjectID = c.idfsSite
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
								and oa_site_group_deny.idfsObjectID = c.idfsSite
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)











