

--##SUMMARY This procedure returns data for AJ - Comparative Report 

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 25.05.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##REMARKS Updated 25.09.2014 by Romasheva S.

--##RETURNS Don't use 

 
create PROCEDURE [dbo].[spRepHumComparative_Calculations]
    @CountryID bigint,
    @StartDate datetime,
    @FinishDate datetime,
    @RegionID bigint,
    @RayonID bigint,
    @OrganizationID	as bigint = null -- idfsSiteID!!

as
begin

exec dbo.spSetFirstDay

declare
	  
    @MinAdminLevel BIGINT,
    @MinTimeInterval BIGINT,
    @AggrCaseType BIGINT,

  	@idfsCustomReportType BIGINT,		
	@FFP_Total			BIGINT,
	@FFP_Age_0_17			BIGINT


	  
   SET @idfsCustomReportType = 10290001 /*Comparative Report*/


	select @FFP_Total = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Total'
	and intRowStatus = 0


	select @FFP_Age_0_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0_17'
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
(	idfAggrCase	BIGINT not null primary KEY,
  idfCaseObservation BIGINT,
  datStartDate datetime,
  idfVersion bigint
)


insert into	@ReportHumanAggregateCase
(	idfAggrCase,
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
						and @OrganizationID is null
		      )
		    or	(	@MinAdminLevel = 10089003 --'satRegion' 
				    and a.idfsAdministrativeUnit = r.idfsRegion
				    AND (r.idfsRegion = @RegionID OR @RegionID IS NULL)
						and (@OrganizationID is null)
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    AND (rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
						and (@OrganizationID is null)
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)
						and (@OrganizationID is null)
					)
				or	(
		    			a.idfsAdministrativeUnit = ts.idfsSite
						and (ts.idfsSite = @OrganizationID or @OrganizationID is null)
						and @RayonID IS NULL
						and @RegionID IS NULL
			    )
	      )
and a.intRowStatus = 0




DECLARE	@ReportAggregateDiagnosisValuesTable	TABLE
(	idfsBaseReference	BIGINT NOT NULL PRIMARY KEY,
	intTotal			INT NOT NULL,
	intAge_0_17			INT NOT NULL
)


 


insert into	@ReportAggregateDiagnosisValuesTable
(	idfsBaseReference,
	intTotal,
	intAge_0_17
)
select		
	fdt.idfsDiagnosis,
	sum(IsNull(CAST(agp_Total.varValue AS INT), 0)),
	sum(IsNull(CAST(agp_Age_0_17.varValue AS INT), 0))

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
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = mtx.idfsDiagnosis

            
        
        
--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


--	Age_0_17		
left join	dbo.tlbActivityParameters agp_Age_0_17
on			agp_Age_0_17.idfObservation = fhac.idfCaseObservation
			and	agp_Age_0_17.idfsParameter = @FFP_Age_0_17
			and agp_Age_0_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0_17.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
group by	fdt.idfsDiagnosis

declare	@ReportCaseTable	table
(	idfsDiagnosis			BIGINT  not null,
	idfCase				BIGINT not null primary key,
	intYear					int NULL,
	idfsHumanGender  BIGINT,
	idfsRegion BIGINT,
	idfsRayon BIGINT
)


insert into	@ReportCaseTable
(	idfsDiagnosis,
	idfCase,
	intYear,
	idfsHumanGender,
	idfsRegion,
	idfsRayon
)
select distinct
			fdt.idfsDiagnosis,
			hc.idfHumanCase AS idfCase,
			case
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 200)
					then	hc.intPatientAge
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 60)
					then	cast(hc.intPatientAge / 12 as int)
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
						and (IsNull(hc.intPatientAge, -1) >= 0)
					then	0
				else	null
			end,
			h.idfsHumanGender, /*gender*/
			gl.idfsRegion,  /*region CR*/
			gl.idfsRayon  /*rayon CR*/
			
FROM tlbHumanCase hc

    INNER JOIN	#ReportDiagnosisTable fdt
    ON			fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

    INNER JOIN tlbHuman h
        LEFT OUTER JOIN tlbGeoLocation gl
        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman AND
         h.intRowStatus = 0
      
    left join tstSite ts
    on ts.idfsSite = hc.idfsSite
    and ts.intRowStatus = 0
    and ts.intFlags = 1
			
WHERE		hc.datFinalCaseClassificationDate is not null 
			and
			(		@StartDate <= hc.datFinalCaseClassificationDate
					and hc.datFinalCaseClassificationDate < @FinishDate				
			) 
			and
		  (gl.idfsRegion = @RegionID and ts.idfsSite is null or @RegionID is null) and
		  (gl.idfsRayon = @RayonID and ts.idfsSite is null OR @RayonID is null)	and
		  (ts.idfsSite = @OrganizationID or @OrganizationID is null)

		AND hc.intRowStatus = 0
		AND hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/


--Total
declare	@ReportCaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis	BIGINT not null primary key,
	intTotal		INT not null
)

insert into	@ReportCaseDiagnosisTotalValuesTable
(	idfsDiagnosis,
	intTotal
)
SELECT fct.idfsDiagnosis,
			count(fct.idfCase)
from		@ReportCaseTable fct
group by	fct.idfsDiagnosis



--Total Age_0_17
declare	@ReportCaseDiagnosis_Age_0_17_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_0_17				INT not null
)

insert into	@ReportCaseDiagnosis_Age_0_17_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_17
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@ReportCaseTable fct
where		(fct.intYear >= 0 and fct.intYear <= 17)
group by	fct.idfsDiagnosis





--aggregate cases
update		fdt
set				
	fdt.intAge_0_17 = fadvt.intAge_0_17,
	fdt.intTotal = fadvt.intTotal	
from		#ReportDiagnosisTable fdt
    inner join	@ReportAggregateDiagnosisValuesTable fadvt
    on			fadvt.idfsBaseReference = fdt.idfsDiagnosis



--standard cases
update		fdt
set			fdt.intTotal = ISNULL(fdt.intTotal, 0) + fcdvt.intTotal
from		#ReportDiagnosisTable fdt
inner join	@ReportCaseDiagnosisTotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis


update		fdt
set			fdt.intAge_0_17 = ISNULL(fdt.intAge_0_17, 0) + fcdvt.intAge_0_17
from		#ReportDiagnosisTable fdt
inner join	@ReportCaseDiagnosis_Age_0_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

end

