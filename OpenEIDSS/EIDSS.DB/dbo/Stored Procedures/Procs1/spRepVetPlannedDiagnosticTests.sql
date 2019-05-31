

--##SUMMARY Select data for KZ Oblast  Report “Planned diagnostic  tests” V4.
--##REMARKS Author: Grigoreva Elena
--##REMARKS Create date: 20.01.2011 
--##REMARKS Updated by: Anastasia Zhdanova
--##REMARKS Modification date: 04.06.2012

--##REMARKS Updated 29.05.2013 by Romasheva S.

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec spRepVetPlannedDiagnosticTests 
'en', 
'2011-01-01', 
'2011-02-01',  
N'<ItemList><Item key="6618180000000" value="Bovine tuberculosis"/></ItemList>', 
N'<ItemList><Item key="6619290000000" value="Allergic reaction"/><Item key="952120000000" value="Serology"/></ItemList>', 
N'<ItemList><Item key="837780000000" value="Birds"/><Item key="837840000000" value="Cattle"/></ItemList>',
41180000000
  
*/

create  PROCEDURE [dbo].[spRepVetPlannedDiagnosticTests]
	(
		@LangID				AS NVARCHAR(10), 
		@StartDate			AS DATETIME,	 
		@FinishDate			AS DATETIME,
		@Diagnosis			AS XML,
        @InvestigationType	AS XML,
        @Species			AS XML,
		@Region				AS BIGINT = NULL
	)
AS	

exec dbo.spSetFirstDay

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/KZ/Reports/Specification_for_reports_development_Oblast_Diagnostic-investigation-KZ-V4.docx"
-- by number marked red at screen form prototype 

-- find parameter IDs
declare @PDiagnosis bigint
select @PDiagnosis = idfsFFObject from trtFFObjectForCustomReport where idfsCustomReportType = 10290005 and strFFObjectAlias = 'Diagnosis'

declare @PInvestigationType bigint
select @PInvestigationType = idfsFFObject from trtFFObjectForCustomReport where idfsCustomReportType = 10290005 and strFFObjectAlias = 'Investigation type'

declare @PSpecies bigint
select @PSpecies = idfsFFObject from trtFFObjectForCustomReport where idfsCustomReportType = 10290005 and strFFObjectAlias = 'Species'

declare @PPlaned bigint
select @PPlaned = idfsFFObject from trtFFObjectForCustomReport where idfsCustomReportType = 10290005 and strFFObjectAlias = 'Number of animals planned'

declare @PPositive bigint
select @PPositive = idfsFFObject from trtFFObjectForCustomReport where idfsCustomReportType = 10290005 and strFFObjectAlias = 'Number of animals positive'

declare @PTested bigint
select @PTested = idfsFFObject from trtFFObjectForCustomReport where idfsCustomReportType = 10290005 and strFFObjectAlias = 'Number of tested animals'


DECLARE	@ReportTable	TABLE
(	idfsBaseReference		BIGINT NOT NULL,
	strRegionName			NVARCHAR(200) COLLATE database_default NULL, --1
    strRayonName			NVARCHAR(200) COLLATE database_default NULL, --1
	strDiagnosisName		NVARCHAR(300) COLLATE database_default NULL, --2
	strInvestigationType	NVARCHAR(200) COLLATE database_default NULL, --3
	strSpecies				NVARCHAR(200) COLLATE database_default NULL, --4

    intTestedTotalWeek		INT NULL, --7
    intPosReactTotalWeek	INT NULL, --8
    intPlannedToTest		INT NULL, --9
    intTestedTotalYear		INT NULL, --10
    intNumOfExecPer			INT NULL, --11
    intPosReactTotalYear	INT NULL, --12
    intInfectedPer			INT NULL, --13
    
	intOrder				INT NOT NULL
)

---------------
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

DECLARE @iMeasures	INT
DECLARE @MeasuresTable	TABLE
(
	 [key]	NVARCHAR(300)
	,[value]	NVARCHAR(300)
)

EXEC sp_xml_preparedocument @iMeasures OUTPUT, @InvestigationType

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
    10102003  Vet Aggregate Action

*/

IF @FinishDate is not null SET @FinishDate = dateadd(day, 1, @FinishDate)
SET @AggrCaseType = 10102003 /*Vet Aggregate Action*/

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
FROM fnAggregateSettings (@AggrCaseType)--@AggrCaseType


-- ������� �� �������� ������
declare	@VetInvestigationTypeMatrix	table
(	idfAggrCase	BIGINT not null primary KEY,
  datStartDate DATETIME,
  idfDiagnosticVersion BIGINT,
  idfDiagnosticObservation BIGINT,
  idfsRegion BIGINT,
  idfsRayon BIGINT
)


insert into	@VetInvestigationTypeMatrix  
(	idfAggrCase,
  datStartDate,
  idfDiagnosticVersion,
  idfDiagnosticObservation,
  idfsRegion,
  idfsRayon
)
select		a.idfAggrCase,
          a.datStartDate,
          a.idfDiagnosticVersion,
          a.idfDiagnosticObservation,
          @Region,
          ISNULL(rr.idfsRayon, s.idfsRayon)
from		tlbAggrCase a
    left join	gisCountry c
    on			c.idfsCountry = a.idfsAdministrativeUnit
			    and c.idfsCountry = 1240000000
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
			a.idfsAggrCaseType = @AggrCaseType
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @FinishDate
				)
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
				)    and		
        (	(	@MinAdminLevel = 10089001 --'satCountry' 
			    and a.idfsAdministrativeUnit = c.idfsCountry
		      )
		    or	(	@MinAdminLevel = 10089003 --'satRegion' 
				    and a.idfsAdministrativeUnit = r.idfsRegion
				    AND (r.idfsRegion = @Region)
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    AND (rr.idfsRegion = @Region)
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    AND (s.idfsRegion = @Region)

			    )
	      )

DECLARE	@VetInvestigationTypeMatrixValuesTable	TABLE
(	idfsRegion	BIGINT,
	idfsRayon	BIGINT,
	idfsDiagnosis	BIGINT,
	idfsSpeciesType	BIGINT,
	idfsDiagnosticAction	BIGINT,
	intTestedTotalWeek INT, --7
	intPosReactTotalWeek INT --8
 )


insert into	@VetInvestigationTypeMatrixValuesTable
(	idfsRegion,
	idfsRayon,
	idfsDiagnosis,
	idfsSpeciesType,
	idfsDiagnosticAction,
	intTestedTotalWeek,
	intPosReactTotalWeek
)
select		
		fhac.idfsRegion,
		fhac.idfsRayon,
		mtx.idfsDiagnosis,
		mtx.idfsSpeciesType,
		mtx.idfsDiagnosticAction,
		sum(IsNull(CAST(agp_TTW.varValue AS INT), 0)), 
		sum(IsNull(CAST(agp_PRT.varValue AS INT), 0)) 


from		@VetInvestigationTypeMatrix fhac
-- Updated for version 6
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71460000000	-- Diagnostic investigations
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfDiagnosticVersion 
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfDiagnosticVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71460000000	-- Diagnostic investigations
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	dbo.tlbAggrDiagnosticActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
			
INNER JOIN @SpeciesTable st
ON st.[key] = mtx.idfsSpeciesType

INNER JOIN @DiagnosisTable dt
ON dt.[key] = mtx.idfsDiagnosis

INNER JOIN @MeasuresTable mt
ON mt.[key] = mtx.idfsDiagnosticAction


left join	dbo.tlbActivityParameters agp_TTW
on			agp_TTW.idfObservation = fhac.idfDiagnosticObservation 
			and agp_TTW.idfsParameter = @PTested
			and agp_TTW.idfRow = mtx.idfAggrDiagnosticActionMTX
			and agp_TTW.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_TTW.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
	

left join	dbo.tlbActivityParameters agp_PRT
on			agp_PRT.idfObservation = fhac.idfDiagnosticObservation 
			and agp_PRT.idfsParameter = @PPositive
			and agp_PRT.idfRow = mtx.idfAggrDiagnosticActionMTX
			and agp_PRT.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_PRT.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			

GROUP BY    
    fhac.idfsRegion, 
    fhac.idfsRayon,
    idfsDiagnosis,
    idfsSpeciesType,
    idfsDiagnosticAction


---------------------------------------------------------------------------------------
SET @StartDate = CAST(CAST(YEAR(@StartDate)	 AS VARCHAR(4)) + '0101' AS DATETIME)


declare	@VetInvestigationTypeMatrix_Year	table
(	idfAggrCase	BIGINT not null primary KEY,
  datStartDate DATETIME,
  idfDiagnosticVersion BIGINT,
  idfDiagnosticObservation BIGINT,
  idfsRegion BIGINT,
  idfsRayon BIGINT
)


insert into	@VetInvestigationTypeMatrix_Year  
(	idfAggrCase,
	datStartDate,
	idfDiagnosticVersion,
	idfDiagnosticObservation,
	idfsRegion,
	idfsRayon
)
select		a.idfAggrCase,
          a.datStartDate,
          a.idfDiagnosticVersion,
          a.idfDiagnosticObservation,
          @Region,
          ISNULL(rr.idfsRayon, s.idfsRayon)
from		tlbAggrCase a
    left join	gisCountry c
    on			c.idfsCountry = a.idfsAdministrativeUnit
			    and c.idfsCountry = 1240000000
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
			a.idfsAggrCaseType = @AggrCaseType
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @FinishDate
				)
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
				)    and		
        (	(	@MinAdminLevel = 10089001 --'satCountry' 
			    and a.idfsAdministrativeUnit = c.idfsCountry
		      )
		    or	(	@MinAdminLevel = 10089003 --'satRegion' 
				    and a.idfsAdministrativeUnit = r.idfsRegion
				    AND (r.idfsRegion = @Region)
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    AND (rr.idfsRegion = @Region)
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    AND (s.idfsRegion = @Region)

			    )
	      )


DECLARE	@VetInvestigationTypeMatrixValuesTable_Year	TABLE
(	idfsRegion				BIGINT,
	idfsRayon				BIGINT,
	idfsDiagnosis			BIGINT,
	idfsSpeciesType			BIGINT,
	idfsDiagnosticAction	BIGINT,
	intTestedTotalYear		INT,
	intPosReactTotalYear	INT
     
)



insert into	@VetInvestigationTypeMatrixValuesTable_Year
(	idfsRegion,
	idfsRayon,
	idfsDiagnosis,
	idfsSpeciesType,
	idfsDiagnosticAction,
	intTestedTotalYear,
	intPosReactTotalYear
)
select		
		fhac.idfsRegion,
		fhac.idfsRayon,
		mtx.idfsDiagnosis,
		mtx.idfsSpeciesType,
		mtx.idfsDiagnosticAction,
		sum(IsNull(CAST(agp_TTW.varValue AS INT), 0)), 
		sum(IsNull(CAST(agp_PRT.varValue AS INT), 0)) 


from		@VetInvestigationTypeMatrix_Year fhac
-- Updated for version 6

-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71460000000	-- Diagnostic investigations
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfDiagnosticVersion 
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfDiagnosticVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71460000000	-- Diagnostic investigations
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	dbo.tlbAggrDiagnosticActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
			
INNER JOIN @SpeciesTable st
ON st.[key] = mtx.idfsSpeciesType

INNER JOIN @DiagnosisTable dt
ON dt.[key] = mtx.idfsDiagnosis

INNER JOIN @MeasuresTable mt
ON mt.[key] = mtx.idfsDiagnosticAction
    

--/* 10 column "Tested: total" */
left join	dbo.tlbActivityParameters agp_TTW
on			agp_TTW.idfObservation = fhac.idfDiagnosticObservation 
			and agp_TTW.idfsParameter = @PTested
			and agp_TTW.idfRow = mtx.idfAggrDiagnosticActionMTX
			and agp_TTW.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_TTW.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')

--/* 12 column "Positive reaction taken: total" */
left join	dbo.tlbActivityParameters agp_PRT
on			agp_PRT.idfObservation = fhac.idfDiagnosticObservation 
			and agp_PRT.idfsParameter = @PPositive
			and agp_PRT.idfRow = mtx.idfAggrDiagnosticActionMTX
			and agp_PRT.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_PRT.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			
GROUP BY    
    fhac.idfsRegion, 
    fhac.idfsRayon,
    idfsDiagnosis,
    idfsSpeciesType,
    idfsDiagnosticAction


------------------------------------------------------------

DECLARE	@VetInvestigationTypeMatrixValuesTable_FirstInYear	TABLE
(	idfsRegion				BIGINT,
	idfsRayon				BIGINT,
	idfsDiagnosis			BIGINT,
	idfsSpeciesType			BIGINT,
	idfsDiagnosticAction	BIGINT,
	intPlannedToTest		INT 
)

insert into	@VetInvestigationTypeMatrixValuesTable_FirstInYear
(	idfsRegion,
  idfsRayon,
  idfsDiagnosis,
  idfsSpeciesType,
  idfsDiagnosticAction,
  intPlannedToTest
)
select		
		fy.idfsRegion,
		fy.idfsRayon,
		fy.idfsDiagnosis,
		fy.idfsSpeciesType,
		fy.idfsDiagnosticAction,
		IsNull(CAST(agp_NAPT.varValue AS INT), 0)


from	
(SELECT 
   fhac.idfsRegion,
   fhac.idfsRayon,
   mtx.idfsDiagnosis,
   mtx.idfsSpeciesType,
   mtx.idfsDiagnosticAction,
   --vD.idfRow,
   mtx.idfAggrDiagnosticActionMTX,
   fhac.idfDiagnosticObservation,
   row_number() over(partition by  fhac.idfsRegion,
                                   fhac.idfsRayon,
                                   mtx.idfsDiagnosis,
                                   mtx.idfsSpeciesType,
                                   mtx.idfsDiagnosticAction
                       order by fhac.datStartDate) AS RN
	FROM @VetInvestigationTypeMatrix_Year fhac
 	-- Updated for version 6
	-- Matrix version
	inner join	tlbAggrMatrixVersionHeader h
	on			h.idfsMatrixType = 71460000000	-- Diagnostic investigations
				and (	-- Get matrix version selected by the user in aggregate case
						h.idfVersion = fhac.idfDiagnosticVersion 
						-- If matrix version is not selected by the user in aggregate case, 
						-- then select active matrix with the latest date activation that is earlier than aggregate case start date
						or (	fhac.idfDiagnosticVersion is null 
								and	h.datStartDate <= fhac.datStartDate
								and	h.blnIsActive = 1
								and not exists	(
											select	*
											from	tlbAggrMatrixVersionHeader h_later
											where	h_later.idfsMatrixType = 71460000000	-- Diagnostic investigations
													and	h_later.datStartDate <= fhac.datStartDate
													and	h_later.blnIsActive = 1
													and h_later.intRowStatus = 0
													and	h_later.datStartDate > h.datStartDate
												)
							))
				and h.intRowStatus = 0

	-- Matrix row
	inner join	dbo.tlbAggrDiagnosticActionMTX mtx
	on			mtx.idfVersion = h.idfVersion
				and mtx.intRowStatus = 0
				
	INNER JOIN @SpeciesTable st
	ON st.[key] = mtx.idfsSpeciesType

	INNER JOIN @DiagnosisTable dt
	ON dt.[key] = mtx.idfsDiagnosis

	INNER JOIN @MeasuresTable mt
	ON mt.[key] = mtx.idfsDiagnosticAction    
  ) fy    

			
left join	dbo.tlbActivityParameters agp_NAPT
on			agp_NAPT.idfObservation = fy.idfDiagnosticObservation 
			and agp_NAPT.idfsParameter = @PPlaned -- Number of animals planned to test in this year
			and agp_NAPT.idfRow = fy.idfAggrDiagnosticActionMTX
			and agp_NAPT.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_NAPT.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')			
			
where	fy.RN = 1
	
	
insert into	@ReportTable
(	idfsBaseReference,
	strRegionName,
    strRayonName,
	strDiagnosisName,
	strInvestigationType,
	strSpecies,
    intTestedTotalWeek,
    intPosReactTotalWeek,
    intPlannedToTest,
    intTestedTotalYear,
    intNumOfExecPer,
    intPosReactTotalYear,
    intInfectedPer,
	intOrder
)


SELECT
	0, 
    ref_region.[name],
    ref_rayon.[name],
    ref_Diagnosis.[name],
    ref_DiagnosticAction.[name],
    ref_Species.[name],
	mx3.intTestedTotalWeek,
	mx3.intPosReactTotalWeek,
    mx2.intPlannedToTest,
	mx1.intTestedTotalYear,
    CASE 
        WHEN ISNULL(mx2.intPlannedToTest, 0) <> 0 
        THEN (cast(mx1.intTestedTotalYear as float) / cast(mx2.intPlannedToTest as float)) * 100.00
        ELSE NULL 
    END,
	mx1.intPosReactTotalYear,
    CASE 
        WHEN ISNULL(mx2.intPlannedToTest, 0) <> 0 
        THEN (cast(mx1.intPosReactTotalYear as float) / cast(mx2.intPlannedToTest as float)) * 100.00
        ELSE NULL 
    END,
	0
FROM 	
 (
    SELECT DISTINCT idfsRegion, idfsRayon, idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable
    UNION
    SELECT DISTINCT idfsRegion, idfsRayon, idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable_Year
    UNION
    SELECT DISTINCT idfsRegion, idfsRayon, idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable_FirstInYear
 ) All_rows
 
LEFT OUTER JOIN fnGisReference (@LangID, 19000003) ref_region
ON ref_region.idfsReference = All_rows.idfsRegion

LEFT OUTER JOIN fnGisReference (@LangID, 19000002) ref_rayon
ON ref_rayon.idfsReference = All_rows.idfsRayon

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000019) ref_Diagnosis
ON ref_Diagnosis.idfsReference = All_rows.idfsDiagnosis

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000086) ref_Species
ON ref_Species.idfsReference = All_rows.idfsSpeciesType

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000021) ref_DiagnosticAction
ON ref_DiagnosticAction.idfsReference = All_rows.idfsDiagnosticAction


LEFT OUTER JOIN @VetInvestigationTypeMatrixValuesTable_Year mx1
ON 
    All_rows.idfsRegion = mx1.idfsRegion AND 
    All_rows.idfsRayon = mx1.idfsRayon AND
    All_rows.idfsDiagnosis = mx1.idfsDiagnosis AND
    All_rows.idfsSpeciesType = mx1.idfsSpeciesType AND
    All_rows.idfsDiagnosticAction = mx1.idfsDiagnosticAction 
    
LEFT OUTER JOIN @VetInvestigationTypeMatrixValuesTable_FirstInYear mx2
ON 
    All_rows.idfsRegion = mx2.idfsRegion AND 
    All_rows.idfsRayon = mx2.idfsRayon AND
    All_rows.idfsDiagnosis = mx2.idfsDiagnosis AND
    All_rows.idfsSpeciesType = mx2.idfsSpeciesType AND
    All_rows.idfsDiagnosticAction = mx2.idfsDiagnosticAction 
    
LEFT OUTER JOIN @VetInvestigationTypeMatrixValuesTable mx3
ON 
    All_rows.idfsRegion = mx3.idfsRegion AND 
    All_rows.idfsRayon = mx3.idfsRayon AND 
    All_rows.idfsDiagnosis = mx3.idfsDiagnosis AND 
    All_rows.idfsSpeciesType = mx3.idfsSpeciesType AND 
    All_rows.idfsDiagnosticAction = mx3.idfsDiagnosticAction    



insert into	@ReportTable
(	idfsBaseReference,
	strRegionName,
    strRayonName,
	strDiagnosisName,
	strInvestigationType,
	strSpecies,
    intTestedTotalWeek,
    intPosReactTotalWeek,
    intPlannedToTest,
    intTestedTotalYear,
    intNumOfExecPer,
    intPosReactTotalYear,
    intInfectedPer,
	intOrder
)
select		
	0, 
    ref_region.[name],
    ref_rayon.[name],
    ref_Diagnosis.[name],
    ref_DiagnosticAction.[name],
    ref_Species.[name],
	null,
	null,
	null,
	null,
	null,
	null,
	null,
	0
from		(
    SELECT DISTINCT idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable
    UNION
    SELECT DISTINCT idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable_Year
    UNION
    SELECT DISTINCT idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable_FirstInYear
			) All_Ref
inner join	gisRayon r
on			r.idfsRegion = @Region

inner join	fnGisReference (@LangID, 19000003) ref_region
on			ref_region.idfsReference = r.idfsRegion
inner join	fnGisReference (@LangID, 19000002) ref_rayon
on			ref_rayon.idfsReference = r.idfsRayon

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000019) ref_Diagnosis
ON ref_Diagnosis.idfsReference = All_Ref.idfsDiagnosis

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000086) ref_Species
ON ref_Species.idfsReference = All_Ref.idfsSpeciesType

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000021) ref_DiagnosticAction
ON ref_DiagnosticAction.idfsReference = All_Ref.idfsDiagnosticAction

left join	(
    SELECT DISTINCT idfsRegion, idfsRayon, idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable
    UNION
    SELECT DISTINCT idfsRegion, idfsRayon, idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable_Year
    UNION
    SELECT DISTINCT idfsRegion, idfsRayon, idfsDiagnosis, idfsSpeciesType, idfsDiagnosticAction FROM @VetInvestigationTypeMatrixValuesTable_FirstInYear
			) All_rows
on			All_rows.idfsDiagnosis = All_Ref.idfsDiagnosis
			and All_rows.idfsSpeciesType = All_Ref.idfsSpeciesType
			and All_rows.idfsDiagnosticAction = All_Ref.idfsDiagnosticAction
			and All_rows.idfsRegion = r.idfsRegion
			and All_rows.idfsRayon = r.idfsRayon

where		All_rows.idfsDiagnosticAction is null


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
									and rt_min.strInvestigationType < rt.strInvestigationType
								)
							or	(	rt_min.strRegionName = rt.strRegionName
									and rt_min.strRayonName = rt.strRayonName
									and rt_min.strDiagnosisName = rt.strDiagnosisName
									and rt_min.strInvestigationType = rt.strInvestigationType
									and rt_min.strSpecies <= rt.strSpecies
								)
									)
from		@ReportTable rt

update		rt
set			rt.idfsBaseReference = rt.intOrder
from		@ReportTable rt

SELECT * 
FROM @ReportTable
ORDER BY intOrder












