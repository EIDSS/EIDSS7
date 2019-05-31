

--##SUMMARY 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumExternalComparative 'az-L', 2011, 2012 

exec spRepHumExternalComparative 'en', 2011, 2014 

exec spRepHumExternalComparative 'ru', 2011, 2012 


exec spRepHumExternalComparative 'az-L', 2013, 2014

*/ 
create PROCEDURE [dbo].[spRepHumExternalComparative]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@EndMonth			as int = null,
	@RegionID			as bigint = null,
	@RayonID			as bigint = null,
	@SiteID				as bigint = null

AS
BEGIN
	declare	@ResultTable	table
	(	  idfsBaseReference			bigint not null primary key
		, intRowNumber				int null
	
		, strDisease				nvarchar(300) collate database_default not null 
		, blnIsSubdisease			bit null	
		
		--, strAdministrativeUnit		nvarchar(2000) collate database_default not null 
		
		, intTotal_Abs_Y1			    int    null
		, dblTotal_By100000_Y1			decimal(10,2)  null
		, intChildren_Abs_Y1			int    null
		, dblChildren_By100000_Y1		decimal(10,2)  null
		
		, intTotal_Abs_Y2			    int    null
		, dblTotal_By100000_Y2			decimal(10,2)  null
		, intChildren_Abs_Y2			int    null
		, dblChildren_By100000_Y2		decimal(10,2)  null
		
		--, dblTotal_Growth			    decimal(10,2)   null
		--, dblChildren_Growth			decimal(10,2)   null
		
		--, intStatisticsForFirstYear		int null
		--, intStatisticsForSecondYear	int null
		
		--, intStatistics17ForFirstYear	int null
		--, intStatistics17ForSecondYear	int null		
		, intOrder int
	)
	
  declare	@ReportTable	table
	(	  idfsBaseReference				bigint not null primary key
		, intRowNumber					int null
	
		, strDisease					nvarchar(300) collate database_default not null 
		, blnIsSubdisease				bit null	
		
		--, strAdministrativeUnit			nvarchar(2000) collate database_default not null 
		
		, intTotal_Abs_Y1			    int    null
		, dblTotal_By100000_Y1			decimal(10,2)  null
		, intChildren_Abs_Y1			int    null
		, dblChildren_By100000_Y1		decimal(10,2)  null
		
		, intTotal_Abs_Y2			    int    null
		, dblTotal_By100000_Y2			decimal(10,2)  null
		, intChildren_Abs_Y2			int    null
		, dblChildren_By100000_Y2		decimal(10,2)  null
		
		--, dblTotal_Growth			    decimal(10,2)   null
		--, dblChildren_Growth			decimal(10,2)   null
		
		,	intOrder int
	)

		
	DECLARE 		
		@StartDate1					datetime,	 
		@FinishDate1				datetime,

		@StartDate2					datetime,	 
		@FinishDate2				datetime,
		
		@idfsLanguage				bigint,
	  
		@idfsCustomReportType		bigint,	
	  
		@strAdministrativeUnit		nvarchar(2000),
	  
		@CountryID					bigint,
		@idfsSite					bigint,
		@idfsSiteType				bigint,

	  
		@StatisticsForFirstYear		int,
		@StatisticsForSecondYear	int,
	
		@Statistics17ForFirstYear	int,
		@Statistics17ForSecondYear	int,
		
		@strStartMonth				nvarchar(2),
		@strEndMonth				nvarchar(2),

		@idfsStatType_Population bigint,
		@idfsStatType_Population17 bigint,
			
		@isWeb bigint,
		@idfsRegionOtherRayons bigint,
		
		--@strAzerbaijanRepublic nvarchar(100),
		
 		@TransportCHE bigint
	
	
	
	declare @RayonsForStatistics table
	(
		idfsRayon bigint primary key,
		 maxYear1 int,
		 maxYear2 int,
		 maxYear171 int,
		 maxYear172 int		 
	)
		  
	
	SET @idfsCustomReportType = 10290019 /*External Comparative Report*/
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		

	declare @StartMonth int
	if @StartMonth is null set @StartMonth = 1
	if @EndMonth is null set @EndMonth = 12


	set @strStartMonth = case when 	@StartMonth	between 1 and 9 then '0' + cast(@StartMonth as nvarchar) else cast(@StartMonth as nvarchar) end
	set @strEndMonth = case when @EndMonth	between 1 and 9 then '0' + cast(@EndMonth as nvarchar) else cast(@EndMonth as nvarchar) end	
		
	set @StartDate1  = (CAST(@FirstYear AS VARCHAR(4)) + @strStartMonth + '01')
	set @FinishDate1  = dateADD(mm, 1, (CAST(@FirstYear AS VARCHAR(4)) + @strEndMonth + '01'))

	set @StartDate2  = (CAST(@SecondYear AS VARCHAR(4)) + @strStartMonth + '01')
	set @FinishDate2  = dateADD(mm, 1, (CAST(@SecondYear AS VARCHAR(4)) + @strEndMonth + '01'))	
	
	
	
	
	set	@CountryID = 170000000
	
	set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
  
	select @isWeb = isnull(ts.blnIsWEB, 0) 
	from tstSite ts
	where ts.idfsSite = dbo.fnSiteID()  
	
	select @idfsSiteType = ts.idfsSiteType
	from tstSite ts
	where ts.idfsSite = @SiteID
	if @idfsSiteType is null set @idfsSiteType = 10085001
			
	--set @idfsStatType_Population = 39850000000  -- Population
	select @idfsStatType_Population = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Statistical Data Type'
	where cast(tbra.varValue as nvarchar(100)) = N'Population'
	
	--set @idfsStatType_Population17 = 000  -- Population under 17
	select @idfsStatType_Population17 = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Statistical Data Type'
	where cast(tbra.varValue as nvarchar(100)) = N'Population under 17'	
					
	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
 	
	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'		
	
	----@strAzerbaijanRepublic
	--select @strAzerbaijanRepublic = tsnt.strTextString
 --	from trtBaseReference tbr 
 --		inner join trtStringNameTranslation tsnt
 --		on tsnt.idfsBaseReference = tbr.idfsBaseReference
 --		and tsnt.idfsLanguage = @idfsLanguage
 --	where tbr.idfsReferenceType = 19000132 /*additional report text*/
 --	and tbr.strDefault = 'Azerbaijan Republic'
 	
 --	set @strAzerbaijanRepublic = isnull(@strAzerbaijanRepublic, 'Azerbaijan Republic')		
			
	--SET @strAdministrativeUnit = ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000002 /*rftRayon*/) WHERE idfsReference = @RayonID),'') 
 --                      +
 --                      CASE WHEN @RayonID IS NOT NULL AND @RegionID IS NOT NULL AND @RegionID <> 1344340000000 -- Other rayons
 --                       THEN
 --                           ', '
 --                       ELSE ''
 --                      END
 --                      +
 --                      CASE WHEN @RegionID IS NOT NULL AND (@RayonID IS NULL OR @RegionID <> 1344340000000) -- Other rayons
 --                       THEN
 --                           ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000003 /*rftRegion*/) WHERE idfsReference = @RegionID),'') 
 --                       ELSE ''
 --                      END
 --           					+  @strAzerbaijanRepublic   
                       
            					
	
	
-- get statistic
	
	
-- Get statictics for Rayon-region
insert into @RayonsForStatistics (idfsRayon)
select idfsRayon from gisRayon
where (
      idfsRayon = @RayonID or
      (idfsRegion = @RegionID and @RayonID is null) or
      (idfsCountry = @CountryID and @RayonID is null and @RegionID is null) or
	  (idfsCountry = @CountryID and @RegionID = @TransportCHE)
      ) 
      and intRowStatus = 0
			

	  
		  			
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
    
update rfstat set
   rfstat.maxYear171 = maxYear
from @RayonsForStatistics rfstat
inner join (
    select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon
    from @RayonsForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = rfs.idfsRayon 
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_Population17 
      and year(stat.datStatisticStartDate) <= @FirstYear
    group by  idfsRayon
    ) as mrfs
    on rfstat.idfsRayon = mrfs.idfsRayon    
                                      	
--если статистика есть по каждому району, то суммируем ее. 
--Иначе считаем статистику не полной и вообще не считаем для данного года-региона
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

if not exists (select * from @RayonsForStatistics where maxYear171 is null)
begin
    select @Statistics17ForFirstYear = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population17 and
         s.datStatisticStartDate = cast(rfs.maxYear171 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @Statistics17ForFirstYear = 0    

      
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
    
update rfstat set
   rfstat.maxYear172 = maxYear
from @RayonsForStatistics rfstat
inner join (
    select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon
    from @RayonsForStatistics  rfs    
      inner join dbo.tlbStatistic stat
      on stat.idfsArea = rfs.idfsRayon 
      and stat.intRowStatus = 0
      and stat.idfsStatisticDataType = @idfsStatType_Population17
      and year(stat.datStatisticStartDate) <= @SecondYear
    group by  idfsRayon
    ) as mrfs
    on rfstat.idfsRayon = mrfs.idfsRayon    
                                      	
--если статистика есть по каждому району, то суммируем ее. 
--Иначе считаем статистику не полной и вообще не считаем для данного года-региона
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

	
if not exists (select * from @RayonsForStatistics where maxYear172 is null)
begin
    select @Statistics17ForSecondYear = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population17 and 
         s.datStatisticStartDate = cast(rfs.maxYear172 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @Statistics17ForSecondYear = 0  		
		
		
		
INSERT INTO @ReportTable (
      idfsBaseReference
		, intRowNumber
		, strDisease
		, blnIsSubdisease
		--, strAdministrativeUnit

    , intTotal_Abs_Y1			    
		, dblTotal_By100000_Y1		
		, intChildren_Abs_Y1		  
		, dblChildren_By100000_Y1	
		
		, intTotal_Abs_Y2			    
		, dblTotal_By100000_Y2		
		, intChildren_Abs_Y2		  
		, dblChildren_By100000_Y2	
		
		,	intOrder
) 
SELECT 
	rr.idfsDiagnosisOrReportDiagnosisGroup, --idfsBaseReference
	rr.intRowOrder, --intRowNumber
	IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault), --strDisease
	CASE WHEN rr.intNullValueInsteadZero & 1 > 0 THEN 1 else 0 END, --blnIsSubdisease

	--@strAdministrativeUnit, --strAdministrativeUnit
  
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
   
    -- additional text
    LEFT OUTER JOIN trtBaseReference br1
        LEFT OUTER JOIN trtStringNameTranslation snt1
        ON br1.idfsBaseReference = snt1.idfsBaseReference
			  AND snt1.idfsLanguage = @idfsLanguage
    ON rr.idfsReportAdditionalText = br1.idfsBaseReference
WHERE rr.idfsCustomReportType = @idfsCustomReportType
		and rr.intRowStatus = 0
ORDER BY rr.intRowOrder  


if OBJECT_ID('tempdb.dbo.#ReportDiagnosisTable') is not null 
drop table #ReportDiagnosisTable

create table 	#ReportDiagnosisTable
(	idfsDiagnosis		BIGINT NOT NULL PRIMARY KEY,
	blnIsAggregate		BIT,
	intTotal			INT not NULL,
	intAge_0_17			INT not NULL
)

INSERT INTO #ReportDiagnosisTable (
	idfsDiagnosis,
	blnIsAggregate,
	intTotal,
	intAge_0_17
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
WHERE  fdt.idfsCustomReportType = @idfsCustomReportType 

       
INSERT INTO #ReportDiagnosisTable (
	idfsDiagnosis,
	blnIsAggregate,
	intTotal,
	intAge_0_17
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
--        AND trtd.intRowStatus = 0
WHERE  rr.idfsCustomReportType = @idfsCustomReportType 
       AND  rr.intRowStatus = 0 
       AND NOT EXISTS 
       (
       SELECT * FROM #ReportDiagnosisTable
       WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
       )      


DECLARE	@ReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup	BIGINT NOT NULL PRIMARY KEY,
	intTotal			INT NOT NULL,
	intAge_0_17			INT NOT NULL
)

	
----------------------------------------------------------------------------------------
-- @StartDate1 - @FinishDate1
----------------------------------------------------------------------------------------
exec dbo.spRepHumExternalComparative_Calculations @CountryID, @StartDate1, @FinishDate1, @RegionID, @RayonID 

delete from @ReportDiagnosisGroupTable

insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal,
	intAge_0_17
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal),	
	    sum(intAge_0_17)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

   		
update		ft
set	
  ft.intTotal_Abs_Y1 = fdt.intTotal,	
	ft.intChildren_Abs_Y1 = fdt.intAge_0_17
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_Abs_Y1 = fdgt.intTotal,	
	ft.intChildren_Abs_Y1 = fdgt.intAge_0_17
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
	intAge_0_17 = 0
	
delete from @ReportDiagnosisGroupTable
	

exec dbo.spRepHumExternalComparative_Calculations @CountryID, @StartDate2, @FinishDate2, @RegionID, @RayonID 


insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal,
	intAge_0_17
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal),	
	    sum(intAge_0_17)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

update		ft
set	
  ft.intTotal_Abs_Y2 = fdt.intTotal,	
	ft.intChildren_Abs_Y2 = fdt.intAge_0_17
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_Abs_Y2 = fdgt.intTotal,	
	ft.intChildren_Abs_Y2 = fdgt.intAge_0_17
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	
	

--------------------------------

	
	
update 	rt		set  

		dblTotal_By100000_Y1	  = case when isnull(@StatisticsForFirstYear, 0) > 0 
		                                then (intTotal_Abs_Y1 * 100000.00) / @StatisticsForFirstYear 
		                                else null
		                          end,  
		
		
		dblChildren_By100000_Y1	= case when isnull(@Statistics17ForFirstYear, 0) > 0 
		                                then (intChildren_Abs_Y1 * 100000.00) / @Statistics17ForFirstYear 
		                                else null
		                          end,      
		 			    
		dblTotal_By100000_Y2		= case when isnull(@StatisticsForSecondYear, 0) > 0 
		                                then (intTotal_Abs_Y2 * 100000.00) / @StatisticsForSecondYear 
		                                else null
		                          end,
		
				  
		dblChildren_By100000_Y2 =	case when isnull(@Statistics17ForSecondYear, 0) > 0 
		                                then (intChildren_Abs_Y2 * 100000.00) / @Statistics17ForSecondYear 
		                                else null
		                            end
		--dblTotal_Growth =			case when intTotal_Abs_Y1 > 0 and intTotal_Abs_Y2 > 0 and @StatisticsForFirstYear> 0 and @StatisticsForSecondYear>0
		--									then
		--										case when 
		--											((intTotal_Abs_Y1 * 100000.00	/ @StatisticsForFirstYear) * 100.00 / 
		--											(intTotal_Abs_Y2 * 100000.00	/ @StatisticsForSecondYear) - 100.00) > 100
		--											then 
		--												((intTotal_Abs_Y1 * 100000.00	/ @StatisticsForFirstYear) * 100.00 / 
		--												(intTotal_Abs_Y2 * 100000.00	/ @StatisticsForSecondYear) - 100.00) / 100.00
		--											else
		--												((intTotal_Abs_Y1 * 100000.00	/ @StatisticsForFirstYear) * 100.00 / 
		--												(intTotal_Abs_Y2 * 100000.00	/ @StatisticsForSecondYear) - 100.00)
		--										end
		--									else null
		--							end,
		--dblChildren_Growth =			case when intChildren_Abs_Y1 > 0 and intChildren_Abs_Y2 > 0 and @Statistics17ForFirstYear > 0 and @Statistics17ForSecondYear > 0
		--									then
		--										case when 
		--											((intChildren_Abs_Y1 * 100000.00	/ @Statistics17ForFirstYear) * 100.00 / 
		--											(intChildren_Abs_Y2 * 100000.00	/ @Statistics17ForSecondYear) - 100.00) > 100
		--											then 
		--												((intChildren_Abs_Y1 * 100000.00	/ @Statistics17ForFirstYear) * 100.00 / 
		--												(intChildren_Abs_Y2 * 100000.00	/ @Statistics17ForSecondYear) - 100.00) / 100.00
		--											else
		--												((intChildren_Abs_Y1 * 100000.00	/ @Statistics17ForFirstYear) * 100.00 / 
		--												(intChildren_Abs_Y2 * 100000.00	/ @Statistics17ForSecondYear) - 100.00)
		--										end
		--									else null
		--							end

from 		@ReportTable rt
	
	



insert into	@ResultTable
	(	  idfsBaseReference
		, intRowNumber
	
		, strDisease
		, blnIsSubdisease
		
		--, strAdministrativeUnit
		
		, intTotal_Abs_Y1
		, dblTotal_By100000_Y1
		, intChildren_Abs_Y1
		, dblChildren_By100000_Y1
		, intTotal_Abs_Y2
		, dblTotal_By100000_Y2
		, intChildren_Abs_Y2
		, dblChildren_By100000_Y2
		
		--, intStatisticsForFirstYear
		--, intStatisticsForSecondYear	
		--, intStatistics17ForFirstYear	
		--, intStatistics17ForSecondYear	
		
		, intOrder
	)
	
select 
		  idfsBaseReference	
		, intRowNumber
	
		, strDisease
		, blnIsSubdisease
		
		--, strAdministrativeUnit
		
		, case when intTotal_Abs_Y1 = 0 then null else intTotal_Abs_Y1  end
		, case when dblTotal_By100000_Y1 = 0 then null else dblTotal_By100000_Y1  end
		, case when intChildren_Abs_Y1 = 0 then null else intChildren_Abs_Y1  end
		, case when dblChildren_By100000_Y1 = 0 then null else dblChildren_By100000_Y1  end
		
		, case when intTotal_Abs_Y2 = 0 then null else intTotal_Abs_Y2  end
		, case when dblTotal_By100000_Y2 = 0 then null else dblTotal_By100000_Y2  end
		, case when intChildren_Abs_Y2 = 0 then null else intChildren_Abs_Y2 end
		, case when dblChildren_By100000_Y2 = 0 then null else dblChildren_By100000_Y2  end
		
		--, @StatisticsForFirstYear
		--, @StatisticsForSecondYear	
		--, @Statistics17ForFirstYear	
		--, @Statistics17ForSecondYear			
		
		, intOrder
		
from 	@ReportTable


select * from @ResultTable
order by intOrder
	

END
	
