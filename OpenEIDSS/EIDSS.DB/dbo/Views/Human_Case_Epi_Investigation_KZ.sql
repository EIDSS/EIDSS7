
CREATE VIEW [dbo].[Human_Case_Epi_Investigation_KZ]
AS

SELECT 
	v.[sflHC_OutbreakID]							AS Outbreak_ID_of_Human_Case
	, v.[sflHC_InvestigationStartDate]				AS Human_Case_Starting_Investigation_Date
	, [ref_sflHC_InvestigatedByOffice].[name]		AS Organization_Conducting_Human_Case_Investigation
	, [ref_sflHC_RelatedToOutbreak].[name]			AS Human_Case_Related_to_Outbreak
	, [ref_sflHC_Diagnosis].[name]					AS Human_Case_Diagnosis
	, [ref_sflHC_FinalDiagnosis].[name]				AS Human_Case_Final_Diagnosis
	, [ref_sflHC_ChangedDiagnosis].[name]			AS Human_Case_Changed_Diagnosis
	, v.[sflHC_CaseID]								AS Human_Case_ID
	, [ref_sflHC_FinalCaseClassification].[name]	AS Human_Case_Final_Classification
	, v.[sflHC_NotificationDate]					AS Human_Case_Notification_Date
	, v.[sflHC_SymptomOnsetDate]					AS Date_of_Onset_of_Patient_Symptoms
	, v.[sflHC_FinalDiagnosisDate]					AS Human_Case_Final_Diagnosis_Date
	, v.[sflHC_DiagnosisDate]						AS Human_Case_Diagnosis_Date
	, [ref_GL_sflHCContact_Information].[name]		AS Contacts_Information
	, v.[sflHCContact_Name]							AS Contact_Name
	, [ref_sflHCContact_Relation].[name]			AS Contact_Relation
	, v.[sflHCContact_LastContactDate]				AS Date_of_Last_Contact
	, v.[sflHCContact_LastContactPlace]				AS Place_of_Last_Contact
FROM Human_Case_Epi_Investigation v

LEFT JOIN fnReferenceRepair('kk', 19000046) [ref_sflHC_InvestigatedByOffice] ON 
	[ref_sflHC_InvestigatedByOffice].idfsReference = v.[sflHC_InvestigatedByOffice_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000100) [ref_sflHC_RelatedToOutbreak] ON 
	[ref_sflHC_RelatedToOutbreak].idfsReference = v.[sflHC_RelatedToOutbreak_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000019) [ref_sflHC_Diagnosis] ON 
	[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000019) [ref_sflHC_FinalDiagnosis] ON 
	[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000019) [ref_sflHC_ChangedDiagnosis] ON 
	[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000011) [ref_sflHC_FinalCaseClassification] ON 
	[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
LEFT JOIN fnGeoLocationTranslation('kk') [ref_GL_sflHCContact_Information] ON 
	[ref_GL_sflHCContact_Information].idfGeoLocation = v.[sflHCContact_Information_ID] 
LEFT JOIN fnReferenceRepair('kk', 19000014) [ref_sflHCContact_Relation] ON 
	[ref_sflHCContact_Relation].idfsReference = v.[sflHCContact_Relation_ID] 
