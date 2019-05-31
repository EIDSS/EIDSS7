

--##SUMMARY Select data for REPORT ON ACTIONS TAKEN AGAINST EPIZOOTIC: Diagnostic investigations report.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec dbo.spRepVetForm1ASanitaryMeasuresAZ @LangID=N'en', @FromYear = 2014, @ToYear = 2014, @FromMonth = 9, @ToMonth = 9
exec dbo.spRepVetForm1ASanitaryMeasuresAZ 'ru',2012,2013
exec dbo.spRepVetForm1ASanitaryMeasuresAZ 'ru',2017,2018

*/

CREATE  Procedure [dbo].[spRepVetForm1ASanitaryMeasuresAZ]
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
	strKey					nvarchar(200) collate database_default not null primary key,
	strMeasureName			nvarchar(2000) collate database_default null,
	SanitaryMeasureOrderColumn	int null,
	intNumberFacilities		int null,
	intSquare				float null,
	strNote					nvarchar(2000) collate database_default null,
	blnAdditionalText		bit
)


declare	@idfsSummaryReportType	bigint
set	@idfsSummaryReportType = 10290035	-- Veterinary Report Form Vet 1A - Sanitary

declare	@idfsMatrixType	bigint
set	@idfsMatrixType = 71260000000	-- Veterinary-sanitary measures


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
END


/*Vet Sanitary Aggregate Matrix that was activated and has the latest Activation Start Date
* , which belongs to the period between first date of the year specified in From Year filter 
* and last date of the year specified in To Year filter, among all activated Vet Sanitary Aggregate Matrices 
* with Activation Start Date belonging to the same period
*/
DECLARE @idfSanitaryVersion BIGINT 

SELECT
	@idfSanitaryVersion = tamvh.idfVersion
FROM tlbAggrMatrixVersionHeader tamvh
WHERE tamvh.blnIsActive = 1
	AND tamvh.intRowStatus = 0
	AND tamvh.datStartDate BETWEEN @StartDate AND @EndDate
	AND tamvh.idfsMatrixType = @idfsMatrixType
	AND NOT EXISTS (SELECT
						1
					FROM tlbAggrMatrixVersionHeader tamvh2
					WHERE tamvh2.blnIsActive = 1
						AND tamvh2.intRowStatus = 0
						AND tamvh2.datStartDate BETWEEN @StartDate AND @EndDate
						AND (tamvh2.datStartDate > tamvh.datStartDate
							OR(tamvh2.datStartDate = tamvh.datStartDate AND tamvh2.idfVersion > tamvh.idfVersion)
							)
						AND tamvh2.idfsMatrixType = 71260000000 /*Veterinary-sanitary measures*/)

-- Select report informative part - start
declare	@attr_part_in_report			bigint

select	@attr_part_in_report = at.idfAttributeType
from	trtAttributeType at
where	at.strAttributeTypeName = N'attr_part_in_report'


declare	@Sanitary_Number_of_facilities	bigint
declare	@Sanitary_Area					bigint
declare	@Sanitary_Note					bigint

-- Sanitary_Number_of_facilities
select		@Sanitary_Number_of_facilities = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Sanitary_Number_of_facilities'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Sanitary_Area
select		@Sanitary_Area = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Sanitary_Area'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0

-- Sanitary_Note
select		@Sanitary_Note = p.idfsParameter
from		trtFFObjectForCustomReport ff_for_cr
inner join	ffParameter p
on			p.idfsParameter = ff_for_cr.idfsFFObject
where		ff_for_cr.strFFObjectAlias = N'Sanitary_Note'
			and ff_for_cr.idfsCustomReportType = @idfsSummaryReportType
			and ff_for_cr.intRowStatus = 0


DECLARE @SpecificOfficeId BIGINT
SELECT
	 @SpecificOfficeId = ts.idfOffice
FROM tstSite ts 
WHERE ts.intRowStatus = 0
	AND ts.intFlags = 100 /*organization with abbreviation = Baku city VO*/

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
(	idfAggrCase				bigint not null primary key,
	idfSanitaryObservation	bigint,
	datStartDate			datetime,
	idfSanitaryVersion		BIGINT
	, idfsRegion BIGINT
	, idfsRayon BIGINT
	, idfsAdministrativeUnit BIGINT
	, datFinishDate DATETIME
)

declare	@idfsCurrentCountry	bigint
select	@idfsCurrentCountry = isnull(dbo.fnCurrentCountry(), 170000000) /*Azerbaijan*/

insert into	#VetAggregateAction
(	idfAggrCase,
	idfSanitaryObservation,
	datStartDate,
	idfSanitaryVersion
	, idfsRegion
	, idfsRayon
	, idfsAdministrativeUnit
	, datFinishDate
)
select		a.idfAggrCase,
			obs.idfObservation,
			a.datStartDate,
			a.idfSanitaryVersion
			, COALESCE(s.idfsRegion, rr.idfsRegion, r.idfsRegion, NULL) AS idfsRegion
			, COALESCE(s.idfsRayon, rr.idfsRayon, NULL) AS idfsRayon
			, a.idfsAdministrativeUnit
			, a.datFinishDate
from		tlbAggrCase a
inner join	tlbObservation obs
on			obs.idfObservation = a.idfSanitaryObservation
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
	on			i.idfOffice = CASE WHEN sit.intFlags = 10 THEN @SpecificOfficeId ELSE sit.idfOffice END
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
(	strKey						nvarchar(200) collate database_default not null primary key,
	idfsSanitaryAction			bigint not null,
	strMeasureName				nvarchar(2000) collate database_default null,
	intNumberFacilities			int null,
	intSquare					float null,
	strNote						nvarchar(2000) collate database_default null,
	SanitaryMeasureOrderColumn	int null,
	MTXOrderColumn				int null
)

DECLARE @NotDeletedAggregateSanitaryAction TABLE (
	[name] NVARCHAR(500)
	, idfsSanitaryAction BIGINT
	, intOrder INT
	, rn INT
)

INSERT INTO @NotDeletedAggregateSanitaryAction
SELECT
	r_sm_actual.[name]
	, r_sm_actual.idfsReference as idfsSanitaryAction
	, r_sm_actual.intOrder
	, ROW_NUMBER() OVER (PARTITION BY r_sm_actual.[name] ORDER BY r_sm_actual.idfsReference) AS rn
from		fnReference(@LangID, 19000079) r_sm_actual /*Sanitary Measure List*/

/*
;
WITH NotDeletedAggregateSanitaryAction AS (
	SELECT
		r_sm_actual.[name]
		, r_sm_actual.idfsReference as idfsSanitaryAction
		, r_sm_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_sm_actual.[name] ORDER BY r_sm_actual.idfsReference) AS rn
	from		fnReference(@LangID, 19000079) r_sm_actual /*Sanitary Measure List*/
)
*/
insert into	@VetAggregateActionData
(	strKey,
	idfsSanitaryAction,
	strMeasureName,
	intNumberFacilities,
	intSquare,
	strNote,
	SanitaryMeasureOrderColumn,
	MTXOrderColumn
)
select		cast(isnull(Actual_Measure_Name.idfsSanitaryAction, 
								mtx.idfsSanitaryAction) as nvarchar(20)) as strKey,
			isnull(Actual_Measure_Name.idfsSanitaryAction, mtx.idfsSanitaryAction) as idfsSanitaryAction,
			isnull(r_sm.[name], N'') as strMeasureName,
			sum(isnull(cast(Sanitary_Number_of_facilities.varValue as int), 0)) as intNumberFacilities,
			sum(isnull(cast(Sanitary_Area.varValue as float), 0.00)) as intSquare,
			max(left(isnull(cast(Sanitary_Note.varValue as nvarchar), N''), 2000)) as strNote,
			isnull(Actual_Measure_Name.intOrder, isnull(r_sm.intOrder, -1000)) as SanitaryMeasureOrderColumn,
			isnull(mtx.intNumRow, -1000) as MTXOrderColumn

from		#VetAggregateAction vaa
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = @idfsMatrixType
			and (	-- Get matrix version selected by the user in aggregate action
					h.idfVersion = vaa.idfSanitaryVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate action start date
					or (	vaa.idfSanitaryVersion is null 
							AND h.idfVersion = @idfSanitaryVersion
						)
				)
			and h.intRowStatus = 0
			
-- Matrix row
inner join	tlbAggrSanitaryActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0

-- Measure Name
inner join	fnReferenceRepair(@LangID, 19000079) r_sm /*Sanitary Measure List*/
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedAggregateSanitaryAction AS Actual_Measure_Name ON
		Actual_Measure_Name.[name] = r_sm.[name] collate Cyrillic_General_CI_AS
		AND Actual_Measure_Name.rn = 1
	------outer apply (
 ------		select top 1
 ------					r_sm_actual.idfsReference as idfsSanitaryAction, r_sm_actual.intOrder
 ------		from		fnReference(@LangID, 19000079) r_sm_actual /*Sanitary Measure List*/
 ------		where		r_sm_actual.[name] = r_sm.[name]
 ------		order by r_sm_actual.idfsReference asc
 ------			) as  Actual_Measure_Name
on			r_sm.idfsReference = mtx.idfsSanitaryAction

-- Number_of_facilities
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfSanitaryObservation
 			and ap.idfRow = mtx.idfAggrSanitaryActionMTX
			and ap.idfsParameter = @Sanitary_Number_of_facilities
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Sanitary_Number_of_facilities

-- Area
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfSanitaryObservation
 			and ap.idfRow = mtx.idfAggrSanitaryActionMTX
			and ap.idfsParameter = @Sanitary_Area
			and ap.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(ap.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Sanitary_Area

-- Note
outer apply ( 
 	select top 1
 			ap.varValue
 	from	tlbActivityParameters ap
 	where	ap.idfObservation = vaa.idfSanitaryObservation
 			and ap.idfRow = mtx.idfAggrSanitaryActionMTX
			and ap.idfsParameter = @Sanitary_Note
			and ap.intRowStatus = 0
			and ap.varValue is not null
 			order by ap.idfActivityParameters asc
 		) as  Sanitary_Note

group by	cast(isnull(Actual_Measure_Name.idfsSanitaryAction, 
								mtx.idfsSanitaryAction) as nvarchar(20)),
			isnull(Actual_Measure_Name.idfsSanitaryAction, mtx.idfsSanitaryAction),
			isnull(r_sm.[name], N''),
			isnull(Actual_Measure_Name.intOrder, isnull(r_sm.intOrder, -1000)),
			isnull(mtx.intNumRow, -1000)
/*Condition is not included in the report specification
-- Do not include the rows with Number of facilities = 0 in the report
having		sum(isnull(cast(Sanitary_Number_of_facilities.varValue as int), 0)) > 0
*/

DECLARE @NotDeletedAggregateSanitaryActionWithoutData TABLE (
	[name] NVARCHAR(500)
	, idfsSanitaryAction BIGINT
	, intOrder INT
	, rn INT
)

INSERT INTO @NotDeletedAggregateSanitaryActionWithoutData
SELECT
	r_sm_actual.[name]
	, r_sm_actual.idfsReference as idfsSanitaryAction
	, r_sm_actual.intOrder
	, ROW_NUMBER() OVER (PARTITION BY r_sm_actual.[name] ORDER BY r_sm_actual.idfsReference) AS rn
from		fnReference(@LangID, 19000079) r_sm_actual /*Sanitary Measure List*/

/*
;
WITH NotDeletedAggregateSanitaryActionWithoutData AS (
	SELECT
		r_sm_actual.[name]
		, r_sm_actual.idfsReference as idfsSanitaryAction
		, r_sm_actual.intOrder
		, ROW_NUMBER() OVER (PARTITION BY r_sm_actual.[name] ORDER BY r_sm_actual.idfsReference) AS rn
	from		fnReference(@LangID, 19000079) r_sm_actual /*Sanitary Measure List*/
)
*/
-- Return all measures even witout FF values
insert into	@VetAggregateActionData
(	strKey,
	idfsSanitaryAction,
	strMeasureName,
	intNumberFacilities,
	intSquare,
	strNote,
	SanitaryMeasureOrderColumn,
	MTXOrderColumn
)
select		cast(isnull(Actual_Measure_Name.idfsSanitaryAction, 
								mtx.idfsSanitaryAction) as nvarchar(20)) as strKey,
			isnull(Actual_Measure_Name.idfsSanitaryAction, mtx.idfsSanitaryAction) as idfsSanitaryAction,
			isnull(r_sm.[name], N'') as strMeasureName,
			0 as intNumberFacilities,
			cast(0 as float) as intSquare,
			N'' as strNote,
			isnull(Actual_Measure_Name.intOrder, isnull(r_sm.intOrder, -1000)) as SanitaryMeasureOrderColumn,
			isnull(mtx.intNumRow, -1000) as MTXOrderColumn

from		tlbAggrMatrixVersionHeader h
			
-- Matrix row
inner join	tlbAggrSanitaryActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0

-- Measure Name
inner join	fnReferenceRepair(@LangID, 19000079) r_sm /*Sanitary Measure List*/
	-- Not deleted species type with the same name
	LEFT JOIN @NotDeletedAggregateSanitaryActionWithoutData AS Actual_Measure_Name ON
		Actual_Measure_Name.[name] = r_sm.[name] collate Cyrillic_General_CI_AS
		AND Actual_Measure_Name.rn = 1
on			r_sm.idfsReference = mtx.idfsSanitaryAction

left join	@VetAggregateActionData vaad
on			vaad.strKey = cast(isnull(Actual_Measure_Name.idfsSanitaryAction, 
								mtx.idfsSanitaryAction) as nvarchar(20))

where		h.idfVersion = @idfSanitaryVersion
			and vaad.strKey is null


-- Fill result table
insert into	@Result
(	strKey,
	strMeasureName,
	SanitaryMeasureOrderColumn,
	intNumberFacilities,
	intSquare,
	strNote
)
select		a.strKey,
			a.strMeasureName,
			isnull(a.MTXOrderColumn, a.SanitaryMeasureOrderColumn),
			a.intNumberFacilities,
			a.intSquare,
			case
				when	@FromYear = @ToYear
						and	@FromMonth = @ToMonth
					then	a.strNote
				else	N''
			end
from		@VetAggregateActionData a
-- Select report informative part - start

-- Return results
if (SELECT count(*) FROM @result) = 0
	select	cast('' as nvarchar(200)) as strKey,
	cast('' as nvarchar(2000)) as strMeasureName,
	cast(null as int) as SanitaryMeasureOrderColumn,
	cast(null as int) as intNumberFacilities, 
	cast(null as float) as intSquare, 
	cast(null as nvarchar(2000)) as strNote,
	0 as blnAdditionalText
else
	SELECT * FROM @result ORDER BY strMeasureName


-- Drop temporary tables
if Object_ID('tempdb..#VetAggregateAction') is not null
begin
	set	@drop_cmd = N'drop table #VetAggregateAction'
	execute sp_executesql @drop_cmd
end

	     
end



