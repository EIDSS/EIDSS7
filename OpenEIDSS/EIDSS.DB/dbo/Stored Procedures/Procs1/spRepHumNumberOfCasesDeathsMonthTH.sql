
--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec [spRepHumNumberOfCasesDeathsMonthTH_test] 
'ru', 
2016,
'<ItemList></ItemList>',
'<ItemList></ItemList>',
'<ItemList></ItemList>',
'<ItemList></ItemList>',
null

exec [spRepHumNumberOfCasesDeathsMonthTH] 
	@LangID = 'ru', 
	@Year = 2016,
	@Diagnosis='<ItemList></ItemList>',
	@ThaiRegion='<ItemList></ItemList>',
	@ThaiZone='<ItemList></ItemList>',
	@ThaiProvince='<ItemList></ItemList>',
	@CaseClassification = null
	
	
exec [spRepHumNumberOfCasesDeathsMonthTH] 
	@LangID = 'ru', 
	@Year = 2016,
	@Diagnosis='<ItemList></ItemList>',
	@ThaiRegion='<ItemList></ItemList>',
	@ThaiZone=N'<ItemList><Item key="56988220000000"/><Item key="56988230000000"/><Item key="56988240000000"/></ItemList>',
	@ThaiProvince='<ItemList></ItemList>',
	@CaseClassification = null	
	
	
exec [spRepHumNumberOfCasesDeathsMonthTH] 
	@LangID = 'ru', 
	@Year = 2016,
	@Diagnosis='<ItemList></ItemList>',
	@ThaiRegion='<ItemList><Item key="56988180000000"/></ItemList>',
	@ThaiZone='<ItemList></ItemList>',
	@ThaiProvince='<ItemList></ItemList>',
	@CaseClassification = null		
	
56924370000000	43809	Botulism
56924770000000	43741	Rabies
56924380000000	43711	Brucellosis	
exec [spRepHumNumberOfCasesDeathsMonthTH] 
	@LangID = 'ru', 
	@Year = 2016,
	@Diagnosis='<ItemList><Item key="56924370000000"/><Item key="56924770000000"/><Item key="56924380000000"/></ItemList>',
	@ThaiRegion='<ItemList><Item key="56988180000000"/></ItemList>',
	@ThaiZone='<ItemList></ItemList>',
	@ThaiProvince='<ItemList></ItemList>',
	@CaseClassification = null		
	
	
	
exec [spRepHumNumberOfCasesDeathsMonthTH] 
	@LangID = 'ru', 
	@Year = 2015,
	@Diagnosis='<ItemList></ItemList>',
	@ThaiRegion='<ItemList></ItemList>',
	@ThaiZone='<ItemList></ItemList>',
	@ThaiProvince='<ItemList><Item key="3809770000000"/><Item key="3809480000000"/></ItemList>',
	@CaseClassification = null
*/ 
 
CREATE PROCEDURE [dbo].[spRepHumNumberOfCasesDeathsMonthTH]
(
	 @LangID		as nvarchar(50),
	 @Year			as int, 
	 @Diagnosis		as XML,
	 @ThaiRegion	as XML,
	 @ThaiZone		as XML,
	 @ThaiProvince	as XML,
	 @CaseClassification as bigint = null
)
AS
begin	
	declare
 		@idfsLanguage				bigint, 
 		@SDDate						datetime,
 		@EDDate						datetime,
 		@idfsCustomReportType		bigint,
 		@iDiagnosis					int,
 		@iThaiRegion				int,
 		@iThaiZone					int,
 		@iThaiProvince				int,
 		@strTotal					nvarchar(500)
 		

	set @SDDate = (cast(@Year as varchar(4)) + '01' + '01')
	set @EDDate = dateadd(year, 1, (cast(@Year as varchar(4)) + '01' + '01'))
	
	declare @ReportTable table
	(
		idfReportingArea		bigint not null primary key,
		strReportingArea		nvarchar(200) not null,
		blnIsTotalOrSubtotal	bit not null,
		intTotalCases			int not null,
		intTotalDeaths			int not null,
		intJanCases				int not null,
		intJanDeaths			int not null,
		intFebCases				int not null,
		intFebDeaths			int not null,
		intMarCases				int not null,
		intMarDeaths			int not null,
		intAprCases				int not null,
		intAprDeaths			int not null,
		intMayCases				int not null,
		intMayDeaths			int not null,
		intJuneCases			int not null,
		intJuneDeaths			int not null,
		intJulyCases			int not null,
		intJulyDeaths			int not null,
		intAugCases				int not null,
		intAugDeaths			int not null,
		intSeptCases			int not null,
		intSeptDeaths			int not null,
		intOctCases				int not null,
		intOctDeaths			int not null,
		intNovCases				int not null,
		intNovDeaths			int not null,
		intDecCases				int not null,
		intDecDeaths			int not null,
		intOrder				int not null,
		intOrderTotal			int not null
		
	)
	if OBJECT_ID('tempdb.dbo.#ProvincesForReport') is not null 
	drop table #ProvincesForReport
  	create table  #ProvincesForReport 
 	(
 		idfsRegion				bigint not null,
 		idfsThaiRegion			bigint null,
 		idfsThaiZone			bigint null,
 		intOrder				int
 		primary key	(idfsRegion)
 	)	
 	
	if OBJECT_ID('tempdb.dbo.#DistrictsTable') is not null 
	drop table #DistrictsTable
	
	create table    #DistrictsTable		
 	(
 		idfsRayon			bigint not null primary key,
 		idfsRegion			bigint not null,
 		intOrder			int
 	) 	
 	
 	if OBJECT_ID('tempdb.dbo.#ReportCaseTableByRegion') is not null 
	drop table #ReportCaseTableByRegion

	create	table #ReportCaseTableByRegion
	(	idfsRegion			bigint not null,
		intMonth			int not null,
		intCaseCount		int not null,
		intCaseDeathsCount	int not null,
		primary key (idfsRegion, intMonth)
	)
	
 	if OBJECT_ID('tempdb.dbo.#ReportCaseTableByRayon') is not null 
	drop table #ReportCaseTableByRayon

	create	table #ReportCaseTableByRayon
	(	idfsRayon			bigint not null,
		intMonth			int not null,
		intCaseCount		int not null,
		intCaseDeathsCount	int not null,
		primary key (idfsRayon, intMonth)
	)	
	
 	declare  @ThaiRegionsTable	table
 	(
 		idfsThaiRegion			bigint primary key,
 		intOrder				int
 	)
	
 	declare    @ThaiZonesTable		table
 	(
 		idfsThaiZone			bigint primary key,
 		intOrder				int
 	)	

 	declare  @DiagnosisTable table
 	(
 		idfsDiagnosis bigint primary key
 	)	
 	

	
 	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
 
	set @idfsCustomReportType = 10290044	
 	
	
 	--@strTotal
	select @strTotal = fr.name
	from dbo.fnReference(@LangID, 19000132) fr
	where fr.strDefault = 'Total'
	
	
	if cast(@Diagnosis as varchar(max)) <> '<ItemList/>'
	begin 
		
		EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @Diagnosis

 		insert into @DiagnosisTable (
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
	end

	if cast(@ThaiRegion as varchar(max)) <> '<ItemList/>'
	begin 
		EXEC sp_xml_preparedocument @iThaiRegion OUTPUT, @ThaiRegion

 		insert into @ThaiRegionsTable (
 			idfsThaiRegion, intOrder
 		) 
 		select distinct RegionName.idfsReference, case when isnumeric(tbr.strBaseReferenceCode) = 1 then cast(tbr.strBaseReferenceCode as int) else 0 end
 		from OPENXML (@iThaiRegion, '/ItemList/Item') 
 		with (
 				[key] bigint '@key'
 		) tr
 		inner join dbo.fnReference(@LangID, 19000132) RegionName 
		on RegionName.idfsReference = tr.[key]
		
		inner join trtBaseReference tbr
		on tbr.idfsBaseReference = RegionName.idfsReference
		
		inner join trtGISBaseReferenceAttribute tgra
			inner join trtAttributeType tat
			on tat.idfAttributeType = tgra.idfAttributeType
			and tat.strAttributeTypeName = 'ThaiRegions'
		on case when isnumeric(cast(tgra.varValue as nvarchar(100))) = 1 then  cast(tgra.varValue as bigint) else null end = RegionName.idfsReference
 
		EXEC sp_xml_removedocument @iThaiRegion		
	end
	
	if cast(@ThaiZone as varchar(max)) <> '<ItemList/>'
	begin 
		EXEC sp_xml_preparedocument @iThaiZone OUTPUT, @ThaiZone

 		insert into @ThaiZonesTable (
 			idfsThaiZone, intOrder
 		) 
 		select distinct ZoneName.idfsReference, case when isnumeric(tbr.strBaseReferenceCode) = 1 then cast(tbr.strBaseReferenceCode as int) else 0 end
 		from OPENXML (@iThaiZone, '/ItemList/Item') 
 		with (
 				[key] bigint '@key'
 		) tz
 		inner join dbo.fnReference(@LangID, 19000132) ZoneName 
		on ZoneName.idfsReference = tz.[key]
		
		inner join trtBaseReference tbr
		on tbr.idfsBaseReference = ZoneName.idfsReference
		
		inner join trtGISBaseReferenceAttribute tgra
			inner join trtAttributeType tat
			on tat.idfAttributeType = tgra.idfAttributeType
			and tat.strAttributeTypeName = 'ThaiZones'
		on case when isnumeric(cast(tgra.varValue as nvarchar(100))) = 1 then  cast(tgra.varValue as bigint) else null end = ZoneName.idfsReference
 
		EXEC sp_xml_removedocument @iThaiZone		
	end
 	
	if cast(@ThaiProvince as varchar(max)) <> '<ItemList/>'
	begin 
		EXEC sp_xml_preparedocument @iThaiProvince OUTPUT, @ThaiProvince

 		insert into #ProvincesForReport (
 			idfsRegion, intOrder
 		) 
 		select RegionName.idfsReference, row_number () over (order by RegionName.name)
 		from OPENXML (@iThaiProvince, '/ItemList/Item') 
 		with (
 				[key] bigint '@key'
 		) rg
 		inner join dbo.fnGisReference(@LangID, 19000003) RegionName 
		on RegionName.idfsReference = rg.[key]
		
 		order by RegionName.name

		EXEC sp_xml_removedocument @iThaiProvince	
	end 	
 	
 	if not exists(select * from @ThaiZonesTable) and not exists (select * from @ThaiRegionsTable) and not exists (select * from #ProvincesForReport) 
 	begin
 		insert into @ThaiZonesTable (
 			idfsThaiZone, intOrder
 		) 
 		select distinct ZoneName.idfsReference, tbr.strBaseReferenceCode
 		from dbo.fnReference(@LangID, 19000132) ZoneName 
 		inner join trtBaseReference tbr
		on tbr.idfsBaseReference = ZoneName.idfsReference
		
 		inner join trtGISBaseReferenceAttribute tgra
			inner join trtAttributeType tat
			on tat.idfAttributeType = tgra.idfAttributeType
			and tat.strAttributeTypeName = 'ThaiZones'
		on cast(tgra.varValue as bigint) = ZoneName.idfsReference
 	end
 	
 	

 	-- Select provinces and districts
 	--Districts by province
 	if exists (select * from #ProvincesForReport) 
 	begin
 		insert into #DistrictsTable (idfsRayon, idfsRegion, intOrder)
 		select gr.idfsRayon, gr.idfsRegion, row_number () over (order by RegionName.name, RayonName.name)
 		from #ProvincesForReport pfr
 			inner join dbo.fnGisReference(@LangID, 19000003) RegionName 
			on RegionName.idfsReference = pfr.idfsRegion
			
 			inner join gisRayon gr
 				left join gisDistrictSubdistrict gds
 				on gds.idfsGeoObject = gr.idfsRayon
 			on gr.idfsRegion = pfr.idfsRegion
 			and gr.intRowStatus = 0
 			and gds.idfsParent is null
	 		
 			inner join dbo.fnGisReference(@LangID, 19000002) RayonName 
			on RayonName.idfsReference = gr.idfsRayon
 		order by RegionName.name, RayonName.name
 	end

	
 	-- Select provinces
 	-- by regions
	insert into #ProvincesForReport (idfsRegion, idfsThaiRegion, intOrder)
	select gr.idfsRegion, rt.idfsThaiRegion, cast(tgra.strAttributeItem as int)
	from trtGISBaseReferenceAttribute tgra
		inner join trtAttributeType tat
		on tat.idfAttributeType = tgra.idfAttributeType
		and tat.strAttributeTypeName = 'ThaiRegions'
			
		inner join gisRegion gr
		on gr.idfsRegion = tgra.idfsGISBaseReference
		and gr.intRowStatus = 0
	
		inner join @ThaiRegionsTable rt
		on rt.idfsThaiRegion = case when isnumeric(cast(tgra.varValue as nvarchar(100))) = 1 then cast(tgra.varValue as bigint) else null end
	
		left join #ProvincesForReport ps
		on ps.idfsRegion = gr.idfsRegion 
	where ps.idfsRegion is null
	
	-- by zones
	insert into #ProvincesForReport (idfsRegion, idfsThaiZone, intOrder)
	select gr.idfsRegion, rt.idfsThaiZone, cast(tgra.strAttributeItem as int)
	from trtGISBaseReferenceAttribute tgra
		inner join trtAttributeType tat
		on tat.idfAttributeType = tgra.idfAttributeType
		and tat.strAttributeTypeName = 'ThaiZones'
			
		inner join gisRegion gr
		on gr.idfsRegion = tgra.idfsGISBaseReference
		and gr.intRowStatus = 0
	
		inner join @ThaiZonesTable rt
		on rt.idfsThaiZone = case when isnumeric(cast(tgra.varValue as nvarchar(100))) = 1 then cast(tgra.varValue as bigint) else null end
	
		left join #ProvincesForReport ps
		on ps.idfsRegion = gr.idfsRegion 
	where ps.idfsRegion is null
	


	-- getting cases by month and provinces for th zones and regions
	if cast(@ThaiProvince as varchar(max)) = '<ItemList/>'
	begin
	--	select 1
		insert into	#ReportCaseTableByRegion
		(	idfsRegion,
			intMonth,
			intCaseCount,
			intCaseDeathsCount
		)
		select 
			gl.idfsRegion,
			month(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))),
			count(hc.idfHumanCase),
			sum(case when hc.idfsOutcome = 10770000000	/*outDied*/ then 1 else 0 end)
		from (tlbHumanCase hc
				inner join tlbHuman h
				on hc.idfHuman = h.idfHuman
				and h.intRowStatus = 0
				and (	@SDDate <= isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))
					and isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate)))) < @EDDate				
					) 
				and hc.intRowStatus = 0	)
				
				inner join tlbGeoLocation gl
				on h.idfCurrentResidenceAddress = gl.idfGeoLocation 
				and gl.idfsRegion is not null
				and gl.intRowStatus = 0
					
				inner join #ProvincesForReport pfr
				on pfr.idfsRegion = gl.idfsRegion
				
				left join @DiagnosisTable d
				on coalesce(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = d.idfsDiagnosis
				
			where 
				(isnull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) = @CaseClassification or @CaseClassification is null)
				and (d.idfsDiagnosis is not null or not exists(select * from @DiagnosisTable))
		group by	
			gl.idfsRegion,
			month(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate)))))
		option (recompile)
		

		
		-- adding provices without data
		insert into @ReportTable
		(	
			idfReportingArea		,
			strReportingArea		,
			blnIsTotalOrSubtotal	,
			intTotalCases			,
			intTotalDeaths			,
			
			intJanCases				,
			intJanDeaths			,
			intFebCases				,
			intFebDeaths			,
			intMarCases				,
			intMarDeaths			,
			intAprCases				,
			intAprDeaths			,
			intMayCases				,
			intMayDeaths			,
			intJuneCases			,
			intJuneDeaths			,
			intJulyCases			,
			intJulyDeaths			,
			intAugCases				,
			intAugDeaths			,
			intSeptCases			,
			intSeptDeaths			,
			intOctCases				,
			intOctDeaths			,
			intNovCases				,
			intNovDeaths			,
			intDecCases				,
			intDecDeaths			,
			
			intOrder				,
			intOrderTotal				
		)
		select 
			pfr.idfsRegion, ref_province.name,
			0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			pfr.intOrder, 0
		from #ProvincesForReport pfr
			inner join dbo.fnGisReference(@LangID, 19000003) ref_province
			on ref_province.idfsReference = pfr.idfsRegion

		-- update totalorder for provinces
		update rt set 
			rt.intOrderTotal = tzt.intOrder
		from @ReportTable rt
			inner join #ProvincesForReport pfr
			on rt.idfReportingArea = pfr.idfsRegion
			
			inner join @ThaiZonesTable tzt
			on tzt.idfsThaiZone = pfr.idfsThaiZone

		update rt set 
			rt.intOrderTotal = trt.intOrder
		from @ReportTable rt
			inner join #ProvincesForReport pfr
			on rt.idfReportingArea = pfr.idfsRegion
			
			inner join @ThaiRegionsTable trt
			on trt.idfsThaiRegion = pfr.idfsThaiRegion	
			
		-- update sum by provinces and month
		update rt set 
			intJanCases				= rct.intCaseCount,
			intJanDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 1
		
		update rt set 
			intFebCases				= rct.intCaseCount,
			intFebDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 2	
		
		update rt set 
			intMarCases				= rct.intCaseCount,
			intMarDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 3		
			
		update rt set 
			intAprCases				= rct.intCaseCount,
			intAprDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 4		
			
		update rt set 
			intMayCases				= rct.intCaseCount,
			intMayDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 5		
			
		update rt set 
			intJuneCases			= rct.intCaseCount,
			intJuneDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 6								
			
		update rt set 
			intJulyCases			= rct.intCaseCount,
			intJulyDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 7							
			
		update rt set 
			intAugCases				= rct.intCaseCount,
			intAugDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 8						
			
		update rt set 
			intSeptCases			= rct.intCaseCount,
			intSeptDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 9			
			
		update rt set 
			intOctCases				= rct.intCaseCount,
			intOctDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 10			
			
		update rt set 
			intNovCases				= rct.intCaseCount,
			intNovDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 11			
			
		update rt set 
			intDecCases				= rct.intCaseCount,
			intDecDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRegion rct
			on rt.idfReportingArea = rct.idfsRegion
			and rct.intMonth = 12		
			
		-- update totals by month
		update rt set 
			rt.intTotalCases = rt.intJanCases + rt.intFebCases + rt.intMarCases + rt.intAprCases + rt.intMayCases + rt.intJuneCases + rt.intJulyCases + rt.intAugCases + rt.intSeptCases + rt.intOctCases + rt.intNovCases + rt.intDecCases,
			rt.intTotalDeaths = rt.intJanDeaths + rt.intFebDeaths + rt.intMarDeaths + rt.intAprDeaths + rt.intMayDeaths + rt.intJuneDeaths + rt.intJulyDeaths + rt.intAugDeaths + rt.intSeptDeaths + rt.intOctDeaths + rt.intNovDeaths + rt.intDecDeaths
		from @ReportTable rt

			
		-- totals by regions or zones
		insert into @ReportTable
		(	
			idfReportingArea		,
			strReportingArea		,
			blnIsTotalOrSubtotal	,

			intTotalCases			,
			intTotalDeaths			,
			
			intJanCases				,
			intJanDeaths			,
			intFebCases				,
			intFebDeaths			,
			intMarCases				,
			intMarDeaths			,
			intAprCases				,
			intAprDeaths			,
			intMayCases				,
			intMayDeaths			,
			intJuneCases			,
			intJuneDeaths			,
			intJulyCases			,
			intJulyDeaths			,
			intAugCases				,
			intAugDeaths			,
			intSeptCases			,
			intSeptDeaths			,
			intOctCases				,
			intOctDeaths			,
			intNovCases				,
			intNovDeaths			,
			intDecCases				,
			intDecDeaths			,

			intOrderTotal			,
			intOrder			
		)
		select 
			isnull(pfr.idfsThaiZone, pfr.idfsThaiRegion),
			ref_zones_regions.name						,
			1											,
			
			sum(intTotalCases)							,
			sum(intTotalDeaths)							,
			
			sum(intJanCases)							,
			sum(intJanDeaths)							,
			sum(intFebCases)							,
			sum(intFebDeaths)							,
			sum(intMarCases)							,
			sum(intMarDeaths)							,
			sum(intAprCases)							,
			sum(intAprDeaths)							,
			sum(intMayCases)							,
			sum(intMayDeaths)							,
			sum(intJuneCases)							,
			sum(intJuneDeaths)							,
			sum(intJulyCases)							,
			sum(intJulyDeaths)							,
			sum(intAugCases)							,
			sum(intAugDeaths)							,
			sum(intSeptCases)							,
			sum(intSeptDeaths)							,
			sum(intOctCases)							,
			sum(intOctDeaths)							,
			sum(intNovCases)							,
			sum(intNovDeaths)							,
			sum(intDecCases)							,
			sum(intDecDeaths)							,
			
			isnull(tzt.intOrder, trt.intOrder)			,
			0		
		from @ReportTable rt
			inner join #ProvincesForReport pfr
			on pfr.idfsRegion = rt.idfReportingArea
			
			inner join dbo.fnReference(@LangID, 19000132) ref_zones_regions
			on isnull(pfr.idfsThaiZone, pfr.idfsThaiRegion) = ref_zones_regions.idfsReference
			
			left join @ThaiZonesTable tzt
			on tzt.idfsThaiZone = pfr.idfsThaiZone
			
			left join @ThaiRegionsTable trt
			on trt.idfsThaiRegion = pfr.idfsThaiRegion
		
		group by isnull(pfr.idfsThaiZone, pfr.idfsThaiRegion), ref_zones_regions.name, isnull(tzt.intOrder, trt.intOrder)									
	end
	else
	-- getting cases by month and districts for province
	if cast(@ThaiProvince as varchar(max)) <> '<ItemList/>'
	begin
	--	select 2
		insert into	#ReportCaseTableByRayon
		(	idfsRayon,
			intMonth,
			intCaseCount,
			intCaseDeathsCount
		)
		select 
			dt.idfsRayon,
			month(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))),
			count(hc.idfHumanCase),
			sum(case when hc.idfsOutcome = 10770000000	/*outDied*/ then 1 else 0 end)
		from (tlbHumanCase hc
				inner join tlbHuman h
				on hc.idfHuman = h.idfHuman
				and h.intRowStatus = 0
				and (	@SDDate <= isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate))))
					and isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate)))) < @EDDate				
					) 
				and hc.intRowStatus = 0	)
				
				inner join tlbGeoLocation gl
					left join gisDistrictSubdistrict gds
					on gl.idfsRayon = gds.idfsGeoObject
				on h.idfCurrentResidenceAddress = gl.idfGeoLocation 
				and gl.idfsRegion is not null
				and gl.intRowStatus = 0
					
				inner join #DistrictsTable dt
				on dt.idfsRayon = isnull(gds.idfsParent, gl.idfsRayon)
				
				left join @DiagnosisTable d
				on coalesce(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) = d.idfsDiagnosis
				
			where 
				
				(isnull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) = @CaseClassification or @CaseClassification is null)
				and (d.idfsDiagnosis is not null or not exists(select * from @DiagnosisTable))
		group by	
			dt.idfsRayon,
			month(isnull(hc.datOnSetDate, isnull(hc.datFinalDiagnosisDate, isnull(hc.datTentativeDiagnosisDate, isnull(hc.datNotificationDate, hc.datEnteredDate)))))
		option (recompile)
		
		
		-- adding provices without data
		insert into @ReportTable
		(	
			idfReportingArea		,
			strReportingArea		,
			blnIsTotalOrSubtotal	,
			intTotalCases			,
			intTotalDeaths			,
			
			intJanCases				,
			intJanDeaths			,
			intFebCases				,
			intFebDeaths			,
			intMarCases				,
			intMarDeaths			,
			intAprCases				,
			intAprDeaths			,
			intMayCases				,
			intMayDeaths			,
			intJuneCases			,
			intJuneDeaths			,
			intJulyCases			,
			intJulyDeaths			,
			intAugCases				,
			intAugDeaths			,
			intSeptCases			,
			intSeptDeaths			,
			intOctCases				,
			intOctDeaths			,
			intNovCases				,
			intNovDeaths			,
			intDecCases				,
			intDecDeaths			,
			
			intOrder				,
			intOrderTotal				
		)
		select 
			dt.idfsRayon, ref_district.name,
			0, 0, 0, 
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
			dt.intOrder, 0
		from #DistrictsTable dt
			inner join dbo.fnGisReference(@LangID, 19000002) ref_district
			on ref_district.idfsReference = dt.idfsRayon

		-- update totalorder for districts
		-- by province
		update rt set 
			rt.intOrderTotal = pfr.intOrder
		from @ReportTable rt
			inner join #DistrictsTable dt
			on rt.idfReportingArea = dt.idfsRayon
			
			inner join #ProvincesForReport pfr
			on dt.idfsRegion = pfr.idfsRegion
			
		
		-- update sum by districts and month
		update rt set 
			intJanCases				= rct.intCaseCount,
			intJanDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 1
		
		update rt set 
			intFebCases				= rct.intCaseCount,
			intFebDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 2	
		
		update rt set 
			intMarCases				= rct.intCaseCount,
			intMarDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 3		
			
		update rt set 
			intAprCases				= rct.intCaseCount,
			intAprDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 4		
			
		update rt set 
			intMayCases				= rct.intCaseCount,
			intMayDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 5		
			
		update rt set 
			intJuneCases			= rct.intCaseCount,
			intJuneDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 6								
			
		update rt set 
			intJulyCases			= rct.intCaseCount,
			intJulyDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 7							
			
		update rt set 
			intAugCases				= rct.intCaseCount,
			intAugDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 8						
			
		update rt set 
			intSeptCases			= rct.intCaseCount,
			intSeptDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 9			
			
		update rt set 
			intOctCases				= rct.intCaseCount,
			intOctDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 10			
			
		update rt set 
			intNovCases				= rct.intCaseCount,
			intNovDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 11			
			
		update rt set 
			intDecCases				= rct.intCaseCount,
			intDecDeaths			= rct.intCaseDeathsCount
		from @ReportTable rt
			inner join #ReportCaseTableByRayon rct
			on rt.idfReportingArea = rct.idfsRayon
			and rct.intMonth = 12		
			
		-- update totals by month
		update rt set 
			rt.intTotalCases = rt.intJanCases + rt.intFebCases + rt.intMarCases + rt.intAprCases + rt.intMayCases + rt.intJuneCases + rt.intJulyCases + rt.intAugCases + rt.intSeptCases + rt.intOctCases + rt.intNovCases + rt.intDecCases,
			rt.intTotalDeaths = rt.intJanDeaths + rt.intFebDeaths + rt.intMarDeaths + rt.intAprDeaths + rt.intMayDeaths + rt.intJuneDeaths + rt.intJulyDeaths + rt.intAugDeaths + rt.intSeptDeaths + rt.intOctDeaths + rt.intNovDeaths + rt.intDecDeaths
		from @ReportTable rt

			
		-- totals by provinces
		insert into @ReportTable
		(	
			idfReportingArea		,
			strReportingArea		,
			blnIsTotalOrSubtotal	,

			intTotalCases			,
			intTotalDeaths			,
			
			intJanCases				,
			intJanDeaths			,
			intFebCases				,
			intFebDeaths			,
			intMarCases				,
			intMarDeaths			,
			intAprCases				,
			intAprDeaths			,
			intMayCases				,
			intMayDeaths			,
			intJuneCases			,
			intJuneDeaths			,
			intJulyCases			,
			intJulyDeaths			,
			intAugCases				,
			intAugDeaths			,
			intSeptCases			,
			intSeptDeaths			,
			intOctCases				,
			intOctDeaths			,
			intNovCases				,
			intNovDeaths			,
			intDecCases				,
			intDecDeaths			,

			intOrderTotal			,
			intOrder			
		)
		select 
			dt.idfsRegion								,
			ProvinceName.name							,
			1											,
			
			sum(intTotalCases)							,
			sum(intTotalDeaths)							,
			
			sum(intJanCases)							,
			sum(intJanDeaths)							,
			sum(intFebCases)							,
			sum(intFebDeaths)							,
			sum(intMarCases)							,
			sum(intMarDeaths)							,
			sum(intAprCases)							,
			sum(intAprDeaths)							,
			sum(intMayCases)							,
			sum(intMayDeaths)							,
			sum(intJuneCases)							,
			sum(intJuneDeaths)							,
			sum(intJulyCases)							,
			sum(intJulyDeaths)							,
			sum(intAugCases)							,
			sum(intAugDeaths)							,
			sum(intSeptCases)							,
			sum(intSeptDeaths)							,
			sum(intOctCases)							,
			sum(intOctDeaths)							,
			sum(intNovCases)							,
			sum(intNovDeaths)							,
			sum(intDecCases)							,
			sum(intDecDeaths)							,
			
			pfr.intOrder								,
			0		
		from @ReportTable rt
			inner join #DistrictsTable dt
			on dt.idfsRayon = rt.idfReportingArea
		
			inner join #ProvincesForReport pfr
			on pfr.idfsRegion = dt.idfsRegion
			
			inner join dbo.fnGisReference(@LangID, 19000003) ProvinceName
			on dt.idfsRegion = ProvinceName.idfsReference
			
		group by dt.idfsRegion, ProvinceName.name, pfr.intOrder									
	end
	
																								
	
	
 	
	-- total
	insert into @ReportTable
	(	
		idfReportingArea		,
		strReportingArea		,
		blnIsTotalOrSubtotal	,

		intTotalCases			,
		intTotalDeaths			,
		
		intJanCases				,
		intJanDeaths			,
		intFebCases				,
		intFebDeaths			,
		intMarCases				,
		intMarDeaths			,
		intAprCases				,
		intAprDeaths			,
		intMayCases				,
		intMayDeaths			,
		intJuneCases			,
		intJuneDeaths			,
		intJulyCases			,
		intJulyDeaths			,
		intAugCases				,
		intAugDeaths			,
		intSeptCases			,
		intSeptDeaths			,
		intOctCases				,
		intOctDeaths			,
		intNovCases				,
		intNovDeaths			,
		intDecCases				,
		intDecDeaths			,

		intOrderTotal			,
		intOrder			
	)
	select
		-1,
		isnull(@strTotal, N'Total'),
		1,

		isnull(sum(intTotalCases), 0)							,
		isnull(sum(intTotalDeaths), 0)							,
		
		isnull(sum(intJanCases), 0)								,
		isnull(sum(intJanDeaths), 0)							,
		isnull(sum(intFebCases), 0)								,
		isnull(sum(intFebDeaths), 0)							,
		isnull(sum(intMarCases), 0)								,
		isnull(sum(intMarDeaths), 0)							,
		isnull(sum(intAprCases), 0)								,
		isnull(sum(intAprDeaths), 0)							,
		isnull(sum(intMayCases), 0)								,
		isnull(sum(intMayDeaths), 0)							,
		isnull(sum(intJuneCases), 0)							,
		isnull(sum(intJuneDeaths), 0)							,
		isnull(sum(intJulyCases), 0)							,
		isnull(sum(intJulyDeaths), 0)							,
		isnull(sum(intAugCases), 0)								,
		isnull(sum(intAugDeaths), 0)							,
		isnull(sum(intSeptCases), 0)							,
		isnull(sum(intSeptDeaths), 0)							,
		isnull(sum(intOctCases), 0)								,
		isnull(sum(intOctDeaths), 0)							,
		isnull(sum(intNovCases), 0)								,
		isnull(sum(intNovDeaths), 0)							,
		isnull(sum(intDecCases), 0)								,
		isnull(sum(intDecDeaths), 0)							,

		-1														,
		-1
	from @ReportTable rt
	where rt.blnIsTotalOrSubtotal = 1 	
 	
 	select * from @ReportTable rt
 	order by  rt.intOrderTotal, rt.intOrder
end
