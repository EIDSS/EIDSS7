

CREATE FUNCTION [dbo].[fn_AVR_BasicSyndromicSurveillanceReport]
(
@LangID	as nvarchar(50)
)
returns table
as
return
select		
v.[sflBss_FormID], 
			v.[sflBss_DateEntered], 
			v.[sflBss_DateLastSaved], 
			v.[sflBss_EnteredBy], 
			v.[sflBss_Site_ID], 
			[ref_sflBss_Site].[name] as [sflBss_Site], 
			v.[sflBss_NotificationOf_ID], 
			[ref_sflBss_NotificationOf].[name] as [sflBss_NotificationOf], 
			v.[sflBss_NameOfHospital_ID], 
			[ref_sflBss_NameOfHospital].[name] as [sflBss_NameOfHospital], 
			v.[sflBss_ReportDate], 
			v.[sflBss_PatientName], 
			v.[sflBss_PersonalID], 
			v.[sflBss_Sex_ID], 
			[ref_sflBss_Sex].[name] as [sflBss_Sex], 
			v.[sflBss_Pregnant_ID], 
			[ref_sflBss_Pregnant].[name] as [sflBss_Pregnant], 
			v.[sflBss_PostpartumPeriod_ID], 
			[ref_sflBss_PostpartumPeriod].[name] as [sflBss_PostpartumPeriod], 
			v.[sflBss_DateOfBirth], 
			v.[sflBss_CompletePatientAgeMonths], 
			v.[sflBss_CompletePatientAgeYears], 
			v.[sflBss_CompletePatientAgeYM], 
			v.[sflBss_Region_ID], 
			[ref_GIS_sflBss_Region].[ExtendedName] as [sflBss_Region], 
			[ref_GIS_sflBss_Region].[name] as [sflBss_Region_ShortGISName], 
			v.[sflBss_Rayon_ID], 
			[ref_GIS_sflBss_Rayon].[ExtendedName] as [sflBss_Rayon], 
			[ref_GIS_sflBss_Rayon].[name] as [sflBss_Rayon_ShortGISName], 
			v.[sflBss_Settlement_ID], 
			[ref_GIS_sflBss_Settlement].[ExtendedName] as [sflBss_Settlement], 
			[ref_GIS_sflBss_Settlement].[name] as [sflBss_Settlement_ShortGISName], 
			v.[sflBss_Elevationm], 
			v.[sflBss_DateOfSymptomsOnset], 
			v.[sflBss_Fever_ID], 
			[ref_sflBss_Fever].[name] as [sflBss_Fever], 
			v.[sflBss_MethodOfMeasurement_ID], 
			[ref_sflBss_MethodOfMeasurement].[name] as [sflBss_MethodOfMeasurement], 
			v.[sflBss_OtherMethodOfMeasurement], 
			v.[sflBss_Cough_ID], 
			[ref_sflBss_Cough].[name] as [sflBss_Cough], 
			v.[sflBss_ShortnessOfBreath_ID], 
			[ref_sflBss_ShortnessOfBreath].[name] as [sflBss_ShortnessOfBreath], 
			v.[sflBss_SeasonalFluVaccine_ID], 
			[ref_sflBss_SeasonalFluVaccine].[name] as [sflBss_SeasonalFluVaccine], 
			v.[sflBss_DateOfCare], 
			v.[sflBss_PatientWasInER_ID], 
			[ref_sflBss_PatientWasInER].[name] as [sflBss_PatientWasInER], 
			v.[sflBss_PatientWasHospitalized1N_ID], 
			[ref_sflBss_PatientWasHospitalized1N].[name] as [sflBss_PatientWasHospitalized1N], 
			v.[sflBss_Outcome_ID], 
			[ref_sflBss_Outcome].[name] as [sflBss_Outcome], 
			v.[sflBss_Treatment_ID], 
			[ref_sflBss_Treatment].[name] as [sflBss_Treatment], 
			v.[sflBss_AdminAntiviralMedication_ID], 
			[ref_sflBss_AdminAntiviralMedication].[name] as [sflBss_AdminAntiviralMedication], 
			v.[sflBss_NameOfMedication], 
			v.[sflBss_DateReceivedAntiviralMed], 
			v.[sflBss_RespiratorySystem_ID], 
			[ref_sflBss_RespiratorySystem].[name] as [sflBss_RespiratorySystem], 
			v.[sflBss_Asthma_ID], 
			[ref_sflBss_Asthma].[name] as [sflBss_Asthma], 
			v.[sflBss_Diabetes_ID], 
			[ref_sflBss_Diabetes].[name] as [sflBss_Diabetes], 
			v.[sflBss_Cardiovascular_ID], 
			[ref_sflBss_Cardiovascular].[name] as [sflBss_Cardiovascular], 
			v.[sflBss_Obesity_ID], 
			[ref_sflBss_Obesity].[name] as [sflBss_Obesity], 
			v.[sflBss_Renal_ID], 
			[ref_sflBss_Renal].[name] as [sflBss_Renal], 
			v.[sflBss_Liver_ID], 
			[ref_sflBss_Liver].[name] as [sflBss_Liver], 
			v.[sflBss_Neurological_ID], 
			[ref_sflBss_Neurological].[name] as [sflBss_Neurological], 
			v.[sflBss_Immunodeficiency_ID], 
			[ref_sflBss_Immunodeficiency].[name] as [sflBss_Immunodeficiency], 
			v.[sflBss_UnknownEtiology_ID], 
			[ref_sflBss_UnknownEtiology].[name] as [sflBss_UnknownEtiology], 
			v.[sflBss_SampleCollectionDate], 
			v.[sflBss_SampleID], 
			v.[sflBss_TestResult_ID], 
			[ref_sflBss_TestResult].[name] as [sflBss_TestResult], 
			v.[sflBss_ResultDate], 
			v.[sflBss_CDCAgeGroup_ID], 
			[ref_sflBss_CDCAgeGroup].[name] as [sflBss_CDCAgeGroup], 
			v.[sflBss_WHOAgeGroup_ID], 
			[ref_sflBss_WHOAgeGroup].[name] as [sflBss_WHOAgeGroup] 
from		vw_AVR_BasicSyndromicSurveillanceReport v

left join	fnReferenceRepair(@LangID, 19000045) [ref_sflBss_Site] 
on			[ref_sflBss_Site].idfsReference = v.[sflBss_Site_ID] 
left join	fnReferenceRepair(@LangID, 19000159) [ref_sflBss_NotificationOf] 
on			[ref_sflBss_NotificationOf].idfsReference = v.[sflBss_NotificationOf_ID] 
left join	fnReferenceRepair(@LangID, 19000045) [ref_sflBss_NameOfHospital] 
on			[ref_sflBss_NameOfHospital].idfsReference = v.[sflBss_NameOfHospital_ID] 
left join	fnReferenceRepair(@LangID, 19000043) [ref_sflBss_Sex] 
on			[ref_sflBss_Sex].idfsReference = v.[sflBss_Sex_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Pregnant] 
on			[ref_sflBss_Pregnant].idfsReference = v.[sflBss_Pregnant_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_PostpartumPeriod] 
on			[ref_sflBss_PostpartumPeriod].idfsReference = v.[sflBss_PostpartumPeriod_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflBss_Region]  
on			[ref_GIS_sflBss_Region].idfsReference = v.[sflBss_Region_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflBss_Rayon]  
on			[ref_GIS_sflBss_Rayon].idfsReference = v.[sflBss_Rayon_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflBss_Settlement]  
on			[ref_GIS_sflBss_Settlement].idfsReference = v.[sflBss_Settlement_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Fever] 
on			[ref_sflBss_Fever].idfsReference = v.[sflBss_Fever_ID] 
left join	fnReferenceRepair(@LangID, 19000160) [ref_sflBss_MethodOfMeasurement] 
on			[ref_sflBss_MethodOfMeasurement].idfsReference = v.[sflBss_MethodOfMeasurement_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Cough] 
on			[ref_sflBss_Cough].idfsReference = v.[sflBss_Cough_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_ShortnessOfBreath] 
on			[ref_sflBss_ShortnessOfBreath].idfsReference = v.[sflBss_ShortnessOfBreath_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_SeasonalFluVaccine] 
on			[ref_sflBss_SeasonalFluVaccine].idfsReference = v.[sflBss_SeasonalFluVaccine_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_PatientWasInER] 
on			[ref_sflBss_PatientWasInER].idfsReference = v.[sflBss_PatientWasInER_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_PatientWasHospitalized1N] 
on			[ref_sflBss_PatientWasHospitalized1N].idfsReference = v.[sflBss_PatientWasHospitalized1N_ID] 
left join	fnReferenceRepair(@LangID, 19000161) [ref_sflBss_Outcome] 
on			[ref_sflBss_Outcome].idfsReference = v.[sflBss_Outcome_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Treatment] 
on			[ref_sflBss_Treatment].idfsReference = v.[sflBss_Treatment_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_AdminAntiviralMedication] 
on			[ref_sflBss_AdminAntiviralMedication].idfsReference = v.[sflBss_AdminAntiviralMedication_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_RespiratorySystem] 
on			[ref_sflBss_RespiratorySystem].idfsReference = v.[sflBss_RespiratorySystem_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Asthma] 
on			[ref_sflBss_Asthma].idfsReference = v.[sflBss_Asthma_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Diabetes] 
on			[ref_sflBss_Diabetes].idfsReference = v.[sflBss_Diabetes_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Cardiovascular] 
on			[ref_sflBss_Cardiovascular].idfsReference = v.[sflBss_Cardiovascular_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Obesity] 
on			[ref_sflBss_Obesity].idfsReference = v.[sflBss_Obesity_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Renal] 
on			[ref_sflBss_Renal].idfsReference = v.[sflBss_Renal_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Liver] 
on			[ref_sflBss_Liver].idfsReference = v.[sflBss_Liver_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Neurological] 
on			[ref_sflBss_Neurological].idfsReference = v.[sflBss_Neurological_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_Immunodeficiency] 
on			[ref_sflBss_Immunodeficiency].idfsReference = v.[sflBss_Immunodeficiency_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflBss_UnknownEtiology] 
on			[ref_sflBss_UnknownEtiology].idfsReference = v.[sflBss_UnknownEtiology_ID] 
left join	fnReferenceRepair(@LangID, 19000162) [ref_sflBss_TestResult] 
on			[ref_sflBss_TestResult].idfsReference = v.[sflBss_TestResult_ID] 
left join	fnReferenceRepair(@LangID, 19000146) [ref_sflBss_CDCAgeGroup] 
on			[ref_sflBss_CDCAgeGroup].idfsReference = v.[sflBss_CDCAgeGroup_ID] 
left join	fnReferenceRepair(@LangID, 19000146) [ref_sflBss_WHOAgeGroup] 
on			[ref_sflBss_WHOAgeGroup].idfsReference = v.[sflBss_WHOAgeGroup_ID] 



--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 


