
CREATE VIEW [dbo].[Human_Case_Persons_Place_Time_GG]
AS

SELECT 	
	v.[sflHC_PatientDOB]							AS Date_of_Patient_Birth
	, v.[sflHC_PatientDeathDate]					AS Date_of_Patients_Death
	, [ref_sflHC_FinalCaseClassification].[name]	AS Final_Human_Case_Classification 
	, [ref_sflHC_ChangedDiagnosis].[name]			AS Human_Case_Changed_Diagnosis
	, v.[sflHC_ChangedDiagnosisDate]				AS Human_Case_Changed_Diagnosis_Date
	, [ref_sflHC_Diagnosis].[name]					AS Human_Case_Diagnosis
	, v.[sflHC_SymptomOnsetDate]					AS Date_of_Onset_of_Patient_Symptoms
	, v.[sflHC_DiagnosisDate]						AS Human_Case_Diagnosis_Date 
	, [ref_sflHC_FinalDiagnosis].[name]				AS Human_Case_Final_Diagnosis
	, v.[sflHC_FinalDiagnosisDate]					AS Human_Case_Final_Diagnosis_Date
	, v.[sflHC_NotificationDate]					AS Human_Case_Notification_Date
	, [ref_sflHC_Outcome].[name]					AS Human_Case_Outcome
	, [ref_sflHC_InitialCaseClassification].[name]	AS Initial_Human_Case_Classification
	, v.[sflHC_PatientCRAddress]					AS Patient_Current_Residence_Address
	, v.[sflHC_PatientCRRayon_ID]						AS sflHC_PatientCRRayon_ID
	, [ref_GIS_sflHC_PatientCRRayon].[name]			AS Patient_Current_Residence_Rayon
	, v.[sflHC_PatientCRRegion_ID]						AS sflHC_PatientCRRegion_ID
	, [ref_GIS_sflHC_PatientCRRegion].[name]		AS Patient_Current_Residence_Region
	, [ref_sflHC_Hospitalization].[name]			AS Patient_Hospitalization
	, v.[sflHC_PatientName]							AS Patient_Name
	, [ref_sflHC_PatientNationality].[name]			AS Patient_Nationality_Citizenship
	, [ref_sflHC_PatientNotificationStatus].[name]	AS Patient_Status_at_Time_of_Notification
	, [ref_sflHC_PatientSex].[name]					AS Patient_Sex
	, [ref_sflHC_PatientOccupation].[name]			AS Patient_Occupation
	, [ref_sflHC_PatientAgeType].[name]				AS Patient_Age_Type
	, [ref_GIS_sflHC_PatientEmpRayon].[name]		AS Patient_Employer_Rayon
	, [ref_GIS_sflHC_PatientEmpRegion].[name]		AS Patient_Employer_Region
	, [ref_GIS_sflHC_PatientEmpSettlement].[name]	AS Patient_Employer_Settlement 
	, v.[sflHC_PatientEmpAddress]					AS Patient_Employer_Address 
	, v.[sflHC_PatientEmployer]						AS Patient_Employer_Name
	, v.[sflHC_CaseID]								AS Human_Case_ID
	, v.[sflHC_PatientAge]							AS Patient_Age
	, v.[sflHC_PatientAgeGroup]						AS Human_Case_Patient_Age_Group 
	, [ref_GIS_sflHC_PatientCRSettlement].[name]	AS Patient_Current_Residence_Settlement 
	, v.[sflHC_PatientCRCoordinatesLatitude]		AS Patient_Current_Residence_Latitude
	, v.[sflHC_PatientCRCoordinatesLongitude]		AS Patient_Current_Residence_Longitude
FROM Human_Case_Persons_Place_Time v

LEFT JOIN fnReferenceRepair('ka', 19000011) [ref_sflHC_FinalCaseClassification] ON
	[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000019) [ref_sflHC_ChangedDiagnosis] ON 
	[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000019) [ref_sflHC_Diagnosis] ON
	[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000019) [ref_sflHC_FinalDiagnosis] ON 
	[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000064) [ref_sflHC_Outcome] ON 
	[ref_sflHC_Outcome].idfsReference = v.[sflHC_Outcome_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000011) [ref_sflHC_InitialCaseClassification] ON 
	[ref_sflHC_InitialCaseClassification].idfsReference = v.[sflHC_InitialCaseClassification_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000002) [ref_GIS_sflHC_PatientCRRayon] ON 
	[ref_GIS_sflHC_PatientCRRayon].idfsReference = v.[sflHC_PatientCRRayon_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000003) [ref_GIS_sflHC_PatientCRRegion] ON 
	[ref_GIS_sflHC_PatientCRRegion].idfsReference = v.[sflHC_PatientCRRegion_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000100) [ref_sflHC_Hospitalization] ON 
	[ref_sflHC_Hospitalization].idfsReference = v.[sflHC_Hospitalization_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000054) [ref_sflHC_PatientNationality] ON 
	[ref_sflHC_PatientNationality].idfsReference = v.[sflHC_PatientNationality_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000035) [ref_sflHC_PatientNotificationStatus] ON 
	[ref_sflHC_PatientNotificationStatus].idfsReference = v.[sflHC_PatientNotificationStatus_ID] 
LEFT JOIN 	fnReferenceRepair('ka', 19000043) [ref_sflHC_PatientSex] ON 
	[ref_sflHC_PatientSex].idfsReference = v.[sflHC_PatientSex_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000061) [ref_sflHC_PatientOccupation] ON 
	[ref_sflHC_PatientOccupation].idfsReference = v.[sflHC_PatientOccupation_ID] 
LEFT JOIN fnReferenceRepair('ka', 19000042) [ref_sflHC_PatientAgeType] ON 
	[ref_sflHC_PatientAgeType].idfsReference = v.[sflHC_PatientAgeType_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000002) [ref_GIS_sflHC_PatientEmpRayon] ON 
	[ref_GIS_sflHC_PatientEmpRayon].idfsReference = v.[sflHC_PatientEmpRayon_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000003) [ref_GIS_sflHC_PatientEmpRegion] ON 
	[ref_GIS_sflHC_PatientEmpRegion].idfsReference = v.[sflHC_PatientEmpRegion_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000004) [ref_GIS_sflHC_PatientEmpSettlement] ON 
	[ref_GIS_sflHC_PatientEmpSettlement].idfsReference = v.[sflHC_PatientEmpSettlement_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('ka', 19000004) [ref_GIS_sflHC_PatientCRSettlement] ON 
	[ref_GIS_sflHC_PatientCRSettlement].idfsReference = v.[sflHC_PatientCRSettlement_ID] 
