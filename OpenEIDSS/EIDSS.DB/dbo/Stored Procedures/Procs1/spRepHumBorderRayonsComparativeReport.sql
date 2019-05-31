
 
 --##SUMMARY Border rayons’ incidence comparative report
 /*
 Implement rules for retrieving data into the Border rayons’ incidence comparative report according to the specification:
 $/BTRP/Project_Documents/08x-Implementation/Customizations/AJ/AJ Customization EIDSS v6/Reports/Border rayons' incidents comparative report/Specification for report development - Border rayons' incidents comparative report.doc
 */
 
 --##REMARKS Author: Romasheva S.
 --##REMARKS Create date: 25.09.2015
 
 --##RETURNS Don't use 
 
 /*
 --Example of a call of procedure:
 
 
 
 exec [spRepHumBorderRayonsComparativeReport] 'en', 2009, 1, 12,  N'<ItemList><Item key="1"/></ItemList>', 1344330000000, 1344360000000, 
 N'<ItemList><Item key="7718510000000"  /><Item key="7718060000000"  /></ItemList>'
 
 exec [spRepHumBorderRayonsComparativeReport] 'en', 2014, 2, 2,  N'<ItemList><Item key="1"/></ItemList>', 1344330000000, 1344360000000, 
 N'<ItemList><Item key="7718510000000"  /><Item key="7718060000000"  /></ItemList>'

exec [spRepHumBorderRayonsComparativeReport] 'en', 2015, 1, 12,  N'<ItemList><Item key="1"/></ItemList>', 1344330000000, 1344360000000, 
 N'<ItemList></ItemList>'
 
 exec [spRepHumBorderRayonsComparativeReport] 'en', 2009, 1, 12,  N'<ItemList><Item key="2"/><Item key="1"/></ItemList>', 1344330000000, 1344360000000, 
 N'<ItemList></ItemList>'
 

declare @p8 xml
set @p8=convert(xml,N'<ItemList><Item key="7718050000000"/><Item key="7718110000000"/><Item key="7718120000000"/><Item key="7718130000000"/><Item key="7718290000000"/><Item key="7718350000000"/><Item key="7718360000000"/></ItemList>')
exec dbo.spRepHumBorderRayonsComparativeReport @LangID='en',@Year=2014,@FromMonth=1,@ToMonth=9,@CounterXML=N'<ItemList><Item key="1"/><Item key="2"/></ItemList>',@RegionID=1344330000000,@RayonID=1344440000000,@DiagnosisXml=@p8,@SiteID=871 

exec dbo.spRepHumBorderRayonsComparativeReport @LangID='en',@Year=2014,@FromMonth=1,@ToMonth=9,@CounterXML=N'<ItemList><Item key="1"/></ItemList>',@RegionID=1344330000000,@RayonID=1344440000000,@DiagnosisXml=@p8,@SiteID=871 

 */ 
  
 create PROCEDURE [dbo].[spRepHumBorderRayonsComparativeReport]
 	@LangID				as varchar(36),
 	@Year				as int, 
 	@FromMonth			as int = null,
 	@ToMonth			as int = null,
 	@CounterXML			as xml,  -- 1 = Absolute number, 2 = For 10.000 population, 3 = For 100.000 population, 4 = For 1.000.000 population
 	@RegionID			as bigint,
 	@RayonID			as bigint,
 	@DiagnosisXml		as xml,
 	@SiteID				as bigint = null
 AS
 BEGIN

	
	create table #Diagnosis (
		intRowNum int identity not null,
		idfsDiagnosis bigint primary key,
		strDiagnosisName nvarchar(2000),
		strIDC10 nvarchar(200)
	)
 	
 	
 	create table	#ReportDiagnosisTable	
	(	
	    strKey					varchar(200) not null primary key,   -- let it be idfsRayon + '_' + intCounter
 		idfsRayon				bigint not null, -- =-1 for total row
 		intCounter				int not null,
 		intCounterValue			int not null,
 		strRayonName			nvarchar(2000) not null,
 		
 		idfsDiagnosis_1			bigint,
 		strDiagnosis_1			nvarchar(200),
 		strIDCCode_1			nvarchar(100),	
 		dblValue_1				decimal(10,2),
 
 		idfsDiagnosis_2			bigint,
 		strDiagnosis_2			nvarchar(200),
 		strIDCCode_2			nvarchar(100),	
 		dblValue_2				decimal(10,2),
 
 		idfsDiagnosis_3			bigint,
 		strDiagnosis_3			nvarchar(200),
 		strIDCCode_3			nvarchar(100),	
 		dblValue_3				decimal(10,2),
 
 		idfsDiagnosis_4			bigint,
 		strDiagnosis_4			nvarchar(200),
 		strIDCCode_4			nvarchar(100),	
 		dblValue_4				decimal(10,2),
 
 		idfsDiagnosis_5			bigint,
 		strDiagnosis_5			nvarchar(200),
 		strIDCCode_5			nvarchar(100),	
 		dblValue_5				decimal(10,2),
 
 		idfsDiagnosis_6			bigint,
 		strDiagnosis_6			nvarchar(200),
 		strIDCCode_6			nvarchar(100),	
 		dblValue_6				decimal(10,2),
 
 		idfsDiagnosis_7			bigint,
 		strDiagnosis_7			nvarchar(200),
 		strIDCCode_7			nvarchar(100),	
 		dblValue_7				decimal(10,2),
 		
 		idfsDiagnosis_8			bigint,
 		strDiagnosis_8			nvarchar(200),
 		strIDCCode_8			nvarchar(100),	
 		dblValue_8				decimal(10,2),
 		
 		idfsDiagnosis_9			bigint,
 		strDiagnosis_9			nvarchar(200),
 		strIDCCode_9			nvarchar(100),	
 		dblValue_9				decimal(10,2),
 		
 		idfsDiagnosis_10		bigint,
 		strDiagnosis_10			nvarchar(200),
 		strIDCCode_10			nvarchar(100),	
 		dblValue_10				decimal(10,2),
 		
 		idfsDiagnosis_11		bigint,
 		strDiagnosis_11			nvarchar(200),
 		strIDCCode_11			nvarchar(100),	
 		dblValue_11				decimal(10,2),
 		
 		idfsDiagnosis_12		bigint,
 		strDiagnosis_12			nvarchar(200),
 		strIDCCode_12			nvarchar(100),	
 		dblValue_12				decimal(10,2), 		 		 		 		 		
 		
 		dblTotal				decimal(10,2),
 		blnTotalVisible			bit default 0,
 													
 		intRowNum				int not null default 0 -- =999 for total row
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
 		
 		@iDiagnosis	int,
 		@blnTotalVisible bit = 0,
 		
 		@iCounter int
 		
	
	declare @FilteredRayons table
	(idfsRayon bigint primary key) 		
 
 	declare @RayonsForStatistics table
	(
		idfsRayon bigint,
		maxYear int,
		intPopulation int,
		primary key (idfsRayon)
	)	
	
	declare @BorderRayons table (
		idfsRayon bigint not null primary key	
	)
	

	
 	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
 		
 	set	@CountryID = 170000000
 	
 	if @FromMonth is null set @FromMonth = 1
 	if @ToMonth is null set @ToMonth = 12
 	set @StartDate = CAST(@Year AS VARCHAR(4)) + case when @FromMonth < 10 then '0' else '' end + cast(@FromMonth as varchar) + '01'
	set @FinishDate = CAST(@Year AS VARCHAR(4)) + case when @ToMonth < 10 then '0' else '' end + cast(@ToMonth as varchar) + '01'
	
	set @FinishDate = dateadd(month, 1, @FinishDate)
	
 	print @StartDate
 	print @FinishDate
 	
	set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
	
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
	
	if cast(@DiagnosisXml as varchar(max)) <> '<ItemList></ItemList>'
	begin 
		EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @DiagnosisXml
------------------
--		select  dgn.name, td.idfsDiagnosis, fr.name
-- 		from OPENXML (@iDiagnosis, '/ItemList/Item') 
-- 		with (
-- 				[key] bigint '@key'
-- 		) dg
-- 		inner join trtDiagnosis td
-- 		on td.idfsDiagnosis = dg.[key]
-- 		inner join dbo.fnReference(@LangID, 19000019) fr
-- 		on td.idfsDiagnosis = fr.idfsReference
 		
-- 		left join trtDiagnosisToDiagnosisGroup dgr
-- 			inner join dbo.fnReference(@LangID, 19000156) dgn
-- 			on dgn.idfsReference = dgr.idfsDiagnosisGroup
-- 		on dgr.idfsDiagnosis = td.idfsDiagnosis
-- 		and dgr.intRowStatus = 0
 		
-- 		order by 
-- 			case when dgr.idfDiagnosisToDiagnosisGroup is not null then '1' else '2' end + '_' + isnull(dgn.name, '') + fr.name
 		
 		
-- 		--fr.name
-------------------- 		
 		
 		insert into #Diagnosis (
 			idfsDiagnosis,
 			strDiagnosisName, 
 			strIDC10
 		) 
 		select td.idfsDiagnosis, fr.name, td.strIDC10
 		from OPENXML (@iDiagnosis, '/ItemList/Item') 
 		with (
 				[key] bigint '@key'
 		) dg
 		inner join trtDiagnosis td
 		on td.idfsDiagnosis = dg.[key]
 		inner join dbo.fnReference(@LangID, 19000019) fr
 		on td.idfsDiagnosis = fr.idfsReference
 		
 		left join trtDiagnosisToDiagnosisGroup dgr
 			inner join dbo.fnReference(@LangID, 19000156) dgn
 			on dgn.idfsReference = dgr.idfsDiagnosisGroup
 		on dgr.idfsDiagnosis = td.idfsDiagnosis
 		and dgr.intRowStatus = 0
 		
 		order by 
 			case when dgr.idfDiagnosisToDiagnosisGroup is not null then '1' else '2' end + '_' + isnull(dgn.name, '') + fr.name
		
		EXEC sp_xml_removedocument @iDiagnosis		
	end
	
	-- calc @blnTotalVisible
	if exists(
		select *
		from trtDiagnosisToDiagnosisGroup tdtdg
			left join #Diagnosis d
			on d.idfsDiagnosis = tdtdg.idfsDiagnosis
			
		where not exists (
			select * from trtDiagnosisToDiagnosisGroup tdtdg2
			left join #Diagnosis d2
			on d2.idfsDiagnosis = tdtdg2.idfsDiagnosis
			where tdtdg2.idfsDiagnosisGroup = tdtdg.idfsDiagnosisGroup
			and d2.idfsDiagnosis is null
		)	
	) or 
	not exists (select * from #Diagnosis) 
	begin	
		set @blnTotalVisible = 1
	end	
	--------
  
	select @isWeb = isnull(ts.blnIsWEB, 0) 
	from tstSite ts
	join tstLocalSiteOptions lso
	on lso.strName = N'SiteID'
		and lso.strValue = cast(ts.idfsSite as nvarchar(20))
	
	select @idfsSiteType = ts.idfsSiteType
	from tstSite ts
	join tstLocalSiteOptions lso
	on lso.strName = N'SiteID'
		and lso.strValue = cast(ts.idfsSite as nvarchar(20))
	if @idfsSiteType is null set @idfsSiteType = 10085001	
	
	--set @idfsStatType_Population = 39850000000  -- Population
	select @idfsStatType_Population = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Statistical Data Type'
	where cast(tbra.varValue as nvarchar(100)) = N'Population'
		   
	insert into @BorderRayons
	select tgfcr.idfsGISBaseReference
	from trtGISObjectForCustomReport tgfcr 
		inner join gisRayon gr
		on gr.idfsRayon = tgfcr.idfsGISBaseReference
	where cast(tgfcr.strGISObjectAlias as bigint) = @RayonID
   
if exists (select * from @Counters c where c.intCounter > 1) -- 1 = Absolute number
begin
	if @idfsSiteType not in (10085001, 10085002) or @isWeb <> 1
	begin
		insert into @FilteredRayons (idfsRayon)
		select r.idfsRayon
		from  tstSite s
			inner join	tstCustomizationPackage cp
			on			cp.idfCustomizationPackage = s.idfCustomizationPackage	
						and cp.idfsCountry = @CountryID
			
			inner join	tlbOffice o
			on			o.idfOffice = s.idfOffice
						and o.intRowStatus = 0
						
			inner join	tlbGeoLocationShared gls
			on			gls.idfGeoLocationShared = o.idfLocation
			
			inner join gisRayon r
			  on r.idfsRayon = gls.idfsRayon
			  and r.intRowStatus = 0
			
			inner join	tflSiteToSiteGroup sts
				inner join	tflSiteGroup tsg
				on			tsg.idfSiteGroup = sts.idfSiteGroup
							and tsg.idfsRayon is null
			on			sts.idfsSite = s.idfsSite
			
			inner join	tflSiteGroupRelation sgr
			on			sgr.idfSenderSiteGroup = sts.idfSiteGroup
			
			inner join	tflSiteToSiteGroup stsr
				inner join	tflSiteGroup tsgr
				on			tsgr.idfSiteGroup = stsr.idfSiteGroup
							and tsgr.idfsRayon is null
			on			sgr.idfReceiverSiteGroup =stsr.idfSiteGroup
						and stsr.idfsSite = @idfsSite
		where  gls.idfsRayon is not null
		
		-- + border area
		insert into @FilteredRayons (idfsRayon)
		select distinct
			osr.idfsRayon
		from @FilteredRayons fr
			inner join gisRayon r
			on			r.idfsRayon = fr.idfsRayon
						and r.intRowStatus = 0
	          
			inner join	tlbGeoLocationShared gls
			on			gls.idfsRayon = r.idfsRayon
		
			inner join	tlbOffice o
			on			gls.idfGeoLocationShared = o.idfLocation
						and o.intRowStatus = 0
			
			inner join tstSite s
				inner join	tstCustomizationPackage cp
				on			cp.idfCustomizationPackage = s.idfCustomizationPackage	
			on s.idfOffice = o.idfOffice
			
			inner join tflSiteGroup tsg_cent 
			on tsg_cent.idfsCentralSite = s.idfsSite
			and tsg_cent.idfsRayon is null
			and tsg_cent.intRowStatus = 0	
			
			inner join tflSiteToSiteGroup tstsg
			on tstsg.idfSiteGroup = tsg_cent.idfSiteGroup
			
			inner join tstSite ts
			on ts.idfsSite = tstsg.idfsSite
			
			inner join tlbOffice os
			on os.idfOffice = ts.idfOffice
			and os.intRowStatus = 0
			
			inner join tlbGeoLocationShared ogl
			on ogl.idfGeoLocationShared = o.idfLocation
			
			inner join gisRayon osr
			on osr.idfsRayon = ogl.idfsRayon
			and ogl.intRowStatus = 0				
			
			left join @FilteredRayons fr2 
			on	osr.idfsRayon = fr2.idfsRayon
		where fr2.idfsRayon is null
	end	

	-- Get statictics for Rayon-region
	insert into @RayonsForStatistics (idfsRayon)
	select r.idfsRayon  from gisRayon r
	where (
		  idfsRayon = @RayonID  or
		  idfsRayon in (select br.idfsRayon	from @BorderRayons br)
		  ) 
		  and 
		  (
		  	@idfsSiteType  in (10085001, 10085002) --sitCDR, sitEMS
			or 
			@isWeb = 1
			or		
			idfsRayon in (select idfsRayon from @FilteredRayons)
		  )
		  and intRowStatus = 0
				

	-- определяем для района максимальный год (меньший или равный отчетному году), за который есть статистика.
	update rfstat set
	   rfstat.maxYear = mrfs.maxYear
	from @RayonsForStatistics rfstat
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon
		from @RayonsForStatistics  rfs    
		  inner join dbo.tlbStatistic stat
		  on stat.idfsArea = rfs.idfsRayon 
		  and stat.intRowStatus = 0
		  and stat.idfsStatisticDataType = @idfsStatType_Population
		  and year(stat.datStatisticStartDate) <= @Year
		group by rfs.idfsRayon
		) as mrfs
		on rfstat.idfsRayon = mrfs.idfsRayon

	                                      	
	-- определяем статистику для каждого района
	update rfsu set
		rfsu.intPopulation = s.sumValue
	from @RayonsForStatistics rfsu
		inner join (select SUM(cast(varValue as int)) as sumValue, rfs.idfsRayon
			from dbo.tlbStatistic s
			  inner join @RayonsForStatistics rfs
			  on rfs.idfsRayon = s.idfsArea and
				 s.intRowStatus = 0 and
				 s.idfsStatisticDataType = @idfsStatType_Population and
				 s.datStatisticStartDate = cast(rfs.maxYear as varchar(4)) + '-01-01' 
			group by rfs.idfsRayon ) as s
		on rfsu.idfsRayon = s.idfsRayon
	
	-- end of get statistics
end --if @Counter > 1 begin	   
   
   	
if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
drop table #ReportTable

create table #ReportTable
(	id int not null identity(1,1) primary key,
	idfsRayon bigint not null  foreign key references gisRayon(idfsRayon),	
	idfsDiagnosis bigint foreign key references trtDiagnosis(idfsDiagnosis),
	intTotal  int not null
)

if exists (select * from #Diagnosis)
	insert into #ReportTable (idfsRayon, idfsDiagnosis, intTotal)
	select 
		r.idfsRayon,
		d.idfsDiagnosis,
		0
	from (
		select gr.idfsRayon
		from gisRayon gr
		where gr.idfsRayon = @RayonID
		union
		select br.idfsRayon
		from @BorderRayons br
	) r
	cross join #Diagnosis d
else	   
	insert into #ReportTable (idfsRayon, idfsDiagnosis, intTotal)
	select 
		r.idfsRayon,
		null,
		0
	from (
		select gr.idfsRayon
		from gisRayon gr
		where gr.idfsRayon = @RayonID
		union
		select br.idfsRayon
		from @BorderRayons br
	) r	   
	   

		   
declare 
	@idfsRegion bigint, 
	@idfsRayon	bigint	   
	
declare cur cursor for
select distinct gr.idfsRegion, rt.idfsRayon
from #ReportTable rt
	inner join gisRayon gr
	on gr.idfsRayon = rt.idfsRayon

open cur

fetch next from cur into @idfsRegion, @idfsRayon

while @@FETCH_STATUS = 0 
begin	   
	exec [spRepHumBorderRayonsComparativeReport_Calculations] @StartDate, @FinishDate, @idfsRegion, @idfsRayon
	fetch next from cur into @idfsRegion, @idfsRayon
end

close cur
deallocate cur		   
   


insert into #ReportDiagnosisTable (strKey, idfsRayon, intCounter, intCounterValue,  strRayonName, blnTotalVisible, intRowNum)
select cast(rayon.idfsRayon as varchar) + '_' + cast(c.intCounter as varchar), rayon.idfsRayon, c.intCounter, c.intCounterValue, rf_rayon.name, @blnTotalVisible, rayon.intRowNum
from
	(
		select gr.idfsRayon, -1 as intRowNum
		from gisRayon gr
		where gr.idfsRayon = @RayonID
		union
		select br.idfsRayon, 0 as intRowNum
		from @BorderRayons br
	) as rayon
	inner join dbo.fnGisReference(@LangID, 19000002) rf_rayon
	on rf_rayon.idfsReference = rayon.idfsRayon
	
	cross join @Counters c
order by rayon.intRowNum	

update rdt set
	rdt.idfsDiagnosis_1	= dg1.idfsDiagnosis, 
	rdt.strDiagnosis_1	= dg1.strDiagnosisName, 
	rdt.strIDCCode_1	= dg1.strIDC10, 
	rdt.dblValue_1		= rt1.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt1
		inner join #Diagnosis dg1
		on dg1.idfsDiagnosis = rt1.idfsDiagnosis
		and dg1.intRowNum = 1
	on rdt.idfsRayon = rt1.idfsRayon

update rdt set
	rdt.idfsDiagnosis_2	= dg2.idfsDiagnosis, 
	rdt.strDiagnosis_2	= dg2.strDiagnosisName, 
	rdt.strIDCCode_2	= dg2.strIDC10, 
	rdt.dblValue_2		= rt2.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt2
		inner join #Diagnosis dg2
		on dg2.idfsDiagnosis = rt2.idfsDiagnosis
		and dg2.intRowNum = 2
	on rdt.idfsRayon = rt2.idfsRayon

update rdt set
	rdt.idfsDiagnosis_3	= dg3.idfsDiagnosis, 
	rdt.strDiagnosis_3	= dg3.strDiagnosisName, 
	rdt.strIDCCode_3	= dg3.strIDC10, 
	rdt.dblValue_3		= rt3.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt3
		inner join #Diagnosis dg3
		on dg3.idfsDiagnosis = rt3.idfsDiagnosis
		and dg3.intRowNum = 3
	on rdt.idfsRayon = rt3.idfsRayon
	
update rdt set
	rdt.idfsDiagnosis_4	= dg4.idfsDiagnosis, 
	rdt.strDiagnosis_4	= dg4.strDiagnosisName, 
	rdt.strIDCCode_4	= dg4.strIDC10, 
	rdt.dblValue_4		= rt4.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt4
		inner join #Diagnosis dg4
		on dg4.idfsDiagnosis = rt4.idfsDiagnosis
		and dg4.intRowNum = 4
	on rdt.idfsRayon = rt4.idfsRayon	
	
update rdt set
	rdt.idfsDiagnosis_5	= dg5.idfsDiagnosis, 
	rdt.strDiagnosis_5	= dg5.strDiagnosisName, 
	rdt.strIDCCode_5	= dg5.strIDC10, 
	rdt.dblValue_5		= rt5.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt5
		inner join #Diagnosis dg5
		on dg5.idfsDiagnosis = rt5.idfsDiagnosis
		and dg5.intRowNum = 5
	on rdt.idfsRayon = rt5.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_6	= dg6.idfsDiagnosis, 
	rdt.strDiagnosis_6	= dg6.strDiagnosisName, 
	rdt.strIDCCode_6	= dg6.strIDC10, 
	rdt.dblValue_6		= rt6.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt6
		inner join #Diagnosis dg6
		on dg6.idfsDiagnosis = rt6.idfsDiagnosis
		and dg6.intRowNum = 6
	on rdt.idfsRayon = rt6.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_7	= dg7.idfsDiagnosis, 
	rdt.strDiagnosis_7	= dg7.strDiagnosisName, 
	rdt.strIDCCode_7	= dg7.strIDC10, 
	rdt.dblValue_7		= rt7.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt7
		inner join #Diagnosis dg7
		on dg7.idfsDiagnosis = rt7.idfsDiagnosis
		and dg7.intRowNum = 7
	on rdt.idfsRayon = rt7.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_8	= dg8.idfsDiagnosis, 
	rdt.strDiagnosis_8	= dg8.strDiagnosisName, 
	rdt.strIDCCode_8	= dg8.strIDC10, 
	rdt.dblValue_8		= rt8.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt8
		inner join #Diagnosis dg8
		on dg8.idfsDiagnosis = rt8.idfsDiagnosis
		and dg8.intRowNum = 8
	on rdt.idfsRayon = rt8.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_9	= dg9.idfsDiagnosis, 
	rdt.strDiagnosis_9	= dg9.strDiagnosisName, 
	rdt.strIDCCode_9	= dg9.strIDC10, 
	rdt.dblValue_9		= rt9.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt9
		inner join #Diagnosis dg9
		on dg9.idfsDiagnosis = rt9.idfsDiagnosis
		and dg9.intRowNum = 9
	on rdt.idfsRayon = rt9.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_10	= dg10.idfsDiagnosis, 
	rdt.strDiagnosis_10	= dg10.strDiagnosisName, 
	rdt.strIDCCode_10	= dg10.strIDC10, 
	rdt.dblValue_10		= rt10.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt10
		inner join #Diagnosis dg10
		on dg10.idfsDiagnosis = rt10.idfsDiagnosis
		and dg10.intRowNum = 10
	on rdt.idfsRayon = rt10.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_11	= dg11.idfsDiagnosis, 
	rdt.strDiagnosis_11	= dg11.strDiagnosisName, 
	rdt.strIDCCode_11	= dg11.strIDC10, 
	rdt.dblValue_11		= rt11.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt11
		inner join #Diagnosis dg11
		on dg11.idfsDiagnosis = rt11.idfsDiagnosis
		and dg11.intRowNum = 11
	on rdt.idfsRayon = rt11.idfsRayon	

update rdt set
	rdt.idfsDiagnosis_12	= dg12.idfsDiagnosis, 
	rdt.strDiagnosis_12	= dg12.strDiagnosisName, 
	rdt.strIDCCode_12	= dg12.strIDC10, 
	rdt.dblValue_12		= rt12.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt12
		inner join #Diagnosis dg12
		on dg12.idfsDiagnosis = rt12.idfsDiagnosis
		and dg12.intRowNum = 12
	on rdt.idfsRayon = rt12.idfsRayon	


update rdt set
	rdt.dblTotal = rt_total.intTotal
from  #ReportDiagnosisTable rdt
	inner join #ReportTable rt_total
		on rdt.idfsRayon = rt_total.idfsRayon
		and rt_total.idfsDiagnosis is null
		


update rdt set
	rdt.dblTotal =
				isnull(rdt.dblValue_1, 0) + 
				isnull(rdt.dblValue_2, 0) + 
				isnull(rdt.dblValue_3, 0) + 
				isnull(rdt.dblValue_4, 0) + 
				isnull(rdt.dblValue_5, 0) + 
				isnull(rdt.dblValue_6, 0) + 
				isnull(rdt.dblValue_7, 0) +
				isnull(rdt.dblValue_8, 0) + 
				isnull(rdt.dblValue_9, 0) + 
				isnull(rdt.dblValue_10, 0) + 
				isnull(rdt.dblValue_11, 0) + 
				isnull(rdt.dblValue_12, 0) +  
				isnull(rdt.dblTotal, 0)
from  #ReportDiagnosisTable rdt
	
			
-- + total bottom            
insert into #ReportDiagnosisTable (strKey, intCounter, intCounterValue, idfsRayon, strRayonName, 
			idfsDiagnosis_1, strDiagnosis_1, strIDCCode_1, dblValue_1, 
			idfsDiagnosis_2, strDiagnosis_2, strIDCCode_2, dblValue_2, 
			idfsDiagnosis_3, strDiagnosis_3, strIDCCode_3, dblValue_3, 
			idfsDiagnosis_4, strDiagnosis_4, strIDCCode_4, dblValue_4, 
			idfsDiagnosis_5, strDiagnosis_5, strIDCCode_5, dblValue_5, 
			idfsDiagnosis_6, strDiagnosis_6, strIDCCode_6, dblValue_6, 
			idfsDiagnosis_7, strDiagnosis_7, strIDCCode_7, dblValue_7, 
			idfsDiagnosis_8, strDiagnosis_8, strIDCCode_8, dblValue_8,
			idfsDiagnosis_9, strDiagnosis_9, strIDCCode_9, dblValue_9,
			idfsDiagnosis_10, strDiagnosis_10, strIDCCode_10, dblValue_10,
			idfsDiagnosis_11, strDiagnosis_11, strIDCCode_11, dblValue_11,
			idfsDiagnosis_12, strDiagnosis_12, strIDCCode_12, dblValue_12,
			dblTotal, blnTotalVisible, intRowNum)
select  '-1_' + cast(intCounter as varchar), intCounter, intCounterValue, -1, '',
		idfsDiagnosis_1, strDiagnosis_1, strIDCCode_1, sum(dblValue_1),
		idfsDiagnosis_2, strDiagnosis_2, strIDCCode_2, sum(dblValue_2), 
		idfsDiagnosis_3, strDiagnosis_3, strIDCCode_3, sum(dblValue_3), 
		idfsDiagnosis_4, strDiagnosis_4, strIDCCode_4, sum(dblValue_4), 
		idfsDiagnosis_5, strDiagnosis_5, strIDCCode_5, sum(dblValue_5), 
		idfsDiagnosis_6, strDiagnosis_6, strIDCCode_6, sum(dblValue_6), 
		idfsDiagnosis_7, strDiagnosis_7, strIDCCode_7, sum(dblValue_7), 
		idfsDiagnosis_8, strDiagnosis_8, strIDCCode_8, sum(dblValue_8),
		idfsDiagnosis_9, strDiagnosis_9, strIDCCode_9, sum(dblValue_9),
		idfsDiagnosis_10, strDiagnosis_10, strIDCCode_10, sum(dblValue_10),
		idfsDiagnosis_11, strDiagnosis_11, strIDCCode_11, sum(dblValue_11),
		idfsDiagnosis_12, strDiagnosis_12, strIDCCode_12, sum(dblValue_12),
		sum(dblTotal), @blnTotalVisible, 999
from #ReportDiagnosisTable		
group by 
			idfsDiagnosis_1, strDiagnosis_1, strIDCCode_1,
			idfsDiagnosis_2, strDiagnosis_2, strIDCCode_2, 
			idfsDiagnosis_3, strDiagnosis_3, strIDCCode_3, 
			idfsDiagnosis_4, strDiagnosis_4, strIDCCode_4, 
			idfsDiagnosis_5, strDiagnosis_5, strIDCCode_5,
			idfsDiagnosis_6, strDiagnosis_6, strIDCCode_6, 
			idfsDiagnosis_7, strDiagnosis_7, strIDCCode_7, 
			idfsDiagnosis_8, strDiagnosis_8, strIDCCode_8, 
			idfsDiagnosis_9, strDiagnosis_9, strIDCCode_9, 
			idfsDiagnosis_10, strDiagnosis_10, strIDCCode_10, 
			idfsDiagnosis_11, strDiagnosis_11, strIDCCode_11, 
			idfsDiagnosis_12, strDiagnosis_12, strIDCCode_12,
			intCounter, intCounterValue


	update rt set 
		rt.dblValue_1 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_1 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_2 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_2 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_3 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_3 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_4 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_4 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_5 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_5 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_6 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_6 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_7 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_7 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_8 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_8 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_9 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_9 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_10 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_10 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_11 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_11 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblValue_12 = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblValue_12 / rfs.intPopulation) * rt.intCounterValue end,
		rt.dblTotal   = case isnull(rfs.intPopulation, 0) when 0 then null else (rt.dblTotal   / rfs.intPopulation) * rt.intCounterValue end
	from #ReportDiagnosisTable rt
		inner join @RayonsForStatistics rfs
		on rfs.idfsRayon = rt.idfsRayon
	where rt.intCounter > 1
		
	-- total bottom
	update rt set
		rt.dblValue_1 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_1 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_2 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_2 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_3 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_3 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_4 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_4 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_5 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_5 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_6 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_6 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_7 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_7 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_8 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_8 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_9 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_9 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_10 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_10 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_11 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_11 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblValue_12 = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblValue_12 / rfs.sum_Population) * rt.intCounterValue end,
		rt.dblTotal   = case isnull(rfs.sum_Population, 0) when 0 then null else (rt.dblTotal   / rfs.sum_Population) * rt.intCounterValue end
	from #ReportDiagnosisTable rt	
		cross join (
			select sum(rfs_s.intPopulation) as sum_Population
			from @RayonsForStatistics rfs_s
		) as rfs
	where rt.idfsRayon = -1
	and rt.intCounter > 1



   
 	select * from #ReportDiagnosisTable
 	order by intRowNum, strRayonName,  intCounter

 
 END

	
