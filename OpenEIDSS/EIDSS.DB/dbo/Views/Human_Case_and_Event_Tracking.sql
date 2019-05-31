
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

CREATE VIEW [dbo].[Human_Case_and_Event_Tracking]
as

select		hc.idfHumanCase as [PKField], 
			hc.intPatientAge as [sflHC_PatientAge], 
			case
	when	(	hc.idfsHumanAgeType = 10042002 and -- Month
				hc.intPatientAge between 0 and 11) or
			(	hc.idfsHumanAgeType = 10042001 and -- Days
				hc.intPatientAge between 0 and 364) or
			(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge = 0)
		then	cast(N' <1' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 1 and 4) or
			(	hc.idfsHumanAgeType = 10042002 and -- Month
				hc.intPatientAge between 12 and 48)
		then	cast(N' 1-4' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 5 and 14)
		then	cast(N' 5-14' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 15 and 19)
		then	cast(N'15-19' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 20 and 29)
		then	cast(N'20-29' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 30 and 59)
		then	cast(N'30-59' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge >= 60)
		then	cast(N'60+' as nvarchar(100))
	else	cast(null as nvarchar(100))
end as [sflHC_PatientAgeGroup], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			hc.idfsHospitalizationStatus as [sflHC_HospitalizationStatus_ID], 
			hc.datEnteredDate as [sflHC_EnteredDate], 
			hc.datModificationDate as [sflHC_ModificationDate], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			hc.datCompletionPaperFormDate as [sflHC_CompletionPaperFormDate], 
			hc.datDischargeDate as [sflHC_PatientDischargeDate], 
			hc.datFacilityLastVisit as [sflHC_FacilityLastVisitDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			h_hc.strWorkPhone as [sflHC_PatientEmployerPhone], 
			o_rec_hc.idfsOfficeName as [sflHC_ReceivedByOffice_ID], 
			o_sent_hc.idfsOfficeName as [sflHC_SentByOffice_ID], 
			hc.idfsYNHospitalization as [sflHC_Hospitalization_ID], 
			case when hc.idfsHospitalizationStatus = 5350000000 then hc.strCurrentLocation else null end as [sflHC_CurrentLocation], 
			hc.strLocalIdentifier as [sflHC_LocalID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			p_rec_hc.strFamilyName + IsNull(N' ' + p_rec_hc.strFirstName, N'') + IsNull(N' ' + p_rec_hc.strSecondName, N'') as [sflHC_ReceivedByPerson], 
			p_sent_hc.strFamilyName + IsNull(N' ' + p_sent_hc.strFirstName, N'') + IsNull(N' ' + p_sent_hc.strSecondName, N'') as [sflHC_SentByPerson], 
			hc.datInvestigationStartDate as [sflHC_InvestigationStartDate], 
			hc.idfsFinalState as [sflHC_PatientNotificationStatus_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			s_cby_o.idfsOfficeName as [sflHCSample_CollectedByOffice_ID], 
			m.strBarcode as [sflHCSample_LabSampleID], 
			m.strFieldBarcode as [sflHCSample_FieldSampleID], 
			IsNull(pm.strBarcode, m.strBarcode) as [sflHCSample_ParentLabSampleID], 
			hc.idfsCaseProgressStatus as [sflHC_CaseProgressStatus_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			hc.datHospitalizationDate as [sflHC_PatientHospitalizationDate], 
			hc.datFirstSoughtCareDate as [sflHC_PatientFirstSoughtCareDate], 
			hc.strHospitalizationPlace as [sflHC_HospitalizationPlace], 
			hdh_p.strFamilyName + IsNull(N' ' + hdh_p.strFirstName, N'') + IsNull(N' ' + hdh_p.strSecondName, N'') as [sflHCDiagnosisHistory_PersonName], 
			hdh_o.idfsOfficeAbbreviation as [sflHCDiagnosisHistory_Organization_ID], 
			hc.idfsNotCollectedReason as [sflHC_ReasonForNotCollectingSample_ID], 
			o_fsc_hc.idfsOfficeName as [sflHC_FacilityWherePatientFSC_ID], 
			hc.idfsNonNotifiableDiagnosis as [sflHC_NonNotifiableDiagnosis_ID], 
			case when hc.idfsHospitalizationStatus = 5360000000 then hc.strCurrentLocation else null end as [sflHC_OtherLocation]
			
			, gl_hc.idfsRegion				AS [sflHC_ResidenceRegion_ID]
			, gl_hc.idfsRayon				AS [sflHC_ResidenceRayon_ID]
			, gl_hc.idfsSettlement			AS [sflHC_ResidenceSettlement_ID]
			, gl_hc.strPostCode				AS [sflHC_ResidencePostCode]
			, gl_hc.strStreetName			AS [sflHC_ResidenceStreetName]
			, p_collect_m.strFamilyName + IsNull(N' ' + p_collect_m.strFirstName, N'') + IsNull(N' ' + p_collect_m.strSecondName, N'') AS [sflHC_CollectedByPerson]
			, p_access_m.strFamilyName + IsNull(N' ' + p_access_m.strFirstName, N'') + IsNull(N' ' + p_access_m.strSecondName, N'') AS [sflHC_AccessionedByPerson]
			, p_invest_hc.strFamilyName + IsNull(N' ' + p_invest_hc.strFirstName, N'') + IsNull(N' ' + p_invest_hc.strSecondName, N'') as [sflHC_InvestigatedByPerson]
from 
( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
	LEFT JOIN tlbGeoLocation gl_hc ON
		gl_hc.idfGeoLocation = h_hc.idfRegistrationAddress AND gl_hc.intRowStatus = 0 
left join tlbOffice o_fsc_hc 
ON o_fsc_hc.idfOffice = hc.idfSoughtCareFacility AND o_fsc_hc.intRowStatus = 0 
left join tlbOffice o_rec_hc 
ON o_rec_hc.idfOffice = hc.idfReceivedByOffice AND o_rec_hc.intRowStatus = 0 
left join tlbOffice o_sent_hc 
ON o_sent_hc.idfOffice = hc.idfSentByOffice AND o_sent_hc.intRowStatus = 0 
left join tlbPerson p_rec_hc 
ON p_rec_hc.idfPerson = hc.idfReceivedByPerson 
left join tlbPerson p_sent_hc 
ON p_sent_hc.idfPerson = hc.idfSentByPerson 
left join tlbPerson p_invest_hc 
ON p_invest_hc.idfPerson = hc.idfInvestigatedByPerson 
left join trtDiagnosis d_changed_hc 
ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join trtDiagnosis d_fin_hc 
ON d_fin_hc.idfsDiagnosis = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
left join trtDiagnosis d_init_hc 
ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
left join 
( 
    tlbChangeDiagnosisHistory AS hdh
          LEFT JOIN	tlbPerson AS hdh_p
                INNER JOIN	tlbEmployee AS hdh_e
                     ON hdh_p.idfPerson = hdh_e.idfEmployee AND 
                        hdh_e.intRowStatus = 0
                LEFT JOIN	tlbOffice AS hdh_o
                     ON hdh_p.idfInstitution = hdh_o.idfOffice AND 
                        hdh_o.intRowStatus = 0
               ON hdh.idfPerson = hdh_p.idfPerson AND
                  hdh_p.intRowStatus = 0 ) 
ON hdh.idfHumanCase = hc.idfHumanCase AND hdh.intRowStatus = 0 
left join 
( 
	tlbMaterial m 
	  left join tlbHuman h_m
	  on h_m.idfHuman = m.idfHuman
	  and h_m.intRowStatus = 0
	  
left join tlbMaterial pm 
ON pm.idfMaterial = m.idfParentMaterial AND pm.intRowStatus = 0  
left join tlbOffice AS s_cby_o
ON s_cby_o.idfOffice = m.idfFieldCollectedByOffice 
left join tlbPerson p_collect_m 
ON p_collect_m.idfPerson = m.idfFieldCollectedByPerson
left join tlbPerson p_access_m 
ON p_access_m.idfPerson = m.idfAccesionByPerson
) 
ON h_hc.idfHuman = m.idfHuman AND m.intRowStatus = 0 
) 
where		hc.intRowStatus = 0
