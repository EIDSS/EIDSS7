

--##SUMMARY Select data for REPORT ON ACTIONS TAKEN AGAINST EPIZOOTIC: Diagnostic investigations report.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepVetForm1AVaccinationMeasuresAZ @LangID=N'en', @FromYear = 2015, @ToYear = 2016
exec dbo.spRepVetForm1AVaccinationMeasuresAZ 'ru',2012,2015
exec dbo.spRepVetForm1AVaccinationMeasuresAZ 'ru',2017,2018

*/

CREATE Procedure [dbo].[spRepVetForm1AVaccinationMeasuresAZ]
    (
        @LangID as nvarchar(10)
        , @FromYear AS int
	, @ToYear AS int
	, @FromMonth AS int = NULL
	, @ToMonth AS int = NULL
	, @RegionID AS bigint = NULL
	, @RayonID AS bigint = NULL
	, @OrganizationEntered AS bigint = NULL
	, @OrganizationID AS bigint = NULL
    )
WITH RECOMPILE
as
begin


declare	@drop_cmd	nvarchar(4000)

-- Drop temporary tables
if Object_ID('tempdb..#VetAggregateAction') is not null
begin
	set	@drop_cmd = N'drop table #VetAggregateAction'
	execute sp_executesql @drop_cmd
end


DECLARE @Result AS TABLE
(
	strDiagnosisSpeciesKey	nvarchar(200) NOT NULL PRIMARY KEY,
	strMeasureName			nvarchar(2000) collate database_default null,
	idfsDiagnosis			bigint not null,
	idfsProphylacticAction	bigint not null,
	idfsSpeciesType			bigint not null,
	strDiagnosisName		nvarchar(2000) collate database_default null,
	strOIECode				nvarchar(200) collate database_default null,
	strSpecies				nvarchar(2000) collate database_default null,
	intActionTaken			int null,
	strNote					nvarchar(2000) collate database_default null,
	InvestigationOrderColumn	int null,
	SpeciesOrderColumn		int null,
	DiagnosisOrderColumn	int null,
	blnAdditionalText		bit
)


declare	@idfsSummaryReportType	bigint
set	@idfsSummaryReportType = 10290034	-- Veterinary Report Form Vet 1A - Prophylactics

declare	@idfsMatrixType	bigint
set	@idfsMatrixType = 71300000000	-- Treatment-prophylactics and vaccination measures


-- Specify the value of missing month if remaining month is specified in interval (1-12)
if	@FromMonth is null and @ToMonth is not null and @ToMonth >= 1 and @ToMonth <= 12
	set	@FromMonth = 1
if	@ToMonth is null and @FromMonth is not null and @FromMonth >= 1 and @FromMonth <= 12
	set	@ToMonth = 12

-- Calculate Start and End dates for conditions: Start Date <= date from Vet Case < End date
declare	@StartDate	date
declare	@EndDate	date

if	@FromMonth is null or @FromMonth < 1 or @FromMonth > 12
	set	@StartDate = cast(@FromYear as nvarchar) + N'0101'
else if @FromMonth < 10
	set	@StartDate = cast(@FromYear as nvarchar) + N'0' + cast(@FromMonth as nvarchar) + N'01'
else
	set	@StartDate = cast(@FromYear as nvarchar) + cast(@FromMonth as nvarchar) + N'01'

if	@ToMonth is null or @ToMonth < 1 or @ToMonth > 12
begin
	set	@EndDate = cast(@ToYear as nvarchar) + N'0101'
	set	@EndDate = dateadd(year, 1, @EndDate)
end
else
begin
	if @ToMonth < 10
		set	@EndDate = cast(@ToYear as nvarchar) + N'0' + cast(@ToMonth as nvarchar) + N'01'
	else
		set	@EndDate = cast(@ToYear as nvarchar) + cast(@ToMonth as nvarchar) + N'01'
	
	set	@EndDate = dateadd(month, 1, @EndDate)
end

-- Select report informative part - start

declare	@vet_form_1_use_specific_gis	bigint
declare	@vet_form_1_specific_gis_region	bigint
declare	@vet_form_1_specific_gis_rayon	bigint
declare	@attr_part_in_report			bigint

select	@vet_form_1_use_specific_gis = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_use_specific_gis'

select	@vet_form_1_specific_gis_region = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_specific_gis_region'

select	@vet_form_1_specific_gis_rayon = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'vet_form_1_specific_gis_rayon'

select	@attr_part_in_report = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'attr_part_in_report'

DECLARE @SpecificOfficeId BIGINT
SELECT
	 @SpecificOfficeId = ts.idfOffice
FROM tstSite ts 
WHERE ts.intRowStatus = 0
	AND ts.intFlags = 100 /*organization with abbreviation = Baku city VO*/

declare	@Prophylactics_Livestock_Treated_number	bigint
declare	@Prophylactics_Avian_Treated_number		bigint

declare	@Prophylactics_Aggr_Action_taken		bigint
declare	@Prophylactics_Aggr_Note				bigint

-- Prophylactics_Livestock_Treated_number
select		@Prophylactics_Livestock_Treated_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Prophylactics_Livestock_Treated_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Prophylactics_Avian_Treated_number
select		@Prophylactics_Avian_Treated_number = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Prophylactics_Avian_Treated_number'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Prophylactics_Aggr_Action_taken
select		@Prophylactics_Aggr_Action_taken = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Prophylactics_Aggr_Action_taken'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Prophylactics_Aggr_Note
select		@Prophylactics_Aggr_Note = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Prophylactics_Aggr_Note'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0


-- Treatment - Prophylactic measure for data from Vet Case
declare	@Treatment				bigint
declare	@Treatment_Translation	nvarchar(2000)

select		@Treatment = rat.idfsReference,
			@Treatment_Translation = rat.[name]
from		trtBaseReferenceAttribute bra
inner join	fnReferenceRepair(@LangID, 19000132) rat	/*Report Additional Text*/
on			rat.idfsReference = bra.idfsBaseReference
where		bra.idfAttributeType = @attr_part_in_report
			and cast(bra.varValue as nvarchar) = cast(@idfsSummaryReportType as nvarchar(20))
			and bra.strAttributeItem = N'Name of measure'

if	@Treatment is null
	set	@Treatment = -1
if	@Treatment_Translation is null
	set	@Treatment_Translation = N''

-- Included state sector - note for data from Vet Cases connecting to the farms, 
-- which have ownership structure = State Farm and are counted for the report
declare	@Included_state_sector				bigint
declare	@Included_state_sector_Translation	nvarchar(2000)

select		@Included_state_sector = rat.idfsReference,
			@Included_state_sector_Translation = rat.[name]
from		trtBaseReferenceAttribute bra
inner join	fnReferenceRepair(@LangID, 19000132) rat	/*Report Additional Text*/
on			rat.idfsReference = bra.idfsBaseReference
where		bra.idfAttributeType = @attr_part_in_report
			and cast(bra.varValue as nvarchar) = cast(@idfsSummaryReportType as nvarchar(20))
			and bra.strAttributeItem = N'Note - Prophylactics'

if	@Included_state_sector is null
	set	@Included_state_sector = -1
if	@Included_state_sector_Translation is null
	set	@Included_state_sector_Translation = N''




-- Vet Case data
declare	@VetCaseData table
(	strDiagnosisSpeciesKey			nvarchar(200) collate database_default not null primary key,
	idfsDiagnosis					bigint not null,
	idfsProphylacticAction			bigint not null,
	idfsSpeciesType					bigint not null,
	strMeasureName					nvarchar(2000) collate database_default null,
	strDiagnosisName				nvarchar(2000) collate database_default null,
	strOIECode						nvarchar(200) collate database_default null,
	strSpecies						nvarchar(2000) collate database_default null,
	intActionTaken					int null,
	blnAddNote						int null default (0),
	SpeciesOrderColumn				int null,
	DiagnosisOrderColumn			int null
)

DECLARE @NotDeletedDiagnosis TABLE (
	[name] NVARCHAR(500)
	, idfsDiagnosis BIGINT
	, intOrder INT
	, strOIECode NVARCHAR(100)
	, rn INT
)

INSERT INTO @NotDeletedDiagnosis
SELECT
		r_d_actual.[name]
		, d_actual.idfsDiagnosis
		, r_d_actual.intOrder
		, d_actual.strOIECode
		, ROW_NUMBER() OVER (PARTITION BY r_d_actual.[name] ORDER BY d_actual.idfsDiagnosis) AS rn
	from		trtDiagnosis d_actual
	inner join	fnReference(@LangID, 19000019) r_d_actual
	on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
	where		d_actual.idfsUsingType = 10020001	/*Case-based*/
				and d_actual.intRowStatus = 0
	


DECLARE @NotDeletedSpecies TABLE (
	[name] NVARCHAR(500)
	, idfsSpeciesType BIGINT
	, intOrder INT
	, rn INT
)	

INSERT INTO @NotDeletedSpecies
SELECT
		r_sp_actual.[name]
		, st_actual.idfsSpeciesType
		, r_sp_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_sp_actual.[name] ORDER BY st_actual.idfsSpeciesType) AS rn
	from		trtSpeciesType st_actual
	inner join	fnReference(@LangID, 19000086) r_sp_actual
	on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
	where		st_actual.intRowStatus = 0
	
/*
;
WITH NotDeletedDiagnosis AS (
	SELECT
		r_d_actual.[name]
		, d_actual.idfsDiagnosis
		, r_d_actual.intOrder
		, d_actual.strOIECode
		, ROW_NUMBER() OVER (PARTITION BY r_d_actual.[name] ORDER BY d_actual.idfsDiagnosis) AS rn
	from		trtDiagnosis d_actual
	inner join	fnReference(@LangID, 19000019) r_d_actual
	on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
	where		d_actual.idfsUsingType = 10020001	/*Case-based*/
				and d_actual.intRowStatus = 0
)
, NotDeletedSpecies AS (
	SELECT
		r_sp_actual.[name]
		, st_actual.idfsSpeciesType
		, r_sp_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_sp_actual.[name] ORDER BY st_actual.idfsSpeciesType) AS rn
	from		trtSpeciesType st_actual
	inner join	fnReference(@LangID, 19000086) r_sp_actual
	on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
	where		st_actual.intRowStatus = 0
)
*/

insert into	@VetCaseData
(	strDiagnosisSpeciesKey,
	idfsDiagnosis,
	idfsProphylacticAction,
	idfsSpeciesType,
	strMeasureName,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intActionTaken,
	blnAddNote,
	SpeciesOrderColumn,
	DiagnosisOrderColumn
)
select		cast(isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				cast(isnull(@Treatment, -1) as nvarchar(20)) as strDiagnosisSpeciesKey,
			isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis),
			isnull(@Treatment, -1) as idfsProphylacticAction,
			isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType),
			@Treatment_Translation,
			isnull(r_d.[name], N'') as strDiagnosisName,
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')) as strOIECode,
			isnull(r_sp.[name], N'') as strSpecies,
			sum(isnull(cast(Treated_number.varValue as int), 0)) as intActionTaken,
			sum(cast((isnull(fot.idfsReference, 0) / 10820000000) as int)) as blnAddNote, /*State Farm*/
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)) as SpeciesOrderColumn,
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)) as DiagnosisOrderColumn
from		
-- Veterinary Case
			tlbVetCase vc

-- Diagnosis = Final Diagnosis of Veterinary Case
inner join	trtDiagnosis d
	inner join	fnReferenceRepair(@LangID, 19000019) r_d
	on			r_d.idfsReference = d.idfsDiagnosis

	-- Not deleted diagnosis with the same name and case-based using type
	LEFT JOIN @NotDeletedDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.[name] = r_d.[name] collate Cyrillic_General_CI_AS
		AND Actual_Diagnosis.rn = 1				
on			d.idfsDiagnosis = vc.idfsFinalDiagnosis
			and d.idfsUsingType = 10020001	/*Case-based*/

-- Species - start
inner join	tlbFarm f

	-- Region and Rayon
	left join	tlbGeoLocation gl
		left join	fnGisReferenceRepair(@LangID, 19000003) reg
		on			reg.idfsReference = gl.idfsRegion
		left join	fnGisReferenceRepair(@LangID, 19000002) ray
		on			ray.idfsReference = gl.idfsRayon
	on			gl.idfGeoLocation = f.idfFarmAddress

	-- State Farm
	left join	fnReferenceRepair(@LangID, 19000065) fot	/*Farm Ownership Type*/
	on			fot.idfsReference = f.idfsOwnershipStructure
				and fot.idfsReference = 10820000000 /*State Farm*/
on			f.idfFarm = vc.idfFarm
			and f.intRowStatus = 0
inner join	tlbHerd h
on			h.idfFarm = f.idfFarm
			and h.intRowStatus = 0
inner join	tlbSpecies sp
	inner join	fnReferenceRepair(@LangID, 19000086) r_sp
	on			r_sp.idfsReference = sp.idfsSpeciesType

	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedSpecies AS Actual_Species_Type ON
		Actual_Species_Type.[name] = r_sp.[name] collate Cyrillic_General_CI_AS
		AND Actual_Species_Type.rn = 1
on			sp.idfHerd = h.idfHerd
			and sp.intRowStatus = 0

			-- Sick + Dead > 0
			and isnull(sp.intDeadAnimalQty, 0) + isnull(sp.intSickAnimalQty, 0) > 0
			-- Total > 0
			and isnull(sp.intTotalAnimalQty, 0) > 0

-- Species - end

-- Site, Organization entered case
inner join	tstSite s
	left join	fnInstitutionRepair(@LangID) i
	on			i.idfOffice = CASE WHEN s.intFlags = 10 THEN @SpecificOfficeId ELSE s.idfOffice END
on			s.idfsSite = vc.idfsSite

-- Specific Region and Rayon for the site with specific attributes (B46)
left join	trtBaseReferenceAttribute bra
	left join	trtGISBaseReferenceAttribute gis_bra_region
		inner join	fnGisReferenceRepair(@LangID, 19000003) reg_specific
		on			reg_specific.idfsReference = gis_bra_region.idfsGISBaseReference
	on			cast(gis_bra_region.varValue as nvarchar) = cast(bra.varValue as nvarchar)
				and gis_bra_region.idfAttributeType = @vet_form_1_specific_gis_region
	left join	trtGISBaseReferenceAttribute gis_bra_rayon
		inner join	fnGisReferenceRepair(@LangID, 19000002) ray_specific
		on			ray_specific.idfsReference = gis_bra_rayon.idfsGISBaseReference
	on			cast(gis_bra_rayon.varValue as nvarchar) = cast(bra.varValue as nvarchar)
				and gis_bra_rayon.idfAttributeType = @vet_form_1_specific_gis_rayon
on			bra.idfsBaseReference = i.idfsOfficeAbbreviation
			and bra.idfAttributeType = @vet_form_1_use_specific_gis
			and cast(bra.varValue as nvarchar) = s.strSiteID

-- Species Observation
left join	tlbObservation	obs
on			obs.idfObservation = sp.idfObservation


-- FF: Treated number
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = obs.idfObservation
			and ap.idfsParameter in (@Prophylactics_Livestock_Treated_number, @Prophylactics_Avian_Treated_number)
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfRow asc
 		) as  Treated_number

where		vc.intRowStatus = 0
			-- Case Classification = Confirmed
			and vc.idfsCaseClassification = 350000000	/*Confirmed*/
			
			-- FF: Treated number > 0
			and cast(Treated_number.varValue as int) > 0

			-- From Year, Month To Year, Month
			and isnull(vc.datFinalDiagnosisDate, vc.datTentativeDiagnosis1Date) >= @StartDate
			and isnull(vc.datFinalDiagnosisDate, vc.datTentativeDiagnosis1Date) < @EndDate
			
			-- Region
			and (@RegionID is null or (@RegionID is not null and isnull(reg_specific.idfsReference, reg.idfsReference) = @RegionID))
			-- Rayon
			and (@RayonID is null or (@RayonID is not null and isnull(ray_specific.idfsReference, ray.idfsReference) = @RayonID))
			
			-- Entered by organization
			and (@OrganizationEntered is null or (@OrganizationEntered is not null and i.idfOffice = @OrganizationEntered))

group by	cast(isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				cast(isnull(@Treatment, -1) as nvarchar(20)),
			isnull(Actual_Diagnosis.idfsDiagnosis, d.idfsDiagnosis),
			isnull(Actual_Species_Type.idfsSpeciesType, sp.idfsSpeciesType),
			isnull(r_d.[name], N''),
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')),
			isnull(r_sp.[name], N''),
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)),
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000))


-- Select aggregate data
DECLARE @MinAdminLevel bigint
DECLARE @MinTimeInterval bigint
DECLARE @AggrCaseType bigint


/*

19000091	rftStatisticPeriodType:
    10091001	sptMonth	Month
    10091002	sptOnday	Day
    10091003	sptQuarter	Quarter
    10091004	sptWeek	Week
    10091005	sptYear	Year

19000089	rftStatisticAreaType
    10089001	satCountry	Country
    10089002	satRayon	Rayon
    10089003	satRegion	Region
    10089004	satSettlement	Settlement


19000102	rftAggregateCaseType:
    10102001  Aggregate Case

*/

SET @AggrCaseType = 10102003 /*Vet Aggregate Action*/

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
FROM fnAggregateSettings (@AggrCaseType)

create table	#VetAggregateAction
(	idfAggrCase					bigint not null primary key,
	idfProphylacticObservation	bigint,
	datStartDate				datetime,
	idfProphylacticVersion		BIGINT
	, idfsRegion BIGINT
	, idfsRayon BIGINT
	, idfsAdministrativeUnit BIGINT
	, datFinishDate DATETIME
)

declare	@idfsCurrentCountry	bigint
select	@idfsCurrentCountry = isnull(dbo.fnCurrentCountry(), 170000000) /*Azerbaijan*/

insert into	#VetAggregateAction
(	idfAggrCase,
	idfProphylacticObservation,
	datStartDate,
	idfProphylacticVersion
	, idfsRegion
	, idfsRayon
	, idfsAdministrativeUnit
	, datFinishDate
)
select		a.idfAggrCase,
			obs.idfObservation,
			a.datStartDate,
			a.idfProphylacticVersion
			, COALESCE(s.idfsRegion, rr.idfsRegion, r.idfsRegion, NULL) AS idfsRegion
			, COALESCE(s.idfsRayon, rr.idfsRayon, NULL) AS idfsRayon
			, a.idfsAdministrativeUnit
			, a.datFinishDate
from		tlbAggrCase a
inner join	tlbObservation obs
on			obs.idfObservation = a.idfProphylacticObservation
left join	gisCountry c
on			c.idfsCountry = a.idfsAdministrativeUnit
left join	gisRegion r
on			r.idfsRegion = a.idfsAdministrativeUnit 
			and r.idfsCountry = @idfsCurrentCountry
left join	gisRayon rr
on			rr.idfsRayon = a.idfsAdministrativeUnit
			and rr.idfsCountry = @idfsCurrentCountry
left join	gisSettlement s
on			s.idfsSettlement = a.idfsAdministrativeUnit
			and s.idfsCountry = @idfsCurrentCountry

-- Site, Organization entered aggregate action
inner join	tstSite sit
	left join	fnInstitutionRepair(@LangID) i
	on			i.idfOffice = sit.idfOffice
on			sit.idfsSite = a.idfsSite

where		a.idfsAggrCaseType = @AggrCaseType
-- Time Period satisfies Report Filters
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @EndDate
			)
			
	AND (
			(r.idfsRegion = @RegionID OR @RegionID IS NULL)
			OR (
				(rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
				)
			OR (
				a.idfsAdministrativeUnit = s.idfsSettlement
				AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)
				)
		)			
			-- Entered by organization satisfies Report Filters
			and (@OrganizationEntered is null or (@OrganizationEntered is not null and i.idfOffice = @OrganizationEntered))

			and a.intRowStatus = 0


	SELECT	
		@MinAdminLevel = idfsStatisticAreaType
		, @MinTimeInterval = idfsStatisticPeriodType
	FROM fnAggregateSettings (10102003 /*Vet Aggregate Action*/)
	

	DELETE FROM #VetAggregateAction
	WHERE idfAggrCase IN (
		SELECT
			idfAggrCase
		FROM (
			SELECT 
				COUNT(*) OVER (PARTITION BY ac.idfAggrCase) cnt
				, ac2.idfAggrCase
				, CASE 
					WHEN DATEDIFF(YEAR, ac2.datStartDate, ac2.datFinishDate) = 0 AND DATEDIFF(quarter, ac2.datStartDate, ac2.datFinishDate) > 1 
						THEN 10091005 --sptYear
					WHEN DATEDIFF(quarter, ac2.datStartDate, ac2.datFinishDate) = 0 AND DATEDIFF(MONTH, ac2.datStartDate, ac2.datFinishDate) > 1
						THEN 10091003 --sptQuarter
					WHEN DATEDIFF(MONTH, ac2.datStartDate, ac2.datFinishDate) = 0 AND dbo.fnWeekDatediff(ac2.datStartDate, ac2.datFinishDate) > 1
						THEN 10091001 --sptMonth
					WHEN dbo.fnWeekDatediff(ac2.datStartDate, ac2.datFinishDate) = 0 AND DATEDIFF(DAY, ac2.datStartDate, ac2.datFinishDate) > 1
						THEN 10091004 --sptWeek
					WHEN DATEDIFF(DAY, ac2.datStartDate, ac2.datFinishDate) = 0
						THEN 10091002 --sptOnday
				END AS TimeInterval
				, CASE
					WHEN ac2.idfsAdministrativeUnit = c2.idfsCountry THEN 10089001 --satCountry
					WHEN ac2.idfsAdministrativeUnit = r2.idfsRegion THEN 10089003 --satRegion
					WHEN ac2.idfsAdministrativeUnit = rr2.idfsRayon THEN 10089002 --satRayon
					WHEN ac2.idfsAdministrativeUnit = s2.idfsSettlement THEN 10089004 --satSettlement
				END AS AdminLevel
			FROM #VetAggregateAction ac
			LEFT JOIN gisCountry c ON
				c.idfsCountry = ac.idfsAdministrativeUnit
			LEFT JOIN gisRegion r ON
				r.idfsRegion = ac.idfsAdministrativeUnit 
				AND r.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisRayon rr ON
				rr.idfsRayon = ac.idfsAdministrativeUnit
				AND rr.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisSettlement s ON
				s.idfsSettlement = ac.idfsAdministrativeUnit
				AND s.idfsCountry = @idfsCurrentCountry
				
			JOIN #VetAggregateAction ac2 ON
				(
					ac2.datStartDate BETWEEN ac.datStartDate AND ac.datFinishDate
					OR ac2.datFinishDate BETWEEN ac.datStartDate AND ac.datFinishDate
				)
				
			LEFT JOIN gisCountry c2 ON
				c2.idfsCountry = ac2.idfsAdministrativeUnit
			LEFT JOIN gisRegion r2 ON
				r2.idfsRegion = ac2.idfsAdministrativeUnit 
				AND r2.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisRayon rr2 ON
				rr2.idfsRayon = ac2.idfsAdministrativeUnit
				AND rr2.idfsCountry = @idfsCurrentCountry
			LEFT JOIN gisSettlement s2 ON
				s2.idfsSettlement = ac2.idfsAdministrativeUnit
				AND s2.idfsCountry = @idfsCurrentCountry
			
			WHERE COALESCE(s2.idfsRayon, rr2.idfsRayon) = ac.idfsAdministrativeUnit
				OR COALESCE(s2.idfsRegion, rr2.idfsRegion, r2.idfsRegion) = ac.idfsAdministrativeUnit
				OR COALESCE(s2.idfsCountry, rr2.idfsCountry, r2.idfsCountry, c2.idfsCountry) = ac.idfsAdministrativeUnit
		) a
		WHERE cnt > 1	
			AND CASE WHEN TimeInterval = @MinTimeInterval AND AdminLevel = @MinAdminLevel THEN 1 ELSE 0 END = 0
	)


declare	@VetAggregateActionData	table
(	strDiagnosisSpeciesKey		nvarchar(200) collate database_default not null primary key,
	idfsDiagnosis				bigint not null,
	idfsProphylacticAction		bigint not null,
	idfsSpeciesType				bigint not null,
	strMeasureName				nvarchar(2000) collate database_default null,
	strDiagnosisName			nvarchar(2000) collate database_default null,
	strOIECode					nvarchar(200) collate database_default null,
	strSpecies					nvarchar(2000) collate database_default null,
	intActionTaken				int null,
	strNote						nvarchar(2000) collate database_default null,
	SpeciesOrderColumn			int null,
	DiagnosisOrderColumn		int null,
	InvestigationOrderColumn	int null
)

DECLARE @NotDeletedAggregateDiagnosis TABLE (
	[name] NVARCHAR(500)
	, idfsDiagnosis BIGINT
	, intOrder INT
	, strOIECode NVARCHAR(100)
	, rn INT
)

INSERT INTO @NotDeletedAggregateDiagnosis
SELECT
	r_d_actual.[name]
	, d_actual.idfsDiagnosis
	, r_d_actual.intOrder
	, d_actual.strOIECode
	, ROW_NUMBER() OVER (PARTITION BY r_d_actual.[name] ORDER BY d_actual.idfsDiagnosis) AS rn
from		trtDiagnosis d_actual
inner join	fnReference(@LangID, 19000019) r_d_actual
on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
where		d_actual.idfsUsingType = 10020002	/*Aggregate*/
			and d_actual.intRowStatus = 0
	

DECLARE @NotDeletedAggregateSpecies TABLE (
	[name] NVARCHAR(500)
	, idfsSpeciesType BIGINT
	, intOrder INT
	, rn INT
)	

INSERT INTO @NotDeletedAggregateSpecies
SELECT
	r_sp_actual.[name]
	, st_actual.idfsSpeciesType
	, r_sp_actual.intOrder
	, ROW_NUMBER() OVER (PARTITION BY r_sp_actual.[name] ORDER BY st_actual.idfsSpeciesType) AS rn
from		trtSpeciesType st_actual
inner join	fnReference(@LangID, 19000086) r_sp_actual
on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
where		st_actual.intRowStatus = 0


DECLARE @NotDeletedAggregateProphylacticAction TABLE (
	[name] NVARCHAR(500)
	, idfsProphylacticAction BIGINT
	, intOrder INT
	, rn INT
)

INSERT INTO @NotDeletedAggregateProphylacticAction
SELECT
	r_pm_actual.[name]
	, r_pm_actual.idfsReference as idfsProphylacticAction
	, r_pm_actual.intOrder
	, ROW_NUMBER() OVER (PARTITION BY r_pm_actual.[name] ORDER BY r_pm_actual.idfsReference) AS rn
from		fnReference(@LangID, 19000074) r_pm_actual /*Prophylactic Measure List*/

/*
;
WITH NotDeletedAggregateDiagnosis AS (
	SELECT
		r_d_actual.[name]
		, d_actual.idfsDiagnosis
		, r_d_actual.intOrder
		, d_actual.strOIECode
		, ROW_NUMBER() OVER (PARTITION BY r_d_actual.[name] ORDER BY d_actual.idfsDiagnosis) AS rn
	from		trtDiagnosis d_actual
	inner join	fnReference(@LangID, 19000019) r_d_actual
	on			r_d_actual.idfsReference = d_actual.idfsDiagnosis
	where		d_actual.idfsUsingType = 10020002	/*Aggregate*/
				and d_actual.intRowStatus = 0
)
, NotDeletedAggregateSpecies AS (
	SELECT
		r_sp_actual.[name]
		, st_actual.idfsSpeciesType
		, r_sp_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_sp_actual.[name] ORDER BY st_actual.idfsSpeciesType) AS rn
	from		trtSpeciesType st_actual
	inner join	fnReference(@LangID, 19000086) r_sp_actual
	on			r_sp_actual.idfsReference = st_actual.idfsSpeciesType
	where		st_actual.intRowStatus = 0
)
, NotDeletedAggregateProphylacticAction AS (
	SELECT
		r_pm_actual.[name]
		, r_pm_actual.idfsReference as idfsProphylacticAction
		, r_pm_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_pm_actual.[name] ORDER BY r_pm_actual.idfsReference) AS rn
	from		fnReference(@LangID, 19000074) r_pm_actual /*Prophylactic Measure List*/
)
*/


insert into	@VetAggregateActionData
(	strDiagnosisSpeciesKey,
	idfsDiagnosis,
	idfsProphylacticAction,
	idfsSpeciesType,
	strMeasureName,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intActionTaken,
	strNote,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	InvestigationOrderColumn
)
select		cast(isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Measure_Name.idfsProphylacticAction, 
								mtx.idfsProphilacticAction) as nvarchar(20)) as strDiagnosisSpeciesKey,
			isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis) as idfsDiagnosis,
			isnull(Actual_Measure_Name.idfsProphylacticAction, mtx.idfsProphilacticAction) as idfsProphylacticAction,
			isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType) as idfsSpeciesType,
			isnull(r_pm.[name], N'') as strMeasureName,
			isnull(r_d.[name], N'') as strDiagnosisName,
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')) as strOIECode,
			isnull(r_sp.[name], N'') as strSpecies,
			sum(isnull(cast(Action_taken.varValue as int), 0)) as intTested,
			max(left(isnull(cast(Prophylactics_Note.varValue as nvarchar), N''), 2000)) as intPositivaReaction,
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)) as SpeciesOrderColumn,
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)) as DiagnosisOrderColumn,
			isnull(Actual_Measure_Name.intOrder, isnull(r_pm.intOrder, -1000)) as InvestigationOrderColumn
from		#VetAggregateAction vaa
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = @idfsMatrixType
			and (	-- Get matrix version selected by the user in aggregate action
					h.idfVersion = vaa.idfProphylacticVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate action start date
					or (	vaa.idfProphylacticVersion is null 
							and	h.datStartDate <= vaa.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = @idfsMatrixType
												and	h_later.datStartDate <= vaa.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						)
				)
			and h.intRowStatus = 0
			
-- Matrix row
inner join	tlbAggrProphylacticActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0

-- Diagnosis       
inner join	trtDiagnosis d
	inner join	fnReferenceRepair(@LangID, 19000019) r_d
	on			r_d.idfsReference = d.idfsDiagnosis

	-- Not deleted diagnosis with the same name and aggregate using type
	LEFT JOIN @NotDeletedAggregateDiagnosis AS Actual_Diagnosis ON
		Actual_Diagnosis.[name] = r_d.[name] collate Cyrillic_General_CI_AS
		AND Actual_Diagnosis.rn = 1				
on			d.idfsDiagnosis = mtx.idfsDiagnosis

-- Species Type
inner join	fnReferenceRepair(@LangID, 19000086) r_sp
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedAggregateSpecies AS Actual_Species_Type ON
		Actual_Species_Type.[name] = r_sp.[name] collate Cyrillic_General_CI_AS
		AND Actual_Species_Type.rn = 1
on			r_sp.idfsReference = mtx.idfsSpeciesType

-- Measure Name
inner join	fnReferenceRepair(@LangID, 19000074) r_pm /*Prophylactic Measure List*/
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedAggregateProphylacticAction AS Actual_Measure_Name ON
		Actual_Measure_Name.[name] = r_pm.[name] collate Cyrillic_General_CI_AS
		AND Actual_Measure_Name.rn = 1
on			r_pm.idfsReference = mtx.idfsProphilacticAction

-- Action_taken
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfProphylacticObservation
 			and ap.idfRow = mtx.idfAggrProphylacticActionMTX
			and ap.idfsParameter = @Prophylactics_Aggr_Action_taken
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Action_taken

-- Note
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfProphylacticObservation
 			and ap.idfRow = mtx.idfAggrProphylacticActionMTX
			and ap.idfsParameter = @Prophylactics_Aggr_Note
			and ap.intRowStatus = 0
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Prophylactics_Note

group by	cast(isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType) as nvarchar(20)) + N'_' + 
				cast(isnull(Actual_Measure_Name.idfsProphylacticAction, 
								mtx.idfsProphilacticAction) as nvarchar(20)),
			isnull(Actual_Diagnosis.idfsDiagnosis, mtx.idfsDiagnosis),
			isnull(Actual_Measure_Name.idfsProphylacticAction, mtx.idfsProphilacticAction),
			isnull(Actual_Species_Type.idfsSpeciesType, mtx.idfsSpeciesType),
			isnull(r_pm.[name], N''),
			isnull(r_d.[name], N''),
			isnull(Actual_Diagnosis.strOIECode, isnull(d.strOIECode, N'')),
			isnull(r_sp.[name], N''),
			isnull(Actual_Species_Type.intOrder, isnull(r_sp.intOrder, -1000)),
			isnull(Actual_Diagnosis.intOrder, isnull(r_d.intOrder, -1000)),
			isnull(Actual_Measure_Name.intOrder, isnull(r_pm.intOrder, -1000))
-- Do not include the rows with Action Taken = 0 in the report
having		sum(isnull(cast(Action_taken.varValue as int), 0)) > 0


-- Fill result table
insert into	@Result
(	strDiagnosisSpeciesKey,
	strMeasureName,
	idfsDiagnosis,
	idfsProphylacticAction,
	idfsSpeciesType,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intActionTaken,
	strNote,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	blnAdditionalText
)
select distinct
			s.strDiagnosisSpeciesKey,
			s.strMeasureName,
			s.idfsDiagnosis,
			s.idfsProphylacticAction,
			s.idfsSpeciesType,
			s.strDiagnosisName,
			s.strOIECode,
			s.strSpecies,
			s.intActionTaken,
			case
				when	s.blnAddNote > 0
					then	@Included_state_sector_Translation
				else	N''
			end,
			s.SpeciesOrderColumn,
			s.DiagnosisOrderColumn,
			1 AS blnAdditionalText

from		@VetCaseData s

insert into	@Result
(	strDiagnosisSpeciesKey,
	strMeasureName,
	idfsDiagnosis,
	idfsProphylacticAction,
	idfsSpeciesType,
	strDiagnosisName,
	strOIECode,
	strSpecies,
	intActionTaken,
	strNote,
	InvestigationOrderColumn,
	SpeciesOrderColumn,
	DiagnosisOrderColumn,
	blnAdditionalText
)
select		a.strDiagnosisSpeciesKey,
			a.strMeasureName,
			a.idfsDiagnosis,
			a.idfsProphylacticAction,
			a.idfsSpeciesType,
			a.strDiagnosisName,
			a.strOIECode,
			a.strSpecies,
			a.intActionTaken,
			case
				when	@FromYear = @ToYear
						and	@FromMonth = @ToMonth
					then	a.strNote
				else	N''
			end,
			a.InvestigationOrderColumn,
			a.SpeciesOrderColumn,
			a.DiagnosisOrderColumn,
			0 AS blnAdditionalText
			
from		@VetAggregateActionData a
left join	@Result r
on			r.strDiagnosisSpeciesKey = a.strDiagnosisSpeciesKey
where		r.idfsDiagnosis is null

-- Update orders in the table
update		r
set			r.InvestigationOrderColumn = ROrderTable.RowOrder,
			r.DiagnosisOrderColumn = 0,
			r.SpeciesOrderColumn = 0
from		@Result r
inner join	(	
	select	r_order.strDiagnosisSpeciesKey,
			row_number () over	(	order by	isnull(r_order.strMeasureName, N''), 
												isnull(r_order.strDiagnosisName, N''),
												isnull(r_order.SpeciesOrderColumn, 0),
												isnull(r_order.strSpecies, N'')
								) as RowOrder
	from	@Result r_order
			) as ROrderTable
on			ROrderTable.strDiagnosisSpeciesKey = r.strDiagnosisSpeciesKey


-- Select report informative part - start

/*
insert into @Result Values('aaa', 'dddd', 7718320000000, 'diagnos', 'B051', 'dog', 12, 'fff', 34, 45, 56)
insert into @Result Values('b', 'dddd', 7718320000000, 'diagnos', 'B051', 'cat', 13, 'jjj', 24, 35, 46)
insert into @Result Values('c', 'gdhdfgdh', 7718730000000, 'diagnos2', 'B103, B152, B253', 'sheep', 12, 'note', 23, 34, 45)
insert into @Result Values('в', 'sdfgsafdgsdfg', 7718350000000, 'diagnos3', 'B0512', 'cat', 13, 'note2', 24, 35, 46)
insert into @Result Values('ф', 'sdfgsafdgsdfg', 7718760000000, 'diagnos4', 'B1031, B152, B253', 'sheep', 12, 'note5', 23, 34, 45)
insert into @Result Values('aaa1', 'sdfgsafdgsdfg', 7718520000000, 'diagnos5', 'B051', 'dog', 12, 'notedddd', 23, 34, 45)
insert into @Result Values('b1', 'sdfgsafdgsdfg', 7718520000000, 'diagnos5', 'B051', 'cat', 13, 'notesdfgs', 24, 35, 46)
*/


-- Return results
if (SELECT count(*) FROM @result) = 0
	select	'' as strDiagnosisSpeciesKey,
	'' as strMeasureName,
	- 1 as idfsDiagnosis,
	- 1 as idfsProphylacticAction,
	- 1 as idfsSpeciesType,
	'' as strDiagnosisName,
	'' as strOIECode, 
	'' as strSpecies,
	null as intActionTaken, 
	null as strNote,
	null as InvestigationOrderColumn, 
	null as SpeciesOrderColumn, 
	null as DiagnosisOrderColumn,
	0 as blnAdditionalText
else
	SELECT * FROM @result ORDER BY InvestigationOrderColumn

-- Drop temporary tables
if Object_ID('tempdb..#VetAggregateAction') is not null
begin
	set	@drop_cmd = N'drop table #VetAggregateAction'
	execute sp_executesql @drop_cmd
end
	     
end



