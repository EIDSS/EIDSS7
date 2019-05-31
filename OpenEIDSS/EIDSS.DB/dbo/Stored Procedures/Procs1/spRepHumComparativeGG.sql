

--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec [spRepHumComparativeGG] 'en', 2011, 2014 

exec [spRepHumComparativeGG] 'ru', 2010, 2016 



*/ 
create PROCEDURE [dbo].[spRepHumComparativeGG]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@StartMonth			as int = null,
	@EndMonth			as int = null,
	@RegionID			as bigint = null,
	@RayonID			as bigint = null,
	@SiteID				as bigint = null

AS
begin
	
declare	@ResultTable	table
(	  idfsBaseReference			bigint not null primary key
	, strDisease				nvarchar(300) collate database_default not null 
	, strICD					nvarchar(300) collate database_default  null 
	, blnIsSubdisease			bit null	

	, intTotal_Abs_Y1			    int    null
	, dblTotal_By100000_Y1			decimal(10,2)  null
	, intChildren_Abs_Y1			int    null
	, dblChildren_By100000_Y1		decimal(10,2)  null

	, intTotal_Abs_Y2			    int    null
	, dblTotal_By100000_Y2			decimal(10,2)  null
	, intChildren_Abs_Y2			int    null
	, dblChildren_By100000_Y2		decimal(10,2)  null

	, intOrder int
)


declare	@ReportTable	table
(	  idfsBaseReference				bigint not null primary key

	, strDisease					nvarchar(300) collate database_default not null 
	, strICD						nvarchar(300) collate database_default  null 
	, blnIsSubdisease				bit null	
	
	, intTotal_Abs_Y1			    int    null
	, dblTotal_By100000_Y1			decimal(10,2)  null
	, intChildren_Abs_Y1			int    null
	, dblChildren_By100000_Y1		decimal(10,2)  null
	
	, intTotal_Abs_Y2			    int    null
	, dblTotal_By100000_Y2			decimal(10,2)  null
	, intChildren_Abs_Y2			int    null
	, dblChildren_By100000_Y2		decimal(10,2)  null
	
	, intOrder int
)

		
DECLARE 		
	@StartDate1					datetime,	 
	@FinishDate1				datetime,

	@StartDate2					datetime,	 
	@FinishDate2				datetime,
	
	@idfsLanguage				bigint,
  
	@idfsCustomReportType		bigint,	
	@idfsCustomReportType_Form3_01_2 bigint,
  
	@CountryID					bigint,
  
	@StatisticsForFirstYear		int,
	@StatisticsForSecondYear	int,

	@Statistics0_15ForFirstYear		int,
	@Statistics0_15ForSecondYear	int,
		
	@strStartMonth				nvarchar(2),
	@strEndMonth				nvarchar(2),

	@idfsStatType_Population bigint,
	@idfsStatType_ByAgeAndGender bigint,
	@idfsStatType_ByAgeInRayons bigint
		



declare @RayonsForStatistics table
(
	idfsRayon bigint primary key,
	maxYear1 int,
	maxYear2 int
)

declare @RayonsAndAgeGroupsForStatistics table
(
	idfsAgeGroup bigint,
	idfsRayon bigint,	 
	maxYear1_ByAgeInRayons int,
	maxYear2_ByAgeInRayons int,
	primary key(idfsAgeGroup, idfsRayon)
)

declare @AgeGroupsAndGenderForStatistics table
(
	idfsAgeGroup bigint,
	idfsGender bigint,
	maxYear1_ByAgeAndGender int,
	maxYear2_ByAgeAndGender int,
	primary key(idfsAgeGroup, idfsGender)
)

declare @AgeGroupsForStatistics table
(
	idfsAgeGroup bigint primary key,
	StatisticsForFirstYear int,
	StatisticsForSecondYear int
)
	  
declare @ChildrenAgeGroups table(
	idfsAgeGroup bigint primary key,
	strAgeGroupName nvarchar(100)
	
)	  
	  
SET @idfsCustomReportType = 10290051 /*Comparative Report on Infectious Diseases/Conditions (by months)*/
SET @idfsCustomReportType_Form3_01_2 = 10290050 /* "Intermediary Form 03 by MoLHSA Order 01-2N"*/
SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		

if @StartMonth is null set @StartMonth = 1
if @EndMonth is null set @EndMonth = 12

set @strStartMonth = case when 	@StartMonth	between 1 and 9 then '0' + cast(@StartMonth as nvarchar) else cast(@StartMonth as nvarchar) end
set @strEndMonth = case when @EndMonth	between 1 and 9 then '0' + cast(@EndMonth as nvarchar) else cast(@EndMonth as nvarchar) end	
	
set @StartDate1  = (CAST(@FirstYear AS VARCHAR(4)) + @strStartMonth + '01')
set @FinishDate1  = dateADD(mm, 1, (CAST(@FirstYear AS VARCHAR(4)) + @strEndMonth + '01'))

set @StartDate2  = (CAST(@SecondYear AS VARCHAR(4)) + @strStartMonth + '01')
set @FinishDate2  = dateADD(mm, 1, (CAST(@SecondYear AS VARCHAR(4)) + @strEndMonth + '01'))	

set	@CountryID = 780000000


--set @idfsStatType_Population = 39850000000  -- Population
select @idfsStatType_Population = tbra.idfsBaseReference
from trtBaseReferenceAttribute tbra
	inner join	trtAttributeType at
	on			at.strAttributeTypeName = N'Statistical Data Type'
where cast(tbra.varValue as nvarchar(100)) = N'Population'

--set @idfsStatType_ByAgeAndGender = 39860000000  -- Population by Age Groups and Gender
select @idfsStatType_ByAgeAndGender = tbra.idfsBaseReference
from trtBaseReferenceAttribute tbra
	inner join	trtAttributeType at
	on			at.strAttributeTypeName = N'Statistical Data Type'
where cast(tbra.varValue as nvarchar(100)) = N'Population by Age Groups and Gender'	
		

--set @idfsStatType_ByAgeInRayons = 00  -- Population by Age Groups in Rayons
select @idfsStatType_ByAgeInRayons = tbra.idfsBaseReference
from trtBaseReferenceAttribute tbra
	inner join	trtAttributeType at
	on			at.strAttributeTypeName = N'Statistical Data Type'
where cast(tbra.varValue as nvarchar(100)) = N'Population by Age Groups in Rayons'		
    					
-- get childare Age Groups - "-1", "1-4", "5-9", "10-14"    					
insert into @ChildrenAgeGroups(idfsAgeGroup, strAgeGroupName)
select tbra.idfsBaseReference, cast(tbra.varValue as nvarchar(100))
from trtBaseReferenceAttribute tbra
	inner join	trtAttributeType at
	on			at.strAttributeTypeName = N'Children Age groups'
	and tbra.strAttributeItem = 'Children Age groups'
	
-- get statistic
	
	
-- Get statictics for Rayon-Region-StatisticalAgeGroups
insert into @RayonsForStatistics (idfsRayon)
select idfsRayon from gisRayon
where (
      idfsRayon = @RayonID or
      (idfsRegion = @RegionID and @RayonID is null) or
      (idfsCountry = @CountryID and @RayonID is null and @RegionID is null)
      ) 
      and intRowStatus = 0
			
insert into @RayonsAndAgeGroupsForStatistics (idfsAgeGroup ,idfsRayon)
select StstAG.idfsBaseReference, idfsRayon 
from gisRayon
	cross join (select StatAgeGroups.idfsBaseReference
					from trtBaseReference StatAgeGroups
					where StatAgeGroups.idfsReferenceType = 19000145 --	rftStatisticalAgeGroup
					and StatAgeGroups.intRowStatus = 0) as StstAG
where (
      idfsRayon = @RayonID or
      (idfsRegion = @RegionID and @RayonID is null) or
      (idfsCountry = @CountryID and @RayonID is null and @RegionID is null)
      ) 
      and intRowStatus = 0		
      
      
insert into @AgeGroupsAndGenderForStatistics (idfsAgeGroup, idfsGender)
select StatAG.idfsAgeGroup, Gender.idfsGender
from (select StatAgeGroups.idfsBaseReference as idfsAgeGroup
					from trtBaseReference StatAgeGroups
					where StatAgeGroups.idfsReferenceType = 19000145 --	rftStatisticalAgeGroup
					and StatAgeGroups.intRowStatus = 0) as StatAG
	cross join (select idfsBaseReference  as idfsGender
	            from trtBaseReference StatGender
	            where StatGender.idfsReferenceType = 19000043	--rftHumanGender
	            and StatGender.intRowStatus = 0) as Gender					
      
insert into @AgeGroupsForStatistics (idfsAgeGroup)
select StatAG.idfsAgeGroup
from (select StatAgeGroups.idfsBaseReference as idfsAgeGroup
					from trtBaseReference StatAgeGroups
					where StatAgeGroups.idfsReferenceType = 19000145 --	rftStatisticalAgeGroup
					and StatAgeGroups.intRowStatus = 0) as StatAG
		  			
-- first year
-- определяем для каждого района максимальный год (меньший или равный отчетному году), за который есть статистика.
update rfstat set
   rfstat.maxYear1 = maxYear
from @RayonsForStatistics rfstat
inner join (
    select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon
    from @RayonsForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = rfs.idfsRayon 
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_Population
      and year(stat.datStatisticStartDate) <= @FirstYear
    group by  idfsRayon
    ) as mrfs
    on rfstat.idfsRayon = mrfs.idfsRayon

    
-- определяем для каждого района и age group максимальный год (меньший или равный отчетному году), за который есть статистика.    
update rfstat set
   rfstat.maxYear1_ByAgeInRayons = maxYear
from @RayonsAndAgeGroupsForStatistics rfstat
inner join (
    select rfs.idfsAgeGroup, rfs.idfsRayon, MAX(year(stat.datStatisticStartDate)) as maxYear
    from @RayonsAndAgeGroupsForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = rfs.idfsRayon 
      and stat.idfsStatisticalAgeGroup = rfs.idfsAgeGroup
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_ByAgeInRayons 
      and year(stat.datStatisticStartDate) <= @FirstYear
    group by rfs.idfsAgeGroup, rfs.idfsRayon
    ) as mrfs
    on rfstat.idfsRayon = mrfs.idfsRayon    
    and rfstat.idfsAgeGroup = mrfs.idfsAgeGroup

    
-- определяем для каждой age group и Gender максимальный год (меньший или равный отчетному году), за который есть статистика.    
update rfstat set
   rfstat.maxYear1_ByAgeAndGender = maxYear
from @AgeGroupsAndGenderForStatistics rfstat
inner join (
    select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsAgeGroup, rfs.idfsGender
    from @AgeGroupsAndGenderForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = @CountryID
      and stat.idfsStatisticalAgeGroup = rfs.idfsAgeGroup 
      and stat.idfsMainBaseReference = rfs.idfsGender
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_ByAgeAndGender 
      and year(stat.datStatisticStartDate) <= @FirstYear
    group by  rfs.idfsAgeGroup, rfs.idfsGender
    ) as mrfs
    on rfstat.idfsAgeGroup = mrfs.idfsAgeGroup   
    and rfstat.idfsGender = mrfs.idfsGender
                                      	

-- by rayons
-- если статистика есть по каждому району, то суммируем ее. 
-- Иначе считаем статистику не полной и вообще не считаем для данного года-региона
if not exists (select * from @RayonsForStatistics where maxYear1 is null)
begin
    select @StatisticsForFirstYear = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population and
         s.datStatisticStartDate = cast(rfs.maxYear1 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @StatisticsForFirstYear = 0      


-- by Rayons and Age Groups
-- если статистика есть по каждому району для Age Group, то суммируем ее. 
-- Иначе считаем статистику не полной
update agfs set
  agfs.StatisticsForFirstYear = case 
									when not exists (select * 
									                 from @RayonsAndAgeGroupsForStatistics rafs 
									                 where rafs.idfsAgeGroup = s.idfsAgeGroup and 
									                 rafs.maxYear1_ByAgeInRayons is null )
										then s.sumValue
										else null 
                                end
 
from @AgeGroupsForStatistics agfs
	inner join (
		select SUM(cast(varValue as int)) as sumValue, rfs.idfsAgeGroup
		from dbo.tlbStatistic s
		  inner join @RayonsAndAgeGroupsForStatistics rfs
		  on rfs.idfsRayon = s.idfsArea and
			 rfs.idfsAgeGroup = s.idfsStatisticalAgeGroup and
			 s.intRowStatus = 0 and
			 s.idfsStatisticDataType = @idfsStatType_ByAgeInRayons and
			 s.datStatisticStartDate = cast(rfs.maxYear1_ByAgeInRayons as varchar(4)) + '-01-01' 
		group by rfs.idfsAgeGroup ) as s
	on agfs.idfsAgeGroup = s.idfsAgeGroup	
	
-- by Gender and Age Groups
-- если статистика есть по каждому полу для каждой Age Group, то суммируем ее. 
-- Иначе считаем статистику не полной
update agfs set
  agfs.StatisticsForFirstYear = case 
									when not exists (select * 
									                 from @AgeGroupsAndGenderForStatistics rafs 
									                 where rafs.idfsAgeGroup = s.idfsAgeGroup and 
									                 rafs.maxYear1_ByAgeAndGender is null )
										then s.sumValue
										else null 
                                end
 
from @AgeGroupsForStatistics agfs
	inner join (
		select SUM(cast(varValue as int)) as sumValue, rfs.idfsAgeGroup
		from dbo.tlbStatistic s
		  inner join @AgeGroupsAndGenderForStatistics rfs
		  on s.idfsArea  = @CountryID and
			 rfs.idfsAgeGroup = s.idfsStatisticalAgeGroup and
			 rfs.idfsGender = s.idfsMainBaseReference and
			 s.intRowStatus = 0 and
			 s.idfsStatisticDataType = @idfsStatType_ByAgeAndGender and
			 s.datStatisticStartDate = cast(rfs.maxYear1_ByAgeAndGender as varchar(4)) + '-01-01' 
		group by rfs.idfsAgeGroup ) as s
	on agfs.idfsAgeGroup = s.idfsAgeGroup	
where agfs.StatisticsForFirstYear is null
		
		
-- second year
-- определяем для каждого района максимальный год (меньший или равный отчетному году), за который есть статистика.
update rfstat set
   rfstat.maxYear2 = maxYear
from @RayonsForStatistics rfstat
inner join (
    select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon
    from @RayonsForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = rfs.idfsRayon 
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_Population
      and year(stat.datStatisticStartDate) <= @SecondYear
    group by  idfsRayon
    ) as mrfs
    on rfstat.idfsRayon = mrfs.idfsRayon
    
-- определяем для каждого района и age group максимальный год (меньший или равный отчетному году), за который есть статистика.    
update rfstat set
   rfstat.maxYear2_ByAgeInRayons = maxYear
from @RayonsAndAgeGroupsForStatistics rfstat
inner join (
    select rfs.idfsAgeGroup, rfs.idfsRayon, MAX(year(stat.datStatisticStartDate)) as maxYear
    from @RayonsAndAgeGroupsForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = rfs.idfsRayon 
      and stat.idfsStatisticalAgeGroup = rfs.idfsAgeGroup
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_ByAgeInRayons 
      and year(stat.datStatisticStartDate) <= @SecondYear
    group by rfs.idfsAgeGroup, rfs.idfsRayon
    ) as mrfs
    on rfstat.idfsRayon = mrfs.idfsRayon    
    and rfstat.idfsAgeGroup = mrfs.idfsAgeGroup
    
-- определяем для каждой age group и Gender максимальный год (меньший или равный отчетному году), за который есть статистика.        
update rfstat set
   rfstat.maxYear2_ByAgeAndGender = maxYear
from @AgeGroupsAndGenderForStatistics rfstat
inner join (
    select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsAgeGroup, rfs.idfsGender
    from @AgeGroupsAndGenderForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = @CountryID
      and stat.idfsStatisticalAgeGroup = rfs.idfsAgeGroup 
      and stat.idfsMainBaseReference = rfs.idfsGender
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_ByAgeAndGender 
      and year(stat.datStatisticStartDate) <= @SecondYear
    group by  rfs.idfsAgeGroup, rfs.idfsGender
    ) as mrfs
    on rfstat.idfsAgeGroup = mrfs.idfsAgeGroup   
    and rfstat.idfsGender = mrfs.idfsGender
                                      	

-- by rayons
-- если статистика есть по каждому району, то суммируем ее. 
-- Иначе считаем статистику не полной и вообще не считаем для данного года-региона
if not exists (select * from @RayonsForStatistics where maxYear2 is null)
begin
    select @StatisticsForSecondYear = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population and
         s.datStatisticStartDate = cast(rfs.maxYear2 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @StatisticsForSecondYear = 0      


-- by Rayons and Age Groups
-- если статистика есть по каждому району для Age Group, то суммируем ее. 
-- Иначе считаем статистику не полной
update agfs set
  agfs.StatisticsForSecondYear = case 
									when not exists (select * 
									                 from @RayonsAndAgeGroupsForStatistics rafs 
									                 where rafs.idfsAgeGroup = s.idfsAgeGroup and 
									                 rafs.maxYear2_ByAgeInRayons is null )
										then s.sumValue
										else null 
                                end
 
from @AgeGroupsForStatistics agfs
	inner join (
		select SUM(cast(varValue as int)) as sumValue, rfs.idfsAgeGroup
		from dbo.tlbStatistic s
		  inner join @RayonsAndAgeGroupsForStatistics rfs
		  on rfs.idfsRayon = s.idfsArea and
			 rfs.idfsAgeGroup = s.idfsStatisticalAgeGroup and
			 s.intRowStatus = 0 and
			 s.idfsStatisticDataType = @idfsStatType_ByAgeInRayons and
			 s.datStatisticStartDate = cast(rfs.maxYear2_ByAgeInRayons as varchar(4)) + '-01-01' 
		group by rfs.idfsAgeGroup ) as s
	on agfs.idfsAgeGroup = s.idfsAgeGroup	
	
-- by Gender and Age Groups
-- если статистика есть по каждому полу для каждой Age Group, то суммируем ее. 
-- Иначе считаем статистику не полной

update agfs set
  agfs.StatisticsForSecondYear = case 
									when not exists (select * 
									                 from @AgeGroupsAndGenderForStatistics rafs 
									                 where rafs.idfsAgeGroup = s.idfsAgeGroup and 
									                 rafs.maxYear2_ByAgeAndGender is null )
										then s.sumValue
										else null 
                                end
 
from @AgeGroupsForStatistics agfs
	inner join (
		select SUM(cast(varValue as int)) as sumValue, rfs.idfsAgeGroup
		from dbo.tlbStatistic s
		  inner join @AgeGroupsAndGenderForStatistics rfs
		  on s.idfsArea  = @CountryID and
			 rfs.idfsAgeGroup = s.idfsStatisticalAgeGroup and
			 rfs.idfsGender = s.idfsMainBaseReference and
			 s.intRowStatus = 0 and
			 s.idfsStatisticDataType = @idfsStatType_ByAgeAndGender and
			 s.datStatisticStartDate = cast(rfs.maxYear2_ByAgeAndGender as varchar(4)) + '-01-01' 
		group by rfs.idfsAgeGroup ) as s
	on agfs.idfsAgeGroup = s.idfsAgeGroup	
where agfs.StatisticsForSecondYear is null


--Statistic for Children population
set @Statistics0_15ForFirstYear = null
select @Statistics0_15ForFirstYear = sum(agfs.StatisticsForFirstYear)
from @AgeGroupsForStatistics agfs
where exists (select * from @ChildrenAgeGroups cag where cag.idfsAgeGroup = agfs.idfsAgeGroup) 
and not exists (select * from @AgeGroupsForStatistics ags where ags.StatisticsForFirstYear is null)
set @Statistics0_15ForFirstYear = isnull(@Statistics0_15ForFirstYear, 0)

set @Statistics0_15ForSecondYear = null
select @Statistics0_15ForSecondYear = sum(agfs.StatisticsForSecondYear)
from @AgeGroupsForStatistics agfs
where exists (select * from @ChildrenAgeGroups cag where cag.idfsAgeGroup = agfs.idfsAgeGroup) 
and not exists (select * from @AgeGroupsForStatistics ags where ags.StatisticsForSecondYear is null)
set @Statistics0_15ForSecondYear = isnull(@Statistics0_15ForSecondYear, 0)


--select 
--	@idfsStatType_Population,
--	@idfsStatType_ByAgeAndGender,
--	@idfsStatType_ByAgeInRayons bigint
	
--select 
--@StatisticsForFirstYear as [@StatisticsForFirstYear],
--@StatisticsForSecondYear as [@StatisticsForSecondYear],
--@Statistics0_15ForFirstYear as [@Statistics0_15ForFirstYear],
--@Statistics0_15ForSecondYear as [@Statistics0_15ForSecondYear]



-- end get statistic

		
INSERT INTO @ReportTable (
		 idfsBaseReference
		, strDisease
		, strICD
		, blnIsSubdisease

		, intTotal_Abs_Y1			    
		, dblTotal_By100000_Y1		
		, intChildren_Abs_Y1		  
		, dblChildren_By100000_Y1	
		
		, intTotal_Abs_Y2			    
		, dblTotal_By100000_Y2		
		, intChildren_Abs_Y2		  
		, dblChildren_By100000_Y2	
		
		,intOrder
) 
SELECT 
	rr.idfsDiagnosisOrReportDiagnosisGroup, --idfsBaseReference
	IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault), --strDisease
	ISNULL(d.strIDC10, dg.strCode) +  isnull(ISNULL(' ' + snt2.strTextString, br2.strDefault), ''),
	CASE WHEN rr.intNullValueInsteadZero & 1 > 0 THEN 1 else 0 END, --blnIsSubdisease

	0,    --intTotal_Abs_Y1			    
	0.00, --dblTotal_By100000_Y1		
	0,    --intChildren_Abs_Y1		  
	0.00, --dblChildren_By100000_Y1	

	0,    --intTotal_Abs_Y2			    
	0.00, --dblTotal_By100000_Y2		
	0,    --strChildren_Abs_Y2		  
	0.00, --dblChildren_By100000_Y2	
	
	rr.intRowOrder
FROM   dbo.trtReportRows rr
    LEFT JOIN trtBaseReference br
        LEFT JOIN trtStringNameTranslation snt
        ON br.idfsBaseReference = snt.idfsBaseReference
			  AND snt.idfsLanguage = @idfsLanguage
			  
        LEFT OUTER JOIN trtDiagnosis d
        ON br.idfsBaseReference = d.idfsDiagnosis
			  
        LEFT OUTER JOIN trtReportDiagnosisGroup dg
        ON br.idfsBaseReference = dg.idfsReportDiagnosisGroup
    ON rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference
    
    LEFT OUTER JOIN trtBaseReference br2
        LEFT OUTER JOIN trtStringNameTranslation snt2
        ON br2.idfsBaseReference = snt2.idfsBaseReference
        AND snt2.idfsLanguage = @idfsLanguage
    ON rr.idfsICDReportAdditionalText = br2.idfsBaseReference    
   
    -- additional text
    LEFT OUTER JOIN trtBaseReference br1
        LEFT OUTER JOIN trtStringNameTranslation snt1
        ON br1.idfsBaseReference = snt1.idfsBaseReference
			  AND snt1.idfsLanguage = @idfsLanguage
    ON rr.idfsReportAdditionalText = br1.idfsBaseReference
WHERE rr.idfsCustomReportType = @idfsCustomReportType_Form3_01_2
		and rr.intRowStatus = 0
ORDER BY rr.intRowOrder  


if OBJECT_ID('tempdb.dbo.#ReportDiagnosisTable') is not null 
drop table #ReportDiagnosisTable

create table 	#ReportDiagnosisTable
(	idfsDiagnosis		BIGINT NOT NULL PRIMARY KEY,
	blnIsAggregate		BIT,
	intTotal			INT not NULL,
	intAge_0_15			INT not NULL
)

INSERT INTO #ReportDiagnosisTable (
	idfsDiagnosis,
	blnIsAggregate,
	intTotal,
	intAge_0_15
) 
SELECT distinct
  fdt.idfsDiagnosis,
  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
    THEN 1
    ELSE 0
  END,
  0,
  0
FROM dbo.trtDiagnosisToGroupForReportType fdt
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = fdt.idfsDiagnosis 
WHERE  fdt.idfsCustomReportType = @idfsCustomReportType_Form3_01_2 

       
INSERT INTO #ReportDiagnosisTable (
	idfsDiagnosis,
	blnIsAggregate,
	intTotal,
	intAge_0_15
) 
SELECT distinct
  trtd.idfsDiagnosis,
  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
    THEN 1
    ELSE 0
  END,
  0,
  0

FROM dbo.trtReportRows rr
    INNER JOIN trtBaseReference br
    ON br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
        AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
WHERE  rr.idfsCustomReportType = @idfsCustomReportType_Form3_01_2 
       AND  rr.intRowStatus = 0 
       AND NOT EXISTS 
       (
       SELECT * FROM #ReportDiagnosisTable
       WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
       )      


DECLARE	@ReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup	BIGINT NOT NULL PRIMARY KEY,
	intTotal			INT NOT NULL,
	intAge_0_15			INT NOT NULL
)


----------------------------------------------------------------------------------------
-- @StartDate1 - @FinishDate1
----------------------------------------------------------------------------------------
exec dbo.spRepHumComparativeGG_Calculations @StartDate1, @FinishDate1, @RegionID, @RayonID 

delete from @ReportDiagnosisGroupTable

insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal,
	intAge_0_15
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal),	
	    sum(intAge_0_15)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

   		
update		ft
set	
  ft.intTotal_Abs_Y1 = fdt.intTotal,	
	ft.intChildren_Abs_Y1 = fdt.intAge_0_15
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_Abs_Y1 = fdgt.intTotal,	
	ft.intChildren_Abs_Y1 = fdgt.intAge_0_15
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	


----------------------------------------------------------------------------------------
-- @StartDate2 - @FinishDate2
-- @FirstRegionID, @FirstRayonID 
----------------------------------------------------------------------------------------
update #ReportDiagnosisTable
set 	
	intTotal = 0,
	intAge_0_15 = 0
	
delete from @ReportDiagnosisGroupTable
	

exec dbo.spRepHumComparativeGG_Calculations @StartDate2, @FinishDate2, @RegionID, @RayonID 


insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal,
	intAge_0_15
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal),	
	    sum(intAge_0_15)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

update		ft
set	
  ft.intTotal_Abs_Y2 = fdt.intTotal,	
	ft.intChildren_Abs_Y2 = fdt.intAge_0_15
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_Abs_Y2 = fdgt.intTotal,	
	ft.intChildren_Abs_Y2 = fdgt.intAge_0_15
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	
	

--------------------------------

	
	
update 	rt		set  

		dblTotal_By100000_Y1	  = case when isnull(@StatisticsForFirstYear, 0) > 0 
		                                then (intTotal_Abs_Y1 * 100000.00) / @StatisticsForFirstYear 
		                                else null
		                          end,  
		
		
		dblChildren_By100000_Y1	= case when isnull(@Statistics0_15ForFirstYear, 0) > 0 
		                                then (intChildren_Abs_Y1 * 100000.00) / @Statistics0_15ForFirstYear 
		                                else null
		                          end,      
		 			    
		dblTotal_By100000_Y2		= case when isnull(@StatisticsForSecondYear, 0) > 0 
		                                then (intTotal_Abs_Y2 * 100000.00) / @StatisticsForSecondYear 
		                                else null
		                          end,
		
				  
		dblChildren_By100000_Y2 =	case when isnull(@Statistics0_15ForSecondYear, 0) > 0 
		                                then (intChildren_Abs_Y2 * 100000.00) / @Statistics0_15ForSecondYear 
		                                else null
		                            end
		

from 		@ReportTable rt
	
	



insert into	@ResultTable
	(	  idfsBaseReference
	
		, strDisease
		, strICD
		, blnIsSubdisease
		
		, intTotal_Abs_Y1
		, dblTotal_By100000_Y1
		, intChildren_Abs_Y1
		, dblChildren_By100000_Y1
		, intTotal_Abs_Y2
		, dblTotal_By100000_Y2
		, intChildren_Abs_Y2
		, dblChildren_By100000_Y2
		
		, intOrder
	)
	
select 
		  idfsBaseReference	

		, strDisease
		, strICD
		, blnIsSubdisease
		
		, intTotal_Abs_Y1 
		, dblTotal_By100000_Y1 
		, intChildren_Abs_Y1
		, dblChildren_By100000_Y1 
		
		, intTotal_Abs_Y2
		, dblTotal_By100000_Y2
		, intChildren_Abs_Y2
		, dblChildren_By100000_Y2
		
		, intOrder
		
from 	@ReportTable






	select * from @ResultTable
	order by intOrder
		

END
	
