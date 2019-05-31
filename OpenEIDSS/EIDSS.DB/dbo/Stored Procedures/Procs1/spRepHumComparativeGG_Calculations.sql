

--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec [spRepHumComparativeGG_Calculations] 'en', 2011, 2014 

exec [spRepHumComparativeGG_Calculations] 'ru', 2011, 2012 



*/ 
create PROCEDURE [dbo].[spRepHumComparativeGG_Calculations]
    @StartDate datetime,
    @FinishDate datetime,
    @RegionID bigint,
    @RayonID bigint

AS
BEGIN

exec dbo.spSetFirstDay

declare
	  
    @MinAdminLevel			bigint,
    @MinTimeInterval		bigint,
    @AggrCaseType			bigint,

  	@idfsCustomReportType	bigint,		
	@FFP_Total				bigint,
	@FFP_Age_0				bigint,
	@FFP_Age_1_4			bigint,
	@FFP_Age_5_14			bigint,
	
	@CountryID				bigint



set	@CountryID = 780000000
	  
SET @idfsCustomReportType = 10290051 /*Comparative Report on Infectious Diseases/Conditions (by months)*/

select @FFP_Age_0 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0'
and intRowStatus = 0

select @FFP_Age_1_4 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_1_4'
and intRowStatus = 0

select @FFP_Age_5_14 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_5_14'
and intRowStatus = 0

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
(	idfAggrCase	bigint not null primary KEY,
	idfCaseObservation bigint,
	datStartDate datetime,
	idfVersion bigint
)


insert into	@ReportHumanAggregateCase
(	idfAggrCase,
	idfCaseObservation,
	datStartDate,
	idfVersion
)
select	a.idfAggrCase,
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




declare	@ReportAggregateDiagnosisValuesTable	table
(	idfsBaseReference	bigint not null primary key,
	intTotal			int not null,
	intAge_0_15			int not null
)



insert into	@ReportAggregateDiagnosisValuesTable
(	idfsBaseReference,
	intTotal,
	intAge_0_15
)
select		
    fdt.idfsDiagnosis,
	sum(IsNull(CAST(agp_Total.varValue AS INT), 0)),
	sum(IsNull(CAST(agp_Age_0.varValue AS INT), 0)) + sum(IsNull(CAST(agp_Age_1_4.varValue AS INT), 0)) + sum(IsNull(CAST(agp_Age_5_14.varValue AS INT), 0))

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


--	Age_0		
left join	dbo.tlbActivityParameters agp_Age_0
on			agp_Age_0.idfObservation = fhac.idfCaseObservation
			and	agp_Age_0.idfsParameter = @FFP_Age_0
			and agp_Age_0.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			

--	Age_1_4		
left join	dbo.tlbActivityParameters agp_Age_1_4
on			agp_Age_1_4.idfObservation = fhac.idfCaseObservation
			and	agp_Age_1_4.idfsParameter = @FFP_Age_1_4
			and agp_Age_1_4.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_1_4.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_1_4.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
--	Age_5_14		
left join	dbo.tlbActivityParameters agp_Age_5_14
on			agp_Age_5_14.idfObservation = fhac.idfCaseObservation
			and	agp_Age_5_14.idfsParameter = @FFP_Age_5_14
			and agp_Age_5_14.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_5_14.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_5_14.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
						
group by	fdt.idfsDiagnosis

declare	@ReportCaseTable	table
(	idfsDiagnosis			bigint  not null,
	idfCase				bigint not null primary key,
	intYear					int NULL,
	idfsHumanGender  bigint,
	idfsRegion bigint,
	idfsRayon bigint
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
	    case
			when	loc_exp.idfsRegion is not null
				then loc_exp.idfsRegion
			else cra.idfsRegion
		 end as idfsRegion,  /*region CR*/
	    case
			when	loc_exp.idfsRegion is not null
				then loc_exp.idfsRayon
			else cra.idfsRayon
		 end as idfsRayon  /*rayon CR*/
			
FROM tlbHumanCase hc

    INNER JOIN	#ReportDiagnosisTable fdt
    ON			fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

    INNER JOIN tlbHuman h
        LEFT OUTER JOIN tlbGeoLocation cra
        ON h.idfCurrentResidenceAddress = cra.idfGeoLocation AND cra.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman AND
         h.intRowStatus = 0

	LEFT OUTER JOIN tlbGeoLocation loc_exp
	ON hc.idfPointGeoLocation = loc_exp.idfGeoLocation AND loc_exp.intRowStatus = 0
   
			
WHERE	(@StartDate <= ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate))))
			and ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate)))) < DATEADD(day, 1, @FinishDate)
		) and
		(	isnull(loc_exp.idfsGeoLocationType, -1) <> 10036001 /*Foreign Address*/
			or isnull(loc_exp.idfsCountry, cra.idfsCountry) is null
			or isnull(loc_exp.idfsCountry, cra.idfsCountry) = 780000000
		) and	
		(case
			when	loc_exp.idfsRegion is not null
				then loc_exp.idfsRegion
			else cra.idfsRegion
		 end = @RegionID
		 or @RegionID is null
		) and 
		(case
			when	loc_exp.idfsRegion is not null
				then loc_exp.idfsRayon
			else cra.idfsRayon
		 end = @RayonID
		 or @RayonID is null
		) and		  
		 hc.intRowStatus = 0 and
		 COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus, 370000000) <> 370000000 --'casRefused'



--Total
declare	@ReportCaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis	bigint not null primary key,
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



--Total Age_0_15
declare	@ReportCaseDiagnosis_Age_0_15_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_0_15				INT not null
)

insert into	@ReportCaseDiagnosis_Age_0_15_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_15
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@ReportCaseTable fct
where		(fct.intYear >=0 and fct.intYear < 15)
group by	fct.idfsDiagnosis


--aggregate cases
update		fdt
set				
	fdt.intAge_0_15 = fadvt.intAge_0_15,
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
set			fdt.intAge_0_15 = ISNULL(fdt.intAge_0_15, 0) + fcdvt.intAge_0_15
from		#ReportDiagnosisTable fdt
inner join	@ReportCaseDiagnosis_Age_0_15_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis















END
	
