

CREATE VIEW [dbo].[Human_Sample_and_Test_UA]
as
select		

			[ref_sflHC_FinalCaseClassification].[name] as [Final_Human_Case_Classification], 
			[ref_sflHC_ChangedDiagnosis].[name] as [Human_Case_Changed_Diagnosis], 
			v.[sflHC_ChangedDiagnosisDate] as [Human_Case_Changed_Diagnosis_Date], 			
			[ref_sflHC_Diagnosis].[name] as [Human_Case_Diagnosis], 
			v.[sflHC_DiagnosisDate] as [Human_Case_Diagnosis_Date], 
			[ref_sflHC_FinalDiagnosis].[name] as [Human_Case_Final_Diagnosis], 
			v.[sflHC_FinalDiagnosisDate] as [Human_Case_Final_Diagnosis_Date], 
			v.[sflHC_NotificationDate] as [Human_Case_Notification_Date], 
			[ref_sflHC_Outcome].[name] as [Human_Case_Outcome], 
			[ref_sflHC_InitialCaseClassification].[name] as [Initial_Human_Case_Classification], 
			v.[sflHC_SymptomOnsetDate] as [Date_of_Onset_of_Patient_Symptoms], 
			v.[sflHC_CaseID] as [Human_Case_ID], 
			[ref_sflHC_SamplesCollected].[name] as [Samples_Collected_for_Human_Case], 
			[ref_sflHC_ReasonForNotCollectingSample].[name] as [Reasons_for_not_Collecting_Sample], 
			[ref_sflHC_ClinicalDiagBasis].[name] as [Basis_of_Diagnosis_Clinical], 
			[ref_sflHC_EpiDiagBasis].[name] as [Basis_of_Diagnosis_Epidemiological_Links], 
			[ref_sflHC_LabDiagBasis].[name] as [Basis_of_Diagnosis_Laboratory_Test], 
			v.[sflHC_PatientAgeGroup] as [Human_Case_Patients_Age_Group], 
			v.[sflHC_PatientAge] as [Patient_Age], 
			[ref_sflHC_PatientAgeType].[name] as [Patient_Age_Type], 
			v.[sflHC_PatientFirstSoughtCareDate] as [Date_Patient_First_Sought_Care], 
			[ref_sflHCSample_CollectedByOffice].[name] as [Sample_Collected_by_Institution], 
			v.[sflHCSample_CollectedByEmployee] as [Collected_by_Officer], 
			v.[sflHCSample_LabSampleID] as [Lab_Sample_ID], 
			v.[sflHCSample_SentDate] as [Sample_Sent_Date], 
			v.[sflHCSample_CollectionDate] as [Sample_Collection_Date], 
			v.[sflHCSample_AccessionDate] as [Sample_Accession_Date], 
			[ref_sflHCSample_AccessionCondition].[name] as [Sample_Condition_Received], 
			[ref_sflHCSample_SampleType].[name] as [Sample_Type], 
			[ref_sflHCTest_TestType].[name] as [Test_Name], 			
			[ref_sflHCTest_Diagnosis].[name] as [Test_Diagnosis], 		
			[ref_sflHCTest_TestForDiseaseType].[name] as [Test_Category],			
			[ref_sflHCTest_TestStatus].[name] as [Test_Status], 	
			[ref_sflHCTest_TestResult].[name] as [Test_Result], 
			v.[sflHCTest_ValidatedDate] as [Date_Test_Validated], 	
			v.[sflHCTest_PerformedDate] as [Date_Tested], 					
			v.[sflHCSample_DaysAfterNotifUntilSC] as [Days_after_Notification_until_ Sample_Collection], 
			v.[sflHCSample_DaysAfterFSCuntilSC] as [Days_after_First_Sought_Care_ until_Sample_Collection], 
			v.[sflHCSample_DaysUntAccesSinceSent] as [Days_until_Sample_Accessioned_since_Sent], 
			v.[sflHCTest_DaysUntilTest_SmplSent] as [Days_until_Testing_since_Sample_Sent], 
			v.[sflHCTest_DaysUntilTest_SmplAcces]  as [Days_until_Testing_since_Sample_Accessioned]
from		Human_Sample_and_Test v

left join	fnReferenceRepair('uk', 19000011) [ref_sflHC_FinalCaseClassification] 
on			[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
left join	fnReferenceRepair('uk', 19000019) [ref_sflHC_ChangedDiagnosis] 
on			[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
left join	fnReferenceRepair('uk', 19000019) [ref_sflHC_Diagnosis] 
on			[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
left join	fnReferenceRepair('uk', 19000019) [ref_sflHC_FinalDiagnosis] 
on			[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
left join	fnReferenceRepair('uk', 19000064) [ref_sflHC_Outcome] 
on			[ref_sflHC_Outcome].idfsReference = v.[sflHC_Outcome_ID] 
left join	fnReferenceRepair('uk', 19000011) [ref_sflHC_InitialCaseClassification] 
on			[ref_sflHC_InitialCaseClassification].idfsReference = v.[sflHC_InitialCaseClassification_ID] 
left join	fnReferenceRepair('uk', 19000100) [ref_sflHC_SamplesCollected] 
on			[ref_sflHC_SamplesCollected].idfsReference = v.[sflHC_SamplesCollected_ID] 
left join	fnReferenceRepair('uk', 19000150) [ref_sflHC_ReasonForNotCollectingSample] 
on			[ref_sflHC_ReasonForNotCollectingSample].idfsReference = v.[sflHC_ReasonForNotCollectingSample_ID] 
left join	fnReferenceRepair('uk', 19000100) [ref_sflHC_ClinicalDiagBasis] 
on			[ref_sflHC_ClinicalDiagBasis].idfsReference = v.[sflHC_ClinicalDiagBasis_ID] 
left join	fnReferenceRepair('uk', 19000100) [ref_sflHC_EpiDiagBasis] 
on			[ref_sflHC_EpiDiagBasis].idfsReference = v.[sflHC_EpiDiagBasis_ID] 
left join	fnReferenceRepair('uk', 19000100) [ref_sflHC_LabDiagBasis] 
on			[ref_sflHC_LabDiagBasis].idfsReference = v.[sflHC_LabDiagBasis_ID] 
left join	fnReferenceRepair('uk', 19000042) [ref_sflHC_PatientAgeType] 
on			[ref_sflHC_PatientAgeType].idfsReference = v.[sflHC_PatientAgeType_ID] 
left join	fnReferenceRepair('uk', 19000046) [ref_sflHCSample_CollectedByOffice] 
on			[ref_sflHCSample_CollectedByOffice].idfsReference = v.[sflHCSample_CollectedByOffice_ID] 
left join	fnReferenceRepair('uk', 19000110) [ref_sflHCSample_AccessionCondition] 
on			[ref_sflHCSample_AccessionCondition].idfsReference = v.[sflHCSample_AccessionCondition_ID] 
left join	fnReferenceRepair('uk', 19000087) [ref_sflHCSample_SampleType] 
on			[ref_sflHCSample_SampleType].idfsReference = v.[sflHCSample_SampleType_ID] 
left join	fnReferenceRepair('uk', 19000097) [ref_sflHCTest_TestType] 
on			[ref_sflHCTest_TestType].idfsReference = v.[sflHCTest_TestType_ID] 
left join	fnReferenceRepair('uk', 19000019) [ref_sflHCTest_Diagnosis] 
on			[ref_sflHCTest_Diagnosis].idfsReference = v.[sflHCTest_Diagnosis_ID] 
left join	fnReferenceRepair('uk', 19000001) [ref_sflHCTest_TestStatus] 
on			[ref_sflHCTest_TestStatus].idfsReference = v.[sflHCTest_TestStatus_ID] 
left join	fnReferenceRepair('uk', 19000096) [ref_sflHCTest_TestResult] 
on			[ref_sflHCTest_TestResult].idfsReference = v.[sflHCTest_TestResult_ID] 
left join	fnReferenceRepair('uk', 19000095) [ref_sflHCTest_TestForDiseaseType] 
on			[ref_sflHCTest_TestForDiseaseType].idfsReference = v.[sflHCTest_TestForDiseaseType_ID] 


--Not needed--left join	fnReference('uk', 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 



