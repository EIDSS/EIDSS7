
--*************************************************************
-- Name 				: FN_GBL_LKUP_OutBreak_GetList
-- Description			: Returns the list of outbreaks.
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--SELECT * FROM fn_Outbreak_SelectList ('en')
--*************************************************************

CREATE FUNCTION [dbo].[FN_GBL_LKUP_OutBreak_GetList](
	@LangID AS NVARCHAR(50)--##PARAM @LangID  - language ID
)

RETURNS TABLE 

AS

RETURN

SELECT		
	tlbOutbreak.idfOutbreak 
	,tlbOutbreak.strOutbreakID
	,tlbOutbreak.datStartDate 
	,tlbOutbreak.datFinishDate
	,ISNULL(Diagnosis.[name], DiagnosisAsGroup.[name]) AS strDiagnosisOrDiagnosisGroup
	,tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
	,ISNULL(DiagnosisAsGroup.[name], DiagnosisGroup.[name]) AS strDiagnosisGroup
	,ISNULL(dg.idfsDiagnosisGroup, tlbOutbreak.idfsDiagnosisOrDiagnosisGroup) as idfsDiagnosisGroup
	,OutbreakStatus.[name] as strOutbreakStatus
	,tlbOutbreak.idfsOutbreakStatus
	,tlbOutbreak.idfGeoLocation		
	,dbo.fnCreateGeoLocationString
		(
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
		) AS strGeoLocationName
	,CASE 
		WHEN (NOT Patient.idfHuman IS NULL) THEN dbo.fnConcatFullName(Patient.strLastName, Patient.strFirstName, Patient.strSecondName) 
		WHEN (NOT FarmOwner.idfHuman IS NULL) THEN dbo.fnConcatFullName(FarmOwner.strLastName, FarmOwner.strFirstName, FarmOwner.strSecondName) 
		ELSE N'' END  as strPatientName
    ,dbo.fnConcatFullName(Patient.strLastName, Patient.strFirstName, Patient.strSecondName) as strHumanPatientName
    ,dbo.fnConcatFullName(FarmOwner.strLastName, FarmOwner.strFirstName, FarmOwner.strSecondName)   as strFarmOwner
FROM	
	(	
	tlbOutbreak 
		LEFT JOIN dbo.fnReferenceRepair(@LangID,19000019) as Diagnosis ON
			tlbOutbreak.idfsDiagnosisOrDiagnosisGroup = Diagnosis.idfsReference
		LEFT JOIN dbo.fnReferenceRepair(@LangID,19000156) as DiagnosisAsGroup ON
			tlbOutbreak.idfsDiagnosisOrDiagnosisGroup = DiagnosisAsGroup.idfsReference
		LEFT JOIN trtDiagnosisToDiagnosisGroup AS dg ON
			dg.idfsDiagnosis = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
		LEFT JOIN dbo.fnReferenceRepair(@LangID,19000156) AS DiagnosisGroup ON
			dg.idfsDiagnosisGroup = DiagnosisGroup.idfsReference
		LEFT JOIN dbo.fnReferenceRepair(@LangID,19000063) AS OutbreakStatus ON
			tlbOutbreak.idfsOutbreakStatus = OutbreakStatus.idfsReference
	)
	LEFT JOIN FN_GBL_LKUP_GeoLoc_GetList(@LangID) AS GeoLocation ON
		GeoLocation.idfGeoLocation = tlbOutbreak.idfGeoLocation
	LEFT JOIN tlbHumanCase ON
		tlbHumanCase.idfHumanCase = tlbOutbreak.idfPrimaryCaseOrSession
		AND 
		tlbHumanCase.intRowStatus = 0
	INNER JOIN tlbHuman AS Patient ON
		Patient.idfHuman = tlbHumanCase.idfHuman
		AND 
		Patient.intRowStatus = 0
	LEFT JOIN tlbVetCase ON
		tlbVetCase.idfVetCase = tlbOutbreak.idfPrimaryCaseOrSession
		AND 
		tlbVetCase.intRowStatus = 0
	INNER JOIN tlbFarm ON
		tlbFarm.idfFarm = tlbVetCase.idfFarm
		AND 
		tlbFarm.intRowStatus = 0
	LEFT JOIN tlbHuman AS FarmOwner ON
		FarmOwner.idfHuman = tlbFarm.idfHuman
		AND 
		FarmOwner.intRowStatus = 0
	LEFT JOIN tstUserTable AS ut ON
		ut.idfUserID = dbo.fnUserID()
	LEFT JOIN tstSite AS s ON
		s.idfsSite = dbo.fnSiteID()
WHERE
	tlbOutbreak.intRowStatus = 0
	AND
	(dbo.fnDiagnosisDenied() = 0 
	OR (
		NOT EXISTS	
			(
			SELECT
				*
			FROM
				tstObjectAccess oa_diag_user_deny
				LEFT JOIN trtDiagnosisToDiagnosisGroup AS dg1 ON
					dg1.idfsDiagnosisGroup = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
					AND 
					dg1.intRowStatus = 0
			WHERE
				oa_diag_user_deny.intPermission = 1						-- deny
				AND 
					oa_diag_user_deny.idfActor = ut.idfPerson
				AND 
					(oa_diag_user_deny.idfsObjectID = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
					OR	
					oa_diag_user_deny.idfsObjectID = dg1.idfsDiagnosis)
				AND 
					oa_diag_user_deny.idfsObjectOperation = 10059003	-- Read
				AND 
					oa_diag_user_deny.idfsOnSite = dbo.fnPermissionSite()
				AND 
				oa_diag_user_deny.intRowStatus = 0
			)
		AND NOT EXISTS	
			(
			SELECT
				*
			FROM
				tstObjectAccess oa_diag_group_deny
				INNER JOIN tlbEmployeeGroupMember AS egm_diag_group_deny ON
					egm_diag_group_deny.idfEmployee = ut.idfPerson
					AND 
					egm_diag_group_deny.intRowStatus = 0
					AND 
					oa_diag_group_deny.idfActor = egm_diag_group_deny.idfEmployeeGroup
				INNER JOIN	
					tlbEmployee AS eg_diag_group_deny ON
						eg_diag_group_deny.idfEmployee = egm_diag_group_deny.idfEmployeeGroup
						AND 
						eg_diag_group_deny.intRowStatus = 0
				LEFT JOIN trtDiagnosisToDiagnosisGroup AS dg1 ON
					dg1.idfsDiagnosisGroup = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
					AND 
					dg1.intRowStatus = 0
			WHERE
				oa_diag_group_deny.intPermission = 1					-- deny
				AND 
					(oa_diag_group_deny.idfsObjectID = tlbOutbreak.idfsDiagnosisOrDiagnosisGroup
					OR	
					oa_diag_group_deny.idfsObjectID = dg1.idfsDiagnosis)
				AND 
					oa_diag_group_deny.idfsObjectOperation = 10059003	-- Read
				AND 
					oa_diag_group_deny.idfsOnSite = dbo.fnPermissionSite()
				AND 
					oa_diag_group_deny.intRowStatus = 0
			)
		)
	)
	AND 
		(dbo.fnSiteDenied() = 0 
		OR 
			(
			NOT EXISTS
				(
				SELECT
					*
				FROM
					tstObjectAccess AS oa_site_user_deny
				WHERE
					oa_site_user_deny.intPermission = 1						-- deny
					AND 
						oa_site_user_deny.idfActor = ut.idfPerson
					AND 
						oa_site_user_deny.idfsObjectID = tlbOutbreak.idfsSite
					AND 
						oa_site_user_deny.idfsObjectOperation = 10059003	-- Read
					AND 
						oa_site_user_deny.idfsOnSite = dbo.fnPermissionSite()
					AND 
						oa_site_user_deny.intRowStatus = 0
				)
			AND 
				NOT EXISTS	
					(
					SELECT
						*
					FROM
						tstObjectAccess oa_site_group_deny
						INNER JOIN tlbEmployeeGroupMember AS egm_site_group_deny ON
							egm_site_group_deny.idfEmployee = ut.idfPerson
							AND 
							oa_site_group_deny.idfActor = egm_site_group_deny.idfEmployeeGroup
							AND 
							egm_site_group_deny.intRowStatus = 0
						INNER JOIN tlbEmployee AS eg_site_group_deny ON
							eg_site_group_deny.idfEmployee = egm_site_group_deny.idfEmployeeGroup
							AND 
							eg_site_group_deny.intRowStatus = 0
					WHERE
						oa_site_group_deny.intPermission = 1					-- deny
						AND 
						oa_site_group_deny.idfsObjectID = tlbOutbreak.idfsSite
						AND 
						oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
						AND 
						oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
						AND 
						oa_site_group_deny.intRowStatus = 0
					)
			)
		)

