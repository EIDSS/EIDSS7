
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

CREATE VIEW [dbo].[Human_Case_Persons_Place_Time]
as

select		hc.idfHumanCase as [PKField], 
			gl_cr_hc.strStreetName + N' ' + gl_cr_hc.strHouse + IsNull(N'-' + gl_cr_hc.strBuilding, N'') + IsNull(N'-' + gl_cr_hc.strApartment, N'') as [sflHC_PatientCRAddress], 
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
			h_hc.datDateofBirth as [sflHC_PatientDOB], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			h_hc.datDateOfDeath as [sflHC_PatientDeathDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			gl_emp_hc.strStreetName + N' ' + gl_emp_hc.strHouse + IsNull(N'-' + gl_emp_hc.strBuilding, N'') + IsNull(N'-' + gl_emp_hc.strApartment, N'') as [sflHC_PatientEmpAddress], 
			gl_emp_hc.idfsRayon as [sflHC_PatientEmpRayon_ID], 
			gl_emp_hc.idfsRegion as [sflHC_PatientEmpRegion_ID], 
			gl_emp_hc.idfsSettlement as [sflHC_PatientEmpSettlement_ID], 
			hc.idfsYNHospitalization as [sflHC_Hospitalization_ID], 
			h_hc.strLastName + IsNull(N' ' + h_hc.strFirstName, N'') + IsNull(N' ' + h_hc.strSecondName, N'') as [sflHC_PatientName], 
			h_hc.strEmployerName as [sflHC_PatientEmployer], 
			h_hc.idfsNationality as [sflHC_PatientNationality_ID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			hc.idfsOutcome as [sflHC_Outcome_ID], 
			gl_cr_hc.idfsRayon as [sflHC_PatientCRRayon_ID], 
			gl_cr_hc.idfsRegion as [sflHC_PatientCRRegion_ID], 
			gl_cr_hc.idfsSettlement as [sflHC_PatientCRSettlement_ID], 
			h_hc.idfsHumanGender as [sflHC_PatientSex_ID], 
			hc.idfsFinalState as [sflHC_PatientNotificationStatus_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			hc.idfsInitialCaseStatus as [sflHC_InitialCaseClassification_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			hc.idfsHumanAgeType as [sflHC_PatientAgeType_ID], 
			h_hc.idfsOccupationType as [sflHC_PatientOccupation_ID], 
			IsNull(N'(' + cast(gl_cr_hc.dblLatitude as nvarchar) + N')', N'') as [sflHC_PatientCRCoordinatesLatitude],
			IsNull(N'(' + cast(gl_cr_hc.dblLongitude as nvarchar) + N')', N'') as [sflHC_PatientCRCoordinatesLongitude]

from 
( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join  tlbGeoLocation gl_cr_hc 
ON gl_cr_hc.idfGeoLocation = h_hc.idfCurrentResidenceAddress AND gl_cr_hc.intRowStatus = 0 
left join tlbGeoLocation gl_emp_hc
ON gl_emp_hc.idfGeoLocation = h_hc.idfEmployerAddress AND gl_emp_hc.intRowStatus = 0 
left join trtDiagnosis d_changed_hc 
ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join trtDiagnosis d_fin_hc 
ON d_fin_hc.idfsDiagnosis = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
left join trtDiagnosis d_init_hc 
ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
) 
where		hc.intRowStatus = 0
