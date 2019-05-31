
CREATE VIEW [dbo].[Human_Case_and_Event_Tracking_GG]
as

SELECT
	v.[sflHC_ModificationDate]							AS Date_Last_Saved_Human_Case
	, v.[sflHC_CompletionPaperFormDate]					AS Date_of_Completion_of_Paper_Form
	, v.[sflHC_FacilityLastVisitDate]					AS Date_of_Last_Patient_Presence_at_Work
	, v.[sflHC_PatientDischargeDate]					AS Date_of_Patient_Discharge
	, v.[sflHC_PatientFirstSoughtCareDate]				AS Date_Patient_First_Sought_Care
	, v.[sflHC_EnteredDate]								AS Human_Case_Date_Entered
	, v.[sflHC_SentByPerson]							AS Human_Case_Notification_Sent_by_Officer
	, v.[sflHC_ReceivedByPerson]						AS Human_Case_Notification_Received_by_Officer
	, [ref_sflHC_ReceivedByOffice].[name]				AS Human_Case_Notification_Received_by_Facility
	, [ref_sflHC_SentByOffice].[name]					AS Human_Case_Notification_Sent_by_Facility
	, v.[sflHC_PatientAgeGroup]							AS Human_case_Patient_Age_Group
	, [ref_sflHC_PatientNotificationStatus].[name]		AS Patient_Status_at_Time_of_Notification
	, v.[sflHC_SymptomOnsetDate]						AS Date_of_Onset_of_Patient_Symptoms
	, v.[sflHC_OtherLocation]							AS Other_location_name
	, [ref_GIS_sflHC_ResidenceRegion].[name]			AS Permanent_Residence_Region
	, [ref_GIS_sflHC_ResidenceRayon].[name]				AS Permanent_Residence_Rayon
	, [ref_GIS_sflHC_ResidenceSettlement].[name]		AS Permanent_Residence_Town_or_Village
	, v.[sflHC_ResidencePostCode]						AS Permanent_Residence_Postal_Code
	, v.[sflHC_ResidenceStreetName]						AS Permanent_Residence_Street
	, v.[sflHC_PatientEmployerPhone]					AS Patient_Employer_Phone_Number
	, [ref_sflHC_HospitalizationStatus].[name]			AS Patient_Location_at_Time_of_Notification
	, [ref_sflHCDiagnosisHistory_Organization].[name]	AS Organization_Changed_Human_Case_Diagnosis
	, v.[sflHCDiagnosisHistory_PersonName]				AS Person_Changed_Human_Case_Diagnosis
	, v.[sflHC_InvestigationStartDate]					AS Human_Case_Starting_Investigation_Date
	, [ref_sflHC_FinalDiagnosis].[name]					AS Human_Case_Final_Diagnosis
	, v.[sflHC_NotificationDate]						AS Human_Case_Notification_Date
	, [ref_sflHC_FinalCaseClassification].[name]		AS Human_Case_Final_Classification
	, v.[sflHC_CurrentLocation]							AS Hospital_Name
	, v.[sflHC_PatientAge]								AS Patient_Age
	, [ref_sflHCSample_CollectedByOffice].[name]		AS Sample_Collected_By_Institution
	, v.[sflHC_HospitalizationPlace]					AS Place_of_Patient_Hospitalization
	, v.[sflHC_PatientHospitalizationDate]				AS Date_of_Patient_Hospitalization
	, [ref_sflHC_Hospitalization].[name]				AS Patient_Hospitalization
	, [ref_sflHC_NonNotifiableDiagnosis].[name]			AS NonNotifiableDiagnosisfromfacilityWherePatientFirstSoughtCare
	, [ref_sflHC_FacilityWherePatientFSC].[name]		AS Facility_Where_Patient_First_Sought_Care
	, v.[sflHC_CaseID]									AS Human_Case_ID
	, [ref_sflHC_CaseProgressStatus].[name]				AS Human_Case_Status
	, [ref_sflHC_ReasonForNotCollectingSample].[name]	AS Reason_for_not_Collecting_Sample
	, v.[sflHC_CollectedByPerson]						AS Collected_By_Officer
	, v.[sflHC_AccessionedByPerson]						AS Accessioned_by_Officer
	, v.[sflHC_InvestigatedByPerson]					AS Epidemiologist_name
	, v.[sflHCSample_ParentLabSampleID]					AS Original_Sample_ID
	, v.[sflHCSample_LabSampleID]						AS Lab_Sample_ID
	, v.[sflHC_LocalID]									AS Local_Identifier
	, v.[sflHCSample_FieldSampleID]						AS Local_Sample_ID
	, [ref_sflHC_Diagnosis].[name]						AS Human_Case_Diagnosis
	, v.[sflHC_DiagnosisDate]							AS Human_Case_Diagnosis_Date
	, [ref_sflHC_ChangedDiagnosis].[name]				AS Human_Case_Changed_Diagnosis
	, v.[sflHC_ChangedDiagnosisDate]					AS Human_Case_Date_of_Changed_Diagnosis
	, v.[sflHC_FinalDiagnosisDate]						AS Human_Case_Final_Diagnosis_Date
FROM Human_Case_and_Event_Tracking v

LEFT JOIN fnReferenceRepair('ka', 19000046) [ref_sflHC_ReceivedByOffice] ON 
	[ref_sflHC_ReceivedByOffice].idfsReference = v.[sflHC_ReceivedByOffice_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000046) [ref_sflHC_SentByOffice] ON 
	[ref_sflHC_SentByOffice].idfsReference = v.[sflHC_SentByOffice_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000035) [ref_sflHC_PatientNotificationStatus] ON 
	[ref_sflHC_PatientNotificationStatus].idfsReference = v.[sflHC_PatientNotificationStatus_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000041) [ref_sflHC_HospitalizationStatus] ON 
	[ref_sflHC_HospitalizationStatus].idfsReference = v.[sflHC_HospitalizationStatus_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000019) [ref_sflHC_FinalDiagnosis] ON 
	[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000011) [ref_sflHC_FinalCaseClassification] ON 
	[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000100) [ref_sflHC_Hospitalization] ON 
	[ref_sflHC_Hospitalization].idfsReference = v.[sflHC_Hospitalization_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000149) [ref_sflHC_NonNotifiableDiagnosis] ON 
	[ref_sflHC_NonNotifiableDiagnosis].idfsReference = v.[sflHC_NonNotifiableDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000046) [ref_sflHC_FacilityWherePatientFSC] ON 
	[ref_sflHC_FacilityWherePatientFSC].idfsReference = v.[sflHC_FacilityWherePatientFSC_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000111) [ref_sflHC_CaseProgressStatus] ON 
	[ref_sflHC_CaseProgressStatus].idfsReference = v.[sflHC_CaseProgressStatus_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000150) [ref_sflHC_ReasonForNotCollectingSample] ON 
	[ref_sflHC_ReasonForNotCollectingSample].idfsReference = v.[sflHC_ReasonForNotCollectingSample_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000019) [ref_sflHC_Diagnosis] ON 
	[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000019) [ref_sflHC_ChangedDiagnosis] ON 
	[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000045) [ref_sflHCDiagnosisHistory_Organization] ON 
	[ref_sflHCDiagnosisHistory_Organization].idfsReference = v.[sflHCDiagnosisHistory_Organization_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000046) [ref_sflHCSample_CollectedByOffice] ON 
	[ref_sflHCSample_CollectedByOffice].idfsReference = v.[sflHCSample_CollectedByOffice_ID] 
	
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000003) [ref_GIS_sflHC_ResidenceRegion] ON 
	[ref_GIS_sflHC_ResidenceRegion].idfsReference = v.[sflHC_ResidenceRegion_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000002) [ref_GIS_sflHC_ResidenceRayon] ON 
	[ref_GIS_sflHC_ResidenceRayon].idfsReference = v.[sflHC_ResidenceRayon_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000004) [ref_GIS_sflHC_ResidenceSettlement] ON 
	[ref_GIS_sflHC_ResidenceSettlement].idfsReference = v.[sflHC_ResidenceSettlement_ID] 
