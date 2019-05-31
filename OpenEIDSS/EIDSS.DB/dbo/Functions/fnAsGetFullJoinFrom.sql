

--##SUMMARY Returns full join from condition for the key references included in the query.


--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 04.09.2010

--##REMARKS UPDATED BY: Mirnaya O.
--##REMARKS Date: 05.12.2011

--##RETURNS Function returns full join from condition for the key references included in the query.


/*
--Example of a call of function:
declare	@BinKey	int

select	dbo.fnAsGetFullJoinFrom	(@BinKey)

*/


create	function	[dbo].[fnAsGetFullJoinFrom]
(
	@BinKey	int	--##PARAM @BinKey Value that corresponds to key reference fields included in the query
)
returns nvarchar(MAX)
as
begin

	-- Define result from condition
	declare @from		nvarchar(MAX)
	set	@from = N''

	if @BinKey = 112	-- Vet Diagnosis, Vet Rayon, Vet Region
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflVC_FarmAddressRayon]	-- Rayon
			ON	[ref_GIS_sflVC_FarmAddressRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflVC_FarmAddressRegion]	-- Region
			ON	[ref_GIS_sflVC_FarmAddressRegion].idfsReference = AllRegions.idfsRegion
		ON	AllRegions.idfsRegion = AllRayons.idfsRegion AND 
			AllRegions.idfsCountry = AllRayons.idfsCountry
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry

	INNER JOIN	(
		fnReferenceRepairWithNoneValue(@LangID, 19000019) AS [ref_sflVC_Diagnosis]
			LEFT JOIN	trtDiagnosis AS AllDiagnoses 
				left join	fnReferenceRepair(@LangID, 19000100) [ref_sflVC_DiagnosisIsZoonotic] 
					on			[ref_sflVC_DiagnosisIsZoonotic].idfsReference = 
								(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
				ON	AllDiagnoses.idfsDiagnosis = [ref_sflVC_Diagnosis].idfsReference
				)
		ON	(	(	AllDiagnoses.idfsDiagnosis is not null
				) OR
				(	[ref_sflVC_Diagnosis].idfsReference = -1 AND
					AllDiagnoses.idfsDiagnosis is null
				)
			)
					)
ON	(	AllRayons.idfsRayon = v.[sflVC_FarmAddressRayon_ID]	AND 
		AllRegions.idfsRegion = v.[sflVC_FarmAddressRegion_ID] AND
		[ref_sflVC_Diagnosis].idfsReference = IsNull(v.[sflVC_Diagnosis_ID], -1)
	)
'
	else if @BinKey = 15 or @BinKey = 11 or @BinKey = 7	-- Human Diagnosis, Human Rayon, Human Region
		set	@from = N'
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
			ON	lso.strName = N''SiteID'' AND 
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
'
	else if @BinKey = 80	-- Vet Diagnosis, Vet Rayon
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflVC_FarmAddressRayon]	-- Rayon
			ON	[ref_GIS_sflVC_FarmAddressRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry

	INNER JOIN	(
		fnReferenceRepairWithNoneValue(@LangID, 19000019) AS [ref_sflVC_Diagnosis]
			LEFT JOIN	trtDiagnosis AS AllDiagnoses 
				left join	fnReferenceRepair(@LangID, 19000100) [ref_sflVC_DiagnosisIsZoonotic] 
					on			[ref_sflVC_DiagnosisIsZoonotic].idfsReference = 
								(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
				ON	AllDiagnoses.idfsDiagnosis = [ref_sflVC_Diagnosis].idfsReference
				)
		ON	(	(	AllDiagnoses.idfsDiagnosis is not null
				) OR
				(	[ref_sflVC_Diagnosis].idfsReference = -1 AND
					AllDiagnoses.idfsDiagnosis is null
				)
			)
					)
ON	(	AllRayons.idfsRayon = v.[sflVC_FarmAddressRayon_ID]	AND 
		[ref_sflVC_Diagnosis].idfsReference = IsNull(v.[sflVC_Diagnosis_ID], -1)
	)
'
	else if @BinKey = 96	-- Vet Diagnosis, Vet Region
		set	@from = N'
FULL JOIN	(
	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflVC_FarmAddressRegion]	-- Region
			ON	[ref_GIS_sflVC_FarmAddressRegion].idfsReference = AllRegions.idfsRegion
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRegions.idfsCountry

	INNER JOIN	(
		fnReferenceRepairWithNoneValue(@LangID, 19000019) AS [ref_sflVC_Diagnosis]
			LEFT JOIN	trtDiagnosis AS AllDiagnoses 
				left join	fnReferenceRepair(@LangID, 19000100) [ref_sflVC_DiagnosisIsZoonotic] 
					on			[ref_sflVC_DiagnosisIsZoonotic].idfsReference = 
								(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
				ON	AllDiagnoses.idfsDiagnosis = [ref_sflVC_Diagnosis].idfsReference
				)
		ON	(	(	AllDiagnoses.idfsDiagnosis is not null
				) OR
				(	[ref_sflVC_Diagnosis].idfsReference = -1 AND
					AllDiagnoses.idfsDiagnosis is null
				)
			)
					)
ON	(	AllRegions.idfsRegion = v.[sflVC_FarmAddressRegion_ID]	AND
		[ref_sflVC_Diagnosis].idfsReference = IsNull(v.[sflVC_Diagnosis_ID], -1)
	)
'
	else if @BinKey = 48	-- Vet Rayon, Vet Region
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflVC_FarmAddressRayon]	-- Rayon
			ON	[ref_GIS_sflVC_FarmAddressRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflVC_FarmAddressRegion]	-- Region
			ON	[ref_GIS_sflVC_FarmAddressRegion].idfsReference = AllRegions.idfsRegion
		ON	AllRegions.idfsRegion = AllRayons.idfsRegion AND 
			AllRegions.idfsCountry = AllRayons.idfsCountry
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry
					)
ON	(	AllRayons.idfsRayon = v.[sflVC_FarmAddressRayon_ID]	AND 
		AllRegions.idfsRegion = v.[sflVC_FarmAddressRegion_ID]
	)
'
	else if @BinKey = 13 or @BinKey = 9 or @BinKey = 5	-- Human Diagnosis, Human Rayon
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflHC_PatientCRRayon]	-- Rayon
			ON	[ref_GIS_sflHC_PatientCRRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
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
		[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID]
	)
'
	else if @BinKey = 14 or @BinKey = 10 or @BinKey = 6	-- Human Diagnosis, Human Region
		set	@from = N'
FULL JOIN	(
	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflHC_PatientCRRegion]	-- Region
			ON	[ref_GIS_sflHC_PatientCRRegion].idfsReference = AllRegions.idfsRegion
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRegions.idfsCountry

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
ON	(	AllRegions.idfsRegion = v.[sflHC_PatientCRRegion_ID]	AND 
		[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID]
	)	
'
	else if @BinKey = 3	-- Human Rayon, Human Region
		set	@from = N'
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
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry
					)
ON	(	AllRayons.idfsRayon = v.[sflHC_PatientCRRayon_ID]	AND 
		AllRegions.idfsRegion = v.[sflHC_PatientCRRegion_ID]
	)
'
	else if @BinKey = 64	-- Vet Diagnosis
		set	@from = N'
FULL JOIN	(
		fnReferenceRepairWithNoneValue(@LangID, 19000019) AS [ref_sflVC_Diagnosis]
			LEFT JOIN	trtDiagnosis AS AllDiagnoses 
				left join	fnReferenceRepair(@LangID, 19000100) [ref_sflVC_DiagnosisIsZoonotic] 
					on			[ref_sflVC_DiagnosisIsZoonotic].idfsReference = 
								(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
				ON	AllDiagnoses.idfsDiagnosis = [ref_sflVC_Diagnosis].idfsReference
			)
ON	(	[ref_sflVC_Diagnosis].idfsReference = IsNull(v.[sflVC_Diagnosis_ID], -1)
	)
'
	else if @BinKey = 12 or @BinKey = 8 or @BinKey = 4	-- Human Diagnosis
		set	@from = N'
FULL JOIN	(
	trtDiagnosis AS AllDiagnoses
		INNER JOIN	fnReferenceRepair(@LangID, 19000019) AS [ref_sflHC_FinalDiagnosis] 
			ON	[ref_sflHC_FinalDiagnosis].idfsReference = AllDiagnoses.idfsDiagnosis
		left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_FinalDiagnosisIsZoonotic] 
			on			[ref_sflHC_FinalDiagnosisIsZoonotic].idfsReference = 
						(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
			)
ON	(	[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID]
	)
'
	else if @BinKey = 16	-- Vet Rayon
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflVC_FarmAddressRayon]	-- Rayon
			ON	[ref_GIS_sflVC_FarmAddressRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry
			)
ON	(	AllRayons.idfsRayon = v.[sflVC_FarmAddressRayon_ID]
	)
'
	else if @BinKey = 1	-- Human Rayon
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflHC_PatientCRRayon]	-- Rayon
			ON	[ref_GIS_sflHC_PatientCRRayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry
			)
ON	(	AllRayons.idfsRayon = v.[sflHC_PatientCRRayon_ID]
'
	else if @BinKey = 32	-- Vet Region
		set	@from = N'
FULL JOIN	(
	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflVC_FarmAddressRegion]	-- Region
			ON	[ref_GIS_sflVC_FarmAddressRegion].idfsReference = AllRegions.idfsRegion
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRegions.idfsCountry
			)
ON	(	AllRegions.idfsRegion = v.[sflVC_FarmAddressRegion_ID]
	)
'
	else if @BinKey = 2	-- Human Region
		set	@from = N'
FULL JOIN	(
	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflHC_PatientCRRegion]	-- Region
			ON	[ref_GIS_sflHC_PatientCRRegion].idfsReference = AllRegions.idfsRegion
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRegions.idfsCountry
			)
ON	(	AllRegions.idfsRegion = v.[sflHC_PatientCRRegion]
	)
'
	else if @BinKey = 896	-- all key references for Zoonotic disease
		set	@from = N'
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
			ON	lso.strName = N''SiteID'' AND 
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
'
	else if @BinKey = 768	-- Diagnosis, Rayon for Zoonotic disease
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflZD_Rayon]	-- Rayon
			ON	[ref_GIS_sflZD_Rayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
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
ON	(	AllRayons.idfsRayon = v.[sflZD_Rayon_ID]	AND 
		[ref_sflZD_Diagnosis].idfsReference = v.[sflZD_Diagnosis_ID]
	)
'
	else if @BinKey = 640	-- Diagnosis, Region for Zoonotic disease
		set	@from = N'
FULL JOIN	(
	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflZD_Region]	-- Region
			ON	[ref_GIS_sflZD_Region].idfsReference = AllRegions.idfsRegion
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRegions.idfsCountry

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
ON	(	AllRegions.idfsRegion = v.[sflHC_sflZD_Region_ID]	AND 
		[ref_sflZD_Diagnosis].idfsReference = v.[sflZD_Diagnosis_ID]
	)	
'
	else if @BinKey = 384	-- Rayon, Region for Zoonotic disease
		set	@from = N'
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
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry
					)
ON	(	AllRayons.idfsRayon = v.[sflZD_Rayon_ID]	AND 
		AllRegions.idfsRegion = v.[sflZD_Region_ID]
	)
'
	else if @BinKey = 512	-- Diagnosis for Zoonotic disease
		set	@from = N'
FULL JOIN	(
	trtDiagnosis AS AllDiagnoses
		LEFT JOIN	fnReferenceRepairWithNoneValue(@LangID, 19000019) AS [ref_sflZD_Diagnosis] 
			ON	[ref_sflZD_Diagnosis].idfsReference = AllDiagnoses.idfsDiagnosis
		left join	fnReferenceRepair(@LangID, 19000100) [ref_sflZD_IsZoonotic] 
			on			[ref_sflZD_IsZoonotic].idfsReference = 
						(IsNull(AllDiagnoses.blnZoonotic, 0) * 10100001 + (1 - IsNull(AllDiagnoses.blnZoonotic, 0)) * 10100002) 
			)
ON	(	[ref_sflZD_Diagnosis].idfsReference = v.[sflZD_Diagnosis_ID]
	)
'
	else if @BinKey = 256	-- Rayon for Zoonotic disease
		set	@from = N'
FULL JOIN	(
	gisRayon AS AllRayons
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000002) AS [ref_GIS_sflZD_Rayon]	-- Rayon
			ON	[ref_GIS_sflZD_Rayon].idfsReference = AllRayons.idfsRayon
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRayons.idfsCountry
			)
ON	(	AllRayons.idfsRayon = v.[sflZD_Rayon_ID]
'
	else if @BinKey = 128	-- Region for Zoonotic disease
		set	@from = N'
FULL JOIN	(
	gisRegion AS AllRegions
		INNER JOIN	fnGisExtendedReferenceRepair(@LangID, 19000003) AS [ref_GIS_sflZD_Region]	-- Region
			ON	[ref_GIS_sflZD_Region].idfsReference = AllRegions.idfsRegion
	INNER JOIN	(
		tstSite s
		INNER JOIN	tstLocalSiteOptions lso
			ON	lso.strName = N''SiteID'' AND 
				lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
		INNER JOIN	tstCustomizationPackage cp
			ON	cp.idfCustomizationPackage = s.idfCustomizationPackage
				)
		ON	cp.idfsCountry = AllRegions.idfsCountry
			AllDiagnoses.intRowStatus = 0
					)
ON	(	AllRegions.idfsRegion = v.[sflZD_Region_ID]
	)
'

	return @from

end



