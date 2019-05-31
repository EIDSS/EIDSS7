
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

CREATE VIEW [dbo].[Human_Case_Diagnosis]
as

select		hc.idfHumanCase as [PKField], 
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
			d_changed_hc.strIDC10 as [sflHC_ChangedDiagnosisCode], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			d_init_hc.strIDC10 as [sflHC_DiagnosisCode], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			hc.idfsOutcome as [sflHC_Outcome_ID], 
			hc.idfsYNSpecimenCollected as [sflHC_SamplesCollected_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			d_fin_hc.strIDC10 as [sflHC_FinalDiagnosisCode], 
			m.idfsSampleType as [sflHCTest_SampleType_ID], 
			t.idfsTestName as [sflHCTest_TestType_ID], 
			t.idfsTestResult as [sflHCTest_TestResult_ID], 
			hc.idfsInitialCaseStatus as [sflHC_InitialCaseClassification_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			hc.datFirstSoughtCareDate as [sflHC_PatientFirstSoughtCareDate], 
			hdh.idfsPreviousDiagnosis as [sflHCDiagnosisHistory_PreviousDiagnosis_ID], 
			hdh.idfsCurrentDiagnosis as [sflHCDiagnosisHistory_ChangedDiagnosis_ID], 
			(IsNull(hc.blnClinicalDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnClinicalDiagBasis, 0)) * 10100002) as [sflHC_ClinicalDiagBasis_ID], 
			(IsNull(hc.blnEpiDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnEpiDiagBasis, 0)) * 10100002) as [sflHC_EpiDiagBasis_ID], 
			(IsNull(hc.blnLabDiagBasis, 0) * 10100001 + (1 - IsNull(hc.blnLabDiagBasis, 0)) * 10100002) as [sflHC_LabDiagBasis_ID],
			m.idfsAccessionCondition as [sflHCSample_AccessionCondition_ID], 
			t.idfsTestCategory as [sflHCTest_TestForDiseaseType_ID]

from 

( 
	tlbHumanCase hc
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

 
	trtDiagnosis d_changed_hc 
 

ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join 

 
	trtDiagnosis d_fin_hc 
 

ON d_fin_hc.idfsDiagnosis = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
left join 

 
	trtDiagnosis d_init_hc 
 

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
left join 

 
	tlbTesting AS t
 

ON m.idfMaterial = t.idfMaterial AND t.intRowStatus = 0 
) 

ON h_hc.idfHuman = m.idfHuman AND m.intRowStatus = 0 
) 



where		hc.intRowStatus = 0





