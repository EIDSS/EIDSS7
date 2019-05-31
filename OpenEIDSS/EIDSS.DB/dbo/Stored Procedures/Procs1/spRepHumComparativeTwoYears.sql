

--##SUMMARY 

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 05.09.2013

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec [spRepHumComparativeTwoYears] 'en', 2011, 2016, '<ItemList><Item key="1"/></ItemList>',  null, null, null
exec [spRepHumComparativeTwoYears] 'en', 2014, 2015, '<ItemList><Item key="2" value="2" /></ItemList>',  null, null, null
exec [spRepHumComparativeTwoYears] 'en', 2012, 2015, '<ItemList><Item key="1" value="1" /></ItemList>',  null, null, null
exec [spRepHumComparativeTwoYears] 'en', 2012, 2013, '<ItemList><Item key="1" value="1" /><Item key="2" value="2" /></ItemList>',  null, null, null
exec [spRepHumComparativeTwoYears] 'en', 2014, 2016, '<ItemList><Item key="1" value="1" /><Item key="2" value="2" /></ItemList>',  null, 1344330000000 /*Baku*/, 1344390000000 /*Nizami (Baku)*/
exec [spRepHumComparativeTwoYears] 'en', 2015, 2016, '<ItemList><Item key="1"/><Item key="2"/></ItemList>',  null, 10300053, 867
exec [spRepHumComparativeTwoYears] 'en', 2015, 2016, '<ItemList><Item key="2"/></ItemList>',  null, 10300053, null

test 1
	Region	(blank)
	Rayon	(blank)
	From	2015
	To	2014
	Diagnosis	Brucellosis
	Entered by Organization	(blank)
	Generate report on site	Republican APS
exec [spRepHumComparativeTwoYears] 'en', 2014, 2015, '<ItemList><Item key="1"/></ItemList>',  7718730000000, null, null

test 2
	Region	(blank)
	Rayon	(blank)
	From	2015
	To	2014
	Diagnosis	Brucellosis
	Entered by Organization	Water Transport CHE
	Generate report on site	Republican APS
exec [spRepHumComparativeTwoYears] 'en', 2014, 2015, '<ItemList><Item key="1"/></ItemList>',  7718730000000, 10300053, 869

test 3
	Region	Other rayons
	Rayon	(blank)
	From	2015
	To	2014
	Diagnosis	Acute Respiratory Infections
	Entered by Organization	(blank)
	Generate report on site	Republican APS
exec [spRepHumComparativeTwoYears] 'en', 2014, 2015, '<ItemList><Item key="1"/></ItemList>',  7718080000000, 1344340000000, null

--test 4
--	Region	Other rayons
--	Rayon	Zagatala
--	From	2015
--	To	2014
--	Diagnosis	(blank)
--	Entered by Organization	(blank)
--	Generate report on site	Republican APS
exec [spRepHumComparativeTwoYears] 'en', 2014, 2015, '<ItemList><Item key="1"/></ItemList>',  null, 1344340000000, 1344790000000
*/ 
 
create PROCEDURE [dbo].[spRepHumComparativeTwoYears]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@CounterXML			as xml,  -- 1 = Absolute number, 2 = For 10.000 population, 3 = For 100.000 population, 4 = For 1.000.000 population
	@DiagnosisID		as bigint = null,
	@RegionID			as bigint = null,
	@RayonID			as bigint = null,
	@SiteID				as bigint = null
AS
BEGIN

declare	@ReportTable	table
(	  strKey	varchar(200) not null primary key   -- let it be intYear + '_' + intCounter
    , intYear	int not null 
    , intCounter	int not null 
    , intCounterValue int not null
	, intJanuary float not null	
	, intFebruary float not null	
	, intMarch float not null	
	, intApril float not null	
	, intMay float not null	
	, intJune float not null	
	, intJuly float not null	
	, intAugust float not null	
	, intSeptember float not null	
	, intOctober float not null	
	, intNovember float not null	
	, intDecember float not null	
	, intTotal float not null
	
)
	
	declare
		@idfsLanguage bigint,
		@CountryID bigint,
		@idfsSite bigint,
		@idfsSiteType bigint,
		
		@StartDate	datetime,	 
		@FinishDate datetime,

		
		@isWeb bigint,
		@idfsStatType_Population bigint,
		
		@iCounter int,
		
 		@TransportCHE bigint
 

	declare  @Counters table(
		intCounter int primary key,
		intCounterValue numeric(10,2) not null
	)

	if cast(@CounterXML as varchar(max)) <> '<ItemList></ItemList>'
	begin 
		EXEC sp_xml_preparedocument @iCounter OUTPUT, @CounterXML

 		insert into @Counters (
 			intCounter,
 			intCounterValue
 		) 
 		select 
 			cn.[key], 
 			case cn.[key] 
 				when 1 then 1
 				when 2 then 10000.00
 				when 3 then 100000.00
 				when 4 then 1000000.00
 				else 0
 			end
 		from OPENXML (@iCounter, '/ItemList/Item') 
 		with (
 				[key] bigint '@key'
 		) cn

		
		EXEC sp_xml_removedocument @iCounter		
	end
	
	--declare @FilteredRayons table
	--(idfsRayon bigint primary key)
	
	declare @Years table (
		intYear int primary key,
		StatisticsForYear int
	)
	declare @intYear int
	set @intYear = @FirstYear
	
	while @intYear <= @SecondYear
	begin
		insert into @Years(intYear) values(@intYear)
		set @intYear = @intYear + 1
	end
	

	declare @RayonsForStatistics table
	(idfsRayon bigint,
	 maxYear int,
	 intYear int,
	 primary key (idfsRayon, intYear)
	)	

		
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
		
		
	set	@CountryID = 170000000
	
	set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
  
	--select @isWeb = isnull(ts.blnIsWEB, 0) 
	--from tstSite ts
	--join tstLocalSiteOptions lso
	--on lso.strName = N'SiteID'
	--	and lso.strValue = cast(ts.idfsSite as nvarchar(20))
	
	--select @idfsSiteType = ts.idfsSiteType
	--from tstSite ts
	--join tstLocalSiteOptions lso
	--on lso.strName = N'SiteID'
	--	and lso.strValue = cast(ts.idfsSite as nvarchar(20))
	--if @idfsSiteType is null set @idfsSiteType = 10085001	
	
	--set @idfsStatType_Population = 39850000000  -- Population
	select @idfsStatType_Population = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Statistical Data Type'
	where cast(tbra.varValue as nvarchar(100)) = N'Population'
	
	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
		
if exists (select * from @Counters c where c.intCounter > 1) -- 1 = Absolute number
begin

	--if @idfsSiteType not in (10085001, 10085002) or @isWeb <> 1
	--begin
	--	insert into @FilteredRayons (idfsRayon)
	--	select r.idfsRayon
	--	from  tstSite s
	--		inner join	tstCustomizationPackage cp
	--		on			cp.idfCustomizationPackage = s.idfCustomizationPackage	
	--					and cp.idfsCountry = @CountryID
			
	--		inner join	tlbOffice o
	--		on			o.idfOffice = s.idfOffice
	--					and o.intRowStatus = 0
						
	--		inner join	tlbGeoLocationShared gls
	--		on			gls.idfGeoLocationShared = o.idfLocation
			
	--		inner join gisRayon r
	--		  on r.idfsRayon = gls.idfsRayon
	--		  and r.intRowStatus = 0
			
	--		inner join	tflSiteToSiteGroup sts
	--			inner join	tflSiteGroup tsg
	--			on			tsg.idfSiteGroup = sts.idfSiteGroup
	--						and tsg.idfsRayon is null
	--		on			sts.idfsSite = s.idfsSite
			
	--		inner join	tflSiteGroupRelation sgr
	--		on			sgr.idfSenderSiteGroup = sts.idfSiteGroup
			
	--		inner join	tflSiteToSiteGroup stsr
	--			inner join	tflSiteGroup tsgr
	--			on			tsgr.idfSiteGroup = stsr.idfSiteGroup
	--						and tsgr.idfsRayon is null
	--		on			sgr.idfReceiverSiteGroup =stsr.idfSiteGroup
	--					and stsr.idfsSite = @idfsSite
	--	where  gls.idfsRayon is not null
		
	--	-- + border area
	--	insert into @FilteredRayons (idfsRayon)
	--	select distinct
	--		osr.idfsRayon
	--	from @FilteredRayons fr
	--		inner join gisRayon r
	--		on			r.idfsRayon = fr.idfsRayon
	--					and r.intRowStatus = 0
	          
	--		inner join	tlbGeoLocationShared gls
	--		on			gls.idfsRayon = r.idfsRayon
		
	--		inner join	tlbOffice o
	--		on			gls.idfGeoLocationShared = o.idfLocation
	--					and o.intRowStatus = 0
			
	--		inner join tstSite s
	--			inner join	tstCustomizationPackage cp
	--			on			cp.idfCustomizationPackage = s.idfCustomizationPackage	
	--		on s.idfOffice = o.idfOffice
			
	--		inner join tflSiteGroup tsg_cent 
	--		on tsg_cent.idfsCentralSite = s.idfsSite
	--		and tsg_cent.idfsRayon is null
	--		and tsg_cent.intRowStatus = 0	
			
	--		inner join tflSiteToSiteGroup tstsg
	--		on tstsg.idfSiteGroup = tsg_cent.idfSiteGroup
			
	--		inner join tstSite ts
	--		on ts.idfsSite = tstsg.idfsSite
			
	--		inner join tlbOffice os
	--		on os.idfOffice = ts.idfOffice
	--		and os.intRowStatus = 0
			
	--		inner join tlbGeoLocationShared ogl
	--		on ogl.idfGeoLocationShared = o.idfLocation
			
	--		inner join gisRayon osr
	--		on osr.idfsRayon = ogl.idfsRayon
	--		and ogl.intRowStatus = 0				
			
	--		left join @FilteredRayons fr2 
	--		on	osr.idfsRayon = fr2.idfsRayon
	--	where fr2.idfsRayon is null
	--end	

	-- Get statictics for Rayon-region
	insert into @RayonsForStatistics (idfsRayon, intYear)
	select r.idfsRayon, y.intYear  from gisRayon r
		cross join @Years y
	where (
		  idfsRayon = @RayonID or
		  (idfsRegion = @RegionID and @RayonID is null) or
		  (idfsCountry = @CountryID and @RayonID is null and @RegionID is null) or
		  (idfsCountry = @CountryID and @RegionID = @TransportCHE)
		  ) 
		 -- and 
		 -- (
		 -- 	@idfsSiteType  in (10085001, 10085002) --sitCDR, sitEMS
			--or 
			--@isWeb = 1
			--or		
			--idfsRayon in (select idfsRayon from @FilteredRayons)
		 -- )
		  and intRowStatus = 0
				
	-- for each year
	-- определяем для района максимальный год (меньший или равный отчетному году), за который есть статистика.
	update rfstat set
	   rfstat.maxYear = mrfs.maxYear
	from @RayonsForStatistics rfstat
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon, rfs.intYear
		from @RayonsForStatistics  rfs    
		  inner join dbo.tlbStatistic stat
		  on stat.idfsArea = rfs.idfsRayon 
		  and stat.intRowStatus = 0
		  and stat.idfsStatisticDataType = @idfsStatType_Population
		  and year(stat.datStatisticStartDate) <= rfs.intYear
		group by  rfs.intYear, rfs.idfsRayon
		) as mrfs
		on rfstat.idfsRayon = mrfs.idfsRayon
		and rfstat.intYear = mrfs.intYear
	                                      	
	--если статистика есть по каждому району, то суммируем ее. 
	--Иначе считаем статистику не полной и вообще не считаем для данного года-региона
	update y set
		y.StatisticsForYear = s.sumValue
	from @Years y
		inner join (select SUM(cast(varValue as int)) as sumValue, rfs.intYear
			from dbo.tlbStatistic s
			  inner join @RayonsForStatistics rfs
			  on rfs.idfsRayon = s.idfsArea and
				 s.intRowStatus = 0 and
				 s.idfsStatisticDataType = @idfsStatType_Population and
				 s.datStatisticStartDate = cast(rfs.maxYear as varchar(4)) + '-01-01' 
			group by rfs.intYear ) as s
		on s.intYear = y.intYear
		
		outer apply (
			select top 1 rfs.intYear
			from @RayonsForStatistics rfs
			where rfs.maxYear is null
			and y.intYear = rfs.intYear
		) as oa
	where oa.intYear is null
	
	--select * from @Years
	-- end of get statistics
end --if @Counter > 1 begin	
	
	
	
if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
drop table #ReportTable

   
create table #ReportTable
(	intYear			int not null,
	intMonth		int not null,
	intTotal		int not null,
	primary key (intYear, intMonth)
)

declare @month table (intMonth int primary key)

insert into @month (intMonth) values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)

insert into #ReportTable (intYear, intMonth, intTotal)
select y.intYear, m.intMonth, 0
from @Years y
	cross join @month m



declare cur cursor local forward_only for 
select y.intYear
from @Years y

open cur

fetch next from cur into @intYear

while @@FETCH_STATUS = 0
begin 
	set @StartDate = (CAST(@intYear AS VARCHAR(4)) + '01' + '01')
	set @FinishDate = dateADD(yyyy, 1, @StartDate)
	
	exec dbo.[spRepHumComparativeTwoYears_Calculations] @CountryID, @StartDate, @FinishDate, @RegionID, @RayonID, @DiagnosisID

	fetch next from cur into @intYear
end	


	
insert into @ReportTable	
(	  
	  strKey
	, intYear
	, intCounter
	, intCounterValue
	, intJanuary 
	, intFebruary 
	, intMarch
	, intApril 
	, intMay
	, intJune 
	, intJuly
	, intAugust
	, intSeptember
	, intOctober
	, intNovember
	, intDecember
	, intTotal	
)
select 
	cast(intYear as varchar(10)) + '_' + cast(intCounter as varchar(10))
	, intYear
	, intCounter
	, intCounterValue
	, [1] as intJanuary 
	, [2] as intFebruary 
	, [3] as intMarch
	, [4] as intApril 
	, [5] as intMay
	, [6] as intJune 
	, [7] as intJuly
	, [8] as intAugust
	, [9] as intSeptember
	, [10] as intOctober
	, [11] as intNovember
	, [12] as intDecember
	, [1]+ [2]+ [3]+ [4]+ [5]+ [6]+ [7]+ [8]+ [9]+ [10]+ [11]+ [12]

from 
	(	
		select rt.intYear, intMonth, intTotal, c.intCounter, c.intCounterValue
		from #ReportTable rt
			cross join @Counters c
	) as p
	pivot
	(	
		sum(intTotal)
		for intMonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
	) as pvt
	order by intYear
	
	
	

	update rt set 
		intJanuary =	case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intJanuary / y.StatisticsForYear) * rt.intCounterValue end,
		intFebruary =	case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intFebruary / y.StatisticsForYear) * rt.intCounterValue end,
		intMarch =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intMarch / y.StatisticsForYear) * rt.intCounterValue end,
		intApril =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intApril / y.StatisticsForYear) * rt.intCounterValue end,
		intMay =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intMay / y.StatisticsForYear) * rt.intCounterValue end,
		intJune =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intJune / y.StatisticsForYear) * rt.intCounterValue end,
		intJuly =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intJuly / y.StatisticsForYear) * rt.intCounterValue end,
		intAugust =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intAugust / y.StatisticsForYear) * rt.intCounterValue end,
		intSeptember =	case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intSeptember / y.StatisticsForYear) * rt.intCounterValue end,
		intOctober =	case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intOctober / y.StatisticsForYear) * rt.intCounterValue end,
		intNovember =	case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intNovember / y.StatisticsForYear) * rt.intCounterValue end,
		intDecember =	case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intDecember / y.StatisticsForYear) * rt.intCounterValue end,
		intTotal =		case isnull(y.StatisticsForYear, 0) when 0 then 0 else (intTotal / y.StatisticsForYear) * rt.intCounterValue end
	from @ReportTable rt
		inner join @Years y
		 on rt.intYear = y.intYear
	where rt.intCounter > 1



	

	select * from @ReportTable

END
	
