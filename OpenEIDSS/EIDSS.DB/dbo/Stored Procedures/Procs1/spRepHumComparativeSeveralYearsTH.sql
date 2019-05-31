

--##SUMMARY 

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 09.11.2015

--##RETURNS Don't use 

/*
--Example of a call of procedure:


exec [spRepHumComparativeSeveralYearsTH] 'en', 2013, 2014, 1, null,  null, '<ItemList></ItemList>', null

--test 1
exec [spRepHumComparativeSeveralYearsTH] 'en', 2013, 2014, 2, 3809400000000 /*Nakhon Ratchasima*/,  3885100000000 /*Mueang Nakhon Ratchasima*/, '<ItemList><Item key="56924380000000"/></ItemList>', null

--test 4
exec [spRepHumComparativeSeveralYearsTH] 'en', 2013, 2014, 1, 3809400000000 /*Nakhon Ratchasima*/,  3885100000000 /*Mueang Nakhon Ratchasima*/, '<ItemList><Item key="56924380000000"/></ItemList>', null

--test 0
exec [spRepHumComparativeSeveralYearsTH] 'en', 2013, 2014, 1, 3809400000000 /*Nakhon Ratchasima*/,  null /*Mueang Nakhon Ratchasima*/, '<ItemList><Item key="56924380000000"/></ItemList>', null


exec [spRepHumComparativeSeveralYearsTH] 'en', 2010, 2015, 2, null,  null, '<ItemList><Item key="56924380000000"/><Item key="7719340000000"/><Item key="7718730000000"/></ItemList>', null

*/ 
 create procedure [dbo].[spRepHumComparativeSeveralYearsTH]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@Counter			as int,					--1 for "rate per 100000", 2 for %
	@RegionID			as bigint = null,
	@RayonID			as bigint = null,
	@DiagnosisXml		as xml = null,
	@SiteID				as bigint = null
as
begin

	declare	@ReportTable	table
	(	  idfsYear				int not null primary key
		, intJanuary			int not null	
		, intFebruary			int not null	
		, intMarch				int not null	
		, intApril				int not null	
		, intMay				int not null	
		, intJune				int not null	
		, intJuly				int not null	
		, intAugust				int not null	
		, intSeptember			int not null	
		, intOctober			int not null	
		, intNovember			int not null	
		, intDecember			int not null	
		
		, dblJanuaryPercent		numeric(8,5)  null	
		, dblFebruaryPercent	numeric(8,5)   null	
		, dblMarchPercent		numeric(8,5)   null	
		, dblAprilPercent		numeric(8,5)   null
		, dblMayPercent			numeric(8,5)   null	
		, dblJunePercent		numeric(8,5)   null	
		, dblJulyPercent		numeric(8,5)   null
		, dblAugustPercent		numeric(8,5)   null	
		, dblSeptemberPercent	numeric(8,5)   null	
		, dblOctoberPercent		numeric(8,5)   null	
		, dblNovemberPercent	numeric(8,5)   null			
		, dblDecemberPercent	numeric(8,5)   null	
		
		, intTotal				int not null
	)
		
	declare  @Diagnosis table(
		idfsDiagnosis bigint not null primary key
	)
	
	declare @Years table (
		intYear int primary key
	)

	if OBJECT_ID('tempdb.dbo.#ReportCaseTable') is not null 
	drop table #ReportCaseTable

	create	table #ReportCaseTable	
	(	intMonth			int not null,
		intYear				int not null,
		intCaseCount		int not null,
		primary key (intYear, intMonth)
	)
		
	if OBJECT_ID('tempdb.dbo.#ProvincesForStatistics') is not null 
	drop table #ProvincesForStatistics
  	create table  #ProvincesForStatistics 
 	(
 		idfsRegion				bigint not null,
 		intYear					int not null,
 		maxYear					int,
 		intPopulation			int,
 		intOrder				int
 		primary key	(idfsRegion, intYear)
 	)
 	
 	if OBJECT_ID('tempdb.dbo.#DistrictsForStatistics') is not null 
	drop table #DistrictsForStatistics
  	create table  #DistrictsForStatistics 
 	(
 		idfsRayon				bigint not null,
 		intYear					int not null,
 		maxYear					int,
 		intPopulation			int,
 		intOrder				int
 		primary key	(idfsRayon, intYear)
 	)
 	
 	if OBJECT_ID('tempdb.dbo.#PopulationByYear') is not null 
	drop table #PopulationByYear
  	create table  #PopulationByYear 
 	(
 		intYear					int not null,
 		intPopulation			int
 		primary key	(intYear)
 	)
 	
	declare
		@idfsLanguage bigint,
		@CountryID bigint,
		@idfsSite bigint,
		
		@StartDate	datetime,	 
		@FinishDate datetime,
		 
		@iDiagnosis	int,
		@intYear int,
		
		@idfsStatType_PopulationByProvince bigint,
		@idfsStatType_PopulationByDistrict bigint,
		
		@Population int
		
		
	set @intYear = @FirstYear
	
	while @intYear <= @SecondYear
	begin
		insert into @Years(intYear) values(@intYear)
		set @intYear = @intYear + 1
	end		
		
	set @StartDate = (cast(@FirstYear as varchar(4)) + '01' + '01')
	set @FinishDate = dateadd(year, 1, (cast(@SecondYear as varchar(4)) + '01' + '01'))
	
	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
		
	set	@CountryID = 2150000000 -- TH0000	Thailand
	
	set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())	
	 	
	 	
	select @idfsStatType_PopulationByProvince = tbra.idfsBaseReference
 	from trtBaseReferenceAttribute tbra
 		inner join	trtAttributeType at 
 		on			at.strAttributeTypeName = N'Statistical Data Type'
 	where cast(tbra.varValue as nvarchar(100)) = N'Population by Province'	
 	
 	select @idfsStatType_PopulationByDistrict = tbra.idfsBaseReference
 	from trtBaseReferenceAttribute tbra
 		inner join	trtAttributeType at 
 		on			at.strAttributeTypeName = N'Statistical Data Type'
 	where cast(tbra.varValue as nvarchar(100)) = N'Population by District'	
 	
	--@idfsStatType_PopulationByProvince
 	-- определяем для провинции максимальный год (меньший или равный отчетному году), за который есть статистика.
 	insert into #ProvincesForStatistics (idfsRegion, intYear)
 	select	gr.idfsRegion, y.intYear
 	from	gisRegion gr 
 	cross join @Years y
 	where	(gr.idfsRegion = @RegionID or @RegionID is null)
 			and gr.idfsCountry = @CountryID 
 			and gr.intRowStatus = 0
 	
	update rfstat set
	   rfstat.maxYear = mrfs.maxYear
	from #ProvincesForStatistics rfstat
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRegion, rfs.intYear
		from #ProvincesForStatistics  rfs    
		  inner join dbo.tlbStatistic stat
		  on stat.idfsArea = rfs.idfsRegion 
		  and stat.intRowStatus = 0
		  and stat.idfsStatisticDataType = @idfsStatType_PopulationByProvince
		  and year(stat.datStatisticStartDate) <= rfs.intYear
		group by rfs.idfsRegion, rfs.intYear
		) as mrfs
		on rfstat.idfsRegion = mrfs.idfsRegion
		and rfstat.intYear = mrfs.intYear

	                                      	
	-- определяем статистику для каждой провинции
	update rfsu set
		rfsu.intPopulation = s.sumValue
	from #ProvincesForStatistics rfsu
		inner join (select SUM(cast(varValue as int)) as sumValue, rfs.idfsRegion, rfs.intYear
			from dbo.tlbStatistic s
			  inner join #ProvincesForStatistics rfs
			  on rfs.idfsRegion = s.idfsArea and
				 s.intRowStatus = 0 and
				 s.idfsStatisticDataType = @idfsStatType_PopulationByProvince and
				 s.datStatisticStartDate = cast(rfs.maxYear as varchar(4)) + '-01-01' 
			group by rfs.idfsRegion, rfs.intYear ) as s
		on rfsu.idfsRegion = s.idfsRegion
		and rfsu.intYear = s.intYear


	-- @idfsStatType_PopulationByDistrict
 	-- определяем для провинции максимальный год (меньший или равный отчетному году), за который есть статистика.
 	insert into #DistrictsForStatistics (idfsRayon, intYear)
 	select gr.idfsRayon, y.intYear
 	from gisRayon gr 
 	cross join @Years y
 	where gr.idfsRayon = @RayonID
 	
	update rfstat set
	   rfstat.maxYear = mrfs.maxYear
	from #DistrictsForStatistics rfstat
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon, rfs.intYear
		from #DistrictsForStatistics  rfs    
		  inner join dbo.tlbStatistic stat
		  on stat.idfsArea = rfs.idfsRayon 
		  and stat.intRowStatus = 0
		  and stat.idfsStatisticDataType = @idfsStatType_PopulationByDistrict
		  and year(stat.datStatisticStartDate) <= rfs.intYear
		group by rfs.idfsRayon, rfs.intYear
		) as mrfs
		on rfstat.idfsRayon = mrfs.idfsRayon
		and rfstat.intYear = mrfs.intYear

	                                      	
	-- определяем статистику для дистрикта
	update rfsu set
		rfsu.intPopulation = s.sumValue
	from #DistrictsForStatistics rfsu
		inner join (select SUM(cast(varValue as int)) as sumValue, rfs.idfsRayon, rfs.intYear
			from dbo.tlbStatistic s
			  inner join #DistrictsForStatistics rfs
			  on rfs.idfsRayon = s.idfsArea and
				 s.intRowStatus = 0 and
				 s.idfsStatisticDataType = @idfsStatType_PopulationByDistrict and
				 s.datStatisticStartDate = cast(rfs.maxYear as varchar(4)) + '-01-01' 
			group by rfs.idfsRayon, rfs.intYear ) as s
		on rfsu.idfsRayon = s.idfsRayon
		and rfsu.intYear = s.intYear
		 	

	EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @DiagnosisXml

	insert into @Diagnosis (
		idfsDiagnosis
	) 
	select td.idfsDiagnosis
	from OPENXML (@iDiagnosis, '/ItemList/Item') 
	with (
			[key] bigint '@key'
	) dg
	inner join trtDiagnosis td
	on td.idfsDiagnosis = dg.[key]

	EXEC sp_xml_removedocument @iDiagnosis		
	
	insert into	#ReportCaseTable
	(	intMonth,
		intYear,
		intCaseCount
	)
	select 
		month(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))),
		year(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))),
		count(hc.idfHumanCase)
	from tlbHumanCase hc
		inner join tlbHuman h
			left outer join tlbGeoLocation gl
				left join dbo.gisDistrictSubdistrict ds
				on ds.idfsGeoObject = gl.idfsRayon
			on h.idfCurrentResidenceAddress = gl.idfGeoLocation 
			and gl.intRowStatus = 0
		on hc.idfHuman = h.idfHuman 
		and h.intRowStatus = 0
		
	    left join @Diagnosis d
	    on coalesce(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = d.idfsDiagnosis
	where		
			(		@StartDate <= isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))
					and isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate)))) < @FinishDate				
			) 
			and	(gl.idfsRegion = @RegionID  or @RegionID is null)
			and ((gl.idfsRayon = @RayonID and ds.idfsParent is null) or ds.idfsParent = @RayonID or @RayonID is null)	
			and hc.intRowStatus = 0
			and (d.idfsDiagnosis is not null or not exists(select * from @Diagnosis))
	group by	
		year(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))), 
		month(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate)))))
	option (recompile)
	
	
	insert into @ReportTable	
	(	  idfsYear
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
		intYear
		, isnull([1],0) as intJanuary 
		, isnull([2],0) as intFebruary 
		, isnull([3],0) as intMarch
		, isnull([4],0) as intApril 
		, isnull([5],0) as intMay
		, isnull([6],0) as intJune 
		, isnull([7],0) as intJuly
		, isnull([8],0) as intAugust
		, isnull([9],0) as intSeptember
		, isnull([10],0) as intOctober
		, isnull([11],0) as intNovember
		, isnull([12],0) as intDecember
		
		, isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0)

	from 
		(	
			select y.intYear, intMonth, intCaseCount
			from @Years y
				left join #ReportCaseTable rt
				on rt.intYear = y.intYear
		) as p
		pivot
		(	
			sum(intCaseCount)
			for intMonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
		) as pvt
		order by intYear		
		
	if @Counter = 2
	begin
		update rt set
			  dblJanuaryPercent		= case when rt.intTotal > 0 then rt.intJanuary		* 100.0 / rt.intTotal else null end
			, dblFebruaryPercent	= case when rt.intTotal > 0 then rt.intFebruary		* 100.0 / rt.intTotal else null end
			, dblMarchPercent		= case when rt.intTotal > 0 then rt.intMarch		* 100.0 / rt.intTotal else null end
			, dblAprilPercent		= case when rt.intTotal > 0 then rt.intApril		* 100.0 / rt.intTotal else null end
			, dblMayPercent			= case when rt.intTotal > 0 then rt.intMay			* 100.0 / rt.intTotal else null end
			, dblJunePercent		= case when rt.intTotal > 0 then rt.intJune			* 100.0 / rt.intTotal else null end
			, dblJulyPercent		= case when rt.intTotal > 0 then rt.intJuly			* 100.0 / rt.intTotal else null end
			, dblAugustPercent		= case when rt.intTotal > 0 then rt.intAugust		* 100.0 / rt.intTotal else null end
			, dblSeptemberPercent	= case when rt.intTotal > 0 then rt.intSeptember	* 100.0 / rt.intTotal else null end
			, dblOctoberPercent		= case when rt.intTotal > 0 then rt.intOctober		* 100.0 / rt.intTotal else null end
			, dblNovemberPercent	= case when rt.intTotal > 0 then rt.intNovember		* 100.0 / rt.intTotal else null end
			, dblDecemberPercent	= case when rt.intTotal > 0 then rt.intDecember		* 100.0 / rt.intTotal else null end
		from @ReportTable rt
	end else 
	if @Counter = 1
	begin
	      if @RayonID is not null
	      begin
	      	insert into #PopulationByYear (intYear, intPopulation)
	      	select dfs.intYear, sum(dfs.intPopulation)
	      	from #DistrictsForStatistics dfs
	      	group by dfs.intYear
	      	
	      end
	      else
	      if @RegionID is not null
	      begin
	      	insert into #PopulationByYear (intYear, intPopulation)
	      	select pfs.intYear, sum(pfs.intPopulation)
	      	from #ProvincesForStatistics pfs
	      	where pfs.idfsRegion = @RegionID
	      	group by pfs.intYear
	      	
	      end
	      else
	      if @RayonID is null and @RegionID is null
	      begin
	        insert into #PopulationByYear (intYear, intPopulation)
	      	select 
	      		pfs.intYear,  
	      		case when not exists (
	      						select * from  #ProvincesForStatistics ps 
	      						where ps.intYear = pfs.intYear 
	      						and isnull(ps.intPopulation,0) = 0 
	      					) then sum(pfs.intPopulation) 
	      		else 0 end
	      	from #ProvincesForStatistics pfs
	      	group by pfs.intYear
	      end

	      update rt set
			  dblJanuaryPercent		= case when py.intPopulation > 0 then (rt.intJanuary*1.0	/ py.intPopulation) * 100000.0 else null end
			, dblFebruaryPercent	= case when py.intPopulation > 0 then (rt.intFebruary*1.0	/ py.intPopulation) * 100000.0 else null end
			, dblMarchPercent		= case when py.intPopulation > 0 then (rt.intMarch*1.0		/ py.intPopulation) * 100000.0 else null end
			, dblAprilPercent		= case when py.intPopulation > 0 then (rt.intApril*1.0		/ py.intPopulation) * 100000.0 else null end
			, dblMayPercent			= case when py.intPopulation > 0 then (rt.intMay*1.0		/ py.intPopulation) * 100000.0 else null end
			, dblJunePercent		= case when py.intPopulation > 0 then (rt.intJune*1.0		/ py.intPopulation) * 100000.0 else null end
			, dblJulyPercent		= case when py.intPopulation > 0 then (rt.intJuly*1.0		/ py.intPopulation) * 100000.0 else null end
			, dblAugustPercent		= case when py.intPopulation > 0 then (rt.intAugust*1.0		/ py.intPopulation) * 100000.0 else null end
			, dblSeptemberPercent	= case when py.intPopulation > 0 then (rt.intSeptember*1.0	/ py.intPopulation) * 100000.0 else null end
			, dblOctoberPercent		= case when py.intPopulation > 0 then (rt.intOctober*1.0	/ py.intPopulation) * 100000.0 else null end
			, dblNovemberPercent	= case when py.intPopulation > 0 then (rt.intNovember*1.0	/ py.intPopulation) * 100000.0 else null end
			, dblDecemberPercent	= case when py.intPopulation > 0 then (rt.intDecember*1.0	/ py.intPopulation) * 100000.0 else null end
		from @ReportTable rt   
			inner join #PopulationByYear py
			on py.intYear = rt.idfsYear               	
	end

	if @Counter = 2
	select 
		idfsYear, 
		
		intJanuary, 
		cast(dblJanuaryPercent as numeric(8,1)) as dblJanuaryPercent, 
		intFebruary, 
		cast(dblFebruaryPercent as numeric(8,1)) as dblFebruaryPercent, 
		intMarch, 
		cast(dblMarchPercent as numeric(8,1)) as dblMarchPercent, 
		intApril,
	    cast(dblAprilPercent as numeric(8,1)) as dblAprilPercent, 
	    intMay, 
	    cast(dblMayPercent as numeric(8,1)) as dblMayPercent, 
	    intJune, 
	    cast(dblJunePercent as numeric(8,1)) as dblJunePercent,
	    intJuly, 
	    cast(dblJulyPercent as numeric(8,1)) as dblJulyPercent, 
	    intAugust, 
	    cast(dblAugustPercent as numeric(8,1)) as dblAugustPercent, 
	    intSeptember,
	    cast(dblSeptemberPercent as numeric(8,1)) as dblSeptemberPercent, 
	    intOctober, 
	    cast(dblOctoberPercent as numeric(8,1)) as dblOctoberPercent, 
	    intNovember,
	    cast(dblNovemberPercent as numeric(8,1)) as dblNovemberPercent, 
	    intDecember, 
	    cast(dblDecemberPercent as numeric(8,1)) as dblDecemberPercent, 
	    
	    intTotal
	  from @ReportTable 
	order by idfsYear
	else
	select 
		idfsYear, 
		
		intJanuary, 
		dblJanuaryPercent, 
		intFebruary, 
		dblFebruaryPercent, 
		intMarch, 
		dblMarchPercent, 
		intApril,
	    dblAprilPercent, 
	    intMay, 
	    dblMayPercent, 
	    intJune, 
	    dblJunePercent,
	    intJuly, 
	    dblJulyPercent, 
	    intAugust, 
	    dblAugustPercent, 
	    intSeptember,
	    dblSeptemberPercent, 
	    intOctober, 
	    dblOctoberPercent, 
	    intNovember,
	    dblNovemberPercent, 
	    intDecember, 
	    dblDecemberPercent, 
	    
	    intTotal
	  from @ReportTable 
	order by idfsYear

end
	
