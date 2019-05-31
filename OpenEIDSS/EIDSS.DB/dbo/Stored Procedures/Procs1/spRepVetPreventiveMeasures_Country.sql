

--##SUMMARY Select data for Country Report “Veterinary preventive measures” V4.
--##REMARKS Author: Mirnaya Olga
--##REMARKS Create date: 31.01.2011 
--##REMARKS Updated by: Anastasia Zhdanova
--##REMARKS Modification date: 04.06.2012

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec [spRepVetPreventiveMeasures_Country] 
'en', 
'2012-01-01', 
'2012-10-01',  
'<ItemList><Item key="6618460000000" value="Swine Erysipelas"/></ItemList>', 
'<ItemList><Item key="838110000000" value="Pig"/></ItemList>', 
'<ItemList><Item key="952180000000" value="Vaccination"/></ItemList>', 
null
  
*/

create  PROCEDURE [dbo].[spRepVetPreventiveMeasures_Country]
	(
		@LangID		AS NVARCHAR(10), 
		@StartDate	AS DATETIME,	 
		@FinishDate	AS DATETIME,
		@Diagnosis AS XML,
		@Species AS XML,
		@Measures	AS XML,
		@Region AS BIGINT = null
	)
AS	
begin
-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/KZ/Reports/Specification_for_reports_development_Country_vaccination-treatment-KZ-V4.docx"

exec dbo.spSetFirstDay

DECLARE	@ReportTable	TABLE
(	idfsBaseReference	BIGINT NOT NULL,
	strRegionName		NVARCHAR(300) COLLATE database_default NULL, --1
	strRayonName		NVARCHAR(300) COLLATE database_default NULL, --1
	strDiagnosisName	NVARCHAR(500) COLLATE database_default NULL, --2
	strMeasureType		NVARCHAR(500) COLLATE database_default NULL, --3
	strSpecies			NVARCHAR(300) COLLATE database_default NULL, --4

    intNumOfAnimForVact INT NULL, --5
    intNumOfVactAnimRep INT NULL, --6
    intNumOfVactAnimYear INT NULL, --7
    intPlanExec FLOAT NULL, --8

	intOrder			INT NOT NULL
)

---------------
--- represent @Species as the table @SpeciesTable
DECLARE @iSpecies	INT
DECLARE @SpeciesTable	TABLE
(
	 [key]	NVARCHAR(300)
	,[value]	NVARCHAR(300)
)

EXEC sp_xml_preparedocument @iSpecies OUTPUT, @Species

INSERT INTO @SpeciesTable (
	[key],
	[value]
	
) 
SELECT * 
FROM OPENXML (@iSpecies, '/ItemList/Item')
WITH ([key] BIGINT '@key',
      [value] NVARCHAR(300) '@value'
        )

EXEC sp_xml_removedocument @iSpecies
--------------------
--- represent @Measures as the table @MeasuresTable
DECLARE @iMeasures	INT
DECLARE @MeasuresTable	TABLE
(
	 [key]	NVARCHAR(300)
	,[value]	NVARCHAR(300)
)

EXEC sp_xml_preparedocument @iMeasures OUTPUT, @Measures

INSERT INTO @MeasuresTable (
	[key],
	[value]
	
) 
SELECT * 
FROM OPENXML (@iMeasures, '/ItemList/Item')
WITH ([key] BIGINT '@key',
      [value] NVARCHAR(300) '@value'
        )

EXEC sp_xml_removedocument @iMeasures
--------------------
--- represent @Diagnosis as the table @DiagnosisTable
DECLARE @iDiagnosis	INT
DECLARE @DiagnosisTable	TABLE
(
	 [key]	NVARCHAR(300)
	,[value]	NVARCHAR(300)
)

EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @Diagnosis

INSERT INTO @DiagnosisTable (
	[key],
	[value]
	
) 
SELECT * 
FROM OPENXML (@iDiagnosis, '/ItemList/Item')
WITH ([key] BIGINT '@key',
      [value] NVARCHAR(300) '@value'
        )

EXEC sp_xml_removedocument @iDiagnosis
-----------------



DECLARE @MinAdminLevel BIGINT
DECLARE @MinTimeInterval BIGINT
DECLARE @AggrCaseType BIGINT


IF @FinishDate is not null SET @FinishDate = dateadd(day, 1, @FinishDate)

SET @AggrCaseType = 10102003 --Vet Aggregate Action

-- find agg setting
SELECT	@MinAdminLevel = ISNULL(fas.idfsStatisticAreaType,10089002 /*Rayon*/),
		@MinTimeInterval = ISNULL(fas.idfsStatisticPeriodType,10091004/*Week*/)
FROM dbo.fnAggregateSettings(@AggrCaseType) fas

-- check admin level
if @MinAdminLevel = 10089001 --'satCountry' 
	return

-- find parameter IDs
-- 10290004 = 'KZ Oblast Report “Veterinary preventive measures” V4'
declare @PDiagnosis bigint
select @PDiagnosis = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290004 and strFFObjectAlias = 'Diagnosis'

declare @PSpecies bigint
select @PSpecies = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290004 and strFFObjectAlias = 'Species'

declare @PMeasureType bigint
select @PMeasureType = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290004 and strFFObjectAlias = 'Measure Type'

declare @PNumberPlanned bigint
select @PNumberPlanned = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290004 and strFFObjectAlias = 'Number of animals planned'

declare @PNumberVaccinated  bigint
select @PNumberVaccinated = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290004 and strFFObjectAlias = 'Number of vaccinated animals'



----------------------------------------------------------------------------------------------------
--- select data for the fixed period
----------------------------------------------------------------------------------------------------
-- List of actual AggCases

declare	@VetProphylacticMeasureMatrix	table
(	idfAggrCase	BIGINT not null primary KEY,
  datStartDate DATETIME,
  idfProphylacticVersion BIGINT,
  idfProphylacticObservation BIGINT,
  idfsRegion BIGINT
)


insert into	@VetProphylacticMeasureMatrix  
(	idfAggrCase,
  datStartDate,
  idfProphylacticVersion,
  idfProphylacticObservation,
  idfsRegion
)
select	
		a.idfAggrCase,
		a.datStartDate,
          a.idfProphylacticVersion,
          a.idfProphylacticObservation,
		COALESCE(r.idfsRegion ,rr.idfsRegion, s.idfsRegion)
from		tlbAggrCase a
	-- datail information about aministrativ unit
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
			    and r.idfsCountry = 1240000000
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = 1240000000
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = 1240000000

WHERE 		
			-- AggCase type	
			a.idfsAggrCaseType = @AggrCaseType
			-- in selected period
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @FinishDate
				)
			-- correct (actual!) period type
			and (	(	@MinTimeInterval = 10091005 --'sptYear'
						and DateDiff(year, a.datStartDate, a.datFinishDate) = 0
						and DateDiff(quarter, a.datStartDate, a.datFinishDate) > 1
					)
					or	(	@MinTimeInterval = 10091003 --'sptQuarter'
							and DateDiff(quarter, a.datStartDate, a.datFinishDate) = 0
							and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091001 --'sptMonth'
							and DateDiff(month, a.datStartDate, a.datFinishDate) = 0
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091004 --'sptWeek'
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) = 0
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091002--'sptOnday'
						and DateDiff(day, a.datStartDate, a.datFinishDate) = 0)
				)    
			
			-- correct (actual!) Administrativ Unit
			-- check Region
			and		
			(		(	@MinAdminLevel = 10089003 --'satRegion' 
						and a.idfsAdministrativeUnit = r.idfsRegion
					)
				or	(	@MinAdminLevel = 10089002 --'satRayon' 
						and a.idfsAdministrativeUnit = rr.idfsRayon
					)
				or	(	@MinAdminLevel = 10089004 --'satSettlement' 
						and a.idfsAdministrativeUnit = s.idfsSettlement
					)
			  )



--- data values from the list of actual AggCases
DECLARE	@VetProphylacticMeasureMatrixValuesTable	TABLE
(	   idfsRegion	BIGINT,
     idfsDiagnosis	BIGINT,
     idfsSpeciesType	BIGINT,
     idfsProphilacticAction	BIGINT,
     intNumOfVactAnimRep INT --6
 )



insert into	@VetProphylacticMeasureMatrixValuesTable
(	idfsRegion,
  idfsDiagnosis,
  idfsSpeciesType,
  idfsProphilacticAction,
  intNumOfVactAnimRep
)
select		
   fhac.idfsRegion,
   mtx.idfsDiagnosis,
   mtx.idfsSpeciesType,
   mtx.idfsProphilacticAction,
   sum(IsNull(CAST(agp_NVA.varValue AS INT), 0)) 


from		@VetProphylacticMeasureMatrix fhac -- list of AggCases
-- Updated for version 6
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71300000000 -- Prophylactic Action
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfProphylacticVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfProphylacticVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71300000000 -- Prophylactic Action
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	dbo.tlbAggrProphylacticActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
			
INNER JOIN @SpeciesTable st
ON st.[key] = mtx.idfsSpeciesType

INNER JOIN @DiagnosisTable dt
ON dt.[key] = mtx.idfsDiagnosis

INNER JOIN @MeasuresTable mt
ON mt.[key] = mtx.idfsProphilacticAction

-- column "Number of vaccinated animals"
left join	dbo.tlbActivityParameters agp_NVA
on			agp_NVA.idfObservation = fhac.idfProphylacticObservation
			and agp_NVA.idfsParameter = @PNumberVaccinated
			and agp_NVA.idfRow = mtx.idfAggrProphylacticActionMTX
			and agp_NVA.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_NVA.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			
GROUP BY    
    fhac.idfsRegion, 
    idfsDiagnosis,
    idfsSpeciesType,
    idfsProphilacticAction

	

----------------------------------------------------------------------------------------------------
--- select data from the start of year
----------------------------------------------------------------------------------------------------
SET @StartDate = CAST(CAST(YEAR(@StartDate)	 AS VARCHAR(4)) + '0101' AS DATETIME)


-- List of actual AggCases for year
declare	@VetProphylacticMeasureMatrix_Year	table
(	idfAggrCase	BIGINT not null primary KEY,
  datStartDate DATETIME,
  idfProphylacticVersion BIGINT,
  idfProphylacticObservation BIGINT,
  idfsRegion BIGINT
)


insert into	@VetProphylacticMeasureMatrix_Year  
(	idfAggrCase,
  datStartDate,
  idfProphylacticVersion,
  idfProphylacticObservation,
  idfsRegion
)
select	
		a.idfAggrCase,
		a.datStartDate,
		a.idfSanitaryVersion,
		a.idfSanitaryObservation,
		COALESCE(r.idfsRegion ,rr.idfsRegion, s.idfsRegion)
from		tlbAggrCase a
	-- datail information about aministrativ unit
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
			    and r.idfsCountry = 1240000000
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = 1240000000
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = 1240000000

WHERE 		
			-- AggCase type	
			a.idfsAggrCaseType = @AggrCaseType
			-- in selected period
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @FinishDate
				)
			-- correct (actual!) period type
			and (	(	@MinTimeInterval = 10091005 --'sptYear'
						and DateDiff(year, a.datStartDate, a.datFinishDate) = 0
						and DateDiff(quarter, a.datStartDate, a.datFinishDate) > 1
					)
					or	(	@MinTimeInterval = 10091003 --'sptQuarter'
							and DateDiff(quarter, a.datStartDate, a.datFinishDate) = 0
							and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091001 --'sptMonth'
							and DateDiff(month, a.datStartDate, a.datFinishDate) = 0
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091004 --'sptWeek'
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) = 0
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091002--'sptOnday'
						and DateDiff(day, a.datStartDate, a.datFinishDate) = 0)
				)    
			
			-- correct (actual!) Administrativ Unit
			-- check Region
			and		
			(		(	@MinAdminLevel = 10089003 --'satRegion' 
						and a.idfsAdministrativeUnit = r.idfsRegion
					)
				or	(	@MinAdminLevel = 10089002 --'satRayon' 
						and a.idfsAdministrativeUnit = rr.idfsRayon
					)
				or	(	@MinAdminLevel = 10089004 --'satSettlement' 
						and a.idfsAdministrativeUnit = s.idfsSettlement
					)
			  )


--- data values from the list of actual AggCases
DECLARE	@VetProphylacticMeasureMatrixValuesTable_Year	TABLE
(	   idfsRegion	BIGINT,
     idfsDiagnosis	BIGINT,
     idfsSpeciesType	BIGINT,
     idfsProphilacticAction	BIGINT,
     intNumOfVactAnimYear INT 
     
)



insert into	@VetProphylacticMeasureMatrixValuesTable_Year
(	idfsRegion,
  idfsDiagnosis,
  idfsSpeciesType,
  idfsProphilacticAction,
  intNumOfVactAnimYear
)
select		
   fhac.idfsRegion,
   mtx.idfsDiagnosis,
   mtx.idfsSpeciesType,
   mtx.idfsProphilacticAction,
   sum(IsNull(CAST(agp_NVA.varValue AS INT), 0)) 


from		@VetProphylacticMeasureMatrix_Year fhac -- list of AggCases

-- Updated for version 6
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71300000000 -- Prophylactic Action
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfProphylacticVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfProphylacticVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71300000000 -- Prophylactic Action
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	dbo.tlbAggrProphylacticActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
			
INNER JOIN @SpeciesTable st
ON st.[key] = mtx.idfsSpeciesType

INNER JOIN @DiagnosisTable dt
ON dt.[key] = mtx.idfsDiagnosis

INNER JOIN @MeasuresTable mt
ON mt.[key] = mtx.idfsProphilacticAction


-- column "Number of vaccinated animals"
left join	dbo.tlbActivityParameters agp_NVA
on			agp_NVA.idfObservation = fhac.idfProphylacticObservation
			and agp_NVA.idfsParameter = @PNumberVaccinated
			and agp_NVA.idfRow = mtx.idfAggrProphylacticActionMTX
			and agp_NVA.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_NVA.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')


GROUP BY    
    fhac.idfsRegion, 
    idfsDiagnosis,
    idfsSpeciesType,
    idfsProphilacticAction

    
    
    
----------------------------------------------------------------------------------------------------
--- select data about num,er of animale planed for vaccination
--- it's really more hard then on region level - it's need a sum
----------------------------------------------------------------------------------------------------


DECLARE	@VetProphylacticMeasureMatrixValuesTable_FirstInYear	TABLE
(	 idfsRegion	BIGINT,
     idfsDiagnosis	BIGINT,
     idfsSpeciesType	BIGINT,
     idfsProphilacticAction	BIGINT,
     intNumOfAnimForVact INT 
)

insert into	@VetProphylacticMeasureMatrixValuesTable_FirstInYear
(	idfsRegion,
	idfsDiagnosis,
	idfsSpeciesType,
	idfsProphilacticAction,
	intNumOfAnimForVact
)

select		
   fy.idfsRegion,
   fy.idfsDiagnosis,
   fy.idfsSpeciesType,
   fy.idfsProphilacticAction,
   sum(IsNull(CAST(agp_NAFV.varValue AS INT), 0))


from	
(SELECT 
   fhac.idfsRegion,
   COALESCE(rr.idfsRayon, s.idfsRayon, 0) as idfsRayon,
   mtx.idfsDiagnosis,
   mtx.idfsSpeciesType,
   mtx.idfsProphilacticAction,
   mtx.idfAggrProphylacticActionMTX,
   fhac.idfProphylacticObservation,
   row_number() over(partition by  fhac.idfsRegion,
                                   COALESCE(rr.idfsRayon, s.idfsRayon, 0),
                                   mtx.idfsDiagnosis,
                                   mtx.idfsSpeciesType,
                                   mtx.idfsProphilacticAction
                       order by fhac.datStartDate) AS RN
	FROM @VetProphylacticMeasureMatrix_Year fhac
	-- need to find rayon (back)
	inner join tlbAggrCase a
	on fhac.idfAggrCase = a.idfAggrCase
	-- datail information about aministrativ unit
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
    
    -- Updated for version 6
	-- Matrix version
	inner join	tlbAggrMatrixVersionHeader h
	on			h.idfsMatrixType = 71300000000 -- Prophylactic Action
				and (	-- Get matrix version selected by the user in aggregate case
						h.idfVersion = fhac.idfProphylacticVersion
						-- If matrix version is not selected by the user in aggregate case, 
						-- then select active matrix with the latest date activation that is earlier than aggregate case start date
						or (	fhac.idfProphylacticVersion is null 
								and	h.datStartDate <= fhac.datStartDate
								and	h.blnIsActive = 1
								and not exists	(
											select	*
											from	tlbAggrMatrixVersionHeader h_later
											where	h_later.idfsMatrixType = 71300000000 -- Prophylactic Action
													and	h_later.datStartDate <= fhac.datStartDate
													and	h_later.blnIsActive = 1
													and h_later.intRowStatus = 0
													and	h_later.datStartDate > h.datStartDate
												)
							))
				and h.intRowStatus = 0

	-- Matrix row
	inner join	dbo.tlbAggrProphylacticActionMTX mtx
	on			mtx.idfVersion = h.idfVersion
				and mtx.intRowStatus = 0
				
	INNER JOIN @SpeciesTable st
	ON st.[key] = mtx.idfsSpeciesType

	INNER JOIN @DiagnosisTable dt
	ON dt.[key] = mtx.idfsDiagnosis

	INNER JOIN @MeasuresTable mt
	ON mt.[key] = mtx.idfsProphilacticAction
  ) fy    

--column "Number of animals planned for vaccination in this year"
		
left join	dbo.tlbActivityParameters agp_NAFV
on			agp_NAFV.idfObservation = fy.idfProphylacticObservation
			and agp_NAFV.idfsParameter = @PNumberPlanned
			and agp_NAFV.idfRow = fy.idfAggrProphylacticActionMTX
			and agp_NAFV.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_NAFV.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
						
where	fy.RN = 1
group by    fy.idfsRegion,   fy.idfsDiagnosis,   fy.idfsSpeciesType,   fy.idfsProphilacticAction
	

----------------------------------------------------------------------------------------------------
--- fill result report
----------------------------------------------------------------------------------------------------	
-- existing data ----------------------------------------------------------------------------------
INSERT INTO	@ReportTable
(	idfsBaseReference,
	strRegionName, --1
	strRayonName, --1
	strDiagnosisName, --2
	strMeasureType, --3
	strSpecies, --4

    intNumOfAnimForVact, --5
    intNumOfVactAnimRep, --6
    intNumOfVactAnimYear, --7
    intPlanExec, --8
	intOrder
)


SELECT
	0, 
    ref_region.[name],
    null,
    ref_Diagnosis.[name],
    ref_ProphilacticAction.[name],
    ref_Species.[name],
    mx2.intNumOfAnimForVact,
    mx3.intNumOfVactAnimRep,
    mx1.intNumOfVactAnimYear,
    CASE 
        WHEN ISNULL(mx2.intNumOfAnimForVact, 0) <> 0 
        THEN (cast(mx1.intNumOfVactAnimYear as float) / cast(mx2.intNumOfAnimForVact as float)) * 100.00
        ELSE NULL 
    END AS intPlanExec,
	0
FROM 	
-- heder part of the table: all existing variants
 (
    SELECT DISTINCT idfsRegion, idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable
    UNION
    SELECT DISTINCT idfsRegion, idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable_Year
    UNION
    SELECT DISTINCT idfsRegion, idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable_FirstInYear
 ) All_rows
 
-- translation 
LEFT OUTER JOIN fnGisReference (@LangID, 19000003) ref_region
ON ref_region.idfsReference = All_rows.idfsRegion

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000019) ref_Diagnosis
ON ref_Diagnosis.idfsReference = All_rows.idfsDiagnosis

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000086) ref_Species
ON ref_Species.idfsReference = All_rows.idfsSpeciesType

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000074) ref_ProphilacticAction
ON ref_ProphilacticAction.idfsReference = All_rows.idfsProphilacticAction


-- data
LEFT OUTER JOIN @VetProphylacticMeasureMatrixValuesTable_Year mx1
ON 
    All_rows.idfsRegion = mx1.idfsRegion AND 
    All_rows.idfsDiagnosis = mx1.idfsDiagnosis AND
    All_rows.idfsSpeciesType = mx1.idfsSpeciesType AND
    All_rows.idfsProphilacticAction = mx1.idfsProphilacticAction 
    
LEFT OUTER JOIN @VetProphylacticMeasureMatrixValuesTable_FirstInYear mx2
ON 
    All_rows.idfsRegion = mx2.idfsRegion AND 
    All_rows.idfsDiagnosis = mx2.idfsDiagnosis AND
    All_rows.idfsSpeciesType = mx2.idfsSpeciesType AND
    All_rows.idfsProphilacticAction = mx2.idfsProphilacticAction 
    
LEFT OUTER JOIN @VetProphylacticMeasureMatrixValuesTable mx3
ON 
    All_rows.idfsRegion = mx3.idfsRegion AND 
    All_rows.idfsDiagnosis = mx3.idfsDiagnosis AND 
    All_rows.idfsSpeciesType = mx3.idfsSpeciesType AND 
    All_rows.idfsProphilacticAction = mx3.idfsProphilacticAction    


-- add rows for all regions that has NO data of KZ -------------------------------------------------
INSERT INTO	@ReportTable
(	idfsBaseReference,
	strRegionName, --1
	strRayonName, --1
	strDiagnosisName, --2
	strMeasureType, --3
	strSpecies, --4

    intNumOfAnimForVact, --5
    intNumOfVactAnimRep, --6
    intNumOfVactAnimYear, --7
    intPlanExec, --8
	intOrder
)
SELECT
	0, 
    ref_region.[name],
    null,
    ref_Diagnosis.[name],
    ref_ProphilacticAction.[name],
    ref_Species.[name],
    null,
    null,
    null,
    null,
	0
FROM 	
--- all used types	
 (
    SELECT DISTINCT idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable
    UNION
    SELECT DISTINCT idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable_Year
    UNION
    SELECT DISTINCT idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable_FirstInYear
 ) All_ref

-- all rayons from the region 
inner join	gisRegion r
on			r.idfsCountry = 1240000000 --Kazakhstan

-- translation
inner join	fnGisReference (@LangID, 19000003) ref_region
on			ref_region.idfsReference = r.idfsRegion
LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000019) ref_Diagnosis
ON ref_Diagnosis.idfsReference = All_ref.idfsDiagnosis
LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000086) ref_Species
ON ref_Species.idfsReference = All_ref.idfsSpeciesType
LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000074) ref_ProphilacticAction
ON ref_ProphilacticAction.idfsReference = All_ref.idfsProphilacticAction
-- connect to header part of the report
-- for check only
left join	 (
    SELECT DISTINCT idfsRegion,  idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable
    UNION
    SELECT DISTINCT idfsRegion,  idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable_Year
    UNION
    SELECT DISTINCT idfsRegion, idfsDiagnosis, idfsSpeciesType, idfsProphilacticAction FROM @VetProphylacticMeasureMatrixValuesTable_FirstInYear
 ) All_rows
on			All_rows.idfsDiagnosis = All_ref.idfsDiagnosis
			and All_rows.idfsSpeciesType = All_ref.idfsSpeciesType
			and All_rows.idfsProphilacticAction = All_ref.idfsProphilacticAction
			and All_rows.idfsRegion = r.idfsRegion
where		All_rows.idfsProphilacticAction is null


-- intOrder =ROW_NUMBER() OVER(ORDER BY strRegionName,strRayonName,strDiagnosisName,strMeasureType,strSpecies)
update		rt
set			rt.intOrder = (
				select		count(*)
				from		@ReportTable rt_min
				where		rt_min.strRegionName < rt.strRegionName
							or	(	rt_min.strRegionName = rt.strRegionName
									and rt_min.strRayonName < rt.strRayonName
								)
							or	(	rt_min.strRegionName = rt.strRegionName
									and rt_min.strRayonName = rt.strRayonName
									and rt_min.strDiagnosisName < rt.strDiagnosisName
								)
							or	(	rt_min.strRegionName = rt.strRegionName
									and rt_min.strRayonName = rt.strRayonName
									and rt_min.strDiagnosisName = rt.strDiagnosisName
									and rt_min.strMeasureType < rt.strMeasureType
								)
							or	(	rt_min.strRegionName = rt.strRegionName
									and rt_min.strRayonName = rt.strRayonName
									and rt_min.strDiagnosisName = rt.strDiagnosisName
									and rt_min.strMeasureType = rt.strMeasureType
									and rt_min.strSpecies <= rt.strSpecies
								)
									)
from		@ReportTable rt

--- ????????
update		rt
set			rt.idfsBaseReference = rt.intOrder
from		@ReportTable rt

SELECT * 
FROM @ReportTable
ORDER BY intOrder

end

