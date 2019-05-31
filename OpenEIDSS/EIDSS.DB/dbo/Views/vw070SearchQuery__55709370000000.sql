

CREATE VIEW [dbo].[vw070SearchQuery__55709370000000]
as

select		hc.idfHumanCase as [PKField], 
			hc.idfHumanCase as [PKField_4582670000000], 
			d_changed_hc.idfsDiagnosis as [PKField_4582680000000], 
			gl_cr_hc.idfGeoLocation as [PKField_4582700000000], 
			gl_emp_hc.idfGeoLocation as [PKField_4582710000000], 
			p_ent_hc.idfPerson as [PKField_4582720000000], 
			d_fin_hc.idfsDiagnosis as [PKField_4582730000000], 
			d_init_hc.idfsDiagnosis as [PKField_4582740000000], 
			p_inv_hc.idfPerson as [PKField_4582750000000], 
			o_inv_hc.idfOffice as [PKField_4582760000000], 
			gl_hc.idfGeoLocation as [PKField_4582770000000], 
			gl_reg_hc.idfGeoLocation as [PKField_4582780000000], 
			p_rec_hc.idfPerson as [PKField_4582790000000], 
			o_rec_hc.idfOffice as [PKField_4582800000000], 
			p_sent_hc.idfPerson as [PKField_4582810000000], 
			o_sent_hc.idfOffice as [PKField_4582820000000], 
			outb.idfOutbreak as [PKField_4582900000000], 
			o_fsc_hc.idfOffice as [PKField_4583090000025], 
			s_ent_hc.idfsSite as [PKField_4583090000030], 
			o_hosp_hc.idfOffice as [PKField_4583090000035], 
			diag_hc.idfsDiagnosis as [PKField_4583090000040], 
			stlm_HCLoc.idfsSettlement as [PKField_4583090000050], 
			stlm_HC_PCR.idfsSettlement as [PKField_4583090000051], 
			stlm_HC_PEmp.idfsSettlement as [PKField_4583090000052], 
			stlm_HC_PPR.idfsSettlement as [PKField_4583090000053], 
			gl_cr_hc.idfGeoLocation as [sflHC_PatientCRAddress_ID], 
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
			hc.idfsYNAntimicrobialTherapy as [sflHC_AntimicrobialTherapy_ID], 
			IsNull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) as [sflHC_CaseClassification_ID], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			d_changed_hc.strIDC10 as [sflHC_ChangedDiagnosisCode], 
			hc.idfsHospitalizationStatus as [sflHC_HospitalizationStatus_ID], 
			hc.datEnteredDate as [sflHC_EnteredDate], 
			hc.datModificationDate as [sflHC_ModificationDate], 
			h_hc.datDateofBirth as [sflHC_PatientDOB], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			hc.datCompletionPaperFormDate as [sflHC_CompletionPaperFormDate], 
			h_hc.datDateOfDeath as [sflHC_PatientDeathDate], 
			hc.datDischargeDate as [sflHC_PatientDischargeDate], 
			hc.datExposureDate as [sflHC_ExposureDate], 
			hc.datFacilityLastVisit as [sflHC_FacilityLastVisitDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			DATEDIFF(D, hc.datNotificationDate, hc.datEnteredDate) as [sflHC_DaysAfterNotification], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			d_init_hc.strIDC10 as [sflHC_DiagnosisCode], 
			gl_emp_hc.idfGeoLocation as [sflHC_PatientEmpAddress_ID], 
			h_hc.strWorkPhone as [sflHC_PatientEmployerPhone], 
			gl_emp_hc.idfsRayon as [sflHC_PatientEmpRayon_ID], 
			gl_emp_hc.idfsRegion as [sflHC_PatientEmpRegion_ID], 
			gl_emp_hc.idfsSettlement as [sflHC_PatientEmpSettlement_ID], 
			o_rec_hc.idfsOfficeName as [sflHC_ReceivedByOffice_ID], 
			o_sent_hc.idfsOfficeName as [sflHC_SentByOffice_ID], 
			hc.idfsYNHospitalization as [sflHC_Hospitalization_ID], 
			case when hc.idfsHospitalizationStatus = 5350000000 then o_hosp_hc.idfsOfficeAbbreviation else null end as [sflHC_CurrentLocation_ID], 
			hc.idfsYNRelatedToOutbreak as [sflHC_RelatedToOutbreak_ID], 
			hc.strLocalIdentifier as [sflHC_LocalID], 
			gl_hc.idfsRayon as [sflHC_LocationRayon_ID], 
			gl_hc.idfsRegion as [sflHC_LocationRegion_ID], 
			dbo.fnConcatFullName(h_hc.strLastName, h_hc.strFirstName, h_hc.strSecondName) as [sflHC_PatientName], 
			h_hc.strEmployerName as [sflHC_PatientEmployer], 
			h_hc.idfsNationality as [sflHC_PatientNationality_ID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			dbo.fnConcatFullName(p_rec_hc.strFamilyName, p_rec_hc.strFirstName, p_rec_hc.strSecondName) as [sflHC_ReceivedByPerson], 
			dbo.fnConcatFullName(p_sent_hc.strFamilyName, p_sent_hc.strFirstName, p_sent_hc.strSecondName) as [sflHC_SentByPerson], 
			o_inv_hc.idfsOfficeName as [sflHC_InvestigatedByOffice_ID], 
			outb.strOutbreakID as [sflHC_OutbreakID], 
			hc.idfsOutcome as [sflHC_Outcome_ID], 
			h_hc.strHomePhone as [sflHC_PatientPhone], 
			gl_cr_hc.idfsRayon as [sflHC_PatientCRRayon_ID], 
			gl_cr_hc.idfsRegion as [sflHC_PatientCRRegion_ID], 
			gl_cr_hc.idfsSettlement as [sflHC_PatientCRSettlement_ID], 
			h_hc.idfsHumanGender as [sflHC_PatientSex_ID], 
			hc.idfsYNSpecimenCollected as [sflHC_SamplesCollected_ID], 
			hc.datInvestigationStartDate as [sflHC_InvestigationStartDate], 
			hc.idfsFinalState as [sflHC_PatientNotificationStatus_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			d_fin_hc.strIDC10 as [sflHC_FinalDiagnosisCode], 
			hc.idfsCaseProgressStatus as [sflHC_CaseProgressStatus_ID], 
			hc.idfsInitialCaseStatus as [sflHC_InitialCaseClassification_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			hc.idfsHumanAgeType as [sflHC_PatientAgeType_ID], 
			h_hc.idfsOccupationType as [sflHC_PatientOccupation_ID], 
			hc.datHospitalizationDate as [sflHC_PatientHospitalizationDate], 
			hc.datFirstSoughtCareDate as [sflHC_PatientFirstSoughtCareDate], 
			gl_hc.idfsSettlement as [sflHC_LocationSettlement_ID], 
			IsNull(N'(' + cast(gl_hc.dblLatitude as nvarchar) + N'; ' + cast(gl_hc.dblLongitude as nvarchar) + N')', N'') as [sflHC_LocationCoordinates], 
			hc.strHospitalizationPlace as [sflHC_HospitalizationPlace], 
			(IsNull(hc.blnClinicalDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnClinicalDiagBasis, 0)) * 10100002) as [sflHC_ClinicalDiagBasis_ID], 
			(IsNull(hc.blnEpiDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnEpiDiagBasis, 0)) * 10100002) as [sflHC_EpiDiagBasis_ID], 
			(IsNull(hc.blnLabDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnLabDiagBasis, 0)) * 10100002) as [sflHC_LabDiagBasis_ID], 
			hc.idfsNotCollectedReason as [sflHC_ReasonForNotCollectingSample_ID], 
			o_fsc_hc.idfsOfficeName as [sflHC_FacilityWherePatientFSC_ID], 
			hc.idfsNonNotifiableDiagnosis as [sflHC_NonNotifiableDiagnosis_ID], 
			case when hc.idfsHospitalizationStatus = 5360000000 then hc.strCurrentLocation else null end as [sflHC_OtherLocation], 
			DATEDIFF(DD, hc.datTentativeDiagnosisDate, hc.datNotificationDate) as [sflHC_DaysAfterInitDiagUntilNotif], 
			DATEDIFF(DD, hc.datOnSetDate, hc.datNotificationDate) as [sflHC_DaysAfterOnsetSymptUntilNotif], 
			DATEDIFF(DD, hc.datOnSetDate, hc.datFirstSoughtCareDate) as [sflHC_DaysAfterSymptOnsetUntilFSC], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, hc.datNotificationDate) as [sflHC_DaysAfterFSCUntilNotif], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, hc.datEnteredDate) as [sflHC_DaysAfterFSCUntilEntered], 
			DATEDIFF(DD, hc.datNotificationDate, hc.datInvestigationStartDate) as [sflHC_DaysAfterNotifUntilCaseInvest], 
			DATEDIFF(DD, hc.datTentativeDiagnosisDate, hc.datFinalDiagnosisDate) as [sflHC_DaysAfterInitDiagUntilFinal], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, hc.datFinalDiagnosisDate) as [sflHC_DaysAfterFSCUntilFinalDiag], 
			IsNull(N'(' + cast(gl_cr_hc.dblLatitude as nvarchar) + N'; ' + cast(gl_cr_hc.dblLongitude as nvarchar) + N')', N'') as [sflHC_PatientCRCoordinates], 
			IsNull(N'(' + cast(gl_reg_hc.dblLatitude as nvarchar) + N'; ' + cast(gl_reg_hc.dblLongitude as nvarchar) + N')', N'') as [sflHC_PatientPRCoordinates], 
			hc.idfsYNTestsConducted as [sflHC_TestConducted_ID], 
			dbo.fnConcatFullName(p_inv_hc.strFamilyName, p_inv_hc.strFirstName, p_inv_hc.strSecondName) as [sflHC_EpidemiologistName], 
			gl_reg_hc.idfsRegion as [sflHC_PatientPRRegion_ID], 
			gl_reg_hc.idfsRayon as [sflHC_PatientPRRayon_ID], 
			gl_reg_hc.idfsSettlement as [sflHC_PatientPRSettlement_ID], 
			gl_reg_hc.idfGeoLocation as [sflHC_PatientPRAddress_ID], 
			gl_reg_hc.idfsCountry as [sflHC_PatientPRCountry_ID], 
			case gl_reg_hc.blnForeignAddress when 1 then gl_reg_hc.strForeignAddress else null end as [sflHC_PatientPRForeignAddress], 
			h_hc.strRegistrationPhone as [sflHC_PatientPRPhone], 
			o_ent_hc.idfsOfficeName as [sflHC_EnteredBySite_ID], 
			gl_cr_hc.dblLongitude as [sflHC_PatientCRLongitude], 
			gl_cr_hc.dblLatitude as [sflHC_PatientCRLatitudee], 
			gl_hc.dblLongitude as [sflHC_LocationLongitude], 
			gl_hc.dblLatitude as [sflHC_LocationLatitude], 
			gl_reg_hc.dblLongitude as [sflHC_PatientPRLongitude], 
			gl_reg_hc.dblLatitude as [sflHC_PatientPRLatitudee], 
			hc.datFinalCaseClassificationDate as [sflHC_DateFinalCaseClassification], 
			dbo.fnConcatFullName(p_ent_hc.strFamilyName, p_ent_hc.strFirstName, p_ent_hc.strSecondName) as [sflHC_EnteredByEmployer], 
			case when hc.idfsHospitalizationStatus = 5350000000 then o_hosp_hc.strOrganizationID else null end as [sflHC_HospitalNameID], 
			(IsNull(d_changed_hc.blnZoonotic, 0) * 10100001 + (1 - IsNull(d_changed_hc.blnZoonotic, 0)) * 10100002) as [sflHC_ChangedDiagnosisIsZoonotic_ID], 
			(IsNull(d_init_hc.blnZoonotic, 0) * 10100001 + (1 - IsNull(d_init_hc.blnZoonotic, 0)) * 10100002) as [sflHC_DiagnosisIsZoonotic_ID], 
			(IsNull(d_fin_hc.blnZoonotic, 0) * 10100001 + (1 - IsNull(d_fin_hc.blnZoonotic, 0)) * 10100002) as [sflHC_FinalDiagnosisIsZoonotic_ID], 
			isnull(gr_diag_hc.idfsDiagnosisGroup ,diag_hc.idfsDiagnosis) as [sflHC_DiagnosesAndGroups_ID], 
			h_hc.idfsPersonIDType as [sflHC_PatientPersonalIDType_ID], 
			h_hc.strPersonID as [sflHC_PatientPersonalID], 
			o_ent_hc.strOrganizationID  as [sflHC_EnteredByOrganizationID], 
			o_fsc_hc.strOrganizationID  as [sflHC_FacilityWherePatientFSCCode], 
			o_rec_hc.strOrganizationID  as [sflHC_ReceivedByOfficeID], 
			o_sent_hc.strOrganizationID  as [sflHC_SentByOfficeID], 
			o_inv_hc.strOrganizationID  as [sflHC_InvestigatedByOfficeID], 
			stlm_HCLoc.intElevation as [sflHC_LocationElevationm], 
			stlm_HC_PCR.intElevation as [sflHC_PCRElevationm], 
			stlm_HC_PEmp.intElevation as [sflHC_PEMPElevationm], 
			stlm_HC_PPR.intElevation as [sflHC_PPRElevationm], 
			gl_hc.idfsCountry  as [sflHC_LocationCountry_ID], 
			case when gl_hc.idfsGeoLocationType = 10036001 then 10100001 when gl_hc.idfsGeoLocationType is null then null else 10100002 end  as [sflHC_LocationIsForeignAddress_ID], 
			case when gl_hc.blnForeignAddress = 1 then gl_hc.strForeignAddress else null end  as [sflHC_LocationForeignAddress]

from 

( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

  	 
  		tlbOffice o_hosp_hc 
  	 
  
ON o_hosp_hc.idfOffice = hc.idfHospital 
left join 

  	 
  		trtDiagnosis diag_hc 
  			outer apply (
  				select min(group_diag_hc.idfsDiagnosisGroup) as idfsDiagnosisGroup
  				from dbo.trtDiagnosisToDiagnosisGroup group_diag_hc
  				where group_diag_hc.idfsDiagnosis = diag_hc.idfsDiagnosis
  			) as gr_diag_hc
  	 
  
ON diag_hc.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join 

 
	tlbOffice o_fsc_hc 
 

ON o_fsc_hc.idfOffice = hc.idfSoughtCareFacility AND o_fsc_hc.intRowStatus = 0 
left join 

 
	tlbOffice o_inv_hc 
 

ON o_inv_hc.idfOffice = hc.idfInvestigatedByOffice AND o_inv_hc.intRowStatus = 0 
left join 

 
	tlbOffice o_rec_hc 
 

ON o_rec_hc.idfOffice = hc.idfReceivedByOffice AND o_rec_hc.intRowStatus = 0 
left join 

 
	tlbOffice o_sent_hc 
 

ON o_sent_hc.idfOffice = hc.idfSentByOffice AND o_sent_hc.intRowStatus = 0 
left join 

 
	tlbOutbreak outb 
 

ON outb.idfOutbreak = hc.idfOutbreak AND outb.intRowStatus = 0 
left join 

 
	tlbPerson p_ent_hc 
 

ON p_ent_hc.idfPerson = hc.idfPersonEnteredBy 
left join 

 
	tlbPerson p_inv_hc 
 

ON p_inv_hc.idfPerson = hc.idfInvestigatedByPerson 
left join 

 
	tlbPerson p_rec_hc 
 

ON p_rec_hc.idfPerson = hc.idfReceivedByPerson 
left join 

 
	tlbPerson p_sent_hc 
 

ON p_sent_hc.idfPerson = hc.idfSentByPerson 
left join 

 
	trtDiagnosis d_changed_hc 
 

ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join 

 
	trtDiagnosis d_fin_hc 
 

ON d_fin_hc.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join 

 
	trtDiagnosis d_init_hc 
 

ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
left join 

( 
	tlbGeoLocation gl_cr_hc 
left join 

	 
		gisSettlement stlm_HC_PCR 
	 
   
ON  gl_cr_hc.idfsSettlement = stlm_HC_PCR.idfsSettlement 
) 

ON gl_cr_hc.idfGeoLocation = h_hc.idfCurrentResidenceAddress AND gl_cr_hc.intRowStatus = 0 
left join 

( 
	tlbGeoLocation gl_emp_hc 
left join 

	 
		gisSettlement stlm_HC_PEmp 
	 
   
ON  gl_emp_hc.idfsSettlement = stlm_HC_PEmp.idfsSettlement 
) 

ON gl_emp_hc.idfGeoLocation = h_hc.idfEmployerAddress AND gl_emp_hc.intRowStatus = 0 
left join 

( 
	tlbGeoLocation gl_hc 
left join 

	 
		gisSettlement stlm_HCLoc 
	 
   
ON  gl_hc.idfsSettlement = stlm_HCLoc.idfsSettlement 
) 

ON gl_hc.idfGeoLocation = hc.idfPointGeoLocation AND gl_hc.intRowStatus = 0 
left join 

( 
	tlbGeoLocation gl_reg_hc 
left join 

	 
		gisSettlement stlm_HC_PPR 
	 
   
ON  gl_reg_hc.idfsSettlement = stlm_HC_PPR.idfsSettlement 
) 

ON gl_reg_hc.idfGeoLocation = h_hc.idfRegistrationAddress AND gl_reg_hc.intRowStatus = 0 
left join 

( 
	tstSite s_ent_hc 
	inner join	tlbOffice o_ent_hc 
	on			o_ent_hc.idfOffice = s_ent_hc.idfOffice 
) 

ON s_ent_hc.idfsSite = hc.idfsSite 
) 



where		hc.intRowStatus = 0


