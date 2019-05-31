

CREATE VIEW [dbo].[vw_AVR_HumanCaseReport]
as

select		hc.idfHumanCase as [PKField], 
			hc.idfHumanCase as [PKField_4582670000000], 
			d_changed_hc.idfsDiagnosis as [PKField_4582680000000], 
			gl_cr_hc.idfGeoLocation as [PKField_4582700000000], 
			d_fin_hc.idfsDiagnosis as [PKField_4582730000000], 
			d_init_hc.idfsDiagnosis as [PKField_4582740000000], 
			outb.idfOutbreak as [PKField_4582900000000], 
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
			IsNull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) as [sflHC_CaseClassification_ID], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			hc.datEnteredDate as [sflHC_EnteredDate], 
			h_hc.datDateofBirth as [sflHC_PatientDOB], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			hc.datCompletionPaperFormDate as [sflHC_CompletionPaperFormDate], 
			h_hc.datDateOfDeath as [sflHC_PatientDeathDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			hc.idfsYNRelatedToOutbreak as [sflHC_RelatedToOutbreak_ID], 
			dbo.fnConcatFullName(h_hc.strLastName, h_hc.strFirstName, h_hc.strSecondName) as [sflHC_PatientName], 
			h_hc.idfsNationality as [sflHC_PatientNationality_ID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			outb.strOutbreakID as [sflHC_OutbreakID], 
			hc.idfsOutcome as [sflHC_Outcome_ID], 
			gl_cr_hc.idfsRayon as [sflHC_PatientCRRayon_ID], 
			gl_cr_hc.idfsRegion as [sflHC_PatientCRRegion_ID], 
			gl_cr_hc.idfsSettlement as [sflHC_PatientCRSettlement_ID], 
			h_hc.idfsHumanGender as [sflHC_PatientSex_ID], 
			hc.idfsYNSpecimenCollected as [sflHC_SamplesCollected_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			hc.idfsCaseProgressStatus as [sflHC_CaseProgressStatus_ID], 
			hc.idfsInitialCaseStatus as [sflHC_InitialCaseClassification_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			hc.idfsHumanAgeType as [sflHC_PatientAgeType_ID], 
			h_hc.idfsOccupationType as [sflHC_PatientOccupation_ID], 
			(IsNull(hc.blnClinicalDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnClinicalDiagBasis, 0)) * 10100002) as [sflHC_ClinicalDiagBasis_ID], 
			(IsNull(hc.blnEpiDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnEpiDiagBasis, 0)) * 10100002) as [sflHC_EpiDiagBasis_ID], 
			(IsNull(hc.blnLabDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnLabDiagBasis, 0)) * 10100002) as [sflHC_LabDiagBasis_ID], 
			hc.datFinalCaseClassificationDate as [sflHC_DateFinalCaseClassification]

from 

( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

 
	tlbGeoLocation gl_cr_hc 
 

ON gl_cr_hc.idfGeoLocation = h_hc.idfCurrentResidenceAddress AND gl_cr_hc.intRowStatus = 0 
left join 

 
	tlbOutbreak outb 
 

ON outb.idfOutbreak = hc.idfOutbreak AND outb.intRowStatus = 0 
left join 

 
	trtDiagnosis d_changed_hc 
 

ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join 

 
	trtDiagnosis d_fin_hc 
 

ON d_fin_hc.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join 

 
	trtDiagnosis d_init_hc 
 

ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
) 



where		hc.intRowStatus = 0


