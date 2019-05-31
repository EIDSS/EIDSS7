


CREATE VIEW [dbo].[Human_Case_Surveillance_Indicators_GG]
as
select		
			v.[sflHCSample_DaysInTransit] as [Sample_Days_in_Transit], 
			v.[sflHCSample_DaysAfterNotifUntilSC] as [Days_After_Notification], 
			v.[sflHC_DaysAfterInitDiagUntilNotif] as [Days_after_Initial_Diagnosis_until_Notification], 
			v.[sflHC_DaysAfterOnsetSymptUntilNotif] as [Days_after_Onset_of_Patient_Symptoms_until_Notification], 
			v.[sflHC_DaysAfterSymptOnsetUntilFSC] as [Days_after_Symptom_Onset_until_First_Sought_Care], 
			v.[sflHC_DaysAfterFSCUntilNotif] as [Days_after_First_Sought_Care_until_Notification], 
			v.[sflHC_DaysAfterFSCUntilEntered] as [Days_after_Patient_First_Sought_Care_until_Entered], 
			v.[sflHC_DaysAfterNotifUntilCaseInvest] as [Days_after_Notification_until_Case_Investigation], 
			v.[sflHC_DaysAfterInitDiagUntilFinal] as [Days_after_Initial_Diagnosis_until_Final_Diagnosis], 
			v.[sflHC_DaysAfterFSCUntilFinalDiag] as [Days_after_Patient_First_Sought_Care_until_Final_Diagnosis], 
			v.[sflHCSample_DaysAfterFSCuntilSC] as [Days_after_First_Sought_Care_until_Sample_Collection], 
			v.[sflHCSample_DaysUntilSent_Collect] as [Days_until_Sample_Sent_Since_Sample_Collection], 
			v.[sflHCSample_DaysUntAccesSinceSent] as [Days_until_Sample_Accessioned_Since_Sent_Date], 
			v.[sflHCTest_DaysUntilTest_SmplSent] as [Days_until_Testing_since_Sample_Sent], 
			v.[sflHCTest_DaysUntilTest_SmplAcces] as [Days_until_Testing_since_Sample_Accessioned], 
			[ref_sflHC_Diagnosis].[name] as [Human_Case_Diagnosis], 
			[ref_sflHC_FinalDiagnosis].[name] as [Human_Case_Final_Diagnosis], 
			[ref_sflHC_ChangedDiagnosis].[name] as [Human_Case_Changed_Diagnosis], 
			v.[sflHC_CaseID] as [Human_Case_ID], 
			[ref_sflHC_FinalCaseClassification].[name] as [Human_Case_Final_Classification], 
			[ref_sflHC_SamplesCollected].[name] as [Samples_Collected_for_Human_Case], 
			v.[sflHC_NotificationDate] as [Human_Case_Notification_Date], 
			v.[sflHC_SymptomOnsetDate] as [Date_of_Onset_of_Patient_Symptoms], 
			v.[sflHC_FinalDiagnosisDate] as [Human_Case_Final_Diagnosis_Date], 
			v.[sflHC_DiagnosisDate] as [Human_Case_Diagnosis_Date], 
			v.[sflHC_EnteredDate] as [Human_Case_Entered_Date], 
			v.[sflHCSample_AccessionDate] as [Sample_Accession_Date], 
			v.[sflHCTest_PerformedDate] as [Date_Tested], 			
			
			v.[sflHCSample_CollectionDate] as [Sample_Collection_Date], 
			v.[sflHCSample_SentDate] as [Sample_Sent_Date]



from		[Human_Case_Surveillance_Indicators] v

left join	fnReferenceRepair('ka', 19000019) [ref_sflHC_Diagnosis] 
on			[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
left join	fnReferenceRepair('ka', 19000019) [ref_sflHC_FinalDiagnosis] 
on			[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
left join	fnReferenceRepair('ka', 19000019) [ref_sflHC_ChangedDiagnosis] 
on			[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
left join	fnReferenceRepair('ka', 19000011) [ref_sflHC_FinalCaseClassification] 
on			[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
left join	fnReferenceRepair('ka', 19000100) [ref_sflHC_SamplesCollected] 
on			[ref_sflHC_SamplesCollected].idfsReference = v.[sflHC_SamplesCollected_ID] 



--Not needed--left join	fnReference('ka', 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 







