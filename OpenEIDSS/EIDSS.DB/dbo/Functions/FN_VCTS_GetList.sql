
--*************************************************************
-- Name 				: FN_VCTS_GetList
-- Description			: List All Vector Surveillance Session data
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- Select * From FN_VCTS_GetList('en')
--*************************************************************

CREATE FUNCTION	[dbo].[FN_VCTS_GetList]
(
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
RETURNS TABLE 
AS
	RETURN

	SELECT		tlbVectorSurveillanceSession.idfVectorSurveillanceSession,
				tlbVectorSurveillanceSession.strSessionID,
				[dbo].[FN_VCTS_VCTTYPNAME_Get](tlbVectorSurveillanceSession.idfVectorSurveillanceSession, @LangID) AS [strVectors],  
				[dbo].[FN_VCTS_VCTTYPID_Get](tlbVectorSurveillanceSession.idfVectorSurveillanceSession) AS [strVectorTypeIds],
				[dbo].[FN_VCTS_VCTDIAGNAMES_Get](tlbVectorSurveillanceSession.idfVectorSurveillanceSession, @LangID) AS [strDiagnoses],
				[dbo].[FN_VCTS_VCTDIAGIDFS_Get](tlbVectorSurveillanceSession.idfVectorSurveillanceSession, @LangID) AS [strDiagnosesIDFS],
				--tlbVectorSurveillanceSession.strDescription,
				tlbVectorSurveillanceSession.strFieldSessionID,
				VSStatus.name AS strVSStatus,
				tlbVectorSurveillanceSession.idfsVectorSurveillanceStatus,  
				Country.name AS strCountry,
				tlbGeoLocation.idfsCountry,
				Region.name AS strRegion,
				tlbGeoLocation.idfsRegion,
				Rayon.name AS strRayon,
				tlbGeoLocation.idfsSettlement,
				Settlement.name AS strSettlement,  
				tlbGeoLocation.idfsRayon,
				tlbGeoLocation.dblLatitude,
				tlbGeoLocation.dblLongitude,
				tlbVectorSurveillanceSession.datStartDate,
				tlbVectorSurveillanceSession.datCloseDate,  
				tlbVectorSurveillanceSession.idfOutbreak,
				tlbVectorSurveillanceSession.idfLocation,
				tlbVectorSurveillanceSession.idfsSite,
				tlbVector.idfsVectorSubType,
				tlbVector.idfVector
	FROM 		tlbVectorSurveillanceSession
	JOIN		tlbVector ON tlbVectorSurveillanceSession.idfVectorSurveillanceSession= tlbVector.idfVectorSurveillanceSession
	LEFT JOIN	tlbGeoLocation ON 
				tlbGeoLocation.idfGeoLocation = tlbVectorSurveillanceSession.idfLocation 
	AND			tlbGeoLocation.intRowStatus = 0 
	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000003) Region ON
				Region.idfsReference = tlbGeoLocation.idfsRegion
	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon ON	
				Rayon.idfsReference = tlbGeoLocation.idfsRayon
	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000001) Country ON
				Country.idfsReference = tlbGeoLocation.idfsCountry
	LEFT JOIN	FN_GBL_REPAIR(@LangID,19000133) VSStatus ON
				VSStatus.idfsReference = tlbVectorSurveillanceSession.idfsVectorSurveillanceStatus
	LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement ON
				Settlement.idfsReference = tlbGeoLocation.idfsSettlement
	LEFT JOIN	tstUserTable ON
				tstUserTable.idfUserID = dbo.FN_GBL_USERID_GET()
	LEFT JOIN	tstSite ON
				tstSite.idfsSite = dbo.FN_GBL_SITEID_GET()
	WHERE 		tlbVectorSurveillanceSession.intRowStatus = 0
	AND 	(
				dbo.FN_GBL_DIAGDENIED() = 0 
	OR 
			(
			NOT EXISTS	
				(
					SELECT	*
					FROM		tstObjectAccess oa_diag_user_deny
					LEFT JOIN	tlbMaterial
					LEFT JOIN	dbo.tlbPensideTest
					INNER JOIN	trtPensideTestTypeToTestResult ON
								tlbPensideTest.idfsPensideTestName = trtPensideTestTypeToTestResult.idfsPensideTestName
					AND 		tlbPensideTest.idfsPensideTestResult = trtPensideTestTypeToTestResult.idfsPensideTestResult
					AND 		tlbPensideTest.intRowStatus = 0
					AND 		trtPensideTestTypeToTestResult.intRowStatus = 0
					AND 		trtPensideTestTypeToTestResult.blnIndicative = 1 ON
								tlbPensideTest.idfMaterial = tlbMaterial.idfMaterial
					AND			tlbPensideTest.intRowStatus = 0
					LEFT JOIN	tlbTesting ON
								tlbTesting.idfMaterial = tlbMaterial.idfMaterial
					AND 		tlbTesting.intRowStatus = 0	ON
								tlbVectorSurveillanceSession.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
					AND			tlbMaterial.intRowStatus = 0
					LEFT JOIN	tlbVectorSurveillanceSessionSummary 
					INNER JOIN	tlbVectorSurveillanceSessionSummaryDiagnosis ON
								tlbVectorSurveillanceSessionSummary.idfsVSSessionSummary = tlbVectorSurveillanceSessionSummaryDiagnosis.idfsVSSessionSummary
					AND			tlbVectorSurveillanceSessionSummaryDiagnosis.intRowStatus = 0 ON
								tlbVectorSurveillanceSessionSummary.idfVectorSurveillanceSession = tlbVectorSurveillanceSession.idfVectorSurveillanceSession
					AND			tlbVectorSurveillanceSessionSummary.intRowStatus = 0
					WHERE		oa_diag_user_deny.intPermission = 1						-- deny
					AND 		oa_diag_user_deny.idfActor = tstUserTable.idfPerson
					AND 		(
									oa_diag_user_deny.idfsObjectID  = tlbPensideTest.idfsDiagnosis
									OR  
									oa_diag_user_deny.idfsObjectID  = tlbTesting.idfsDiagnosis
									OR 
									oa_diag_user_deny.idfsObjectID  =  tlbVectorSurveillanceSessionSummaryDiagnosis.idfsDiagnosis
								)
					AND 		oa_diag_user_deny.idfsObjectOperation = 10059003	-- Read
					AND 		oa_diag_user_deny.idfsOnSite = dbo.fnPermissionSite()
					AND 		oa_diag_user_deny.intRowStatus = 0
				)
			AND 
			NOT EXISTS	
				(
					SELECT		*
					FROM		tstObjectAccess oa_diag_group_deny
					INNER JOIN	tlbEmployeeGroupMember egm_diag_group_deny ON
								egm_diag_group_deny.idfEmployee = tstUserTable.idfPerson
					AND 		egm_diag_group_deny.intRowStatus = 0
					AND 		oa_diag_group_deny.idfActor = egm_diag_group_deny.idfEmployeeGroup
					INNER JOIN	tlbEmployee eg_diag_group_deny ON
								eg_diag_group_deny.idfEmployee = egm_diag_group_deny.idfEmployeeGroup
					AND 		eg_diag_group_deny.intRowStatus = 0
					LEFT JOIN	dbo.tlbMaterial
					LEFT JOIN	dbo.tlbPensideTest
					INNER JOIN	trtPensideTestTypeToTestResult ON
								tlbPensideTest.idfsPensideTestName = trtPensideTestTypeToTestResult.idfsPensideTestName
					AND 		tlbPensideTest.idfsPensideTestResult = trtPensideTestTypeToTestResult.idfsPensideTestResult
					AND 		tlbPensideTest.intRowStatus = 0
					AND 		trtPensideTestTypeToTestResult.intRowStatus = 0
					AND 		trtPensideTestTypeToTestResult.blnIndicative = 1 ON	
								tlbPensideTest.idfMaterial = tlbMaterial.idfMaterial
					AND 		tlbPensideTest.intRowStatus = 0
					LEFT JOIN	tlbTesting ON
								tlbTesting.idfMaterial = tlbMaterial.idfMaterial
					AND 		tlbTesting.intRowStatus = 0 ON
								tlbVectorSurveillanceSession.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
					AND 		tlbMaterial.intRowStatus = 0
					LEFT JOIN	tlbVectorSurveillanceSessionSummary 
					INNER JOIN	tlbVectorSurveillanceSessionSummaryDiagnosis ON
								tlbVectorSurveillanceSessionSummary.idfsVSSessionSummary = tlbVectorSurveillanceSessionSummaryDiagnosis.idfsVSSessionSummary
					AND 		tlbVectorSurveillanceSessionSummaryDiagnosis.intRowStatus = 0 ON
								tlbVectorSurveillanceSessionSummary.idfVectorSurveillanceSession = tlbVectorSurveillanceSession.idfVectorSurveillanceSession
					AND 		tlbVectorSurveillanceSessionSummary.intRowStatus = 0
					WHERE		oa_diag_group_deny.intPermission = 1					-- deny
					AND 		(
									oa_diag_group_deny.idfsObjectID  = tlbPensideTest.idfsDiagnosis
									OR 
									oa_diag_group_deny.idfsObjectID  = tlbTesting.idfsDiagnosis
									OR 
									oa_diag_group_deny.idfsObjectID  =  tlbVectorSurveillanceSessionSummaryDiagnosis.idfsDiagnosis
								)
					AND 		oa_diag_group_deny.idfsObjectOperation = 10059003	-- Read
					AND 		oa_diag_group_deny.idfsOnSite = dbo.fnPermissionSite()
					AND 		oa_diag_group_deny.intRowStatus = 0
				)
			)
		)
		AND 
		(
		dbo.FN_GBL_SITEDENIED() = 0 
		OR 
			(
			NOT EXISTS
				(
					SELECT	*
					FROM	tstObjectAccess oa_site_user_deny
					WHERE	oa_site_user_deny.intPermission = 1						-- deny
					AND 	oa_site_user_deny.idfActor = tstUserTable.idfPerson
					AND 	oa_site_user_deny.idfsObjectID = tlbVectorSurveillanceSession.idfsSite
					AND 	oa_site_user_deny.idfsObjectOperation = 10059003	-- Read
					AND 	oa_site_user_deny.idfsOnSite = dbo.fnPermissionSite()
					AND 	oa_site_user_deny.intRowStatus = 0
				)
			AND 
			NOT EXISTS	
				(
					SELECT		*
					FROM		tstObjectAccess oa_site_group_deny
					INNER JOIN	tlbEmployeeGroupMember egm_site_group_deny ON
								egm_site_group_deny.idfEmployee = tstUserTable.idfPerson
					AND			oa_site_group_deny.idfActor = egm_site_group_deny.idfEmployeeGroup
					AND			egm_site_group_deny.intRowStatus = 0
					INNER JOIN	tlbEmployee eg_site_group_deny ON
								eg_site_group_deny.idfEmployee = egm_site_group_deny.idfEmployeeGroup
					AND 		eg_site_group_deny.intRowStatus = 0
					WHERE		oa_site_group_deny.intPermission = 1					-- deny
					AND			oa_site_group_deny.idfsObjectID = tlbVectorSurveillanceSession.idfsSite
					AND			oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
					AND 		oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
					AND 		oa_site_group_deny.intRowStatus = 0
				)
			)
		)
