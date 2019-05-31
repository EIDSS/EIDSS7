

--##SUMMARY This procedure returns data for AJ - Comparative Report Two Years

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 05.09.2013

--##RETURNS Don't use 

 
create PROCEDURE [dbo].[spRepHumComparativeTwoYears_Calculations]
    @CountryID			bigint,
    @StartDate			datetime,
    @FinishDate			datetime,
    @RegionID			bigint,
    @RayonID			bigint,
    @DiagnosisID		bigint = null
as
begin

	exec dbo.spSetFirstDay

	declare
		@MinAdminLevel bigint,
		@MinTimeInterval bigint,
		@AggrCaseType bigint,

  		@idfsCustomReportType bigint,		
		@FFP_Total			bigint,
		@TransportCHE	bigint

	SET @idfsCustomReportType = 10290001 /*Comparative Report - Two Years*/


	select @FFP_Total = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Total'
	and intRowStatus = 0

	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
 	
 	declare @Organizations table (
 		idfsSite bigint
 	)
 	
 	if @RegionID = @TransportCHE
 	begin
 		insert into @Organizations (idfsSite)
 		select frr.idfsReference
 		from dbo.fnGisReferenceRepair('en', 19000021) frr
 		where frr.idfsReference = @RayonID or @RayonID is null
 	end	
 	
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
(	idfAggrCase	bigint not null primary KEY,
	idfCaseObservation bigint,
	datStartDate datetime,
	idfVersion bigint
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
						AND (r.idfsRegion = @RegionID  and ts.idfsSite is null OR @RegionID IS NULL)
						
					)
				or	(	@MinAdminLevel = 10089002 --'satRayon' 
						and a.idfsAdministrativeUnit = rr.idfsRayon
						AND (rr.idfsRayon = @RayonID  and ts.idfsSite is null OR @RayonID IS NULL) 
						AND (rr.idfsRegion = @RegionID and ts.idfsSite is null OR @RegionID IS NULL)
						
					)
				or	(	@MinAdminLevel = 10089004 --'satSettlement' 
						and a.idfsAdministrativeUnit = s.idfsSettlement
						AND (s.idfsRayon = @RayonID  and ts.idfsSite is null OR @RayonID IS NULL) 
						AND (s.idfsRegion = @RegionID and ts.idfsSite is null OR @RegionID IS NULL)
						
					)
				or	(
		    			a.idfsAdministrativeUnit = ts.idfsSite
						and (ts.idfsSite in (select idfsSite from @Organizations))
						
					)
			 )
and a.intRowStatus = 0 --and 1=0




DECLARE	@ReportAggregateValuesTable	TABLE
(	idfAggrCase	bigint not null primary key,
	intMonth			int not null,
	intYear				int not null,
	intTotal			int not null
)



 


insert into	@ReportAggregateValuesTable
(	idfAggrCase,
	intMonth,
	intYear,
	intTotal
)
select	
		fhac.idfAggrCase,
		month(fhac.datStartDate),
		year(fhac.datStartDate),
		sum(IsNull(CAST(agp_Total.varValue AS INT), 0))

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
			and (mtx.idfsDiagnosis = @DiagnosisID or @DiagnosisID is null)
       
        
--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

group by 
		fhac.idfAggrCase,
		year(fhac.datStartDate),
		month(fhac.datStartDate)






declare	@ReportCaseTable	table
(	idfCase		bigint not null primary key,
	intMonth	int not null,
	intYear	int not null

)


--select idfsSite from @Organizations


--select distinct
--	hc.idfHumanCase AS idfCase,
--	month(hc.datFinalCaseClassificationDate),
--	year(hc.datFinalCaseClassificationDate)	,
--	@RegionID as [@RegionID] ,
--	 @TransportCHE as [@TransportCHE],
--	 ts.idfsSite
--FROM tlbHumanCase hc

--    INNER JOIN tlbHuman h
--        LEFT OUTER JOIN tlbGeoLocation gl
--        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
--      ON hc.idfHuman = h.idfHuman AND
--         h.intRowStatus = 0
      
--    left join tstSite ts
--    on ts.idfsSite = hc.idfsSite
--    and ts.intRowStatus = 0
--    and ts.intFlags = 1
			
--WHERE	hc.datFinalCaseClassificationDate is not null 
--		and (COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @DiagnosisID or @DiagnosisID is null)
--		and
--			(		@StartDate <= hc.datFinalCaseClassificationDate
--					and hc.datFinalCaseClassificationDate < @FinishDate				
--			) 
--		and(	
--		    ((gl.idfsRegion = @RegionID and  ts.idfsSite is null or @RegionID is null)  and (gl.idfsRayon = @RayonID and  ts.idfsSite is null  or @RayonID is null)		   )
--		      or	
--		    (ts.idfsSite in (select idfsSite from @Organizations)  )
		 
--		 ) 
--		and hc.intRowStatus = 0
--		and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/

insert into	@ReportCaseTable
(	idfCase,
	intMonth,
	intYear
)
select distinct
	hc.idfHumanCase AS idfCase,
	month(hc.datFinalCaseClassificationDate),
	year(hc.datFinalCaseClassificationDate)	
FROM tlbHumanCase hc

    INNER JOIN tlbHuman h
        LEFT OUTER JOIN tlbGeoLocation gl
        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman AND
         h.intRowStatus = 0
      
    left join tstSite ts
    on ts.idfsSite = hc.idfsSite
    and ts.intRowStatus = 0
    and ts.intFlags = 1
			
WHERE	hc.datFinalCaseClassificationDate is not null 
		and (COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = @DiagnosisID or @DiagnosisID is null)
		and
			(		@StartDate <= hc.datFinalCaseClassificationDate
					and hc.datFinalCaseClassificationDate < @FinishDate				
			) 
		and(	
		    ((gl.idfsRegion = @RegionID and  ts.idfsSite is null or @RegionID is null)  and (gl.idfsRayon = @RayonID and  ts.idfsSite is null  or @RayonID is null)		   )
		      or	
		    (ts.idfsSite in (select idfsSite from @Organizations)  )
		 
		 ) 
		and hc.intRowStatus = 0
		and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/






--Total
--standart cases
declare	@ReportCaseTotalValuesTable	table
(	intMonth	bigint not null,
	intTotal	INT not null,
	intYear		int not null,
	primary key (intYear, intMonth)
)

insert into	@ReportCaseTotalValuesTable
(	intMonth,
	intTotal,
	intYear
)
SELECT		fct.intMonth,
			count(fct.idfCase),
			fct.intYear
from		@ReportCaseTable fct
group by	fct.intYear, fct.intMonth


-- aggregate cases
declare	@ReportAggrCaseTotalValuesTable	table
(	intMonth	bigint not null,
	intTotal	INT not null,
	intYear		int not null,
	primary key (intYear, intMonth)
)

insert into	@ReportAggrCaseTotalValuesTable
(	intMonth,
	intTotal,
	intYear
)
SELECT		fct.intMonth,
			sum(fct.intTotal),
			fct.intYear
from		@ReportAggregateValuesTable fct
group by	fct.intYear, fct.intMonth





update rt
	set rt.intTotal = isnull(rt.intTotal,0) + rctvt.intTotal
from #ReportTable rt
inner join @ReportCaseTotalValuesTable rctvt
on rctvt.intMonth = rt.intMonth
and rctvt.intYear = rt.intYear


update rt
	set rt.intTotal = isnull(rt.intTotal,0) + ractvt.intTotal
from #ReportTable rt
inner join @ReportAggrCaseTotalValuesTable ractvt
on ractvt.intMonth = rt.intMonth
and ractvt.intYear = rt.intYear


end

