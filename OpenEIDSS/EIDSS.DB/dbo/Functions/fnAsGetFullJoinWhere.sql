

--##SUMMARY Returns full join where condition for the key references included in the query.


--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 04.09.2010

--##REMARKS UPDATED BY: Mirnaya O.
--##REMARKS Date: 05.12.2011

--##RETURNS Function returns full join where condition for the key references included in the query.


/*
--Example of a call of function:
declare	@BinKey	int

select	dbo.fnAsGetFullJoinWhere	(@BinKey)

*/


create	function	[dbo].[fnAsGetFullJoinWhere]
(
	@BinKey	int	--##PARAM @BinKey Value that corresponds to key reference fields included in the query
)
returns nvarchar(MAX)
as
begin

	-- Define result where condition
	declare @where		nvarchar(MAX)
	set	@where = N''

	if @BinKey = 112	-- Vet Diagnosis, Vet Rayon, Vet Region
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflVC_FarmAddressRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflVC_FarmAddressRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 15 or @BinKey = 11 or @BinKey = 7	-- Human Diagnosis, Human Rayon, Human Region
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	IsNull([ref_sflHC_FinalDiagnosis].intHACode, 2) & 2 > 0	AND		-- Human
	[ref_GIS_sflHC_PatientCRRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflHC_PatientCRRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 80	-- Vet Diagnosis, Vet Rayon
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflVC_FarmAddressRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 96	-- Vet Diagnosis, Vet Region
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflVC_FarmAddressRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	
)'
	else if @BinKey = 48	-- Vet Rayon, Vet Region
		set	@where = 
N'(	[ref_GIS_sflVC_FarmAddressRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflVC_FarmAddressRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 13 or @BinKey = 9 or @BinKey = 5	-- Human Diagnosis, Human Rayon
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	IsNull([ref_sflHC_FinalDiagnosis].intHACode, 2) & 2 > 0	AND		-- Human
	[ref_GIS_sflHC_PatientCRRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 14 or @BinKey = 10 or @BinKey = 6	-- Human Diagnosis, Human Region
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	IsNull([ref_sflHC_FinalDiagnosis].intHACode, 2) & 2 > 0	AND		-- Human
	[ref_GIS_sflHC_PatientCRRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0
)'
	else if @BinKey = 3	-- Human Rayon, Human Region
		set	@where = 
N'(	[ref_GIS_sflHC_PatientCRRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflHC_PatientCRRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 64	-- Vet Diagnosis
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflVC_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)
)'
	else if @BinKey = 12 or @BinKey = 8 or @BinKey = 4	-- Human Diagnosis
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	IsNull([ref_sflHC_FinalDiagnosis].intHACode, 2) & 2 > 0			-- Human
)'
	else if @BinKey = 16	-- Vet Rayon
		set	@where = 
N'(	[ref_GIS_sflVC_FarmAddressRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 1	-- Human Rayon
		set	@where = 
N'(	[ref_GIS_sflHC_PatientCRRayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 32	-- Vet Region
		set	@where = 
N'(	[ref_GIS_sflVC_FarmAddressRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	
)'
	else if @BinKey = 2	-- Human Region
		set	@where = 
N'(	[ref_GIS_sflHC_PatientCRRegion].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	
)'
	else if @BinKey = 896	-- all key references for Zoonotic disease
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 2 > 0	OR		-- Human
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflZD_Region].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflZD_Rayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 768	-- Diagnosis, Rayon for Zoonotic disease
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 2 > 0	OR		-- Human
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflZD_Rayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 640	-- Diagnosis, Region for Zoonotic disease
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 2 > 0	OR		-- Human
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)	AND
	[ref_GIS_sflZD_Region].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	
)'
	else if @BinKey = 384	-- Rayon, Region for Zoonotic disease
		set	@where = 
N'(	[ref_GIS_sflZD_Region].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	AND
	[ref_GIS_sflZD_Rayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 512	-- Diagnosis for Zoonotic disease
		set	@where = 
N'(	AllDiagnoses.idfsUsingType = 10020001	AND						-- Case-based
	AllDiagnoses.intRowStatus = 0	AND
	(	IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 2 > 0	OR		-- Human
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 32 > 0	OR	-- Livestock
		IsNull([ref_sflZD_Diagnosis].intHACode, 96) & 64 > 0		-- Avian
	)
)'
	else if @BinKey = 256	-- Rayon for Zoonotic disease
		set	@where = 
N'(	[ref_GIS_sflZD_Rayon].intRowStatus = 0	AND
	AllRayons.intRowStatus = 0
)'
	else if @BinKey = 128	-- Region for Zoonotic disease
		set	@where = 
N'([ref_GIS_sflZD_Region].intRowStatus = 0	AND
	AllRegions.intRowStatus = 0	
)'

	return @where

end



