
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

CREATE VIEW [dbo].[Human_Case_Antibiotic_Use_and_Sample]
as

select		hc.idfHumanCase as [PKField], 
			at.strDosage as [sflHCAntibiotic_AdministratedDate], 
			hc.idfsYNAntimicrobialTherapy as [sflHC_AntimicrobialTherapy_ID], 
			at.strAntimicrobialTherapyName as [sflHCAntibiotic_Name], 
			at.strDosage as [sflHCAntibiotic_Dose], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			hc.idfsYNSpecimenCollected as [sflHC_SamplesCollected_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			m.datAccession as [sflHCSample_AccessionDate], 
			m.idfsSampleType as [sflHCSample_SampleType_ID], 
			t.idfsTestName as [sflHCTest_TestType_ID], 
			t.idfsTestResult as [sflHCTest_TestResult_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			m.idfsAccessionCondition as [sflHCSample_AccessionCondition_ID],
			t.idfsTestCategory as [sflHCTest_TestForDiseaseType_ID]

from 

( 
	tlbHumanCase hc
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

 
	tlbAntimicrobialTherapy at 
 

ON at.idfHumanCase = hc.idfHumanCase AND at.intRowStatus = 0 
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







