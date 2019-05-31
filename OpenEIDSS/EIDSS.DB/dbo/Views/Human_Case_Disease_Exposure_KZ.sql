
CREATE VIEW [dbo].[Human_Case_Disease_Exposure_KZ]
AS

SELECT 
	v.[sflHC_ExposureDate]							AS Date_of_Human_Case_Exposure
	, [ref_GIS_sflHC_LocationRegion].[name]			AS Location_of_Human_Case_Exposure_Region
	, [ref_GIS_sflHC_LocationRayon].[name]			AS Location_of_Human_Case_Exposure_Rayon
	, [ref_GIS_sflHC_LocationSettlement].[name]		AS Location_of_Human_Case_Exposure_Settlement
	, [ref_sflHC_Diagnosis].[name]					AS Human_Case_Diagnosis
	, [ref_sflHC_FinalDiagnosis].[name]				AS Human_Case_Final_Diagnosis
	, [ref_sflHC_ChangedDiagnosis].[name]			AS Human_Case_Changed_Diagnosis
	, v.[sflHC_CaseID]								AS Human_Case_ID
	, [ref_sflHC_FinalCaseClassification].[name]	AS Human_Case_Final_Classification
	, v.[sflHC_SymptomOnsetDate]					AS Date_of_Onset_of_Patient_Symptoms
	, v.[sflHC_NotificationDate]					AS Human_Case_Notification_Date
	, v.[sflHC_FinalDiagnosisDate]					AS Human_Case_Final_Diagnosis_Date
	, v.[sflHC_DiagnosisDate]						AS Human_Case_Diagnosis_Date
	, v.[sflHC_ChangedDiagnosisDate]				AS Human_Case_Date_of_Changed_Diagnosis
	, v.[sflHC_PatientFirstSoughtCareDate]			AS Date_Patient_First_Sought_Care
	, v.[sflHC_LocationCoordinatesLatitude]			AS Location_of__Human_Case_Exposure_Longitude
	, v.[sflHC_LocationCoordinatesLongitude]		AS Location_of__Human_Case_Exposure_Latitude
FROM Human_Case_Disease_Exposure v

LEFT JOIN fnGisExtendedReferenceRepair('kk', 19000003) [ref_GIS_sflHC_LocationRegion] ON 
	[ref_GIS_sflHC_LocationRegion].idfsReference = v.[sflHC_LocationRegion_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('kk', 19000002) [ref_GIS_sflHC_LocationRayon] ON 
	[ref_GIS_sflHC_LocationRayon].idfsReference = v.[sflHC_LocationRayon_ID] 
LEFT JOIN fnGisExtendedReferenceRepair('kk', 19000004) [ref_GIS_sflHC_LocationSettlement] ON 
	[ref_GIS_sflHC_LocationSettlement].idfsReference = v.[sflHC_LocationSettlement_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000019) [ref_sflHC_Diagnosis] ON 
	[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000019) [ref_sflHC_FinalDiagnosis] ON 
	[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000019) [ref_sflHC_ChangedDiagnosis] ON 
	[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000011) [ref_sflHC_FinalCaseClassification] ON 
	[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
