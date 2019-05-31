


--##SUMMARY Returns list of VS sessions.

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 21.07.2011

--##RETURNS Returns list of VS sessions.



/*
--Example of function call:

SELECT * FROM fn_VsSession_SelectList ('en')

*/


CREATE     Function [dbo].[fn_VsSession_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return

Select
  vss.idfVectorSurveillanceSession,
  vss.strSessionID,
  [dbo].[fn_VsSession_GetVectorTypeNames](vss.idfVectorSurveillanceSession, @LangID) as [strVectors],  
  [dbo].[fn_VsSession_GetVectorTypeIds](vss.idfVectorSurveillanceSession) as [strVectorTypeIds],
  [dbo].[fn_VsSession_GetDiagnosesNames](vss.idfVectorSurveillanceSession, @LangID) as [strDiagnoses],
  --vss.strDescription,
  vss.strFieldSessionID,
  VSStatus.name as strVSStatus,
  vss.idfsVectorSurveillanceStatus,  
  Country.name as strCountry,
  gl.idfsCountry,
  Region.name as strRegion,
  gl.idfsRegion,
  Rayon.name as strRayon,
  gl.idfsSettlement,
  Settlement.name as strSettlement,  
  gl.idfsRayon,
  gl.dblLatitude,
  gl.dblLongitude,
  vss.datStartDate,
  vss.datCloseDate,  
  vss.idfOutbreak,
  vss.idfLocation,
  vss.idfsSite
from tlbVectorSurveillanceSession vss
  left join tlbGeoLocation gl
  on gl.idfGeoLocation = vss.idfLocation and gl.intRowStatus = 0 
  
  left join fnGisReference(@LangID,19000003) Region
  on	Region.idfsReference = gl.idfsRegion

  left join fnGisReference(@LangID,19000002) Rayon
	on	Rayon.idfsReference = gl.idfsRayon
  
  left join fnGisReference(@LangID,19000001) Country
  on	Country.idfsReference = gl.idfsCountry
  
  left join fnReferenceRepair(@LangID,19000133) VSStatus
  on	VSStatus.idfsReference = vss.idfsVectorSurveillanceStatus
  
  left join fnGisReference(@LangID,19000004) Settlement
  on	Settlement.idfsReference = gl.idfsSettlement
left join	tstUserTable ut
on			ut.idfUserID = dbo.fnUserID()
left join	tstSite s
on			s.idfsSite = dbo.fnSiteID()

  
where 
		vss.intRowStatus = 0
		and (dbo.fnDiagnosisDenied() = 0 OR (
			not exists	(
					select		*
					from		tstObjectAccess oa_diag_user_deny
					left Join dbo.tlbMaterial m 
								left join  dbo.tlbPensideTest pt
									inner join trtPensideTestTypeToTestResult tr
									on			pt.idfsPensideTestName = tr.idfsPensideTestName
												and pt.idfsPensideTestResult = tr.idfsPensideTestResult
												and pt.intRowStatus = 0
												and tr.intRowStatus = 0
												and tr.blnIndicative = 1
								on			pt.idfMaterial = m.idfMaterial
											and pt.intRowStatus = 0
								left join tlbTesting t
								on			t.idfMaterial = m.idfMaterial
								and t.intRowStatus = 0
					On			vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
								and m.intRowStatus = 0
					left join  tlbVectorSurveillanceSessionSummary vsss 
						inner Join	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
						On			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
									and vssd.intRowStatus = 0
					on			vsss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
								and vsss.intRowStatus = 0
					where		oa_diag_user_deny.intPermission = 1						-- deny
								and oa_diag_user_deny.idfActor = ut.idfPerson
								and (oa_diag_user_deny.idfsObjectID  = pt.idfsDiagnosis
								or  oa_diag_user_deny.idfsObjectID  = t.idfsDiagnosis
								or oa_diag_user_deny.idfsObjectID  =  vssd.idfsDiagnosis)
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
					left Join dbo.tlbMaterial m 
								left join  dbo.tlbPensideTest pt
									inner join trtPensideTestTypeToTestResult tr
									on			pt.idfsPensideTestName = tr.idfsPensideTestName
												and pt.idfsPensideTestResult = tr.idfsPensideTestResult
												and pt.intRowStatus = 0
												and tr.intRowStatus = 0
												and tr.blnIndicative = 1
								on			pt.idfMaterial = m.idfMaterial
											and pt.intRowStatus = 0
								left join tlbTesting t
								on			t.idfMaterial = m.idfMaterial
								and t.intRowStatus = 0
					On			vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
								and m.intRowStatus = 0
					left join  tlbVectorSurveillanceSessionSummary vsss 
						inner Join	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
						On			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
									and vssd.intRowStatus = 0
					on			vsss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
								and vsss.intRowStatus = 0
					where		oa_diag_group_deny.intPermission = 1					-- deny
								and (oa_diag_group_deny.idfsObjectID  = pt.idfsDiagnosis
								or  oa_diag_group_deny.idfsObjectID  = t.idfsDiagnosis
								or oa_diag_group_deny.idfsObjectID  =  vssd.idfsDiagnosis)
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
								and oa_site_user_deny.idfsObjectID = vss.idfsSite
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
								and oa_site_group_deny.idfsObjectID = vss.idfsSite
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
					)
				)












