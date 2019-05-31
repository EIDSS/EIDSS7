

--##SUMMARY This procedure returns Header (Page 1) for Form N1

--##REMARKS Author: 
--##REMARKS Create date: 

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumSummaryRayonDiseaseAge 
'en', 
N'2011-04-29T00:00:00',
N'2015-05-29T00:00:00',
'<ItemList><Item key="7718050000000" value=""/><Item key="7720340000000" value=""/><Item key="7721290000000" value=""/></ItemList>'


exec spRepHumSummaryRayonDiseaseAge 
'ru', 
N'2011-04-29T00:00:00',
N'2015-05-29T00:00:00',
'<ItemList><Item key="7720810000000" value=""/><Item key="7721380000000" value=""/></ItemList>'




*/ 
 
create PROCEDURE [dbo].[spRepHumSummaryRayonDiseaseAge]
(
	 @LangID		As nvarchar(50),
	 @SD			as datetime, 
	 @ED			as datetime,
	 @Diagnosis		AS XML
)
AS
	
exec dbo.spSetFirstDay


	declare 
		--@SD as datetime,
		--@ED as datetime,

		@SDDate_agr as datetime,
		@EDDate_agr as datetime,


		@CountryID bigint,
		@iDiagnosis	int,
		@idfsLanguage bigint,
		
		@MinAdminLevel BIGINT,
		@MinTimeInterval BIGINT,
		@AggrCaseType BIGINT,

		@idfsSummaryReportType BIGINT,		
		@FFP_Total			BIGINT,
		@FFP_Age_0_17			BIGINT		,
		@sql nvarchar(max)			 ,
		@select nvarchar(max) ,
		@from nvarchar(max),
		
		@idfsRegionBaku bigint,
		@idfsRegionOtherRayons bigint,
		@idfsRegionNakhichevanAR bigint

	declare @DiagnosisTable	table
	(
	   intRowNumber int identity(1,1) primary key
		,[key]	nvarchar(300)
		,[value]	nvarchar(300)
	)


	declare  	@ReportDiagnosisTable table
	(	  idfsDiagnosis		BIGINT NOT NULL,
		  blnIsAggregate		BIT,
		  intTotal			INT not NULL,
		  intAge_0_17			INT not NULL,
		  idfsRegion bigint not null,
		  idfsRayon bigint not null,
		primary key (idfsDiagnosis, idfsRegion, idfsRayon)
	)
				
  if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
  drop table #ReportTable
				
	create	table #ReportTable	
	(	  idfsDiagnosis	bigint not null
		, strDiagnosis	nvarchar (300) collate database_default not null 
		, blnIsTransportCHE bit
		, idfsRegion bigint not null
		, idfsRayon  bigint not null
		, strRegion nvarchar (2000) collate database_default not null 
		, strRayon nvarchar (2000) collate database_default not null      	

		, intTotal			INT not NULL
		, intAge_0_17			INT not NULL
		, intRegionOrder int not null
		, primary key (idfsDiagnosis, idfsRegion, idfsRayon)

	)				

	
	select 
	@SDDate_agr =	case 
						when @SD <> dateadd(day,1-day(@SD),@SD) 
						then dateadd(day,1-day(dateadd(mm, 1,@SD)),dateadd(mm, 1,@SD))
						else @SD
					end,
	@EDDate_agr =	case
						when @ED <> dateadd(month,1,dateadd(day,1-day(@ED),@ED))-1
						then dateadd(month,1,dateadd(day,1-day(dateadd(mm, -1, @ED)),dateadd(mm, -1, @ED)))-1
						else @ED
					end
	
	
	
	set @CountryID = 170000000

	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		  

	SET @idfsSummaryReportType = 10290002 /*Summary Report*/

	select @FFP_Total = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Total'
	and intRowStatus = 0


	select @FFP_Age_0_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsSummaryReportType and strFFObjectAlias = 'FFP_Age_0_17'
	and intRowStatus = 0
	
 
 	--1344330000000 --Baku
	select @idfsRegionBaku = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Baku'

	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'


	--1344350000000 --Nakhichevan AR
	select @idfsRegionNakhichevanAR = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Nakhichevan AR'    
	
		
 	--Transport CHE
 	declare @TransportCHE bigint
 
 	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
 			

	EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @Diagnosis

	INSERT INTO @DiagnosisTable (
		[key],
		[value]
	) 
	SELECT 
		fnRef.idfsReference,
		fnRef.[name]
	FROM OPENXML (@iDiagnosis, '/ItemList/Item')  
	WITH (
			[key] BIGINT '@key',
			[value] NVARCHAR(300) '@value'
		 ) as xmlDiagnosis
	inner join   dbo.fnReferenceRepair(@LangID, 19000019)	fnRef
	on  xmlDiagnosis.[key] = fnRef.idfsReference
	
	EXEC sp_xml_removedocument @iDiagnosis		
			
				
	insert into #ReportTable
	(
		  idfsDiagnosis
		, strDiagnosis
		, blnIsTransportCHE
		, idfsRegion
		, idfsRayon
		, strRegion
		, strRayon 	

		, intTotal
		, intAge_0_17
		, intRegionOrder

	)
	select
	trtd.idfsDiagnosis,
	dt.[value],
	0,
	ray.idfsRegion,
	ray.idfsRayon,

	isnull(gsnt_reg.strTextString, gbr_reg.strDefault),
	isnull(gsnt_ray.strTextString, gbr_ray.strDefault),

	0,
	0,
	case ray.idfsRegion
	  when @idfsRegionBaku --Baku
	  then 1
	  
	  when @idfsRegionOtherRayons --Other rayons
	  then 2
	  
	  when @idfsRegionNakhichevanAR --Nakhichevan AR
	  then 3
	  
	  else 0
	 end 
  
  from @DiagnosisTable dt
    inner join trtDiagnosis trtd
    on trtd.idfsDiagnosis = dt.[key] 
       and trtd.intRowStatus = 0
      
    inner join trtBaseReference br
    on br.idfsBaseReference = trtd.idfsDiagnosis
    and br.intRowStatus = 0
      
    join gisRayon ray
      inner join gisRegion reg
      on ray.idfsRegion = reg.idfsRegion
      and reg.intRowStatus = 0
      and reg.idfsCountry = @CountryID
      
      inner join gisBaseReference gbr_reg
      on gbr_reg.idfsGISBaseReference = reg.idfsRegion
      and gbr_reg.intRowStatus = 0
      
      inner join dbo.gisStringNameTranslation gsnt_reg
      on gsnt_reg.idfsGISBaseReference = gbr_reg.idfsGISBaseReference
      and gsnt_reg.idfsLanguage = @idfsLanguage
      and gsnt_reg.intRowStatus = 0
      
      inner join gisBaseReference gbr_ray
      on gbr_ray.idfsGISBaseReference = ray.idfsRayon
      and gbr_ray.intRowStatus = 0
      
      inner join dbo.gisStringNameTranslation gsnt_ray
      on gsnt_ray.idfsGISBaseReference = gbr_ray.idfsGISBaseReference
      and gsnt_ray.idfsLanguage = @idfsLanguage
      and gsnt_ray.intRowStatus = 0
    on ray.intRowStatus = 0
      
  insert into #ReportTable
  (
	idfsDiagnosis
	, strDiagnosis
	, blnIsTransportCHE
	, idfsRegion
	, idfsRayon
	, strRegion
	, strRayon 	
      
	, intTotal
	, intAge_0_17
	, intRegionOrder
						
  )
  select
    trtd.idfsDiagnosis,
    dt.[value],
    1,
    reg.idfsGISBaseReference,
    ray.idfsSite,
							
    isnull(gsnt_reg.strTextString, reg.strDefault),
    i.[name],
    
    0,
    0,
    4
  
	from @DiagnosisTable dt
	inner join trtDiagnosis trtd
	on trtd.idfsDiagnosis = dt.[key] 
	   and trtd.intRowStatus = 0
	  
	inner join trtBaseReference br
	on br.idfsBaseReference = trtd.idfsDiagnosis
	and br.intRowStatus = 0
	  
	join tstSite ray
		join gisBaseReference reg
		on reg.idfsGISBaseReference = @TransportCHE

		inner join dbo.gisStringNameTranslation gsnt_reg
		on gsnt_reg.idfsGISBaseReference = reg.idfsGISBaseReference
		and gsnt_reg.idfsLanguage = @idfsLanguage
		and gsnt_reg.intRowStatus = 0

		inner join	dbo.fnInstitution(@LangID) as i  
		on	ray.idfOffice = i.idfOffice  

	on ray.intRowStatus = 0		
	and ray.intFlags = 1				
							
	insert into @ReportDiagnosisTable (
		idfsDiagnosis,
		blnIsAggregate,
		intTotal,
		intAge_0_17,
		idfsRegion,
		idfsRayon
	) 
	select distinct
		rt.idfsDiagnosis,
		case when  trtd.idfsUsingType = 10020002  --dutAggregatedCase
		then 1
		else 0
		end,
		0,
		0,
		rt.idfsRegion,
		rt.idfsRayon

	from #ReportTable rt
	inner join trtDiagnosis trtd
	on trtd.idfsDiagnosis = rt.idfsDiagnosis
	   and trtd.intRowStatus = 0
						

			


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
  idfVersion bigint,
  idfsRegion bigint not null,
  idfsRayon bigint not null
)


insert into	@ReportHumanAggregateCase
(	idfAggrCase,
  idfCaseObservation,
  datStartDate,
  idfVersion,
  idfsRegion,
  idfsRayon
)
select		
	a.idfAggrCase,
	a.idfCaseObservation,
	a.datStartDate,
	a.idfVersion,
	case when ts.idfsSite is not null then @TransportCHE else  isnull(rr.idfsRegion, s.idfsRegion) end,
	case when ts.idfsSite is not null then ts.idfsSite else  isnull(rr.idfsRayon, s.idfsRayon) end
from		tlbAggrCase a
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = @CountryID
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = @CountryID
	left join tstSite ts
		join tstCustomizationPackage tcpac on
			tcpac.idfCustomizationPackage = ts.idfCustomizationPackage
			and tcpac.idfsCountry = @CountryID
	on			ts.idfsSite = a.idfsAdministrativeUnit
				and ts.intRowStatus = 0
				and ts.intFlags = 1	
WHERE 			
			a.idfsAggrCaseType = @AggrCaseType
			and (	@SDDate_agr <= a.datStartDate
					and a.datFinishDate <  DATEADD(day, 1, @EDDate_agr) 
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
        (	
        
		    	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon

			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				)
		    or 
				(	
					a.idfsAdministrativeUnit = ts.idfsSite
			    )
	      )
	      and isnull(isnull(rr.idfsRegion, s.idfsRegion), ts.idfsSite) is not null
	      and isnull(isnull(rr.idfsRayon, s.idfsRayon),   ts.idfsSite) is not null
	      and a.intRowStatus = 0



DECLARE	@ReportAggregateDiagnosisValuesTable	TABLE
(	idfsBaseReference	BIGINT NOT NULL,
	intTotal			INT NOT NULL,
	intAge_0_17			INT NOT NULL,
	idfsRegion bigint not null,
	idfsRayon bigint not null
	primary key	(idfsBaseReference asc,
              idfsRegion asc,
              idfsRayon asc)
	
)



--select		
--		fdt.idfsDiagnosis,
--		sum(IsNull(CAST(agp_Total.varValue AS INT), 0)),
--		sum(IsNull(CAST(agp_Age_0_17.varValue AS INT), 0)),
--		fdt.idfsRegion,
--		fdt.idfsRayon

--from		@ReportHumanAggregateCase fhac
---- Updated for version 6
			
---- Matrix version
--inner join	tlbAggrMatrixVersionHeader h
--on			h.idfsMatrixType = 71190000000	-- Human Aggregate Case
--			and (	-- Get matrix version selected by the user in aggregate case
--					h.idfVersion = fhac.idfVersion 
--					-- If matrix version is not selected by the user in aggregate case, 
--					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
--					or (	fhac.idfVersion is null 
--							and	h.datStartDate <= fhac.datStartDate
--							and	h.blnIsActive = 1
--							and not exists	(
--										select	*
--										from	tlbAggrMatrixVersionHeader h_later
--										where	h_later.idfsMatrixType = 71190000000	-- Human Aggregate Case
--												and	h_later.datStartDate <= fhac.datStartDate
--												and	h_later.blnIsActive = 1
--												and h_later.intRowStatus = 0
--												and	h_later.datStartDate > h.datStartDate
--				)
--						))
--			and h.intRowStatus = 0
			
			
---- Matrix row
--inner join	tlbAggrHumanCaseMTX mtx
--on			mtx.idfVersion = h.idfVersion
--			and mtx.intRowStatus = 0
--inner join	@ReportDiagnosisTable fdt
--on			fdt.idfsDiagnosis = mtx.idfsDiagnosis     
--and isnull(fdt.idfsRegion,0) = isnull(fhac.idfsRegion,0)
--and isnull(fdt.idfsRayon,0) = isnull(fhac.idfsRayon,0)

--and fdt.idfsRegion = 1344330000000 --baku 

----	Total		
--left join	dbo.tlbActivityParameters agp_Total
--on			agp_Total.idfObservation= fhac.idfCaseObservation
--			and	agp_Total.idfsParameter = @FFP_Total
--			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
--			and agp_Total.intRowStatus = 0
--			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

----	Age_0_17		
--left join	dbo.tlbActivityParameters agp_Age_0_17
--on			agp_Age_0_17.idfObservation= fhac.idfCaseObservation
--			and	agp_Age_0_17.idfsParameter = @FFP_Age_0_17
--			and agp_Age_0_17.idfRow = mtx.idfAggrHumanCaseMTX
--			and agp_Age_0_17.intRowStatus = 0
--			and SQL_VARIANT_PROPERTY(agp_Age_0_17.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

--group by	fdt.idfsDiagnosis, fdt.idfsRegion, fdt.idfsRayon

			
			

insert into	@ReportAggregateDiagnosisValuesTable
(	idfsBaseReference,
	intTotal,
	intAge_0_17,
	idfsRegion,
	idfsRayon
)
select		
		fdt.idfsDiagnosis,
		sum(IsNull(CAST(agp_Total.varValue AS INT), 0)),
		sum(IsNull(CAST(agp_Age_0_17.varValue AS INT), 0)),
		fdt.idfsRegion,
		fdt.idfsRayon

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
inner join	@ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = mtx.idfsDiagnosis            
and isnull(fdt.idfsRegion,0) = isnull(fhac.idfsRegion,0)
and isnull(fdt.idfsRayon,0) = isnull(fhac.idfsRayon,0)        
        
--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

--	Age_0_17		
left join	dbo.tlbActivityParameters agp_Age_0_17
on			agp_Age_0_17.idfObservation= fhac.idfCaseObservation
			and	agp_Age_0_17.idfsParameter = @FFP_Age_0_17
			and agp_Age_0_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0_17.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

group by	fdt.idfsDiagnosis, fdt.idfsRegion, fdt.idfsRayon




declare	@ReportCaseTable	table
(	idfsDiagnosis			BIGINT  not null,
	idfCase				BIGINT not null primary key,
	intYear					int NULL,
	idfsHumanGender  BIGINT,
	idfsRegion BIGINT not null,
	idfsRayon BIGINT not null
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
			case when ts.idfsSite is not null then @TransportCHE /*Transport CHE*/ else  gl.idfsRegion end,  /*region CR*/
			case when ts.idfsSite is not null then ts.idfsSite else gl.idfsRayon  end /*rayon CR*/
			
FROM tlbHumanCase hc
     
    INNER JOIN tlbHuman h
        left  JOIN tlbGeoLocation gl
        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman AND
         h.intRowStatus = 0

    INNER JOIN	@ReportDiagnosisTable fdt
    ON			fdt.blnIsAggregate = 0
            AND fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
            and fdt.idfsRegion = gl.idfsRegion
            and fdt.idfsRayon = gl.idfsRayon
			
    left join tstSite ts
    on ts.idfsSite = hc.idfsSite
    and ts.intRowStatus = 0
    and ts.intFlags = 1
    			
WHERE		hc.datFinalCaseClassificationDate is not null and
			(	@SD <= hc.datFinalCaseClassificationDate
					and hc.datFinalCaseClassificationDate < DATEADD(day, 1, @ED)				
			) 
			and ((gl.idfsRegion is not null and gl.idfsRayon is not null) or (ts.idfsSite is not null))

		AND hc.intRowStatus = 0 
         -- Cases should only be seleced for the report Final Case Classification = Confirmed
         -- updated 22.05.2012 by Romasheva S.
         AND hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/




--Total
declare	@ReportCaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis	BIGINT not null,
	intTotal		INT not null,
	idfsRegion bigint not null,
	idfsRayon bigint not null,
	primary key	(idfsDiagnosis asc,
              idfsRegion asc,
              idfsRayon asc)
)

insert into	@ReportCaseDiagnosisTotalValuesTable
(	idfsDiagnosis,
	intTotal,
	idfsRegion,
	idfsRayon
)
SELECT fct.idfsDiagnosis,
			count(fct.idfCase),
			idfsRegion,
			idfsRayon
from		@ReportCaseTable fct
group by	fct.idfsDiagnosis, fct.idfsRegion, fct.idfsRayon



--Total Age_0_17
declare	@ReportCaseDiagnosis_Age_0_17_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null,
	intAge_0_17				INT not null,
	idfsRegion bigint not null,
	idfsRayon bigint not null,
	primary key	(idfsDiagnosis asc,
              idfsRegion asc,
              idfsRayon asc)
	
	
)

insert into	@ReportCaseDiagnosis_Age_0_17_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_17,
	idfsRegion,
	idfsRayon
)
select		fct.idfsDiagnosis,
			count(fct.idfCase),
	    idfsRegion,
	    idfsRayon
			
from		@ReportCaseTable fct
where		(fct.intYear >= 0 and fct.intYear <= 17)
group by	fct.idfsDiagnosis, 	fct.idfsRegion,	fct.idfsRayon




--aggregate cases
update		fdt
set				
	fdt.intAge_0_17 = fadvt.intAge_0_17,
	fdt.intTotal = fadvt.intTotal
from		@ReportDiagnosisTable fdt
    inner join	@ReportAggregateDiagnosisValuesTable fadvt
    on			fadvt.idfsBaseReference = fdt.idfsDiagnosis
    and fadvt.idfsRegion = fdt.idfsRegion
    and fadvt.idfsRayon = fdt.idfsRayon
where		fdt.blnIsAggregate = 1	



--standard cases
update		fdt
set			fdt.intTotal = isnull(fdt.intTotal, 0) + fcdvt.intTotal
from		@ReportDiagnosisTable fdt
inner join	@ReportCaseDiagnosisTotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
    and fcdvt.idfsRegion = fdt.idfsRegion
    and fcdvt.idfsRayon = fdt.idfsRayon
where		fdt.blnIsAggregate = 0		

update		fdt
set			fdt.intAge_0_17 = isnull(fdt.intAge_0_17, 0) +  fcdvt.intAge_0_17
from		@ReportDiagnosisTable fdt
inner join	@ReportCaseDiagnosis_Age_0_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
    and fcdvt.idfsRegion = fdt.idfsRegion
    and fcdvt.idfsRayon = fdt.idfsRayon
where		fdt.blnIsAggregate = 0

			
						

-- update Report Table
update		rt
set	
  rt.intTotal = rdt.intTotal,	
	rt.intAge_0_17 = rdt.intAge_0_17 

from		#ReportTable rt
inner join	@ReportDiagnosisTable rdt
on			rdt.idfsDiagnosis = rt.idfsDiagnosis	
    and rdt.idfsRegion = rt.idfsRegion
    and rdt.idfsRayon = rt.idfsRayon				
						
			

				
set @select ='
select 
	regions.intRegionOrder
  , regions.strRegion
  , regions.strRayon		
  , regions.idfsRegion
  , regions.idfsRayon	
  , regions.blnIsTransportCHE
  
'	

set @from = '
from
    (select distinct
      rt.idfsRegion,
      rt.idfsRayon,
      rt.strRegion,
      rt.strRayon,
      rt.intRegionOrder,
      rt.blnIsTransportCHE
    from #ReportTable rt) as regions
'

declare
  @idfsDiagnosis bigint,
  @i int
  						
declare cur_diagnosis cursor for
select dt.intRowNumber, dt.[key]	from @DiagnosisTable  dt
    inner join trtDiagnosis trtd
    on trtd.idfsDiagnosis = dt.[key] 
       and trtd.intRowStatus = 0
      
    inner join trtBaseReference br
    on br.idfsBaseReference = trtd.idfsDiagnosis
    and br.intRowStatus = 0
order by intRowNumber
						
open cur_diagnosis

fetch next from cur_diagnosis into @i, @idfsDiagnosis

while @@fetch_status = 0 
begin
  set @select = @select + '
  , rt_' + cast(@i as varchar(20))+ '.strDiagnosis strDiagnosis_' + cast(@i as varchar(20))+ ' 
  , rt_' + cast(@i as varchar(20))+ '.intTotal intFirstSubcolumn_' + cast(@i as varchar(20))+ ' 
  , rt_' + cast(@i as varchar(20))+ '.intAge_0_17 intSecondSubcolumn_' + cast(@i as varchar(20))+ '
  '


   set @from = @from + '
   inner join (select idfsRegion, idfsRayon, intTotal, intAge_0_17, strDiagnosis from #ReportTable where 
   idfsDiagnosis = ' + cast(@idfsDiagnosis as varchar(20)) + ') as rt_' + cast(@i as varchar(20))+ '
   on 
       rt_' + cast(@i as varchar(20))+ '.idfsRegion = regions.idfsRegion
   and rt_' + cast(@i as varchar(20))+ '.idfsRayon = regions.idfsRayon
   '


    fetch next from cur_diagnosis into @i, @idfsDiagnosis
end


close cur_diagnosis
deallocate cur_diagnosis						
						
						

set @sql = @select + @from + '
order by regions.intRegionOrder, regions.strRayon
'						
      
print @sql						
exec (@sql)



if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
  drop table #ReportTable
  	

	
	
	
	
