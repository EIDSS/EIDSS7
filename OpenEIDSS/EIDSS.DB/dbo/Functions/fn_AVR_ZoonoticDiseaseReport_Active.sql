

CREATE FUNCTION [dbo].[fn_AVR_ZoonoticDiseaseReport_Active]
(
@LangID	as nvarchar(50)
)
returns table
as
return
select		
v.[sflZD_CaseID], 
			v.[sflZD_CaseType_ID], 
			[ref_sflZD_CaseType].[name] as [sflZD_CaseType], 
			v.[sflZD_Country_ID], 
			[ref_GIS_sflZD_Country].[ExtendedName] as [sflZD_Country], 
			[ref_GIS_sflZD_Country].[name] as [sflZD_Country_ShortGISName], 
			v.[sflZD_Region_ID], 
			[ref_GIS_sflZD_Region].[ExtendedName] as [sflZD_Region], 
			[ref_GIS_sflZD_Region].[name] as [sflZD_Region_ShortGISName], 
			v.[sflZD_Rayon_ID], 
			[ref_GIS_sflZD_Rayon].[ExtendedName] as [sflZD_Rayon], 
			[ref_GIS_sflZD_Rayon].[name] as [sflZD_Rayon_ShortGISName], 
			v.[sflZD_Settlement_ID], 
			[ref_GIS_sflZD_Settlement].[ExtendedName] as [sflZD_Settlement], 
			[ref_GIS_sflZD_Settlement].[name] as [sflZD_Settlement_ShortGISName], 
			v.[sflZD_Coordinates], 
			v.[sflZD_NotificationOrReportDate], 
			v.[sflZD_InvestigationDate], 
			v.[sflZD_SymptomOnsetOrStartOfSignDate], 
			v.[sflZD_Diagnosis_ID], 
			[ref_sflZD_Diagnosis].[name] as [sflZD_Diagnosis], 
			v.[sflZD_CaseClassification_ID], 
			[ref_sflZD_CaseClassification].[name] as [sflZD_CaseClassification], 
			v.[sflZD_HumanCaseExposureDate], 
			v.[sflZD_PatientDeathDate], 
			v.[sflZD_PatientHospitalizationDate], 
			v.[sflZD_PatientFirstSoughtCareDate], 
			v.[sflZD_PatientAge], 
			v.[sflZD_PatientAgeType_ID], 
			[ref_sflZD_PatientAgeType].[name] as [sflZD_PatientAgeType], 
			v.[sflZD_PatientSex_ID], 
			[ref_sflZD_PatientSex].[name] as [sflZD_PatientSex], 
			v.[sflZD_PatientOccupation_ID], 
			[ref_sflZD_PatientOccupation].[name] as [sflZD_PatientOccupation], 
			v.[sflZD_PatientCitizenship_ID], 
			[ref_sflZD_PatientCitizenship].[name] as [sflZD_PatientCitizenship], 
			v.[sflZD_LocationOfHCExposureCountry_ID], 
			[ref_GIS_sflZD_LocationOfHCExposureCountry].[ExtendedName] as [sflZD_LocationOfHCExposureCountry], 
			[ref_GIS_sflZD_LocationOfHCExposureCountry].[name] as [sflZD_LocationOfHCExposureCountry_ShortGISName], 
			v.[sflZD_LocationOfHCExposureRegion_ID], 
			[ref_GIS_sflZD_LocationOfHCExposureRegion].[ExtendedName] as [sflZD_LocationOfHCExposureRegion], 
			[ref_GIS_sflZD_LocationOfHCExposureRegion].[name] as [sflZD_LocationOfHCExposureRegion_ShortGISName], 
			v.[sflZD_LocationOfHCExposureRayon_ID], 
			[ref_GIS_sflZD_LocationOfHCExposureRayon].[ExtendedName] as [sflZD_LocationOfHCExposureRayon], 
			[ref_GIS_sflZD_LocationOfHCExposureRayon].[name] as [sflZD_LocationOfHCExposureRayon_ShortGISName], 
			v.[sflZD_LocationOfHCExposureSettlement_ID], 
			[ref_GIS_sflZD_LocationOfHCExposureSettlement].[ExtendedName] as [sflZD_LocationOfHCExposureSettlement], 
			[ref_GIS_sflZD_LocationOfHCExposureSettlement].[name] as [sflZD_LocationOfHCExposureSettlement_ShortGISName], 
			v.[sflZD_LocationOfHCExposureCoord], 
			v.[sflZD_PatientEmployerCountry_ID], 
			[ref_GIS_sflZD_PatientEmployerCountry].[ExtendedName] as [sflZD_PatientEmployerCountry], 
			[ref_GIS_sflZD_PatientEmployerCountry].[name] as [sflZD_PatientEmployerCountry_ShortGISName], 
			v.[sflZD_PatientEmployerRegion_ID], 
			[ref_GIS_sflZD_PatientEmployerRegion].[ExtendedName] as [sflZD_PatientEmployerRegion], 
			[ref_GIS_sflZD_PatientEmployerRegion].[name] as [sflZD_PatientEmployerRegion_ShortGISName], 
			v.[sflZD_PatientEmployerRayon_ID], 
			[ref_GIS_sflZD_PatientEmployerRayon].[ExtendedName] as [sflZD_PatientEmployerRayon], 
			[ref_GIS_sflZD_PatientEmployerRayon].[name] as [sflZD_PatientEmployerRayon_ShortGISName], 
			v.[sflZD_PatientEmployerSettlement_ID], 
			[ref_GIS_sflZD_PatientEmployerSettlement].[ExtendedName] as [sflZD_PatientEmployerSettlement], 
			[ref_GIS_sflZD_PatientEmployerSettlement].[name] as [sflZD_PatientEmployerSettlement_ShortGISName], 
			v.[sflZD_LivestockAgeRangeOfDeadAnimals], 
			v.[sflZD_LivestockAgeRangeOfSickAnimals], 
			v.[sflZD_Species_ID], 
			[ref_sflZD_Species].[name] as [sflZD_Species], 
			v.[sflZD_TotalNumberOfAnimalsForSpecies], 
			v.[sflZD_NumberOfSickAnimalsForSpecies], 
			v.[sflZD_NumberOfDeadAnimalsForSpecies], 
			v.[sflZD_ReportType_ID], 
			[ref_sflZD_ReportType].[name] as [sflZD_ReportType], 
			(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) as [sflZD_IsZoonotic_ID], 
			[ref_sflZD_IsZoonotic].[name] as [sflZD_IsZoonotic], 
			v.[sflZD_DiagnosisDate] 
from		vw_AVR_ZoonoticDiseaseReport_Active v

left join	fnReferenceRepair(@LangID, 19000012) [ref_sflZD_CaseType] 
on			[ref_sflZD_CaseType].idfsReference = v.[sflZD_CaseType_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000001) [ref_GIS_sflZD_Country]  
on			[ref_GIS_sflZD_Country].idfsReference = v.[sflZD_Country_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflZD_Settlement]  
on			[ref_GIS_sflZD_Settlement].idfsReference = v.[sflZD_Settlement_ID] 
left join	fnReferenceRepair(@LangID, 19000011) [ref_sflZD_CaseClassification] 
on			[ref_sflZD_CaseClassification].idfsReference = v.[sflZD_CaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000042) [ref_sflZD_PatientAgeType] 
on			[ref_sflZD_PatientAgeType].idfsReference = v.[sflZD_PatientAgeType_ID] 
left join	fnReferenceRepair(@LangID, 19000043) [ref_sflZD_PatientSex] 
on			[ref_sflZD_PatientSex].idfsReference = v.[sflZD_PatientSex_ID] 
left join	fnReferenceRepair(@LangID, 19000061) [ref_sflZD_PatientOccupation] 
on			[ref_sflZD_PatientOccupation].idfsReference = v.[sflZD_PatientOccupation_ID] 
left join	fnReferenceRepair(@LangID, 19000054) [ref_sflZD_PatientCitizenship] 
on			[ref_sflZD_PatientCitizenship].idfsReference = v.[sflZD_PatientCitizenship_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000001) [ref_GIS_sflZD_LocationOfHCExposureCountry]  
on			[ref_GIS_sflZD_LocationOfHCExposureCountry].idfsReference = v.[sflZD_LocationOfHCExposureCountry_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflZD_LocationOfHCExposureRegion]  
on			[ref_GIS_sflZD_LocationOfHCExposureRegion].idfsReference = v.[sflZD_LocationOfHCExposureRegion_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflZD_LocationOfHCExposureRayon]  
on			[ref_GIS_sflZD_LocationOfHCExposureRayon].idfsReference = v.[sflZD_LocationOfHCExposureRayon_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflZD_LocationOfHCExposureSettlement]  
on			[ref_GIS_sflZD_LocationOfHCExposureSettlement].idfsReference = v.[sflZD_LocationOfHCExposureSettlement_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000001) [ref_GIS_sflZD_PatientEmployerCountry]  
on			[ref_GIS_sflZD_PatientEmployerCountry].idfsReference = v.[sflZD_PatientEmployerCountry_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflZD_PatientEmployerRegion]  
on			[ref_GIS_sflZD_PatientEmployerRegion].idfsReference = v.[sflZD_PatientEmployerRegion_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflZD_PatientEmployerRayon]  
on			[ref_GIS_sflZD_PatientEmployerRayon].idfsReference = v.[sflZD_PatientEmployerRayon_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflZD_PatientEmployerSettlement]  
on			[ref_GIS_sflZD_PatientEmployerSettlement].idfsReference = v.[sflZD_PatientEmployerSettlement_ID] 
left join	fnReferenceRepair(@LangID, 19000086) [ref_sflZD_Species] 
on			[ref_sflZD_Species].idfsReference = v.[sflZD_Species_ID] 
left join	fnReferenceRepair(@LangID, 19000144) [ref_sflZD_ReportType] 
on			[ref_sflZD_ReportType].idfsReference = v.[sflZD_ReportType_ID] 


FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflZD_Rayon]	-- Rayon
			ON	[ref_GIS_sflZD_Rayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflZD_Region]	-- Region
			ON	[ref_GIS_sflZD_Region].idfsReference = AllRegions.idfsRegion
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
		fnReferenceRepairWithNoneValue(@LangID, 19000019) AS [ref_sflZD_Diagnosis]
			LEFT JOIN	trtDiagnosis AS AllDiagnoses 
				left join	fnReferenceRepair(@LangID, 19000100) [ref_sflZD_IsZoonotic] 
					on			[ref_sflZD_IsZoonotic].idfsReference = 
								(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
				ON	AllDiagnoses.idfsDiagnosis = [ref_sflZD_Diagnosis].idfsReference
				)
		ON	(	(	AllDiagnoses.idfsDiagnosis is not null
				) OR
				(	[ref_sflZD_Diagnosis].idfsReference = -1 AND
					AllDiagnoses.idfsDiagnosis is null
				)
			)
					)
ON	(	AllRayons.idfsRayon = v.[sflZD_Rayon_ID] AND 
		AllRegions.idfsRegion = v.[sflZD_Region_ID] AND
		[ref_sflZD_Diagnosis].idfsReference = IsNull(v.[sflZD_Diagnosis_ID], -1)
	)


--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 
where		(

			(
			(v.[sflZD_ReportType_ID] = 4578940000001) 
				)	or	(v.[PKField] is null) 
			) 
				and	(	(v.[PKField] is not null)	
						or	(	(v.[PKField] is null)
								and	(
(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 2 > 0	OR		-- Human
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflZD_Region].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflZD_Rayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)
									)
							)
					)

