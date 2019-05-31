

--##SUMMARY This procedure returns table for "Comparative Report of several years by months" GG report

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 15.07.2016

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec [spRepHumComparativeSeveralYearsGG] 'en', 2014, 2015, '<ItemList><Item key="1"/></ItemList>',  '<ItemList><Item key="1"/></ItemList>', 1344340000000, 1344790000000



exec [spRepHumComparativeSeveralYearsGG] 'en', 2015, 2016, '<ItemList><Item key="1"/><Item key="2"/></ItemList>',  '<ItemList></ItemList>', null, null


*/ 
 
create PROCEDURE [dbo].[spRepHumComparativeSeveralYearsGG]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@CounterXML			as xml,  -- 1 = Absolute number, 2 = percent
	@DiagnosisXML		as xml,
	@RegionID			as bigint = null,
	@RayonID			as bigint = null,
	@SiteID				as bigint = null
AS
BEGIN

	-- Variables - start
	declare	@ReportTable	table
	(	  strKey	varchar(200) not null primary key   -- let it be intYear + '_' + intCounter
		, intYear	int not null 
		, intCounter	int not null 
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

		@idfsLanguage			bigint,
		@CountryID				bigint,
		@idfsSite				bigint,
		
		@StartDate				datetime,	 
		@FinishDate				datetime,
		 
		@iDiagnosis				int,
		@iCounter				int,
		@intYear				int,
		
		@idfsCustomReportType	bigint,
		@idfAttributeType		bigint
		
	
	declare @Years table (
		intYear int not null primary key
	)

	declare @Counter table (
		intCounter int not null primary key
	)

	-- Variables - end
	
	-- Fill and set initial input parameters - start
		
	set @intYear = @FirstYear
	
	while @intYear <= @SecondYear
	begin
		insert into @Years(intYear) values(@intYear)
		set @intYear = @intYear + 1
	end		
		
	set @StartDate = (cast(@FirstYear as varchar(4)) + '01' + '01')
	set @FinishDate = dateadd(year, 1, (cast(@SecondYear as varchar(4)) + '01' + '01'))
	
	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
		
	set	@CountryID = 780000000 -- Georgia
	
	set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
	
	set	@idfsCustomReportType = 10290053 /*GG Comparative Report of several years by months*/

	select		@idfAttributeType = at.idfAttributeType
	from		trtAttributeType at
	where		at.strAttributeTypeName = N'RDG to SDG' collate Cyrillic_General_CI_AS


	if OBJECT_ID('tempdb.dbo.#ReportDiagnoses') is not null 
	drop table #ReportDiagnoses

	create table #ReportDiagnoses
	(	
		idfID bigint not null identity (1, 1),
		idfsDiagnosis bigint not null,
		idfsDiagnosisReportGroup bigint not null,
		idfsDiagnosisGroup bigint null,
		primary key	(
			idfsDiagnosis asc,
			idfsDiagnosisReportGroup asc
					)
	)

	if	@DiagnosisXML is not null
	begin

		EXEC sp_xml_preparedocument @iDiagnosis OUTPUT, @DiagnosisXML

		insert into #ReportDiagnoses (
			idfsDiagnosis,
			idfsDiagnosisReportGroup,
			idfsDiagnosisGroup
		) 
		select		d.idfsDiagnosis,
					rdg.idfsReportDiagnosisGroup,
					sdg.idfsDiagnosisGroup
		from OPENXML (@iDiagnosis, '/ItemList/Item') 
		with (
				[key] bigint '@key'
		) dg
		inner join	trtReportDiagnosisGroup rdg
		on			rdg.idfsReportDiagnosisGroup = dg.[key]
		inner join	trtDiagnosisToGroupForReportType d_to_g_for_rt
		on			d_to_g_for_rt.idfsReportDiagnosisGroup = rdg.idfsReportDiagnosisGroup
					and d_to_g_for_rt.idfsCustomReportType = @idfsCustomReportType
					and rdg.intRowStatus = 0 
		inner join	trtDiagnosis d
		on			d.idfsDiagnosis = d_to_g_for_rt.idfsDiagnosis
		outer apply	(
				select top 1
							r_dg.idfsReference as idfsDiagnosisGroup
				from		trtBaseReferenceAttribute bra
				inner join	fnReferenceRepair('en', 19000156) r_dg	-- Diagnoses Groups
				on			cast(r_dg.idfsReference as nvarchar) collate Cyrillic_General_CI_AS = 
								cast(bra.varValue as nvarchar) collate Cyrillic_General_CI_AS
				where		bra.idfAttributeType = @idfAttributeType
							and bra.idfsBaseReference = rdg.idfsReportDiagnosisGroup
							and bra.strAttributeItem collate Cyrillic_General_CI_AS = 
									cast(@idfsCustomReportType as nvarchar) collate Cyrillic_General_CI_AS
				order by	bra.idfBaseReferenceAttribute asc
						) as sdg

		EXEC sp_xml_removedocument @iDiagnosis
	
	end

	--if	@CounterXML is not null
	--begin

	--	EXEC sp_xml_preparedocument @iCounter OUTPUT, @CounterXML

	--	insert into @Counter (
	--		intCounter
	--	) 
	--	select c.[key]
	--	from OPENXML (@iCounter, '/ItemList/Item') 
	--	with (
	--			[key] int '@key'
	--	) c
	--	where c.[key] in (1, 2)

	--	EXEC sp_xml_removedocument @iCounter
	
	--end
	-- Fill and set initial input parameters - end

	-- Calculations - start


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
	select		y.intYear, m.intMonth, 0
	from		@Years y
	cross join	@month m


	declare cur cursor local forward_only for 
	select y.intYear
	from @Years y

	open cur

	fetch next from cur into @intYear

	while @@FETCH_STATUS = 0
	begin 
		set @StartDate = (CAST(@intYear AS VARCHAR(4)) + '01' + '01')
		set @FinishDate = dateadd(dd, -1, dateadd(yyyy, 1, @StartDate))
		
		exec dbo.[spRepHumComparativeSeveralYearsGG_Calculations] @CountryID, @StartDate, @FinishDate, @RegionID, @RayonID

		fetch next from cur into @intYear
	end	

	insert into	@ReportTable
	(	  strKey	-- let it be intYear + '_' + intCounter
		, intYear
		, intCounter
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
		cast(pvt.intYear as varchar(10)) + '_' + cast(isnull(c.intCounter, 1) as varchar(10)) collate Cyrillic_General_CI_AS
		, pvt.intYear
		, isnull(c.intCounter, 1)
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([1],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([1],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intJanuary 
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([2],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([2],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intFebruary 
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([3],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([3],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intMarch
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([4],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([4],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intApril 
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([5],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([5],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intMay
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([6],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([6],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intJune 
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([7],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([7],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intJuly
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([8],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([8],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intAugust
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([9],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([9],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intSeptember
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([10],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([10],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intOctober
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([11],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([11],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intNovember
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([12],0)
			when isnull(c.intCounter, 1) = 2
					and isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0) <> 0
				then isnull([12],0) * 100.0 / (isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0))
			else 0.0
		  end as intDecember
		
		, case
			when isnull(c.intCounter, 1) = 1
				then isnull([1],0) + isnull([2],0)+ isnull([3],0)+ isnull([4],0)+ isnull([5],0)+ isnull([6],0)+ isnull([7],0)+ isnull([8],0)+ isnull([9],0)+ isnull([10],0)+ isnull([11],0)+ isnull([12],0)
			when isnull(c.intCounter, 1) = 2
				then 100.0
		  end as intTotal	

	from 
		(	
			select y.intYear, intMonth, intTotal
			from @Years y
			left join	#ReportTable rt
			on rt.intYear = y.intYear
		) as p
		pivot
		(	
			sum(intTotal)
			for intMonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
		) as pvt
		left join	@Counter c
		on			c.intCounter in (1, 2)
		order by	pvt.intYear, isnull(c.intCounter, 1)


		--insert into @ReportTable values
		--(1,2014,1, 23,43,21,35,14,33,12,43,18,19,23,25, 213),
		--(2,2015,1, 43,21,35,14,33,12,43,18,19,23,25,11, 203),
		--(3,2016,1, 35,14,33,12,43,18,19,23,25,11,14,12, 255)
		
		--if LEN(cast(@CounterXML as nvarchar(200))) >40 begin
		--	insert into @ReportTable values
		--	(12,2014,2, 4.3,2.1,3.5,1.4,3.3,1.2,4.3,1.8,1.9,2.3,2.5, 1.25678544567, 22.3),
		--	(22,2015,2, 2.1,3.5,1.4,3.3,1.2,4.3,1.8,1.9,2.3,2.5,1.1, 1.2, 19.3),
		--	(32,2016,2, 1.4,3.3,1.2,4.3,1.8,1.9,2.3,2.5,1.1,1.4,1.2, 2.344444, 25.5)
		--end
	
	-- Calculations - end

	-- Output
	select * from @ReportTable

	-- Remove temporary tables

	if OBJECT_ID('tempdb.dbo.#ReportTable') is not null 
	drop table #ReportTable

	if OBJECT_ID('tempdb.dbo.#ReportDiagnoses') is not null 
	drop table #ReportDiagnoses

END
	
