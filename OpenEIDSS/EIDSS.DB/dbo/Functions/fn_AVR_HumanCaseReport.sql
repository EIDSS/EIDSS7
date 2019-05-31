

CREATE FUNCTION [dbo].[fn_AVR_HumanCaseReport]
(
@LangID	as nvarchar(50)
)
returns table
as
return
select		
v.[sflHC_PatientAge], 
			v.[sflHC_PatientAgeGroup], 
			v.[sflHC_CaseClassification_ID], 
			[ref_sflHC_CaseClassification].[name] as [sflHC_CaseClassification], 
			v.[sflHC_CaseID], 
			v.[sflHC_ChangedDiagnosis_ID], 
			[ref_sflHC_ChangedDiagnosis].[name] as [sflHC_ChangedDiagnosis], 
			v.[sflHC_EnteredDate], 
			v.[sflHC_PatientDOB], 
			v.[sflHC_ChangedDiagnosisDate], 
			v.[sflHC_CompletionPaperFormDate], 
			v.[sflHC_PatientDeathDate], 
			v.[sflHC_SymptomOnsetDate], 
			v.[sflHC_Diagnosis_ID], 
			[ref_sflHC_Diagnosis].[name] as [sflHC_Diagnosis], 
			v.[sflHC_DiagnosisDate], 
			v.[sflHC_RelatedToOutbreak_ID], 
			[ref_sflHC_RelatedToOutbreak].[name] as [sflHC_RelatedToOutbreak], 
			v.[sflHC_PatientName], 
			v.[sflHC_PatientNationality_ID], 
			[ref_sflHC_PatientNationality].[name] as [sflHC_PatientNationality], 
			v.[sflHC_NotificationDate], 
			v.[sflHC_OutbreakID], 
			v.[sflHC_Outcome_ID], 
			[ref_sflHC_Outcome].[name] as [sflHC_Outcome], 
			v.[sflHC_PatientCRRayon_ID], 
			[ref_GIS_sflHC_PatientCRRayon].[ExtendedName] as [sflHC_PatientCRRayon], 
			[ref_GIS_sflHC_PatientCRRayon].[name] as [sflHC_PatientCRRayon_ShortGISName], 
			v.[sflHC_PatientCRRegion_ID], 
			[ref_GIS_sflHC_PatientCRRegion].[ExtendedName] as [sflHC_PatientCRRegion], 
			[ref_GIS_sflHC_PatientCRRegion].[name] as [sflHC_PatientCRRegion_ShortGISName], 
			v.[sflHC_PatientCRSettlement_ID], 
			[ref_GIS_sflHC_PatientCRSettlement].[ExtendedName] as [sflHC_PatientCRSettlement], 
			[ref_GIS_sflHC_PatientCRSettlement].[name] as [sflHC_PatientCRSettlement_ShortGISName], 
			v.[sflHC_PatientSex_ID], 
			[ref_sflHC_PatientSex].[name] as [sflHC_PatientSex], 
			v.[sflHC_SamplesCollected_ID], 
			[ref_sflHC_SamplesCollected].[name] as [sflHC_SamplesCollected], 
			v.[sflHC_FinalDiagnosis_ID], 
			[ref_sflHC_FinalDiagnosis].[name] as [sflHC_FinalDiagnosis], 
			v.[sflHC_CaseProgressStatus_ID], 
			[ref_sflHC_CaseProgressStatus].[name] as [sflHC_CaseProgressStatus], 
			v.[sflHC_InitialCaseClassification_ID], 
			[ref_sflHC_InitialCaseClassification].[name] as [sflHC_InitialCaseClassification], 
			v.[sflHC_FinalCaseClassification_ID], 
			[ref_sflHC_FinalCaseClassification].[name] as [sflHC_FinalCaseClassification], 
			v.[sflHC_FinalDiagnosisDate], 
			v.[sflHC_PatientAgeType_ID], 
			[ref_sflHC_PatientAgeType].[name] as [sflHC_PatientAgeType], 
			v.[sflHC_PatientOccupation_ID], 
			[ref_sflHC_PatientOccupation].[name] as [sflHC_PatientOccupation], 
			v.[sflHC_ClinicalDiagBasis_ID], 
			[ref_sflHC_ClinicalDiagBasis].[name] as [sflHC_ClinicalDiagBasis], 
			v.[sflHC_EpiDiagBasis_ID], 
			[ref_sflHC_EpiDiagBasis].[name] as [sflHC_EpiDiagBasis], 
			v.[sflHC_LabDiagBasis_ID], 
			[ref_sflHC_LabDiagBasis].[name] as [sflHC_LabDiagBasis], 
			v.[sflHC_DateFinalCaseClassification] 
from		vw_AVR_HumanCaseReport v

left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_CaseClassification] 
on			[ref_sflHC_CaseClassification].idfsReference = v.[sflHC_CaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000019) [ref_sflHC_ChangedDiagnosis] 
on			[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
left join	fnReferenceRepair(@LangID, 19000019) [ref_sflHC_Diagnosis] 
on			[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_RelatedToOutbreak] 
on			[ref_sflHC_RelatedToOutbreak].idfsReference = v.[sflHC_RelatedToOutbreak_ID] 
left join	fnReferenceRepair(@LangID, 19000054) [ref_sflHC_PatientNationality] 
on			[ref_sflHC_PatientNationality].idfsReference = v.[sflHC_PatientNationality_ID] 
left join	fnReferenceRepair(@LangID, 19000064) [ref_sflHC_Outcome] 
on			[ref_sflHC_Outcome].idfsReference = v.[sflHC_Outcome_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflHC_PatientCRSettlement]  
on			[ref_GIS_sflHC_PatientCRSettlement].idfsReference = v.[sflHC_PatientCRSettlement_ID] 
left join	fnReferenceRepair(@LangID, 19000043) [ref_sflHC_PatientSex] 
on			[ref_sflHC_PatientSex].idfsReference = v.[sflHC_PatientSex_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_SamplesCollected] 
on			[ref_sflHC_SamplesCollected].idfsReference = v.[sflHC_SamplesCollected_ID] 
left join	fnReferenceRepair(@LangID, 19000111) [ref_sflHC_CaseProgressStatus] 
on			[ref_sflHC_CaseProgressStatus].idfsReference = v.[sflHC_CaseProgressStatus_ID] 
left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_InitialCaseClassification] 
on			[ref_sflHC_InitialCaseClassification].idfsReference = v.[sflHC_InitialCaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_FinalCaseClassification] 
on			[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000042) [ref_sflHC_PatientAgeType] 
on			[ref_sflHC_PatientAgeType].idfsReference = v.[sflHC_PatientAgeType_ID] 
left join	fnReferenceRepair(@LangID, 19000061) [ref_sflHC_PatientOccupation] 
on			[ref_sflHC_PatientOccupation].idfsReference = v.[sflHC_PatientOccupation_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_ClinicalDiagBasis] 
on			[ref_sflHC_ClinicalDiagBasis].idfsReference = v.[sflHC_ClinicalDiagBasis_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_EpiDiagBasis] 
on			[ref_sflHC_EpiDiagBasis].idfsReference = v.[sflHC_EpiDiagBasis_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_LabDiagBasis] 
on			[ref_sflHC_LabDiagBasis].idfsReference = v.[sflHC_LabDiagBasis_ID] 


FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflHC_PatientCRRayon]	-- Rayon
			ON	[ref_GIS_sflHC_PatientCRRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflHC_PatientCRRegion]	-- Region
			ON	[ref_GIS_sflHC_PatientCRRegion].idfsReference = AllRegions.idfsRegion
		ON	AllRegions.idfsRegion = AllRayons.idfsRegion AND 
			AllRegions.idfsCountry = AllRayons.idfsCountry
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N'SiteID' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry

	INNER JOIN	(
		trtDiagnosis AS AllDiagnoses
			INNER JOIN	fnReferenceRepair(@LangID, 19000019) AS [ref_sflHC_FinalDiagnosis] 
				ON	[ref_sflHC_FinalDiagnosis].idfsReference = AllDiagnoses.idfsDiagnosis 
			left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_FinalDiagnosisIsZoonotic] 
				on			[ref_sflHC_FinalDiagnosisIsZoonotic].idfsReference = 
							(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
				)
		ON	1 = 1
					)
ON	(	AllRayons.idfsRayon = v.[sflHC_PatientCRRayon_ID]	AND 
		AllRegions.idfsRegion = v.[sflHC_PatientCRRegion_ID]	AND 
		[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID]
	)


--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 
where		

				(	(v.[PKField] is not null)	
					or	(	(v.[PKField] is null)
							and	(
(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	IsNull([ref_sflHC_FinalDiagnosis].intHACode, 2) & 2 > 0	AND		-- Human
	[ref_GIS_sflHC_PatientCRRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflHC_PatientCRRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)
								)
						)
				)
			 

