



CREATE VIEW [dbo].[Human_Case_Antibiotic_Use_and_Sample_RU]
as
select		
			[ref_sflHC_AntimicrobialTherapy].[name] as [AntibioticsAntiviralTherapyAdministeredbeforeSampleCollection], 
			v.[sflHCAntibiotic_Name] as [Antibiotic_Name], 
			v.[sflHCAntibiotic_Dose] as [Antibiotic_Dose], 
			v.[sflHCAntibiotic_AdministratedDate] as [Antibiotic_First_Administered_Date], 		
			[ref_sflHC_SamplesCollected].[name] as [Samples_Collected_for_Human_Case], 
			[ref_sflHCSample_SampleType].[name] as [Sample_Type], 			
			[ref_sflHCTest_TestResult].[name] as [Test_Result], 
			[ref_sflHCTest_TestType].[name] as [Test_Name] ,
			[ref_sflHCTest_TestForDiseaseType].[name] as [Test_Category],
			[ref_sflHCSample_AccessionCondition].[name] as [Sample_Condition_Received], 			
			v.[sflHCSample_AccessionDate] as [Sample_Accession_Date], 					
			[ref_sflHC_Diagnosis].[name] as [Human_Case_Diagnosis], 
			[ref_sflHC_FinalDiagnosis].[name] as [Human_Case_Final_Diagnosis], 
			[ref_sflHC_ChangedDiagnosis].[name] as [Human_Case_Changed_Diagnosis], 
			v.[sflHC_CaseID] as [Human_Case_ID], 
			[ref_sflHC_FinalCaseClassification].[name] as [Human_Case_Final_Classification], 
			v.[sflHC_SymptomOnsetDate] as [Date_of_Onset_of_Patient_Symptoms], 
			v.[sflHC_NotificationDate] as [Human_Case_Notification_Date], 
			v.[sflHC_FinalDiagnosisDate] as [Human_Case_Final_Diagnosis_Date]





			
from		[Human_Case_Antibiotic_Use_and_Sample] v

left join	fnReferenceRepair('ru', 19000100) [ref_sflHC_AntimicrobialTherapy] 
on			[ref_sflHC_AntimicrobialTherapy].idfsReference = v.[sflHC_AntimicrobialTherapy_ID] 
left join	fnReferenceRepair('ru', 19000100) [ref_sflHC_SamplesCollected] 
on			[ref_sflHC_SamplesCollected].idfsReference = v.[sflHC_SamplesCollected_ID] 
left join	fnReferenceRepair('ru', 19000019) [ref_sflHC_Diagnosis] 
on			[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
left join	fnReferenceRepair('ru', 19000019) [ref_sflHC_FinalDiagnosis] 
on			[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
left join	fnReferenceRepair('ru', 19000019) [ref_sflHC_ChangedDiagnosis] 
on			[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
left join	fnReferenceRepair('ru', 19000011) [ref_sflHC_FinalCaseClassification] 
on			[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
left join	fnReferenceRepair('ru', 19000087) [ref_sflHCSample_SampleType] 
on			[ref_sflHCSample_SampleType].idfsReference = v.[sflHCSample_SampleType_ID] 
left join	fnReferenceRepair('ru', 19000110) [ref_sflHCSample_AccessionCondition] 
on			[ref_sflHCSample_AccessionCondition].idfsReference = v.[sflHCSample_AccessionCondition_ID] 
left join	fnReferenceRepair('ru', 19000096) [ref_sflHCTest_TestResult] 
on			[ref_sflHCTest_TestResult].idfsReference = v.[sflHCTest_TestResult_ID] 
left join	fnReferenceRepair('ru', 19000097) [ref_sflHCTest_TestType] 
on			[ref_sflHCTest_TestType].idfsReference = v.[sflHCTest_TestType_ID] 
left join	fnReferenceRepair('ru', 19000095) [ref_sflHCTest_TestForDiseaseType] 
on			[ref_sflHCTest_TestForDiseaseType].idfsReference = v.[sflHCTest_TestForDiseaseType_ID] 


--Not needed--left join	fnReference('ru', 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 



