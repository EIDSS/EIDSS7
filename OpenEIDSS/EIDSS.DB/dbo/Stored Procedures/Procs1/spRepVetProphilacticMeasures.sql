

--##SUMMARY Select data for Oblast Report “Veterinary- sanitary measures” - V4.
--##REMARKS Author: Grigoreva Elena
--##REMARKS Create date: 19.01.2011  
--##REMARKS Updated by: Anastasia Zhdanova
--##REMARKS Modification date: 04.06.2012

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec spRepVetProphilacticMeasures 
'en', 
'2011-02-01', 
'2011-03-01', 
'<ItemList><Item key="952220000000" value="Deratization"/><Item key="952230000000" value="Disinsection"/><Item key="952250000000" value="Prophylactic Disinfection"/></ItemList>', 
41180000000
  
*/

--List of critical IDs
--	10102003 --Vet Aggregate Action
--	1240000000 --Kazakhstan
--	10089002	--satRayon	Rayon
--	10091004	--sptWeek	Week
--	71260000000	--Veterinary-sanitary measures

create  PROCEDURE [dbo].[spRepVetProphilacticMeasures]
	(
		@LangID		AS NVARCHAR(10), 
		@StartDate	AS DATETIME,	 
		@FinishDate	AS DATETIME,
		@Measures	AS XML,
        @Region AS BIGINT
	)
AS	

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/KZ/Reports/Specification_for_reports_development_Oblast_prophilactic-measure-KZ-V4.docx"

exec dbo.spSetFirstDay

-- result table
DECLARE	@ReportTable	TABLE
(	idfsBaseReference	BIGINT NOT NULL,
	strRegionName		NVARCHAR(200) COLLATE database_default NULL, --1
    strRayonName		NVARCHAR(200) COLLATE database_default NULL, --1
	
	strMeasureType		NVARCHAR(200) COLLATE database_default NULL, --2
	
    intNumOfObjForRep INT NULL, --3
    intThousSquareForRep INT NULL, --4
    intNumOfObjYear INT NULL, --5
    intThousSquareYear INT NULL, --6

	intOrder			INT NOT NULL
)

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
-- 10290003 = 'Oblast Report “Veterinary- sanitary measures”'
-- Sanytary action measure Type   
declare @PMeasureType bigint
select @PMeasureType = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290003 and strFFObjectAlias = 'Measure Type'
-- column "Number of objects"
declare @PNumberOfObjects bigint
select @PNumberOfObjects = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290003 and strFFObjectAlias = 'Number of objects'
-- column "Thousands square m."
declare @PThousandsSquareM bigint
select @PThousandsSquareM = idfsFFObject
from trtFFObjectForCustomReport
where idfsCustomReportType = 10290003 and strFFObjectAlias = 'Thousands square m.'

----------------------------------------------------------------------------------------------------
--- select data for the fixed period
----------------------------------------------------------------------------------------------------
-- List of actual AggCases
declare	@VetSanitaryActionMatrix	table
(	
	idfAggrCase	BIGINT not null primary KEY,
	datStartDate DATETIME,
	idfSanitaryVersion BIGINT,
	idfSanitaryObservation BIGINT,
	idfsRegion BIGINT,
	idfsRayon BIGINT
)


insert into	@VetSanitaryActionMatrix  
(	
	idfAggrCase,
	datStartDate,
	idfSanitaryVersion,
	idfSanitaryObservation,
	idfsRegion,
	idfsRayon
)
select	
		a.idfAggrCase,
		a.datStartDate,
		a.idfSanitaryVersion,
		a.idfSanitaryObservation,
		@Region, --All cases filtered by @Region
		ISNULL(rr.idfsRayon, s.idfsRayon)
from		tlbAggrCase a
	-- datail information about aministrativ unit
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit

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


--- data values from the list of actual AggCases
DECLARE	@VetSanitaryActionMatrixValuesTable	TABLE
(	
		idfsRegion	BIGINT,
		idfsRayon	BIGINT,
		idfsSanitaryAction	BIGINT,
		intNumOfObjectsRep INT,
		intNumOfSquareMeters INT 
 )

insert into	@VetSanitaryActionMatrixValuesTable
(
		idfsRegion,
		idfsRayon,
		idfsSanitaryAction,
		intNumOfObjectsRep,
		intNumOfSquareMeters
)
select		
	fhac.idfsRegion,
	fhac.idfsRayon,
	asa.idfsSanitaryAction,
	sum(IsNull(CAST(agp_NVA.varValue AS INT), 0)), 
	sum(IsNull(CAST(agp_SM.varValue AS INT), 0)) 

from		@VetSanitaryActionMatrix fhac -- list of AggCases
-- Updated for version 6
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71260000000	--Veterinary-sanitary measures
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfSanitaryVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfSanitaryVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71260000000	--Veterinary-sanitary measures
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	dbo.tlbAggrSanitaryActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
			
-- checked list of Measuer for current report
inner join dbo.trtSanitaryAction asa
    INNER JOIN @MeasuresTable mt
    ON mt.[key] = asa.idfsSanitaryAction
	inner join	trtBaseReference br_asa
	on			br_asa.idfsBaseReference = asa.idfsSanitaryAction
on	asa.idfsSanitaryAction = mtx.idfsSanitaryAction and
	asa.intRowStatus = 0 			
				   

---- column "Number of objects"
left join	dbo.tlbActivityParameters agp_NVA
on			agp_NVA.idfObservation = fhac.idfSanitaryObservation
			and agp_NVA.idfsParameter = @PNumberOfObjects
			and agp_NVA.idfRow = mtx.idfAggrSanitaryActionMTX
			and agp_NVA.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_NVA.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			
---- column "Thousands square m."
left join	dbo.tlbActivityParameters agp_SM
on			agp_SM.idfObservation = fhac.idfSanitaryObservation
			and agp_SM.idfsParameter = @PThousandsSquareM
			and agp_SM.idfRow = mtx.idfAggrSanitaryActionMTX
			and agp_SM.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_SM.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			
GROUP BY    
    fhac.idfsRegion, 
    fhac.idfsRayon,
    asa.idfsSanitaryAction

--SELECT * FROM @VetSanitaryActionMatrixValuesTable	


----------------------------------------------------------------------------------------------------
--- select data from the start of year
----------------------------------------------------------------------------------------------------
SET @StartDate = CAST(CAST(YEAR(@StartDate)	 AS VARCHAR(4)) + '0101' AS DATETIME)


-- List of actual AggCases for year
declare	@VetSanitaryActionMatrix_Year	table
(	
	idfAggrCase	BIGINT not null primary KEY,
	datStartDate DATETIME,
	idfSanitaryVersion BIGINT,
	idfSanitaryObservation BIGINT,
	idfsRegion BIGINT,
	idfsRayon BIGINT
)


insert into	@VetSanitaryActionMatrix_Year  
(	
	idfAggrCase,
	datStartDate,
	idfSanitaryVersion,
	idfSanitaryObservation,
	idfsRegion,
	idfsRayon
)
select	
		a.idfAggrCase,
		a.datStartDate,
		a.idfSanitaryVersion,
		a.idfSanitaryObservation,
		@Region, --All cases filtered by @Region
		ISNULL(rr.idfsRayon, s.idfsRayon)
from		tlbAggrCase a
	-- datail information about aministrativ unit
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit

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


--- data values from the list of actual AggCases
DECLARE	@VetSanitaryActionMatrixValuesTable_Year	TABLE
(	
		idfsRegion	BIGINT,
		idfsRayon	BIGINT,
		idfsSanitaryAction	BIGINT,
		intNumOfObjectsRep INT,
		intNumOfSquareMeters INT --6
 )

insert into	@VetSanitaryActionMatrixValuesTable_Year
(
		idfsRegion,
		idfsRayon,
		idfsSanitaryAction,
		intNumOfObjectsRep,
		intNumOfSquareMeters
)
select		
	fhac.idfsRegion,
	fhac.idfsRayon,
	asa.idfsSanitaryAction,
	sum(IsNull(CAST(agp_NVA.varValue AS INT), 0)), 
	sum(IsNull(CAST(agp_SM.varValue AS INT), 0)) 

from		@VetSanitaryActionMatrix_Year fhac -- list of AggCases

-- Updated for version 6
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71260000000	--Veterinary-sanitary measures
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfSanitaryVersion
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfSanitaryVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71260000000	--Veterinary-sanitary measures
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	dbo.tlbAggrSanitaryActionMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
			
-- checked list of Measuer for current report
inner join dbo.trtSanitaryAction asa
    INNER JOIN @MeasuresTable mt
    ON mt.[key] = asa.idfsSanitaryAction
	inner join	trtBaseReference br_asa
	on			br_asa.idfsBaseReference = asa.idfsSanitaryAction
on	asa.idfsSanitaryAction = mtx.idfsSanitaryAction and
	asa.intRowStatus = 0 			
				   

---- column "Number of objects"
left join	dbo.tlbActivityParameters agp_NVA
on			agp_NVA.idfObservation = fhac.idfSanitaryObservation
			and agp_NVA.idfsParameter = @PNumberOfObjects
			and agp_NVA.idfRow = mtx.idfAggrSanitaryActionMTX
			and agp_NVA.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_NVA.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			
---- column "Thousands square m."

left join	dbo.tlbActivityParameters agp_SM
on			agp_SM.idfObservation = fhac.idfSanitaryObservation
			and agp_SM.idfsParameter = @PThousandsSquareM
			and agp_SM.idfRow = mtx.idfAggrSanitaryActionMTX
			and agp_SM.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_SM.varValue, 'BaseType') in ('smallint', 'int', 'bigint', 'numeric')
			

GROUP BY    
    fhac.idfsRegion, 
    fhac.idfsRayon,
    asa.idfsSanitaryAction

--SELECT * FROM @VetSanitaryActionMatrixValuesTable_Year	


----------------------------------------------------------------------------------------------------
--- fill result report
----------------------------------------------------------------------------------------------------

-- existing data ----------------------------------------------------------------------------------
INSERT INTO @ReportTable
(	idfsBaseReference
	,strRegionName
    ,strRayonName
	,strMeasureType
    ,intNumOfObjForRep
    ,intThousSquareForRep
    ,intNumOfObjYear
    ,intThousSquareYear
	,intOrder
)
SELECT
	0, 
    ref_region.[name],
    ref_rayon.[name],
    ref_SanitaryAction.[name],
    ISNULL(mx1.intNumOfObjectsRep,0),
    ISNULL(mx1.intNumOfSquareMeters,0),
    ISNULL(mx2.intNumOfObjectsRep,0),
    ISNULL(mx2.intNumOfSquareMeters,0),
	0
FROM 	
-- heder part of the table: all existing variants
 (
    SELECT DISTINCT idfsRegion, idfsRayon, idfsSanitaryAction FROM @VetSanitaryActionMatrixValuesTable
    UNION
    SELECT DISTINCT idfsRegion, idfsRayon, idfsSanitaryAction FROM @VetSanitaryActionMatrixValuesTable_Year
 ) All_rows
-- translation 
LEFT OUTER JOIN fnGisReference (@LangID, 19000003) ref_region
ON ref_region.idfsReference = All_rows.idfsRegion

LEFT OUTER JOIN fnGisReference (@LangID, 19000002) ref_rayon
ON ref_rayon.idfsReference = All_rows.idfsRayon

LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000079) ref_SanitaryAction
ON ref_SanitaryAction.idfsReference = All_rows.idfsSanitaryAction

-- data
LEFT OUTER JOIN @VetSanitaryActionMatrixValuesTable mx1
ON 
    All_rows.idfsRegion = mx1.idfsRegion AND 
    All_rows.idfsRayon = mx1.idfsRayon AND
    All_rows.idfsSanitaryAction = mx1.idfsSanitaryAction 
    
LEFT OUTER JOIN @VetSanitaryActionMatrixValuesTable_Year mx2
ON 
    All_rows.idfsRegion = mx2.idfsRegion AND 
    All_rows.idfsRayon = mx2.idfsRayon AND
    All_rows.idfsSanitaryAction = mx2.idfsSanitaryAction 


-- add rows for all rayons that has NO data of the @Region -------------------------------------------------
INSERT INTO @ReportTable
(	idfsBaseReference
	,strRegionName
    ,strRayonName
	,strMeasureType
    ,intNumOfObjForRep
    ,intThousSquareForRep
    ,intNumOfObjYear
    ,intThousSquareYear
	,intOrder
)
SELECT
	0, 
    ref_region.[name],
    ref_rayon.[name],
    ref_SanitaryAction.[name],
    null,
    null,
    null,
    null,
	0
FROM 
--- all used measuer types	
 (
    SELECT DISTINCT idfsSanitaryAction FROM @VetSanitaryActionMatrixValuesTable
    UNION
    SELECT DISTINCT idfsSanitaryAction FROM @VetSanitaryActionMatrixValuesTable_Year
 ) All_ref
 
-- all rayons from the region 
inner join	gisRayon r
on			r.idfsRegion = @Region

-- translation
inner join	fnGisReference (@LangID, 19000003) ref_region
on			ref_region.idfsReference = r.idfsRegion
inner join	fnGisReference (@LangID, 19000002) ref_rayon
on			ref_rayon.idfsReference = r.idfsRayon
LEFT OUTER JOIN fnReferenceRepair (@LangID, 19000079) ref_SanitaryAction
ON ref_SanitaryAction.idfsReference = All_ref.idfsSanitaryAction

-- connect to header part of the report
-- for check only
left join	 (
    SELECT DISTINCT idfsRegion, idfsRayon, idfsSanitaryAction FROM @VetSanitaryActionMatrixValuesTable
    UNION
    SELECT DISTINCT idfsRegion, idfsRayon, idfsSanitaryAction FROM @VetSanitaryActionMatrixValuesTable_Year
 ) All_rows
on			All_rows.idfsSanitaryAction = All_ref.idfsSanitaryAction
			and All_rows.idfsRegion = r.idfsRegion
			and All_rows.idfsRayon = r.idfsRayon

where		All_rows.idfsSanitaryAction is null


-- intOrder =ROW_NUMBER() OVER(ORDER BY strRegionName,strRayonName,strMeasureType)
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
									and rt_min.strMeasureType <= rt.strMeasureType
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
	



