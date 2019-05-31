
--*************************************************************
-- Name 				: FN_VCTS_VSSESSION_GetList
-- Description			: List All Vector Surveillance Session data
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
-- Harold Pryor   6/7/2018   Updated to return idfsGeoLocationType
-- Harold Pryor   6/11/2018  Updated to return default idfsGeoLocationType value when nulls
-- Stephen Long   9/17/2018  Added disease id's for lab module.
--
-- Testing code:
--SELECT * FROM FN_VCTS_VSSESSION_GetList ('en')
--*************************************************************
CREATE FUNCTION [dbo].[FN_VCTS_VSSESSION_GetList]
(
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
RETURNS TABLE 
AS
	RETURN

	SELECT		vss.idfVectorSurveillanceSession,
				vss.strSessionID,
				ISNULL([dbo].[FN_VCTS_VSSESSION_VECTORTYPENAMES_GET](vss.idfVectorSurveillanceSession, @LangID),'') AS [strVectors],  
				ISNULL([dbo].[FN_VCTS_VSSESSION_VECTORTYPEIDS_GET](vss.idfVectorSurveillanceSession),'') AS [strVectorTypeIds],
				ISNULL([dbo].[FN_VCTS_VSSESSION_DIAGNOSESNAMES_GET](vss.idfVectorSurveillanceSession, @LangID), '') AS [strDiagnoses],
				ISNULL([dbo].[FN_VCTS_VSSESSION_DIAGNOSESIDS_GET](vss.idfVectorSurveillanceSession, @LangID), '') AS [strDiagnosesIDs],
				--vss.strDescription,
				vss.strFieldSessionID,
				VSStatus.name AS strVSStatus,
				vss.idfsVectorSurveillanceStatus,  
				vss.intCollectionEffort,
				vectSubType.idfsReference AS idfsVectorSubType,
				vectSubType.name AS vectorSubType,
				ISNULL(gl.idfsGeoLocationType,10036003) as idfsGeoLocationType,
				Country.name AS strCountry,
				gl.idfsCountry,
				Region.name AS strRegion,
				gl.idfsRegion,
				Rayon.name AS strRayon,
				gl.idfsSettlement,
				Settlement.name AS strSettlement,  
				gl.idfsRayon,
				gl.dblLatitude,
				gl.dblLongitude,
				vss.datStartDate,
				vss.datCloseDate,  
				ISNULL(vss.idfOutbreak, '') AS idfOUtBreak,
				vss.idfLocation,
				vss.idfsSite,
				gl.strBuilding,
				gl.strStreetName

	FROM		tlbVectorSurveillanceSession vss

	LEFT JOIN	tlbVector vect
	ON			vect.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession AND vect.intRowStatus = 0

	LEFT JOIN	FN_GBL_REFERENCEREPAIR(@LangID,19000141) vectSubType
	ON			vectSubType.idfsReference = vect.idfsVectorSubType

	LEFT JOIN	FN_GBL_REFERENCEREPAIR(@LangID,19000133) VSStatus
	ON			VSStatus.idfsReference = vss.idfsVectorSurveillanceStatus

	LEFT JOIN	tlbGeoLocation gl
	ON			gl.idfGeoLocation = vss.idfLocation AND gl.intRowStatus = 0 
  
	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000001) Country
	ON			Country.idfsReference = gl.idfsCountry

	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon
	ON			Rayon.idfsReference = gl.idfsRayon
  
	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
	ON			Region.idfsReference = gl.idfsRegion

	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
	ON			Settlement.idfsReference = gl.idfsSettlement

	LEFT JOIN	tstUserTable ut
	ON			ut.idfUserID = dbo.FN_GBL_USERID_GET()

	LEFT JOIN	tstSite s
	ON			s.idfsSite = dbo.FN_GBL_SITEID_GET()

	WHERE 
			vss.intRowStatus = 0
			AND (dbo.FN_GBL_DIAGDENIED() = 0 OR (
				NOT EXISTS	(
								SELECT		*
								FROM		tstObjectAccess oa_diag_user_deny
								LEFT JOIN	dbo.tlbMaterial m 
								LEFT JOIN	dbo.tlbPensideTest pt
								LEFT JOIN	trtPensideTestTypeToTestResult tr
								ON			pt.idfsPensideTestName = tr.idfsPensideTestName
								AND			pt.idfsPensideTestResult = tr.idfsPensideTestResult
								AND			pt.intRowStatus = 0
								AND			tr.intRowStatus = 0
								AND			tr.blnIndicative = 1
								ON			pt.idfMaterial = m.idfMaterial
								AND			pt.intRowStatus = 0
								LEFT JOIN	tlbTesting t
								ON			t.idfMaterial = m.idfMaterial
								AND			t.intRowStatus = 0
								ON			vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
								AND			m.intRowStatus = 0
								LEFT JOIN	tlbVectorSurveillanceSessionSummary vsss 
								LEFT JOIN	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
								ON			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
								AND			vssd.intRowStatus = 0
								ON			vsss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
								AND			vsss.intRowStatus = 0
								WHERE		oa_diag_user_deny.intPermission = 1						-- deny
								AND			oa_diag_user_deny.idfActor = ut.idfPerson
								AND			(oa_diag_user_deny.idfsObjectID  = pt.idfsDiagnosis
											OR  oa_diag_user_deny.idfsObjectID  = t.idfsDiagnosis
											OR oa_diag_user_deny.idfsObjectID  =  vssd.idfsDiagnosis)
								AND			oa_diag_user_deny.idfsObjectOperation = 10059003	-- Read
								AND			oa_diag_user_deny.idfsOnSite = dbo.FN_GBL_PERMISSIONSITE()
								AND			oa_diag_user_deny.intRowStatus = 0
							)
			AND NOT EXISTS	(
								SELECT		*
								FROM		tstObjectAccess oa_diag_group_deny
								LEFT JOIN	tlbEmployeeGroupMember egm_diag_group_deny
								ON			egm_diag_group_deny.idfEmployee = ut.idfPerson
								AND			egm_diag_group_deny.intRowStatus = 0
								AND			oa_diag_group_deny.idfActor = egm_diag_group_deny.idfEmployeeGroup
								LEFT JOIN	tlbEmployee eg_diag_group_deny
								ON			eg_diag_group_deny.idfEmployee = egm_diag_group_deny.idfEmployeeGroup
								AND			eg_diag_group_deny.intRowStatus = 0
								LEFT JOIN	dbo.tlbMaterial m 
								LEFT JOIN	dbo.tlbPensideTest pt
								LEFT JOIN	trtPensideTestTypeToTestResult tr
								ON			pt.idfsPensideTestName = tr.idfsPensideTestName
								AND			pt.idfsPensideTestResult = tr.idfsPensideTestResult
								AND			pt.intRowStatus = 0
								AND			tr.intRowStatus = 0
								AND			tr.blnIndicative = 1
								ON			pt.idfMaterial = m.idfMaterial
								AND			pt.intRowStatus = 0
								LEFT JOIN	tlbTesting t
								ON			t.idfMaterial = m.idfMaterial
								AND			t.intRowStatus = 0
								ON			vss.idfVectorSurveillanceSession = m.idfVectorSurveillanceSession
								AND			m.intRowStatus = 0
								LEFT JOIN	tlbVectorSurveillanceSessionSummary vsss 
								LEFT JOIN	tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
								ON			vsss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
								AND			vssd.intRowStatus = 0
								ON			vsss.idfVectorSurveillanceSession = vss.idfVectorSurveillanceSession
								AND			vsss.intRowStatus = 0
								WHERE		oa_diag_group_deny.intPermission = 1					-- deny
								AND			(oa_diag_group_deny.idfsObjectID  = pt.idfsDiagnosis
											OR  oa_diag_group_deny.idfsObjectID  = t.idfsDiagnosis
											OR oa_diag_group_deny.idfsObjectID  =  vssd.idfsDiagnosis)
								AND			oa_diag_group_deny.idfsObjectOperation = 10059003	-- Read
								AND			oa_diag_group_deny.idfsOnSite = dbo.FN_GBL_PERMISSIONSITE()
								AND			oa_diag_group_deny.intRowStatus = 0
							)
						)
					)
			AND (dbo.FN_GBL_SITEDENIED() = 0 OR (
				NOT EXISTS	(
								SELECT	*
								FROM	tstObjectAccess oa_site_user_deny
								WHERE	oa_site_user_deny.intPermission = 1						-- deny
										AND oa_site_user_deny.idfActor = ut.idfPerson
										AND oa_site_user_deny.idfsObjectID = vss.idfsSite
										AND oa_site_user_deny.idfsObjectOperation = 10059003	-- Read
										AND oa_site_user_deny.idfsOnSite = dbo.FN_GBL_PERMISSIONSITE()
										AND oa_site_user_deny.intRowStatus = 0
							)
				AND NOT EXISTS	
							(
								SELECT		*
								FROM		tstObjectAccess oa_site_group_deny
								LEFT JOIN	tlbEmployeeGroupMember egm_site_group_deny
								ON			egm_site_group_deny.idfEmployee = ut.idfPerson
								AND			oa_site_group_deny.idfActor = egm_site_group_deny.idfEmployeeGroup
								AND			egm_site_group_deny.intRowStatus = 0
								LEFT JOIN	tlbEmployee eg_site_group_deny
								ON			eg_site_group_deny.idfEmployee = egm_site_group_deny.idfEmployeeGroup
								AND			eg_site_group_deny.intRowStatus = 0
								WHERE		oa_site_group_deny.intPermission = 1					-- deny
								AND			oa_site_group_deny.idfsObjectID = vss.idfsSite
								AND			oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								AND			oa_site_group_deny.idfsOnSite = dbo.FN_GBL_PERMISSIONSITE()
								AND			oa_site_group_deny.intRowStatus = 0
							)
						)
					)

