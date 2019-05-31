

CREATE VIEW [dbo].[Human_Case_Diagnosis_KZ]
as

select		
			[ref_sflHC_FinalCaseClassification].[name] as [Final_Human_Case_Classification], 
			[ref_sflHC_ChangedDiagnosis].[name] as [Human_Case_Changed_Diagnosis], 
			v.[sflHC_ChangedDiagnosisCode] as [Human_Case_Changed_Diagnosis_Code], 
			v.[sflHC_ChangedDiagnosisDate] as [Human_Case_Changed_Diagnosis_Date], 
			[ref_sflHC_Diagnosis].[name] as [Human_Case_Diagnosis], 
			v.[sflHC_DiagnosisCode] as [Human_Case_Diagnosis_Code], 
			v.[sflHC_DiagnosisDate] as [Human_Case_Diagnosis_Date], 
			[ref_sflHC_FinalDiagnosis].[name] as [Human_Case_Final_Diagnosis], 
			v.[sflHC_FinalDiagnosisCode] as [Human_Case_Final_Diagnosis_Code], 
			v.[sflHC_FinalDiagnosisDate] as [Human_Case_Final_Diagnosis_Date], 
			v.[sflHC_NotificationDate] as [Human_Case_Notification_Date], 
			[ref_sflHC_Outcome].[name] as [Human_Case_Outcome], 
			[ref_sflHC_InitialCaseClassification].[name] as [Initial_Human_Case_Classification], 
			v.[sflHC_SymptomOnsetDate] as [Date_of_Onset_of_Patient_Symptoms], 
			[ref_sflHCDiagnosisHistory_ChangedDiagnosis].[name] as [Changed_Diagnosis_from_History], 
			[ref_sflHCDiagnosisHistory_PreviousDiagnosis].[name] as [Previous_Diagnosis_from_History], 			
			v.[sflHC_CaseID] as [Human_Case_ID], 
			[ref_sflHC_SamplesCollected].[name] as [Samples_Collected_for_Human_Case], 
			[ref_sflHCTest_SampleType].[name] as [Sample_Type], 
			[ref_sflHCTest_TestResult].[name] as [Test_Result], 
			[ref_sflHCTest_TestType].[name] as [Test_Name],
			[ref_sflHCTest_TestForDiseaseType].[name] as [Test_Category],
			[ref_sflHCSample_AccessionCondition].[name] as [Sample_Condition_Received],			
			[ref_sflHC_ClinicalDiagBasis].[name] as [Basis_of_Diagnosis_Clinical], 
			[ref_sflHC_EpiDiagBasis].[name] as [Basis_of_Diagnosis_Epidemiological_Links], 
			[ref_sflHC_LabDiagBasis].[name] as [Basis_of_Diagnosis_Laboratory_Test], 
			v.[sflHC_PatientAgeGroup] as [Human_Case_Patients_Age_Group], 			
			v.[sflHC_PatientFirstSoughtCareDate] as [Date_Patient_First_Sought_Care]		
			
from		Human_Case_Diagnosis v

left join	fnReferenceRepair('kk', 19000011) [ref_sflHC_FinalCaseClassification] 
on			[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
left join	fnReferenceRepair('kk', 19000019) [ref_sflHC_ChangedDiagnosis] 
on			[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
left join	fnReferenceRepair('kk', 19000019) [ref_sflHC_Diagnosis] 
on			[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
left join	fnReferenceRepair('kk', 19000019) [ref_sflHC_FinalDiagnosis] 
on			[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
left join	fnReferenceRepair('kk', 19000064) [ref_sflHC_Outcome] 
on			[ref_sflHC_Outcome].idfsReference = v.[sflHC_Outcome_ID] 
left join	fnReferenceRepair('kk', 19000011) [ref_sflHC_InitialCaseClassification] 
on			[ref_sflHC_InitialCaseClassification].idfsReference = v.[sflHC_InitialCaseClassification_ID] 
left join	fnReferenceRepair('kk', 19000100) [ref_sflHC_SamplesCollected] 
on			[ref_sflHC_SamplesCollected].idfsReference = v.[sflHC_SamplesCollected_ID] 
left join	fnReferenceRepair('kk', 19000100) [ref_sflHC_ClinicalDiagBasis] 
on			[ref_sflHC_ClinicalDiagBasis].idfsReference = v.[sflHC_ClinicalDiagBasis_ID] 
left join	fnReferenceRepair('kk', 19000100) [ref_sflHC_EpiDiagBasis] 
on			[ref_sflHC_EpiDiagBasis].idfsReference = v.[sflHC_EpiDiagBasis_ID] 
left join	fnReferenceRepair('kk', 19000100) [ref_sflHC_LabDiagBasis] 
on			[ref_sflHC_LabDiagBasis].idfsReference = v.[sflHC_LabDiagBasis_ID] 
left join	fnReferenceRepair('kk', 19000019) [ref_sflHCDiagnosisHistory_ChangedDiagnosis] 
on			[ref_sflHCDiagnosisHistory_ChangedDiagnosis].idfsReference = v.[sflHCDiagnosisHistory_ChangedDiagnosis_ID] 
left join	fnReferenceRepair('kk', 19000019) [ref_sflHCDiagnosisHistory_PreviousDiagnosis] 
on			[ref_sflHCDiagnosisHistory_PreviousDiagnosis].idfsReference = v.[sflHCDiagnosisHistory_PreviousDiagnosis_ID] 
left join	fnReferenceRepair('kk', 19000087) [ref_sflHCTest_SampleType] 
on			[ref_sflHCTest_SampleType].idfsReference = v.[sflHCTest_SampleType_ID] 
left join	fnReferenceRepair('kk', 19000096) [ref_sflHCTest_TestResult] 
on			[ref_sflHCTest_TestResult].idfsReference = v.[sflHCTest_TestResult_ID] 
left join	fnReferenceRepair('kk', 19000097) [ref_sflHCTest_TestType] 
on			[ref_sflHCTest_TestType].idfsReference = v.[sflHCTest_TestType_ID] 
left join	fnReferenceRepair('kk', 19000110) [ref_sflHCSample_AccessionCondition] 
on			[ref_sflHCSample_AccessionCondition].idfsReference = v.[sflHCSample_AccessionCondition_ID] 
left join	fnReferenceRepair('kk', 19000095) [ref_sflHCTest_TestForDiseaseType] 
on			[ref_sflHCTest_TestForDiseaseType].idfsReference = v.[sflHCTest_TestForDiseaseType_ID] 
