

--##SUMMARY This procedure returns resultset for "Weekly situation on infectious diseases by districts" report

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 14.01.2015

--##RETURNS Don't use 

/*
--Example of a call of procedure:

declare @UserId	 bigint
select @UserId = u.idfUserID
from tstUserTable u
join tstSite s
on s.idfsSite = u.idfsSite
and s.strSiteName = N'CDC' 

exec spRepHumWeeklyDiseasesByDistrics 
'en',
 N'2010-01-01T00:00:00',
  N'2020-01-01T00:00:00', 
  39520000000, --Baghdad
  @UserId

*/ 
 
create PROCEDURE [dbo].[spRepHumWeeklyDiseasesByDistrics]
(
	 @LangID		As nvarchar(50),
	 @SD			as nvarchar(20), 
	 @ED			as nvarchar(20),
	 @RegionID		as bigint,
	 @UserId		as bigint = null
)
AS	
begin

	declare 
		@idfsLanguage BIGINT
	,	@idfsCustomReportType BIGINT
	,	@strUserName nvarchar(200) 
	,	@SDDate DATETIME
	,	@EDDate datetime
	,   @CountReportColumns int


	SELECT 
		@strUserName = dbo.fnConcatFullName(tp.strFamilyName, tp.strFirstName, tp.strSecondName)
	FROM tstUserTable tut
		inner join tlbPerson tp
		on tp.idfPerson = tut.idfPerson
	WHERE tut.idfUserID = isnull(@UserId, dbo.fnUserID())


	if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
	drop table #ReportTable

	create table #ReportTable 
	(
		idfsRayon							bigint not null,
		idfsDiagnosisOrReportDiagnosisGroup	bigint not null,
		strDiagnosisOrReportDiagnosisGroup	nvarchar (300) collate database_default not null,
		strRayon							nvarchar(200) not null,
		strUserName							nvarchar(300)  null,
		intTotal							int,
		intOrder							int,
		primary key (
			idfsRayon,
			idfsDiagnosisOrReportDiagnosisGroup
		)
	)


	SET @idfsCustomReportType = 10290022 /*IQ Weekly situation on infectious diseases by districts*/

	SET @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD AS DATETIME),0)
	SET @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED AS DATETIME),1)
	
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		


	declare @ReportDiagnosisTable TABLE 
		(	
			idfsDiagnosis	bigint not null primary key
		)

	insert into @ReportDiagnosisTable 
	(
		idfsDiagnosis
	) 
	select distinct
		trtd.idfsDiagnosis		
	from dbo.trtDiagnosisToGroupForReportType fdt
		inner join trtDiagnosis trtd
		on trtd.idfsDiagnosis = fdt.idfsDiagnosis 
		inner join trtReportRows trr
		on trr.idfsDiagnosisOrReportDiagnosisGroup = fdt.idfsReportDiagnosisGroup		
		and trr.idfsCustomReportType = fdt.idfsCustomReportType
	where  fdt.idfsCustomReportType = @idfsCustomReportType    

	insert into @ReportDiagnosisTable (
		idfsDiagnosis
	) 
	select distinct
	  trtd.idfsDiagnosis
	from dbo.trtReportRows rr
		inner join trtBaseReference br
		on br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
			and br.idfsReferenceType = 19000019 --'rftDiagnosis'
		inner join trtDiagnosis trtd
		on trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
	where  rr.idfsCustomReportType = @idfsCustomReportType 
		   and  rr.intRowStatus = 0 
		   and NOT EXISTS 
		   (
		   select * from @ReportDiagnosisTable
		   where idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
		   )      
		   

	insert into #ReportTable 
	(
		 idfsRayon
		,idfsDiagnosisOrReportDiagnosisGroup
		,strDiagnosisOrReportDiagnosisGroup
		,strRayon	
		,strUserName		
		,intTotal 
		,intOrder 
	)
	select 
		  gr.idfsRayon
		, rr.idfsDiagnosisOrReportDiagnosisGroup
		, isnull(snt.strTextString, br.strDefault) as strDiagnosisOrReportDiagnosisGroup
		, isnull(gsnt.strTextString, gbr.strDefault) as strRayon
		, @strUserName
		, 0
		, rr.intRowOrder
	from dbo.trtReportRows rr
	left join trtBaseReference br
		left join trtStringNameTranslation snt on 
			br.idfsBaseReference = snt.idfsBaseReference
			and snt.idfsLanguage = @idfsLanguage
		left outer join trtDiagnosis d on
			br.idfsBaseReference = d.idfsDiagnosis
		left outer join trtReportDiagnosisGroup dg
        on br.idfsBaseReference = dg.idfsReportDiagnosisGroup
	on rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference
	
	cross join gisRayon gr
		inner join gisBaseReference gbr
		on gbr.idfsGISBaseReference = gr.idfsRayon
		and gbr.intRowStatus = 0
		and gr.idfsRegion = @RegionID
		and gr.intRowStatus = 0
		
		left join gisStringNameTranslation gsnt
		on gsnt.idfsGISBaseReference = gbr.idfsGISBaseReference
		and gsnt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		
	where rr.idfsCustomReportType = @idfsCustomReportType
		and rr.intRowStatus = 0
	order by rr.intRowOrder  
	
	
	
	select 
		@CountReportColumns = count(*)
	from dbo.trtReportRows rr
	where rr.idfsCustomReportType = @idfsCustomReportType
	
	
	
	declare @ReportCaseTable table
	(	
		idfsRayon bigint not null,
		idfsDiagnosis bigint not null,
		intTotal			int,
		primary key (
			idfsRayon,
			idfsDiagnosis
		)
	)
	
	declare @ReportDiagnosisGroupTable table
	(	
		idfsRayon bigint not null,
		idfsReportDiagnosisGroup bigint not null,
		intTotal			int,
		primary key (
			idfsRayon,
			idfsReportDiagnosisGroup
		)
	)
	

	insert into @ReportCaseTable
	(
		 idfsRayon
		,idfsDiagnosis
		,intTotal
	)
	select
			gl.idfsRayon,
			coalesce(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) AS idfsDiagnosis,
			count(hc.idfHumanCase) as intTotal
		from tlbHumanCase hc
		join tlbHuman h on
			hc.idfHuman = h.idfHuman 
			and h.intRowStatus = 0
		join tlbGeoLocation gl on
			h.idfCurrentResidenceAddress = gl.idfGeoLocation 
			and gl.intRowStatus = 0  
			and gl.idfsRegion = @RegionID
		where @SDDate <= COALESCE(hc.datOnSetDate, hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate)
			and COALESCE(hc.datOnSetDate, hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate) <= @EDDate
			and hc.intRowStatus = 0 
			and COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) <> 370000000 /*casRefused*/ 
	group by gl.idfsRayon, coalesce(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)


	insert into @ReportDiagnosisGroupTable	
	(
		 idfsRayon
		,idfsReportDiagnosisGroup
		,intTotal
	)
	select
		 rct.idfsRayon
		,dtg.idfsReportDiagnosisGroup	
		,sum(rct.intTotal)
	from		@ReportCaseTable rct
		inner join	dbo.trtDiagnosisToGroupForReportType dtg
		on			dtg.idfsDiagnosis = rct.idfsDiagnosis
					and dtg.idfsCustomReportType = @idfsCustomReportType
	group by	rct.idfsRayon, dtg.idfsReportDiagnosisGroup		
	
	
	
	update		rt
	set	
		rt.intTotal			= rct.intTotal
	from		#ReportTable rt
	inner join	@ReportCaseTable rct
	on			rct.idfsDiagnosis = rt.idfsDiagnosisOrReportDiagnosisGroup	
				and rct.idfsRayon = rt.idfsRayon
		
	update		rt
	set	
		rt.intTotal			= rdgt.intTotal
	from		#ReportTable rt
	inner join	@ReportDiagnosisGroupTable rdgt
	on			rdgt.idfsReportDiagnosisGroup = rt.idfsDiagnosisOrReportDiagnosisGroup
				and rdgt.idfsRayon = rt.idfsRayon		


	declare 
		@select nvarchar(max),
		@from nvarchar(max),
		@sql nvarchar(max)

	set @select = '
	select 
	    regions.strRayon		
	  , regions.idfsRayon	
	  , regions.strUserName
	  , ' + cast(@CountReportColumns as nvarchar(20)) + ' as intCountReportColumns
	'	

	set @from = '
	from
		(select distinct
		  rt.strRayon,
		  rt.idfsRayon,
		  rt.strUserName
		from #ReportTable rt) as regions
	'

	declare
	  @idfsDiagnosisOrReportDiagnosisGroup bigint,	  
	  @i int
	  						
	declare cur_diagnosis cursor for
	select distinct 
		dt.intOrder, 
		dt.idfsDiagnosisOrReportDiagnosisGroup
	from #ReportTable  dt
	order by dt.intOrder
							
	open cur_diagnosis

	fetch next from cur_diagnosis into @i, @idfsDiagnosisOrReportDiagnosisGroup

	while @@fetch_status = 0 
	begin
	  set @select = @select + '
	  , rt_' + cast(@i as varchar(20))+ '.strDiagnosisOrReportDiagnosisGroup strDiagnosisOrReportDiagnosisGroup_' + cast(@i as varchar(20))+ '
	  , rt_' + cast(@i as varchar(20))+ '.idfsDiagnosisOrReportDiagnosisGroup idfsDiagnosisOrReportDiagnosisGroup_' + cast(@i as varchar(20))+ ' 
	  , rt_' + cast(@i as varchar(20))+ '.intTotal intFirstSubcolumn_' + cast(@i as varchar(20))+ ' 
	  '
	  set @from = @from + '
	   inner join (select idfsRayon, intTotal, strDiagnosisOrReportDiagnosisGroup, idfsDiagnosisOrReportDiagnosisGroup from #ReportTable where 
	   idfsDiagnosisOrReportDiagnosisGroup = ' + cast(@idfsDiagnosisOrReportDiagnosisGroup as varchar(20)) + ') as rt_' + cast(@i as varchar(20))+ '
	   on rt_' + cast(@i as varchar(20))+ '.idfsRayon = regions.idfsRayon
	   '


		fetch next from cur_diagnosis into @i, @idfsDiagnosisOrReportDiagnosisGroup
	end


	close cur_diagnosis
	deallocate cur_diagnosis						
							
							

	set @sql = @select + @from + '
	order by regions.strRayon
	'						
	      
	print @sql						
	exec (@sql)







/*				
--=========================================================--					
	--- STUB results ---
	--- it should be deleted after proper implementation ---
--=========================================================--									
	
	insert into #ReportTable
	select		ray.idfsRayon,
				refRay.[name] as strRayon,
				'Some user',
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intDiphtheria,
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intNeonatalTetanus,
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intHemorrhagicFever,
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intVisceralLeshmaniasis,
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intRabies,
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intMeningitis,
				cast(20*RAND(BINARY_CHECKSUM(NEWID()))as int)	as intTotal
	from		gisRayon as ray
	inner join	fnGisReference(@LangID, 19000002 /*rftRayon*/) as refRay 
	on			ray.idfsRayon = refRay.idfsReference	
	where		ray.idfsRegion = @RegionID
*/	

	--select * from #ReportTable
	--order by  strRayon
	
	
	if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
	drop table #ReportTable
	
end

