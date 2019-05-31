
  --##SUMMARY 
 
 --##REMARKS Author: 
 --##REMARKS Create date: 
 
 --##RETURNS Don't use 
 
 /*
 --Example of a call of procedure:
 
 exec [spRepHumNumberOfCasesDeathsMorbidityMortalityTH] 
 'ru', 
 N'2008-04-29T00:00:00',
 N'2015-05-29T00:00:00',
 '<ItemList></ItemList>',
 '<ItemList></ItemList>',
 '<ItemList></ItemList>',
 '<ItemList></ItemList>',
 null
 
-- ThaiRegion!
declare @p4 xml
set @p4=convert(xml,N'<ItemList></ItemList>')
declare @p5 xml
set @p5=convert(xml,N'<ItemList><Item key="56988180000000"/><Item key="56988190000000"/><Item key="56988200000000"/><Item key="56988210000000"/></ItemList>')
--set @p5=convert(xml,N'<ItemList><Item key="56988180000000"/></ItemList>')
exec dbo.spRepHumNumberOfCasesDeathsMorbidityMortalityTH 
	@LangID=N'en',
	@SD='2015-01-01 00:00:00',
	@ED='2015-11-11 00:00:00',
	@Diagnosis=@p4,
	@ThaiRegion=@p5,
	@ThaiZone='<ItemList></ItemList>',
	@ThaiProvince = '<ItemList></ItemList>',
	@CaseClassification=null


-- ThaiZone!
declare @p4 xml
set @p4=convert(xml,N'<ItemList><Item key="56924280000000"/><Item key="56924290000000"/><Item key="56924300000000"/></ItemList>')
set @p4=convert(xml,N'<ItemList></ItemList>')
declare @p6 xml
set @p6=convert(xml,N'<ItemList><Item key="56988220000000"/><Item key="56988230000000"/><Item key="56988240000000"/><Item key="56988250000000"/><Item key="56988260000000"/><Item key="56988270000000"/><Item key="56988280000000"/><Item key="56988290000000"/><Item key="56988300000000"/><Item key="56988310000000"/><Item key="56988320000000"/><Item key="56988330000000"/><Item key="56988340000000"/></ItemList>')
--set @p6=convert(xml,N'<ItemList><Item key="56988220000000"/><Item key="56988230000000"/><Item key="56988240000000"/></ItemList>')
exec dbo.spRepHumNumberOfCasesDeathsMorbidityMortalityTH
 
	@LangID=N'en',
	@SD='2010-01-01 00:00:00',
	@ED='2015-11-11 00:00:00',
	@Diagnosis=@p4,
	@ThaiRegion='<ItemList></ItemList>',
	@ThaiZone=@p6,
	@ThaiProvince='<ItemList></ItemList>',
	@CaseClassification=null

 
-- ThaiZone! with diagnosis and case classification
56924370000000	43809	Botulism
56924770000000	43741	Rabies
56924380000000	43711	Brucellosis


declare @p4 xml
set @p4=convert(xml,N'<ItemList><Item key="56924370000000"/><Item key="56924770000000"/><Item key="56924380000000"/></ItemList>')
--set @p4=convert(xml,N'<ItemList><Item key="56924370000000"/></ItemList>')

declare @p6 xml
set @p6=convert(xml,N'<ItemList><Item key="56988220000000"/><Item key="56988230000000"/><Item key="56988240000000"/></ItemList>')
exec dbo.spRepHumNumberOfCasesDeathsMorbidityMortalityTH
	@LangID=N'en',
	@SD='1900-01-01 00:00:00',
	@ED='2016-01-01 00:00:00',
	@Diagnosis=@p4,
	@ThaiRegion='<ItemList></ItemList>',
	@ThaiZone=@p6,
	@ThaiProvince='<ItemList></ItemList>',
	@ThaiDistrict='<ItemList></ItemList>', --'<ItemList><Item key="3883640000000"/></ItemList>',----'<ItemList></ItemList>',
	@CaseClassification=null

 
 -- Provice and Districts
 	------jl: case clarification:  350000000,360000000,380000000 confirmed, Probable,Suspect
 exec dbo.spRepHumNumberOfCasesDeathsMorbidityMortalityTH
	@LangID=N'en',
	@SD='2000-01-01 00:00:00',
	@ED='2018-12-01 00:00:00',
	@Diagnosis='<ItemList></ItemList>',
	@ThaiRegion='<ItemList></ItemList>',
	@ThaiZone='<ItemList></ItemList>',
	@ThaiProvince='<ItemList></ItemList>',   ---'<ItemList><Item key="3809770000000"/><Item key="3809480000000"/></ItemList>',
	@ThaiDistrict='<ItemList></ItemList>', --'<ItemList><Item key="3883640000000"/></ItemList>',----'<ItemList></ItemList>',
	@CaseClassification= 350000000  ---null
	
	
 */ 
  
 CREATE PROCEDURE [dbo].[spRepHumNumberOfCasesDeathsMorbidityMortalityTH]
 (
 	 @LangID		as nvarchar(50),
 	 @SD			as datetime, 
 	 @ED			as datetime,
 	 @Diagnosis		as XML,
 	 @ThaiRegion	as XML,
 	 @ThaiZone		as XML,
 	 @ThaiProvince	as XML,
	 @ThaiDistrict	AS XML,
 	 @CaseClassification as bigint = null
 )
 AS
 BEGIN	
 
 	DECLARE
 		@idfsLanguage						bigint, 
 		@SDDate								datetime,
 		@EDDate								datetime,
 		@idfsStatType_PopulationByProvince	bigint,
 		@idfsStatType_PopulationByDistrict	bigint ,
 		@idfsCustomReportType				bigint,
 		@iDiagnosis							int,
 		@iThaiRegion						int,
 		@iThaiZone							int,
 		@iThaiProvince						int,
		@iThaiDistrict						INT, -- MCW Added to process district list
 		@Year								int,
 		@strTotal							nvarchar(500)
 		
 	declare @ReportTable table
 	(
		
 		idfReportingArea		bigint not null,
 		strReportingArea		nvarchar(200) null,
 		blnIsTotalOrSubtotal	bit not null,
 		intCases				int not null default (0),
 		intDeath				int not null default (0),
 		intPopulation			int null	 default (0),
 		intOrderTotal			int not null default (0),
 		intOrder				int not null default (0)
 	)
	
	if OBJECT_ID('tempdb.dbo.#ProvincesForReport') is not null 
	drop table #ProvincesForReport
  	create table  #ProvincesForReport 
 	(
 		idfsRegion				bigint not null,
 		idfsThaiRegion			bigint null,
 		idfsThaiZone			bigint  null,
 		maxYear					int,
 		intPopulation			int,
 		intOrder				int
 		primary key	(idfsRegion)
 	)	
 	
 	declare  @ThaiRegionsTable	table
 	(
 		idfsThaiRegion			bigint primary key,
 		intPopulation			int,
 		intOrder				int
 	)
	
 	declare    @ThaiZonesTable		table
 	(
 		idfsThaiZone			bigint primary key,
 		intPopulation			int,
 		intOrder				int
 	)
	
	DECLARE @ThaiDistrictTable TABLE
	(
		idfsThaiDistrict BIGINT

	)	

	if OBJECT_ID('tempdb.dbo.#DistrictsTable') is not null 
	drop table #DistrictsTable
	
	create table    #DistrictsTable		
 	(
 		idfsRayon			bigint primary key,
 		idfsRegion			bigint,
 		maxYear				int,
 		intPopulation		int,
 		intOrder			int
 	)
 	
 	declare  @DiagnosisTable table
 	(
 		idfsDiagnosis bigint primary key
 	)		
	
	DECLARE @HumanCase TABLE
	(
		idfHumanCase BIGINT,
		idfsDiagnosis BIGINT,
		strDiagnsosis VARCHAR(300),
		idfHuman BIGINT,
		idfsOutcome BIGINT,
		strOutcome VARCHAR(100),
		DateOfRecord DATETIME,
		DiagnosisYear INT,
		idfsSubDist BIGINT,
		strSubDist VARCHAR(300),
		idfsDistrict BIGINT,
		strDistrict VARCHAR(300),
		idfsProvince BIGINT,
		strProvince VARCHAR(300),
		IntOrder INT
	)

	DECLARE @ProvinceDistrict TABLE
	(
		idfsDistrict BIGINT,
		strDistrict VARCHAR(300),
		idfsSubDistrict BIGINT,
		strSubDistrict VARCHAR(300),
		MaxYear INT,
		intPopulation BIGINT,
		idfsProvince BIGINT,
		strProvince VARCHAR(300),
		intOrder INT

	)

 	set @SDDate = dbo.fn_SetMinMaxTime(@SD, 0)
 	set @EDDate = dbo.fn_SetMinMaxTime(@ED, 1)
 	
 	set @Year = year(@EDDate)
 	
 	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
 
	set @idfsCustomReportType = 10290043	--Number of cases, deaths, morbidity rate, mortality rate, case fatality rate
 	
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
	ELSE -- If there is no diagnosis list, create report on all diagnoses
	BEGIN
		INSERT INTO @DiagnosisTable 
		SELECT 
			D.idfsDiagnosis

		FROM dbo.trtDiagnosis D
		JOIN dbo.trtBaseReference DR on DR.idfsBaseReference = D.idfsDiagnosis
		WHERE D.intRowStatus = 0
	END

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
 	
 	-- Select provinces and districts for getting statistics
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

	
 	-- by regions
 	if exists (select * from @ThaiRegionsTable)
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
	if exists (select * from @ThaiZonesTable)
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
	
	-- Province Stats
	-- determine for the province the maximum year (less than or equal to the reporting year) for which there is statistics.

	update rfstat set
	   rfstat.maxYear = mrfs.maxYear
	from #ProvincesForReport rfstat
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRegion
		from #ProvincesForReport  rfs    
		  inner join dbo.tlbStatistic stat
		  on stat.idfsArea = rfs.idfsRegion 
		  and stat.intRowStatus = 0
		  and stat.idfsStatisticDataType = @idfsStatType_PopulationByProvince
		  and year(stat.datStatisticStartDate) <= @Year
		group by rfs.idfsRegion
		) as mrfs
		on rfstat.idfsRegion = mrfs.idfsRegion

	-- determine the statistics for each province
	update rfsu set
		rfsu.intPopulation = s.sumValue
	from #ProvincesForReport rfsu
		inner join (select SUM(cast(varValue as int)) as sumValue, rfs.idfsRegion
			from dbo.tlbStatistic s
			  inner join #ProvincesForReport rfs
			  on rfs.idfsRegion = s.idfsArea and
				 s.intRowStatus = 0 and
				 s.idfsStatisticDataType = @idfsStatType_PopulationByProvince and
				 s.datStatisticStartDate = cast(rfs.maxYear as varchar(4)) + '-01-01' 
			group by rfs.idfsRegion ) as s
		on rfsu.idfsRegion = s.idfsRegion
		
	-- statistics for the districts
	-- determine for the districts the maximum year (less than or equal to the reporting year) for which there is statistics.
	update dt set
	   dt.maxYear = mrfs.maxYear
	from #DistrictsTable dt
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, dts.idfsRayon
		from #DistrictsTable  dts    
		  inner join dbo.tlbStatistic stat
		  on stat.idfsArea = dts.idfsRayon 
		  and stat.intRowStatus = 0
		  and stat.idfsStatisticDataType = @idfsStatType_PopulationByDistrict
		  and year(stat.datStatisticStartDate) <= @Year
		group by dts.idfsRayon
		) as mrfs
		on dt.idfsRayon = mrfs.idfsRayon
	                                      	
	-- determine the statistics for each district
	update dt set
		dt.intPopulation = s.sumValue
	from #DistrictsTable dt
		inner join (select SUM(cast(varValue as int)) as sumValue, dts.idfsRayon
			from dbo.tlbStatistic s
			  inner join #DistrictsTable dts
			  on dts.idfsRayon = s.idfsArea and
				 s.intRowStatus = 0 and
				 s.idfsStatisticDataType = @idfsStatType_PopulationByDistrict and
				 s.datStatisticStartDate = cast(dts.maxYear as varchar(4)) + '-01-01' 
			group by dts.idfsRayon ) as s
		on dt.idfsRayon = s.idfsRayon
		
				
	
	-- calculate statistics for regions
	update u_trt set
		u_trt.intPopulation = s.sum_p
	from @ThaiRegionsTable u_trt
		inner join 
		( 
			select tr.idfsThaiRegion, sum (pr.intPopulation) as sum_p
			from	@ThaiRegionsTable tr
				inner join #ProvincesForReport pr
				on pr.idfsThaiRegion = tr.idfsThaiRegion
			where not exists 
				(
						select * 
						from #ProvincesForReport pfr 
						where	pfr.idfsThaiRegion = tr.idfsThaiRegion 
								and pfr.intPopulation is null
				)
			group by tr.idfsThaiRegion
		) as s
		on s.idfsThaiRegion = u_trt.idfsThaiRegion
	
	-- calculate statistics for zones
	update u_tzt set
		u_tzt.intPopulation = s.sum_p
	from @ThaiZonesTable u_tzt
		inner join 
		( 
			select tz.idfsThaiZone, sum (pr.intPopulation) as sum_p
			from	@ThaiZonesTable tz
				inner join #ProvincesForReport pr
				on pr.idfsThaiZone = tz.idfsThaiZone
			where not exists 
				(
						select * 
						from #ProvincesForReport pfr 
						where	pfr.idfsThaiZone = tz.idfsThaiZone 
								and pfr.intPopulation is null
				)
			group by tz.idfsThaiZone
		) as s
		on s.idfsThaiZone = u_tzt.idfsThaiZone
	--------------------------------------------------------------------------------------------------------------------
    -- MCW edit - put the districts and subdistricts into a table if they're passed to the stored proc
    -- Check if @ThaiDistrictTable is populated later
	IF CAST(@ThaiDistrict AS VARCHAR(MAX)) <> '<ItemList/>' -- Run the DistrictSubDistrictReport, so we need to get SubDistricts for the Districts selected
	BEGIN 
		
		EXEC sp_xml_preparedocument @iThaiDistrict OUTPUT, @ThaiDistrict

 		INSERT INTO @ThaiDistrictTable 
 		SELECT 
			DISTINCT DistrictName.idfsReference
		 
 		FROM OPENXML (@iThaiDistrict, '/ItemList/Item') 
 		WITH (
 				[key] BIGINT '@key'
 		) tr
		INNER JOIN dbo.fnGisExtendedReferenceRepair(@LangID,19000002) DistrictName ON DistrictName.idfsReference = tr.[key]

		EXEC sp_xml_removedocument @iThaiDistrict	;

		-- Get all the districts
		WITH CTE_DistrictTable AS
		(
			SELECT
				D.idfsThaiDistrict AS idfsDistrict,
				DistRef.strDefault AS strDistrict,
				NULL AS idfsThaiSubDistrict,
				NULL AS strSubDistrict,
				0 AS MaxYear,
				0 AS intPopulation,
				Province.idfsRegion AS idfsProvince,
				ProvName.strDefault AS strProvince

			FROM @ThaiDistrictTable D
			JOIN dbo.gisBaseReference DistRef ON DistRef.idfsGISBaseReference = D.idfsThaiDistrict
			JOIN dbo.gisRayon Province on Province.idfsRayon = D.idfsThaiDistrict
			JOIN dbo.gisBaseReference ProvName on ProvName.idfsGISBaseReference = Province.idfsRegion

		),

		--Add the SubDistricts
		CTE_SubDistrictTable AS
		(
			SELECT
				D.idfsThaiDistrict AS idfsDistrict,
				DistRef.strDefault AS strDistrict,
				SubDistrict.idfsGeoObject AS idfsSubDistrict,
				SubDistRef.strDefault AS strSubDistrict,
				0 AS MaxYear,
				0 AS intPopulation,
				Province.idfsRegion AS idfsProvince,
				ProvName.strDefault AS strProvince

			FROM @ThaiDistrictTable D
			JOIN dbo.gisBaseReference DistRef ON DistRef.idfsGISBaseReference = D.idfsThaiDistrict
			JOIN dbo.gisDistrictSubdistrict DistOnly on DistOnly.idfsGeoObject = D.idfsThaiDistrict
			LEFT JOIN gisDistrictSubdistrict AS	SubDistrict ON SubDistrict.idfsParent = D.idfsThaiDistrict
			JOIN dbo.gisBaseReference SubDistRef ON SubDistRef.idfsGISBaseReference = SubDistrict.idfsGeoObject
			JOIN dbo.gisRayon Province on Province.idfsRayon = SubDistrict.idfsGeoObject
			JOIN dbo.gisBaseReference ProvName on ProvName.idfsGISBaseReference = Province.idfsRegion

		)

		INSERT INTO @ProvinceDistrict
		(
			idfsDistrict,
			strDistrict,
			idfsSubDistrict,
			strSubDistrict,
			MaxYear,
			intPopulation,
			idfsProvince,
			strProvince,
			intOrder
		)
		
		SELECT 
			Locations.*,
			ROW_NUMBER() OVER (ORDER BY Locations.strDistrict, Locations.strSubDistrict) AS intOrder

		FROM
		(
			SELECT * FROM CTE_DistrictTable
			UNION ALL
			SELECT * FROM CTE_SubDistrictTable
		) AS Locations;
		
		WITH CTE_Population AS
		(		
			SELECT 
				CONVERT(BIGINT, S.varValue) AS intPopulation,
				S.idfsArea,
				A.strDefault AS strLocation,
				R.strDefault AS strDataType,
				MAX(YEAR(S.datStatisticStartDate)) AS MaxYear

		
			FROM dbo.tlbStatistic  S
			JOIN dbo.trtBaseReference R on R.idfsBaseReference = idfsStatisticDataType
			JOIN dbo.gisBaseReference A on A.idfsGISBaseReference = S.idfsArea
	
			WHERE R.strDefault = 'Population by District' 
			OR R.strDefault = 'Population'
			AND YEAR(S.datStatisticStartDate) <= @Year
			AND S.intRowStatus = 0

			GROUP BY 
				CONVERT(BIGINT, S.varValue),
				S.idfsArea,
				A.strDefault,
				R.strDefault
		)

		UPDATE DT
		SET DT.MaxYear = Pop.MaxYear,
			DT.intPopulation = Pop.intPopulation

		FROM  @ProvinceDistrict DT
		INNER JOIN CTE_Population Pop on Pop.idfsArea = CASE WHEN DT.idfsSubDistrict IS NULL THEN DT.idfsDistrict ELSE DT.idfsSubDistrict END

		--BEGIN - TABLE to store all human case data for the districts passed to stored proc
 		INSERT INTO @HumanCase
		SELECT 
		  hc.idfHumanCase,
		  dr.idfsBaseReference as idfsDiagnosis,
		  dr.strDefault AS strDiagnosis,
		  hc.idfHuman, 
		  hc.idfsOutcome,
		  O.strDefault AS strOutcome,
		  COALESCE(hc.datOnSetDate,hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate) AS DiagnosisDate,
		  DATEPART(YEAR, COALESCE(hc.datOnSetDate,hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate)) DiagnosisYear,
		  CASE WHEN SubDistrict.idfsParent IS NOT NULL THEN SubDistrict.idfsGeoObject ELSE NULL END AS idfsSubDistrict,
		  SubRef.strDefault AS strSubDistrict,
		  CASE WHEN SubDistrict.idfsParent IS NULL THEN SubDistrict.idfsGeoObject ELSE SubDistrict.idfsParent END AS idfsDistrict,
		  DistRef.strDefault AS strDistrict,
		  gl.idfsRegion,
		  Region.strDefault as strProvince,
		  ROW_NUMBER() OVER (ORDER BY DistRef.strDefault, SubRef.strDefault)
   
		FROM dbo.tlbHumanCase hc
		JOIN dbo.tlbHuman h ON h.idfHuman = hc.idfHuman
		JOIN trtBaseReference dr ON dr.idfsBaseReference = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
		JOIN dbo.tlbGeoLocation gl on gl.idfGeoLocation = h.idfCurrentResidenceAddress
		JOIN dbo.fnGisExtendedReferenceRepair(@LangID,19000002) AS SubDistrictRef ON SubDistrictRef.idfsReference = gl.idfsRayon 
		LEFT JOIN gisDistrictSubdistrict AS	SubDistrict ON SubDistrict.idfsGeoObject = gl.idfsRayon 
		FULL OUTER JOIN dbo.trtBaseReference O on O.idfsBaseReference = hc.idfsOutcome
		FULL OUTER JOIN dbo.gisBaseReference SubRef ON SubRef.idfsGISBaseReference =  CASE WHEN SubDistrict.idfsParent IS NOT NULL THEN SubDistrict.idfsGeoObject ELSE NULL END
		FULL OUTER JOIN dbo.gisBaseReference DistRef ON DistRef.idfsGISBaseReference = CASE WHEN SubDistrict.idfsParent IS NULL THEN SubDistrict.idfsGeoObject ELSE SubDistrict.idfsParent END
		JOIN gisBaseReference Region on Region.idfsGISBaseReference = gl.idfsRegion

		WHERE CASE WHEN SubDistrict.idfsParent IS NULL THEN SubDistrict.idfsGeoObject ELSE SubDistrict.idfsParent END IN 
				(SELECT CASE WHEN idfsSubDistrict IS NULL THEN idfsDistrict ELSE idfsSubDistrict END FROM @ProvinceDistrict
				 WHERE idfsDistrict IS NOT NULL)
		----JL: add case status mapping 
		AND (isnull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) = @CaseClassification OR @CaseClassification IS NULL)		
		AND (dr.idfsBaseReference IS NOT NULL OR NOT EXISTS (SELECT * FROM @DiagnosisTable))
		--------------------------------------------
		AND @SD <= COALESCE(hc.datOnSetDate,hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate)
		AND @ED >= COALESCE(hc.datOnSetDate,hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate)
		AND dr.idfsBaseReference in (SELECT * FROM @DiagnosisTable)
	END
---------------------------------------------------------------------------------------------------------------------------

	-- sum by province
	if cast(@ThaiProvince as varchar(max)) = '<ItemList/>'
	begin
		insert into @ReportTable
		(	
			idfReportingArea		,
			blnIsTotalOrSubtotal	,
			intCases				,
			intDeath				
		)
		select 
			gl.idfsRegion,
			0,
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
			gl.idfsRegion 

		option (recompile)
		
			-- adding provices without data
		insert into @ReportTable
		(	
			idfReportingArea		,
			blnIsTotalOrSubtotal	,
			intCases				,
			intDeath				
		)
		select 
			pfr.idfsRegion,
			0,
			0,
			0
		from #ProvincesForReport pfr
			left join @ReportTable rt
			on rt.idfReportingArea = pfr.idfsRegion
		where rt.idfReportingArea is null
	
		-- update province name, orders, population
		update rt set 
			rt.intOrder = pfr.intOrder,
			rt.strReportingArea = ref_province.name,
			rt.intPopulation = pfr.intPopulation
		from @ReportTable rt
			inner join #ProvincesForReport pfr
			on rt.idfReportingArea = pfr.idfsRegion
			
			inner join dbo.fnGisReference(@LangID, 19000003) ref_province
			on ref_province.idfsReference = pfr.idfsRegion
			
		-- update totalorder for provinces
		-- by zone
		update rt set 
			rt.intOrderTotal = tzt.intOrder
		from @ReportTable rt
			inner join #ProvincesForReport pfr
			on rt.idfReportingArea = pfr.idfsRegion
			
			inner join @ThaiZonesTable tzt
			on tzt.idfsThaiZone = pfr.idfsThaiZone
			
		--by thai region
		update rt set 
			rt.intOrderTotal = trt.intOrder
		from @ReportTable rt
			inner join #ProvincesForReport pfr
			on rt.idfReportingArea = pfr.idfsRegion
			
			inner join @ThaiRegionsTable trt
			on trt.idfsThaiRegion = pfr.idfsThaiRegion	

		-- totals by regions or zones
		insert into @ReportTable
		(	
			idfReportingArea		,
			strReportingArea		,
			blnIsTotalOrSubtotal	,
			intCases				,
			intDeath				,
			intPopulation			,
			intOrderTotal			,
			intOrder			
		)
		select 
			isnull(pfr.idfsThaiZone, pfr.idfsThaiRegion),
			ref_zones_regions.name						,
			1											,
			sum(intCases)								,
			sum(intDeath)								,
			isnull(tzt.intPopulation, trt.intPopulation),
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
			
		group by isnull(pfr.idfsThaiZone, pfr.idfsThaiRegion), ref_zones_regions.name, isnull(tzt.intPopulation, trt.intPopulation), isnull(tzt.intOrder, trt.intOrder)	
 				
			
	end
	
	--by districts when only Province is passed
	if cast(@ThaiProvince as varchar(max)) <> '<ItemList/>' AND cast(@ThaiDistrict as varchar(max)) = '<ItemList/>' -- MCW Added check for empty @ThaiDistrict
	begin 
		insert into @ReportTable
		(	
			idfReportingArea		,
			blnIsTotalOrSubtotal	,
			intCases				,
			intDeath				
		)
		select 
			dt.idfsRayon,
			0,
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
			dt.idfsRayon
		option (recompile)	
				
		-- adding districts without data
		insert into @ReportTable
		(	
			idfReportingArea		,
			blnIsTotalOrSubtotal	,
			intCases				,
			intDeath				
		)
		select 
			dt.idfsRayon,
			0,
			0,
			0
		from #DistrictsTable dt
			left join @ReportTable rt
			on rt.idfReportingArea = dt.idfsRayon
		where rt.idfReportingArea is null
		
		-- update district name, orders, population
		update rt set 
			rt.intOrder = dt.intOrder,
			rt.strReportingArea = ref_district.name,
			rt.intPopulation = dt.intPopulation
		from @ReportTable rt
			inner join #DistrictsTable dt
			on rt.idfReportingArea = dt.idfsRayon
			
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
			
		-- totals by province for districts
		insert into @ReportTable
		(	
			idfReportingArea		,
			strReportingArea		,
			blnIsTotalOrSubtotal	,
			intCases				,
			intDeath				,
			intPopulation			,
			intOrderTotal			,
			intOrder			
		)
		select 
			dt.idfsRegion			,
			ProvinceName.name		,
			1						,
			sum(intCases)			,
			sum(intDeath)			,
			pfr.intPopulation		,
			pfr.intOrder			,
			0		
		from @ReportTable rt
			inner join #DistrictsTable dt
			on dt.idfsRayon = rt.idfReportingArea
			
			inner join #ProvincesForReport pfr
			on pfr.idfsRegion = dt.idfsRegion
			
			inner join dbo.fnGisReference(@LangID, 19000003) ProvinceName
			on dt.idfsRegion = ProvinceName.idfsReference
			
		group by dt.idfsRegion, ProvinceName.name, pfr.intPopulation, pfr.intOrder				
	end

--by districts when only District list is passed added by MCW
	IF CAST(@ThaiDistrict AS VARCHAR(MAX)) <> '<ItemList/>'
	BEGIN 
		
		-- adding areas in the selected districts without data
		INSERT INTO @ReportTable
		SELECT 
			CASE WHEN dt.idfsSubDistrict IS NULL THEN dt.idfsDistrict ELSE dt.idfsSubDistrict END, 
			CASE WHEN dt.strSubDistrict IS NULL THEN dt.strDistrict ELSE dt.strSubDistrict END, 
			0, 0, 0, 0, 0, dt.intOrder
		FROM @ProvinceDistrict dt

		WHERE dt.idfsDistrict IS NOT NULL --only perform on Districts and SubDistricts

		-- UPDATE totalorder for districts
		-- by province
		UPDATE rt set 
			rt.intOrderTotal = dt.intOrder
		FROM @ReportTable rt
		INNER JOIN @ProvinceDistrict dt on rt.idfReportingArea = CASE WHEN dt.idfsSubDistrict IS NULL THEN dt.idfsDistrict ELSE dt.idfsSubDistrict END

		UPDATE R -- Add Deaths
		SET R.intDeath = (SELECT COUNT(*) FROM @HumanCase HC
						  WHERE CASE WHEN HC.idfsSubDist IS NULL THEN HC.idfsDistrict ELSE idfsSubDist END = R.idfReportingArea
						  AND HC.idfsOutcome = 10770000000)

		FROM @ReportTable R

		UPDATE R -- Add Population
		SET R.intPopulation = PD.intPopulation		
		FROM @ReportTable R
		INNER JOIN @ProvinceDistrict PD ON CASE WHEN PD.idfsSubDistrict IS NULL THEN PD.idfsDistrict ELSE PD.idfsSubDistrict END = R.idfReportingArea

		-- Insert a row for the District Totals
		INSERT INTO @ReportTable
		SELECT
			idfsDistrict,
			strDistrict + ' - Total',
			1,
			0,
			0,
			intPopulation,
			0,
			intOrder

		FROM @ProvinceDistrict
		WHERE idfsSubDistrict IS NULL

		-- UPDATE totalorder for districts
		UPDATE rt set 
			rt.intOrderTotal = dt.intOrder
		FROM @ReportTable rt
		INNER JOIN @ProvinceDistrict dt on rt.idfReportingArea = CASE WHEN dt.idfsSubDistrict IS NULL THEN dt.idfsDistrict ELSE dt.idfsSubDistrict END	

		-- MCW Add rows for District Totals
		-- by province
		UPDATE rt 
		SET	rt.intOrderTotal = (SELECT intOrder FROM @ReportTable R WHERE R.idfReportingArea = rt.idfReportingArea AND R.strReportingArea NOT LIKE '%Total') - 1 -- Make sure the district total is before the District reporting area
		FROM @ReportTable rt 
		WHERE rt.strReportingArea LIKE '%- Total'
		
		-- Add cases
		UPDATE rt
		SET rt.intCases = (SELECT COUNT(*) FROM @HumanCase HC WHERE CASE WHEN HC.idfsSubDist IS NULL THEN HC.idfsDistrict ELSE HC.idfsSubDist END = rt.idfReportingArea)

		FROM @ReportTable rt
		WHERE rt.strReportingArea NOT LIKE '%- Total'

		-- Update Deaths
		UPDATE rt
		SET rt.intDeath = (SELECT COUNT(*) FROM @HumanCase HC WHERE CASE WHEN HC.idfsSubDist IS NULL THEN HC.idfsDistrict ELSE HC.idfsSubDist END = rt.idfReportingArea AND HC.idfsOutcome = 10770000000)

		FROM @ReportTable rt
		WHERE rt.strReportingArea NOT LIKE '%- Total'

		-- Update totals
		UPDATE rt
		SET rt.intCases = (SELECT SUM(R.intCases) 
						   FROM @ReportTable R 
						   WHERE R.idfReportingArea IN (SELECT CASE WHEN PD.idfsSubDistrict IS NULL THEN PD.idfsDistrict ELSE PD.idfsSubDistrict END FROM @ProvinceDistrict PD WHERE PD.idfsDistrict = rt.idfReportingArea)
						   AND R.strReportingArea NOT LIKE '%- Total')

		FROM @ReportTable rt
		WHERE rt.strReportingArea LIKE '%- Total'

	END
	-- total
	insert into @ReportTable
	(	
		idfReportingArea		,
		strReportingArea		,
		blnIsTotalOrSubtotal	,
		intCases				,
		intDeath				,
		intPopulation			,
		intOrderTotal			,
		intOrder			
	)
	select
		-1								,
		isnull(@strTotal, N'Total')		,
		1								,
		isnull(sum(intCases), 0)		,
		isnull(sum(intDeath), 0)		,
		isnull(sum(intPopulation), 0)	,
		-1								,
		-1
	from @ReportTable rt
	where rt.blnIsTotalOrSubtotal = 1 	
 	
 	select * from @ReportTable rt
 	order by  rt.intOrderTotal, rt.intOrder
 	

 	
 end

