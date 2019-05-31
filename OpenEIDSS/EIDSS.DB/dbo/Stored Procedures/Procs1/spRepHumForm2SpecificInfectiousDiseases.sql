



--##SUMMARY This procedure returns data for "Report on specific infectious and parasitic diseases" for KZ

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 10.12.2014

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumForm2SpecificInfectiousDiseases 'ru', 2014, 1, 12


*/ 
 
create PROCEDURE [dbo].[spRepHumForm2SpecificInfectiousDiseases]
	@LangID				as varchar(36),
	@Year				as int, 
	@FromMonth			as int = null,
	@ToMonth			as int = null,
	@RegionID			as bigint = null,
	@RayonID			as bigint = null
AS
begin

	exec dbo.spSetFirstDay
	
	declare 
	@StartDate				datetime,	 
	@FinishDate				datetime,		
	@idfsCustomReportType	bigint,
	@idfsLanguage			bigint,	
	@CountryID				bigint,
	
	@FFP_Total				bigint,
	@FFP_Age_0_14			bigint,
	@FFP_Age_15_17			bigint,
	
	@FFP_RuralTotal			bigint,
	@FFP_RuralAge_0_14		bigint,
	@FFP_RuralAge_15_17		bigint,
	@FFP_TerritorialCaseAccessory	bigint,
	
	@idfsCountrySide	bigint,
	
	@idfCustomizationPackage	bigint 

	
	declare	@ReportTable	table
	(	idfsBaseReference	bigint not null primary key,
		strDiseaseName		nvarchar(300) collate database_default not null,	--1
		intRowNumber		int null,											--2
		strICD10			nvarchar(200) collate database_default null,		--3
		intTotal			int not null,										--8
		intAge_0_14			int not null,										--9
		intAge_15_17		int not null,										--10
		intRuralTotal		int not null, --11
		intRuralAge_0_14	int not null, --12
		intRuralAge_15_17	int not null, --13
		intOrder			int not null
	)
		
	
	set	@CountryID = 1240000000  
	set @idfsCustomReportType = 10290036 /*KZ Form 2, report on specific infectious and parasitic diseases*/	
	set @idfCustomizationPackage = 51577380000000 /*Kazakhstan (MoH)*/
	--set @idfsCountrySide = 00 -- To Do !!!!
	
	select @idfsCountrySide = tbr.idfsBaseReference
	from trtBaseReference tbr
	where tbr.strDefault = 'Countryside'
	and tbr.idfsReferenceType = 19000069
	
	
	select @FFP_Total = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Total'
	and intRowStatus = 0

	select @FFP_Age_0_14 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0_14'
	and intRowStatus = 0
	
	select @FFP_Age_15_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_15_17'
	and intRowStatus = 0
	
	select @FFP_RuralTotal = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RuralTotal'
	and intRowStatus = 0

	select @FFP_RuralAge_0_14 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RuralAge_0_14'
	and intRowStatus = 0
	  
	select @FFP_RuralAge_15_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RuralAge_15_17'
	and intRowStatus = 0	
	
	select @FFP_TerritorialCaseAccessory  = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_TerritorialCaseAccessory'
	and intRowStatus = 0		
	
	
	--select 
	--	@FFP_Total,
	--	@FFP_Age_0_14,
	--	@FFP_Age_15_17,
		
	--	@FFP_RuralTotal,
	--	@FFP_RuralAge_0_14,
	--	@FFP_RuralAge_15_17,
	--	@FFP_TerritorialCaseAccessory
	
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
	
	if @FromMonth IS null
	begin
		set @StartDate = (CAST(@Year AS VARCHAR(4)) + '01' + '01')
		set @FinishDate = dateADD(yyyy, 1, @StartDate)
	end
	else
	begin	
	  IF @FromMonth < 10	
			set @StartDate = (CAST(@Year AS VARCHAR(4)) + '0' +CAST(@FromMonth AS VARCHAR(2)) + '01')
	  ELSE				
			set @StartDate = (CAST(@Year AS VARCHAR(4)) + CAST(@FromMonth AS VARCHAR(2)) + '01')
			
	  IF (@ToMonth is null) or (@FromMonth = @ToMonth)
			set @FinishDate = dateADD(mm, 1, @StartDate)
	  ELSE	begin
			IF @ToMonth < 10	
				set @FinishDate = (CAST(@Year AS VARCHAR(4)) + '0' +CAST(@ToMonth AS VARCHAR(2)) + '01')
			ELSE				
				set @FinishDate = (CAST(@Year AS VARCHAR(4)) + CAST(@ToMonth AS VARCHAR(2)) + '01')
				
			set @FinishDate = dateADD(mm, 1, @FinishDate)
	  end
	end		
		
	print @StartDate
	print @FinishDate
	
	
	insert into @ReportTable (
		idfsBaseReference,
		intRowNumber,
		strDiseaseName,
		strICD10,
		intTotal			, --8
		intAge_0_14			, --9
		intAge_15_17		, --10
		intRuralTotal		, --11
		intRuralAge_0_14	, --12
		intRuralAge_15_17	, --13
		intOrder
	) 
	select 
	  rr.idfsDiagnosisOrReportDiagnosisGroup,
	  rr.intRowOrder,
	  IsNull(snt.strTextString, br.strDefault),
	  d.strIDC10,
	  0,
	  0,
	  0,
	  0,
	  0,
	  0,
	  rr.intRowOrder
	from   dbo.trtReportRows rr
		inner join trtBaseReference br
			inner  join trtDiagnosis d
			on br.idfsBaseReference = d.idfsDiagnosis		
			
			left join trtStringNameTranslation snt
			on br.idfsBaseReference = snt.idfsBaseReference
				and snt.idfsLanguage = @idfsLanguage
		on rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference
	   
	where rr.idfsCustomReportType = @idfsCustomReportType
			and rr.intRowStatus = 0
	order by rr.intRowOrder  


	DECLARE	@Form2DiagnosisTable	TABLE
	(	idfsDiagnosis		bigint NOT NULL PRIMARY KEY,
		blnIsAggregate		BIT,
		intTotal			int not null, --8
		intAge_0_14			int not null, --9
		intAge_15_17		int not null, --10
		intRuralTotal		int not null, --11
		intRuralAge_0_14	int not null, --12
		intRuralAge_15_17	int not null  --13
	)

	INSERT INTO @Form2DiagnosisTable (
		idfsDiagnosis,
		blnIsAggregate,
		intTotal			, --8
		intAge_0_14			, --9`
		intAge_15_17		, --10
		intRuralTotal		, --11
		intRuralAge_0_14	, --12
		intRuralAge_15_17	 --13
	) 
	SELECT distinct
	  fdt.idfsDiagnosisOrReportDiagnosisGroup,
	  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
		THEN 1
		ELSE 0
	  END,
	  0,
	  0,
	  0,
	  0,
	  0,
	  0

	from dbo.trtReportRows fdt
		inner join trtDiagnosis trtd
		ON trtd.idfsDiagnosis = fdt.idfsDiagnosisOrReportDiagnosisGroup
	WHERE  fdt.idfsCustomReportType = @idfsCustomReportType 

	       

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

SET @AggrCaseType = 10102001

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
from fnAggregateSettings (@AggrCaseType)--@AggrCaseType

declare	@Form2HumanAggregateCase	table
(	idfAggrCase	bigint not null primary KEY,
	idfCaseObservation bigint,
	datStartDate datetime,
	idfVersion bigint
)


insert into	@Form2HumanAggregateCase
(	idfAggrCase,
  idfCaseObservation,
  datStartDate,
  idfVersion
)
select	  a.idfAggrCase,
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
	left join tstSite ts
	on			ts.idfsSite = a.idfsAdministrativeUnit
				and ts.idfCustomizationPackage = @idfCustomizationPackage
				and ts.intRowStatus = 0
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
				    and (r.idfsRegion = @RegionID OR @RegionID IS NULL)
					
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    and (rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    and (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
					
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    and (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    and (s.idfsRegion = @RegionID OR @RegionID IS NULL)
					
			    )
				or	(
		    			a.idfsAdministrativeUnit = ts.idfsSite
						and @RayonID IS NULL
						and @RegionID IS NULL
	      )
			 )

  and a.intRowStatus = 0


DECLARE	@Form2AggregateDiagnosisValuesTable	TABLE
(	idfsBaseReference	bigint NOT NULL PRIMARY KEY,
	intTotal			int not null, --8
	intAge_0_14			int not null, --9
	intAge_15_17		int not null, --10
	intRuralTotal		int not null, --11
	intRuralAge_0_14	int not null, --12
	intRuralAge_15_17	int not null --13
)

 


insert into	@Form2AggregateDiagnosisValuesTable
(	idfsBaseReference,
	intTotal			, --8
	intAge_0_14			, --9
	intAge_15_17		, --10
	intRuralTotal		, --11
	intRuralAge_0_14	, --12
	intRuralAge_15_17	 --13
)
select		
      fdt.idfsDiagnosis      ,
			sum(IsNull(CAST(agp_Total.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_0_14.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_15_17.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_RuralTotal.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_RuralAge_0_14.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_RuralAge_15_17.varValue AS INT), 0))

from		@Form2HumanAggregateCase fhac
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
inner join	@Form2DiagnosisTable fdt
on			fdt.idfsDiagnosis = mtx.idfsDiagnosis        

        
        
--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
--	Age_0_14		
left join	dbo.tlbActivityParameters agp_Age_0_14
on			agp_Age_0_14.idfObservation= fhac.idfCaseObservation
			and	agp_Age_0_14.idfsParameter = @FFP_Age_0_14
			and agp_Age_0_14.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0_14.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0_14.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
--	Age_15_17		
left join	dbo.tlbActivityParameters agp_Age_15_17
on			agp_Age_15_17.idfObservation = fhac.idfCaseObservation
			and	agp_Age_15_17.idfsParameter = @FFP_Age_15_17
			and agp_Age_15_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_15_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_15_17.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')




--	RuralTotal		
left join	dbo.tlbActivityParameters agp_RuralTotal
on			agp_RuralTotal.idfObservation = fhac.idfCaseObservation
			and	agp_RuralTotal.idfsParameter = @FFP_RuralTotal
			and agp_RuralTotal.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_RuralTotal.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_RuralTotal.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



--	RuralAge_0_14		
left join	dbo.tlbActivityParameters agp_RuralAge_0_14
on			agp_RuralAge_0_14.idfObservation = fhac.idfCaseObservation
			and	agp_RuralAge_0_14.idfsParameter = @FFP_RuralAge_0_14
			and agp_RuralAge_0_14.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_RuralAge_0_14.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_RuralAge_0_14.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



--	RuralAge_15_17
left join	dbo.tlbActivityParameters agp_RuralAge_15_17
on			agp_RuralAge_15_17.idfObservation = fhac.idfCaseObservation
			and	agp_RuralAge_15_17.idfsParameter = @FFP_RuralAge_15_17
			and agp_RuralAge_15_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_RuralAge_15_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_RuralAge_15_17.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



group by	fdt.idfsDiagnosis

declare	@Form2CaseTable	table
(	idfsDiagnosis		bigint  not null,
	idfCase				bigint not null primary key,
	intYear				int null,
	idfsHumanGender		bigint,
	idfsRegion			bigint,
	idfsRayon			bigint,
	isCountrySide		bit not null default (0)	
)


insert into	@Form2CaseTable
(	idfsDiagnosis,
	idfCase,
	intYear,
	idfsRegion,
	idfsRayon,
	isCountrySide
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
			gl.idfsRegion,
			gl.idfsRayon,
			case when cast(tap.varValue as bigint) = @idfsCountrySide then 1 else 0 end as isCountrySide
			
from tlbHumanCase hc     

    inner join	@Form2DiagnosisTable fdt
    on			fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

    inner join tlbHuman h
        left outer join tlbGeoLocation gl
        on h.idfCurrentResidenceAddress = gl.idfGeoLocation and gl.intRowStatus = 0
    on hc.idfHuman = h.idfHuman and
    h.intRowStatus = 0
         
    left outer join tlbObservation obs
		left outer join tlbActivityParameters tap
		on tap.idfObservation = obs.idfObservation
		and tap.idfsParameter = @FFP_TerritorialCaseAccessory
		and SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
		and tap.intRowStatus = 0
    on obs.idfObservation = hc.idfEpiObservation
    and obs.intRowStatus = 0
      
    			
where		hc.datFinalCaseClassificationDate is not null and
			(	@StartDate <= hc.datFinalCaseClassificationDate
				and hc.datFinalCaseClassificationDate < @FinishDate				
			) and
			(gl.idfsRegion = @RegionID or @RegionID is null) and
			(gl.idfsRayon = @RayonID or @RayonID is null)	

			and hc.intRowStatus = 0 
			and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/

--Total
declare	@Form2CaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis	bigint not null primary key,
	intTotal		INT not null
)

insert into	@Form2CaseDiagnosisTotalValuesTable
(	idfsDiagnosis,
	intTotal
)
SELECT fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form2CaseTable fct
group by	fct.idfsDiagnosis




--Total Age_0_14
declare	@Form2CaseDiagnosis_Age_0_14_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_0_14				INT not null
)

insert into	@Form2CaseDiagnosis_Age_0_14_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_14
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form2CaseTable fct
where		(fct.intYear >= 0 and fct.intYear <= 14) 
group by	fct.idfsDiagnosis



--Total Age_15_17
declare	@Form2CaseDiagnosis_Age_15_17_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_15_17				INT not null
)

insert into	@Form2CaseDiagnosis_Age_15_17_TotalValuesTable
(	idfsDiagnosis,
	intAge_15_17
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form2CaseTable fct
where		(fct.intYear >= 15 and fct.intYear <= 17) 
group by	fct.idfsDiagnosis





--Total RuralTotal
declare	@Form2CaseDiagnosis_RuralTotal_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intRuralTotal				INT not null
)

insert into	@Form2CaseDiagnosis_RuralTotal_TotalValuesTable
(	idfsDiagnosis,
	intRuralTotal
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form2CaseTable fct
where fct.isCountrySide = 1
group by	fct.idfsDiagnosis



--Total RuralAge_0_14
declare	@Form2CaseDiagnosis_RuralAge_0_14_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intRuralAge_0_14				INT not null
)

insert into	@Form2CaseDiagnosis_RuralAge_0_14_TotalValuesTable
(	idfsDiagnosis,
	intRuralAge_0_14
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form2CaseTable fct
where		
(fct.intYear >= 0 and fct.intYear <= 14) and  fct.isCountrySide = 1
group by	fct.idfsDiagnosis
		
		

--Total RuralAge_15_17
declare	@Form2CaseDiagnosis_RuralAge_15_17_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intRuralAge_15_17		INT not null
)

insert into	@Form2CaseDiagnosis_RuralAge_15_17_TotalValuesTable
(	idfsDiagnosis,
	intRuralAge_15_17
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form2CaseTable fct
where		
(fct.intYear >= 15 and fct.intYear <= 17) and  fct.isCountrySide = 1
group by	fct.idfsDiagnosis		

--aggregate cases
update		fdt
set				
	fdt.intTotal = fadvt.intTotal,	
	fdt.intAge_0_14 = fadvt.intAge_0_14,
	fdt.intAge_15_17 = fadvt.intAge_15_17,
	
	fdt.intRuralTotal = fadvt.intRuralTotal,
	fdt.intRuralAge_0_14 = fadvt.intRuralAge_0_14,	
	fdt.intRuralAge_15_17 = fadvt.intRuralAge_15_17
	
from		@Form2DiagnosisTable fdt
    inner join	@Form2AggregateDiagnosisValuesTable fadvt
    on			fadvt.idfsBaseReference = fdt.idfsDiagnosis
		
		
		
		

--standard cases
update		fdt
set			fdt.intTotal = isnull(fdt.intTotal, 0) + fcdvt.intTotal
from		@Form2DiagnosisTable fdt
inner join	@Form2CaseDiagnosisTotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

update		fdt
set			fdt.intAge_0_14 = isnull(fdt.intAge_0_14, 0) + fcdvt.intAge_0_14
from		@Form2DiagnosisTable fdt
inner join	@Form2CaseDiagnosis_Age_0_14_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

update		fdt
set			fdt.intAge_15_17 = isnull(fdt.intAge_15_17, 0) + fcdvt.intAge_15_17
from		@Form2DiagnosisTable fdt
inner join	@Form2CaseDiagnosis_Age_15_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

update		fdt
set			fdt.intRuralTotal = isnull(fdt.intRuralTotal, 0) + fcdvt.intRuralTotal
from		@Form2DiagnosisTable fdt
inner join	@Form2CaseDiagnosis_RuralTotal_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
		
update		fdt
set			fdt.intRuralAge_0_14 = isnull(fdt.intRuralAge_0_14, 0) + fcdvt.intRuralAge_0_14
from		@Form2DiagnosisTable fdt
inner join	@Form2CaseDiagnosis_RuralAge_0_14_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

update		fdt
set			fdt.intRuralAge_15_17 = isnull(fdt.intRuralAge_15_17, 0) + fcdvt.intRuralAge_15_17
from		@Form2DiagnosisTable fdt
inner join	@Form2CaseDiagnosis_RuralAge_15_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
		
		


update		ft
set	
	ft.intTotal = fdt.intTotal,	
	ft.intAge_0_14 = fdt.intAge_0_14,
	ft.intAge_15_17 = fdt.intAge_15_17,
	
	ft.intRuralTotal = fdt.intRuralTotal,
	ft.intRuralAge_0_14 = fdt.intRuralAge_0_14,	
	ft.intRuralAge_15_17 = fdt.intRuralAge_15_17
	
from		@ReportTable ft
inner join	@Form2DiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		






-------------------------------------	

	
	select 
		 idfsBaseReference	
		,strDiseaseName		
		,intRowNumber		
		,strICD10
		,case when intTotal = 0				then null else 	intTotal			end as intTotal		
		,case when intAge_0_14 = 0			then null else 	intAge_0_14			end as intAge_0_14			
		,case when intAge_15_17 = 0			then null else 	intAge_15_17		end as intAge_15_17		
		,case when intRuralTotal = 0		then null else 	intRuralTotal		end as intRuralTotal		
		,case when intRuralAge_0_14 = 0		then null else 	intRuralAge_0_14	end as intRuralAge_0_14	
		,case when intRuralAge_15_17 = 0	then null else 	intRuralAge_15_17	end as intRuralAge_15_17
		,intOrder
	from @ReportTable
	order by intOrder
	
	
	
end
