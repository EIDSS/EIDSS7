

--##SUMMARY This procedure returns data for AJ -Border Rayons Comparative Report

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 25.09.2015

--##RETURNS Don't use 

 
create PROCEDURE [dbo].[spRepHumBorderRayonsComparativeReport_Calculations]
    @StartDate			datetime,
    @FinishDate			datetime,
    @RegionID			bigint,
    @RayonID			bigint
as
begin

exec dbo.spSetFirstDay

declare
	  
    @MinAdminLevel BIGINT,
    @MinTimeInterval BIGINT,
    @AggrCaseType BIGINT,

  	@idfsCustomReportType BIGINT,		
	@FFP_Total			bigint,
	
	@CountryID bigint
	
	set @CountryID = 170000000
	  
	set @idfsCustomReportType = 10290039 /*Border rayons� incidence comparative report*/

	select @FFP_Total = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Total'
	and intRowStatus = 0

	
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



SET @AggrCaseType = 10102001

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
FROM fnAggregateSettings (@AggrCaseType)--@AggrCaseType


declare	@ReportHumanAggregateCase	table
(	idfAggrCase				BIGINT not null primary KEY,
	idfCaseObservation		BIGINT,
	datStartDate			datetime,
	idfVersion				bigint
)


insert into	@ReportHumanAggregateCase
( idfAggrCase,
  idfCaseObservation,
  datStartDate,
  idfVersion
)
select		a.idfAggrCase,
			a.idfCaseObservation,
			a.datStartDate,
			a.idfVersion
from		tlbAggrCase a
    left join	gisCountry c
    on			c.idfsCountry = a.idfsAdministrativeUnit
			    and c.idfsCountry = @CountryID
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
			    and r.idfsCountry = @CountryID
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = @CountryID
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = @CountryID
	left join tstCustomizationPackage tcpac on
		tcpac.idfsCountry = @CountryID
	left join tstSite ts
	on			ts.idfsSite = a.idfsAdministrativeUnit
				and ts.idfCustomizationPackage = tcpac.idfCustomizationPackage
				and ts.intFlags = 1				    

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
				)    		
			and (	
        			(	@MinAdminLevel = 10089001 --'satCountry' 
						and a.idfsAdministrativeUnit = c.idfsCountry
						
					 )
				or	(	@MinAdminLevel = 10089003 --'satRegion' 
						and a.idfsAdministrativeUnit = r.idfsRegion
						AND (r.idfsRegion = @RegionID OR @RegionID IS NULL)

					)
				or	(	@MinAdminLevel = 10089002 --'satRayon' 
						and a.idfsAdministrativeUnit = rr.idfsRayon
						AND (rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
						AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)

					)
				or	(	@MinAdminLevel = 10089004 --'satSettlement' 
						and a.idfsAdministrativeUnit = s.idfsSettlement
						AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
						AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)

					)

			 )
and a.intRowStatus = 0




DECLARE	@ReportAggregateValuesTable	TABLE
(	idfAggrCase			bigint not null,
	idfsRayon			bigint not null,
	idfsDiagnosis		bigint not null,
	intTotal			int not null,
	primary key (idfAggrCase, idfsRayon, idfsDiagnosis)
)



insert into	@ReportAggregateValuesTable
(	idfAggrCase,
	idfsRayon,
	idfsDiagnosis,
	intTotal
)
select		
		fhac.idfAggrCase,
		@RayonID,
		isnull(rt.idfsDiagnosis, 0),
		sum(isnull(CAST(agp_Total.varValue AS int), 0)) as intTotal

from		@ReportHumanAggregateCase fhac
-- Updated for version 6
			
-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71190000000	-- Human Aggregate Case
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfVersion 
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71190000000	-- Human Aggregate Case
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
						)
						))
			and h.intRowStatus = 0
			
-- Matrix row
inner join	tlbAggrHumanCaseMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
				
inner join #ReportTable rt
on 	(rt.idfsDiagnosis = mtx.idfsDiagnosis or rt.idfsDiagnosis is null)
	and rt.idfsRayon = @RayonID
	        
--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


group by fhac.idfAggrCase, isnull(rt.idfsDiagnosis, 0)





declare	@ReportCaseTable	table
(	idfCase			bigint not null primary key,
	idfsRayon		bigint not null,
	idfsDiagnosis	bigint not null
)


insert into	@ReportCaseTable
(	idfCase,
	idfsRayon,
	idfsDiagnosis
)
select distinct
	hc.idfHumanCase AS idfCase,
	@RayonID,
	isnull(rt.idfsDiagnosis, 0)
	
FROM tlbHumanCase hc
    INNER JOIN tlbHuman h
        LEFT OUTER JOIN tlbGeoLocation gl
        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman AND
         h.intRowStatus = 0
         
	inner join #ReportTable rt
	on (rt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) or  rt.idfsDiagnosis is null)
		and rt.idfsRayon = @RayonID       
		and rt.idfsRayon = gl.idfsRayon
      
    left join tstSite ts
    on ts.idfsSite = hc.idfsSite
    and ts.intRowStatus = 0
    and ts.intFlags = 1
			
WHERE	hc.datFinalCaseClassificationDate is not null 
		and
			(		@StartDate <= hc.datFinalCaseClassificationDate
					and hc.datFinalCaseClassificationDate < @FinishDate				
			) 
		and	gl.idfsRegion = @RegionID
		and gl.idfsRayon = @RayonID
		and hc.intRowStatus = 0
		and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
		and ts.idfsSite is null
		
	
			



--Total
--standart cases
declare	@ReportCaseTotalValuesTable	table
(	id int identity(1,1) not null primary key,
	idfsRayon		bigint not null,
	idfsDiagnosis	bigint not null,
	intTotal		int not null
)

insert into	@ReportCaseTotalValuesTable
(	idfsRayon,
	idfsDiagnosis,
	intTotal
)
SELECT		fct.idfsRayon,
			isnull(fct.idfsDiagnosis, 0),
			count(fct.idfCase)
from		@ReportCaseTable fct
group by	fct.idfsRayon, isnull(fct.idfsDiagnosis, 0)


-- aggregate cases
declare	@ReportAggrCaseTotalValuesTable	table
(	id int identity(1,1) not null primary key,
	idfsRayon		bigint not null,
	idfsDiagnosis	bigint not null,
	intTotal		int not null
)

insert into	@ReportAggrCaseTotalValuesTable
(	idfsRayon,
	idfsDiagnosis,
	intTotal
)
SELECT		fct.idfsRayon,
			isnull(fct.idfsDiagnosis, 0),
			sum(fct.intTotal)
from		@ReportAggregateValuesTable fct
group by	fct.idfsRayon, isnull(fct.idfsDiagnosis, 0)


update rt
	set rt.intTotal = isnull(rt.intTotal,0) + rctvt.intTotal
from #ReportTable rt
inner join @ReportCaseTotalValuesTable rctvt
on rctvt.idfsRayon = rt.idfsRayon
and (rctvt.idfsDiagnosis = rt.idfsDiagnosis or rt.idfsDiagnosis is null)


update rt
	set rt.intTotal = isnull(rt.intTotal,0) + ractvt.intTotal
from #ReportTable rt
inner join @ReportAggrCaseTotalValuesTable ractvt
on ractvt.idfsRayon = rt.idfsRayon
and (ractvt.idfsDiagnosis = rt.idfsDiagnosis or rt.idfsDiagnosis is null)


end

