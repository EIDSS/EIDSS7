

--##SUMMARY 

--##REMARKS Author:  Romasheva S.
--##REMARKS Create date: 25.05.2012

--##REMARKS Updated 25.09.2014 by Romasheva S.

--##RETURNS Don't use 

/*
--Example of a call of procedure:
867
868
869

exec spRepHumComparative 'az-l', 2011, 2012, 1, 12, null, null, null, NULL, null, 1

exec spRepHumComparative 'en', 2011, 2012, 1, 12, null, null, null, NULL, 867, 1
exec spRepHumComparative 'en', 2011, 2012, 1, 12, null, null, null, NULL, 868, 1
exec spRepHumComparative 'en', 2011, 2012, 1, 12, null, null, null, NULL, 869, 1

exec spRepHumComparative 'en', 2012, 2012, 1, 12, null, null, null, NULL, null, 2
exec spRepHumComparative 'en', 2012, 2012, 1, 12, null, null, null, NULL, null, 3

exec spRepHumComparative 'az-l', 2012, 2014, 1, 12, 1344330000000, 1344440000000, null, NULL, null, 4 -- Baku, Yasamal (Baku)
*/ 
 
create PROCEDURE [dbo].[spRepHumComparative]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@StartMonth			as int = null,
	@EndMonth			as int = null,
	@FirstRegionID		as bigint = null,
	@FirstRayonID		as bigint = null,
	@SecondRegionID		as bigint = null,
	@SecondRayonID		as bigint = null,
	@OrganizationID		as bigint = null, -- idfsSiteID!!
	@Counter			as int,  -- 1 = Absolute number, 2 = For 10.000 population, 3 = For 100.000 population, 4 = For 1.000.000 population
	@SiteID				as bigint = null

AS
BEGIN
	declare	@ReportTable	table
	(	  idfsBaseReference	bigint not null primary key
		, intRowNumber		int null
	
		, strDisease		nvarchar(300) collate database_default not null 
		, strICD10			nvarchar(200) collate database_default null	
		
		, strAdministrativeUnit1 nvarchar(2000) collate database_default not null 
		, intTotal_1_Y1 decimal(8,2) not null
		, intTotal_1_Y2 decimal(8,2) not null
		, intTotal_1_Percent decimal(8,2) not null
		, intChildren_1_Y1 decimal(8,2) not null
		, intChildren_1_Y2 decimal(8,2) not null
		, intChildren_1_Percent decimal(10,2) not null
		
		, strAdministrativeUnit2 nvarchar(2000) collate database_default not null 
		, intTotal_2_Y1 decimal(8,2) not null
		, intTotal_2_Y2 decimal(8,2) not null
		, intTotal_2_Percent decimal(10,2) not null
		, intChildren_2_Y1 decimal(8,2) not null
		, intChildren_2_Y2 decimal(8,2) not null
		, intChildren_2_Percent decimal(10,2) not null
	
		, intOrder			int not null
	)




 DECLARE 		
	@StartDate1	DATETIME,	 
	@FinishDate1	DATETIME,

	@StartDate2	DATETIME,	 
	@FinishDate2	DATETIME,

	@idfsLanguage BIGINT,

	@idfsCustomReportType BIGINT,	

	@strAdministrativeUnit1 nvarchar(2000),
	@strAdministrativeUnit2 nvarchar(2000),

	@CountryID bigint,
	@idfsSite bigint,
	@idfsSiteType bigint,

	@StatisticsForFirstYearFirstArea int,
	@StatisticsForSecondYearFirstArea int,
	@StatisticsForFirstYearSecondArea int,
	@StatisticsForSecondYearSecondArea int,
	
	@Statistics17ForFirstYearFirstArea int,
	@Statistics17ForSecondYearFirstArea int,
	@Statistics17ForFirstYearSecondArea int,
	@Statistics17ForSecondYearSecondArea int,	
	
	@idfsStatType_Population bigint,
	@idfsStatType_Population17 bigint,
	
	@idfsRegionOtherRayons bigint,
	@idfsRegionBaku bigint,
	@isWeb bigint,
	@strRepublic nvarchar(100)
	  

	declare @FilteredRayons table
	(idfsRayon bigint primary key)

	declare @RayonsForStatistics table
	(idfsRayon bigint primary key,
	 maxYear1 int,
	 maxYear2 int,
	 maxYear171 int,
	 maxYear172 int
	)
	  
 
	SET @idfsCustomReportType = 10290001 /*Comparative Report*/

	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		

	if @StartMonth IS null
	begin
		  set @StartDate1 = (CAST(@FirstYear AS VARCHAR(4)) + '01' + '01')
		  set @FinishDate1 = dateADD(yyyy, 1, @StartDate1)
	  	
		set @StartDate2 = (CAST(@SecondYear AS VARCHAR(4)) + '01' + '01')
		  set @FinishDate2 = dateADD(yyyy, 1, @StartDate2)
	end
	else
	begin	
	  IF @StartMonth < 10	begin
			  set @StartDate1 = (CAST(@FirstYear AS VARCHAR(4)) + '0' +CAST(@StartMonth AS VARCHAR(2)) + '01')
			  set @StartDate2 = (CAST(@SecondYear AS VARCHAR(4)) + '0' +CAST(@StartMonth AS VARCHAR(2)) + '01')
		end	
	  ELSE begin				
			  set @StartDate1 = (CAST(@FirstYear AS VARCHAR(4)) + CAST(@StartMonth AS VARCHAR(2)) + '01')
			  set @StartDate2 = (CAST(@SecondYear AS VARCHAR(4)) + CAST(@StartMonth AS VARCHAR(2)) + '01')
		end
			
	  IF (@EndMonth is null) or (@StartMonth = @EndMonth) begin
			  set @FinishDate1 = dateADD(mm, 1, @StartDate1)
			  set @FinishDate2 = dateADD(mm, 1, @StartDate2)
		end	
	  ELSE	begin
			IF @EndMonth < 10	begin
				  set @FinishDate1 = (CAST(@FirstYear AS VARCHAR(4)) + '0' +CAST(@EndMonth AS VARCHAR(2)) + '01')
				  set @FinishDate2 = (CAST(@SecondYear AS VARCHAR(4)) + '0' +CAST(@EndMonth AS VARCHAR(2)) + '01')
				end
			  ELSE begin
				  set @FinishDate1 = (CAST(@FirstYear AS VARCHAR(4)) + CAST(@EndMonth AS VARCHAR(2)) + '01')
				  set @FinishDate2 = (CAST(@SecondYear AS VARCHAR(4)) + CAST(@EndMonth AS VARCHAR(2)) + '01')
				end  
				
			  set @FinishDate1 = dateADD(mm, 1, @FinishDate1)
			  set @FinishDate2 = dateADD(mm, 1, @FinishDate2)
	  end
	end	

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
					
	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'			
	
	--1344330000000 --Baku
	select @idfsRegionBaku = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Baku'
	
	--@strRepublic
	select @strRepublic = tsnt.strTextString
 	from trtBaseReference tbr 
 		inner join trtStringNameTranslation tsnt
 		on tsnt.idfsBaseReference = tbr.idfsBaseReference
 		and tsnt.idfsLanguage = @idfsLanguage
 	where tbr.idfsReferenceType = 19000132 /*additional report text*/
 	and tbr.strDefault = 'Republic'
			
	set @strRepublic = isnull(@strRepublic, 'Republic')

	SET @strAdministrativeUnit1 = isnull((select [name] from fnGisReference(@LangID, 19000002 /*rftRayon*/) where idfsReference = @FirstRayonID),'') 
							+
							case when @FirstRayonID IS NOT NULL AND @FirstRegionID IS NOT NULL AND @FirstRegionID <> @idfsRegionOtherRayons -- Other rayons
							then ', '
							else ''
							end
							+
							case when @FirstRegionID IS NOT NULL AND (@FirstRayonID IS NULL OR @FirstRegionID <> @idfsRegionOtherRayons) -- Other rayons
								then isnull((select [name] from fnGisReference(@LangID, 19000003 /*rftRegion*/) where idfsReference = @FirstRegionID),'') 
								else ''
							end
							+
							case when @FirstRayonID IS NULL AND @FirstRegionID IS null 
								then @strRepublic --case when @LangID = 'az-l' then 'Respublika' when @LangID = 'ru' then 'Республика' else 'Republic' end
								else ''
							end
						
					

	SET @strAdministrativeUnit2 = ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000002 /*rftRayon*/) WHERE idfsReference = @SecondRayonID),'') 
						   +
						   CASE WHEN @SecondRayonID IS NOT NULL AND @SecondRegionID IS NOT NULL AND @SecondRegionID <> @idfsRegionOtherRayons -- Other rayons
							THEN
								', '
							ELSE ''
						   END
						   +
						   CASE WHEN @SecondRegionID IS NOT NULL AND (@SecondRayonID IS NULL OR @SecondRegionID <> @idfsRegionOtherRayons) -- Other rayons
							THEN
								ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000003 /*rftRegion*/) WHERE idfsReference = @SecondRegionID),'') 
							ELSE ''
						   END
            						+
						   CASE WHEN @SecondRayonID IS NULL AND @SecondRegionID IS NULL and @OrganizationID is null
							THEN @strRepublic --case when @LangID = 'az-l' then 'Respublika' when @LangID = 'ru' then 'Республика' else 'Republic' end
							ELSE ''
						   end
						   +
							case when  @OrganizationID is not null
								then isnull((select top 1 fi.[name] 
									 from dbo.fnInstitution(@LangID) fi 
										inner join tstSite ts
										on ts.idfOffice = fi.idfOffice
											 where ts.idfsSite = @OrganizationID), '')
								else ''
							end	

-----------------------------------------------------------------------------------------------
if @Counter > 1 -- 1 = Absolute number
begin

-- get statistic
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
					and stsr.idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
	where  gls.idfsRayon is not null
	
	-- + border area
	insert into @FilteredRayons (idfsRayon)
	select distinct
		osr.idfsRayon
	from @FilteredRayons fr
		inner join gisRayon r
          on r.idfsRayon = fr.idfsRayon
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

-- Get statictics for first Rayon-region
insert into @RayonsForStatistics (idfsRayon)
select idfsRayon from gisRayon
where (
      idfsRayon = @FirstRayonID or
      (idfsRegion = @FirstRegionID and @FirstRayonID is null) or
      (idfsCountry = @CountryID and @FirstRayonID is null and @FirstRegionID is null)
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
    select @StatisticsForFirstYearFirstArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea 
         and s.intRowStatus = 0 
         and s.idfsStatisticDataType = @idfsStatType_Population  
         and s.datStatisticStartDate = cast(rfs.maxYear1 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @StatisticsForFirstYearFirstArea = 0       

if not exists (select * from @RayonsForStatistics where maxYear171 is null)
begin
    select @Statistics17ForFirstYearFirstArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea 
         and s.intRowStatus = 0 
         and s.idfsStatisticDataType = @idfsStatType_Population17  
         and s.datStatisticStartDate = cast(rfs.maxYear171 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @Statistics17ForFirstYearFirstArea = 0  

      
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
    select @StatisticsForSecondYearFirstArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population  
         and s.datStatisticStartDate = cast(rfs.maxYear2 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @StatisticsForSecondYearFirstArea = 0    

if not exists (select * from @RayonsForStatistics where maxYear172 is null)
begin
    select @Statistics17ForSecondYearFirstArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population17  
         and s.datStatisticStartDate = cast(rfs.maxYear172 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @Statistics17ForSecondYearFirstArea = 0   

-- Get statictics for second Rayon-region
delete from @RayonsForStatistics

insert into @RayonsForStatistics (idfsRayon)
select idfsRayon from gisRayon
where (
      idfsRayon = @SecondRayonID or
      (idfsRegion = @SecondRegionID and @SecondRayonID is null) or
      (idfsCountry = @CountryID and @SecondRayonID is null and @SecondRegionID is null)
      ) 
      and 
      (
		@idfsSiteType  in (10085001, 10085002)--sitCDR, sitEMS
		or
		@isWeb = 1
		or 
		idfsRayon in (select idfsRayon from @FilteredRayons)
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
    select @StatisticsForFirstYearSecondArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population 
         and s.datStatisticStartDate = cast(rfs.maxYear1 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @StatisticsForFirstYearSecondArea = 0 

if not exists (select * from @RayonsForStatistics where maxYear171 is null)
begin
    select @Statistics17ForFirstYearSecondArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population17  
         and s.datStatisticStartDate = cast(rfs.maxYear171 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @Statistics17ForFirstYearSecondArea = 0       

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
    select @StatisticsForSecondYearSecondArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population  
         and s.datStatisticStartDate = cast(rfs.maxYear2 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @StatisticsForSecondYearSecondArea = 0    

if not exists (select * from @RayonsForStatistics where maxYear172 is null)
begin
    select @Statistics17ForSecondYearSecondArea = SUM(cast(s.sumValue as int))
    from (
    select SUM(cast(varValue as int)) as sumValue
    from dbo.tlbStatistic s
      inner join @RayonsForStatistics rfs
      on rfs.idfsRayon = s.idfsArea and
         s.intRowStatus = 0 and
         s.idfsStatisticDataType = @idfsStatType_Population17  
         and s.datStatisticStartDate = cast(rfs.maxYear2 as varchar(4)) + '-01-01' 
    group by rfs.idfsRayon ) as s
end    
else set @Statistics17ForSecondYearSecondArea = 0  


-- end of get statistics
end --if @Counter > 1 begin
-----------------------------------------------------------------------------------------------


INSERT INTO @ReportTable (
		idfsBaseReference
		, intRowNumber
	
		, strDisease
		, strICD10
		
		, strAdministrativeUnit1
		, intTotal_1_Y1
		, intTotal_1_Y2
		, intTotal_1_Percent
		, intChildren_1_Y1
		, intChildren_1_Y2
		, intChildren_1_Percent
		
		, strAdministrativeUnit2
		, intTotal_2_Y1
		, intTotal_2_Y2
		, intTotal_2_Percent
		, intChildren_2_Y1
		, intChildren_2_Y2
		, intChildren_2_Percent
		, intOrder

) 
SELECT 
  rr.idfsDiagnosisOrReportDiagnosisGroup,
  case
	when	IsNull(br.idfsReferenceType, -1) = 19000130	-- Diagnosis Group
			and IsNull(br.strDefault, N'') = N'Total'
		then	null
	else	rr.intRowOrder
  end,
  case
	when	IsNull(br.idfsReferenceType, -1) = 19000130	-- Diagnosis Group
			and IsNull(br.strDefault, N'') = N'Total'
		then	IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault) + N'*'
	else	IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault)
  end,
  ISNULL(d.strIDC10, dg.strCode),
  
  @strAdministrativeUnit1,
  0,
  0,
  0.00,
  0,
  0,
  0.00,
  
  @strAdministrativeUnit2,
  0,
  0,
  0.00,
  0,
  0,
  0.00,
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
-- @FirstRegionID, @FirstRayonID 
----------------------------------------------------------------------------------------
exec dbo.spRepHumComparative_Calculations @CountryID, @StartDate1, @FinishDate1, @FirstRegionID, @FirstRayonID, @OrganizationID

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
    ft.intTotal_1_Y1 = fdt.intTotal,	
	ft.intChildren_1_Y1 = fdt.intAge_0_17
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_1_Y1 = fdgt.intTotal,	
	ft.intChildren_1_Y1 = fdgt.intAge_0_17
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
	

exec dbo.spRepHumComparative_Calculations @CountryID, @StartDate2, @FinishDate2, @FirstRegionID, @FirstRayonID, @OrganizationID

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
  ft.intTotal_1_Y2 = fdt.intTotal,	
	ft.intChildren_1_Y2 = fdt.intAge_0_17
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_1_Y2 = fdgt.intTotal,	
	ft.intChildren_1_Y2 = fdgt.intAge_0_17
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	




----------------------------------------------------------------------------------------
-- @StartDate1 - @FinishDate1
-- @SecondRegionID, @SecondRayonID 
----------------------------------------------------------------------------------------
update #ReportDiagnosisTable
set 	
	intTotal = 0,
	intAge_0_17 = 0
	
delete from @ReportDiagnosisGroupTable
	

exec dbo.spRepHumComparative_Calculations @CountryID, @StartDate1, @FinishDate1, @SecondRegionID, @SecondRayonID, @OrganizationID

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
  ft.intTotal_2_Y1 = fdt.intTotal,	
	ft.intChildren_2_Y1 = fdt.intAge_0_17
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal_2_Y1 = fdgt.intTotal,	
	ft.intChildren_2_Y1 = fdgt.intAge_0_17
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	




----------------------------------------------------------------------------------------
-- @StartDate2 - @FinishDate2
-- @SecondRegionID, @SecondRayonID 
----------------------------------------------------------------------------------------
update #ReportDiagnosisTable
set 	
	intTotal = 0,
	intAge_0_17 = 0
	
delete from @ReportDiagnosisGroupTable
	

exec dbo.spRepHumComparative_Calculations  @CountryID, @StartDate2, @FinishDate2, @SecondRegionID, @SecondRayonID, @OrganizationID

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
	ft.intTotal_2_Y2 = fdt.intTotal,	
	ft.intChildren_2_Y2 = fdt.intAge_0_17
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
	ft.intTotal_2_Y2 = fdgt.intTotal,	
	ft.intChildren_2_Y2 = fdgt.intAge_0_17
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	




if @Counter > 1
begin
	if @Counter = 2 set @Counter = 10000.00
	else
	if @Counter = 3 set @Counter = 100000.00
	else
	if @Counter = 4 set @Counter = 1000000

	update @ReportTable set 
	intTotal_1_Y1 = case isnull(@StatisticsForFirstYearFirstArea, 0) when 0 then 0 else (intTotal_1_Y1 / @StatisticsForFirstYearFirstArea) * @Counter end,
	intTotal_1_Y2 = case isnull(@StatisticsForSecondYearFirstArea, 0) when 0 then 0 else (intTotal_1_Y2 / @StatisticsForSecondYearFirstArea) * @Counter end,

	intChildren_1_Y1 = case isnull(@StatisticsForFirstYearFirstArea, 0) when 0 then 0 else (intChildren_1_Y1 / @Statistics17ForFirstYearFirstArea) * @Counter end,
	intChildren_1_Y2 = case isnull(@StatisticsForSecondYearFirstArea, 0) when 0 then 0 else (intChildren_1_Y2 / @Statistics17ForSecondYearFirstArea) * @Counter end,

	intTotal_2_Y1 = case isnull(@StatisticsForFirstYearSecondArea, 0) when 0 then 0 else (intTotal_2_Y1 / @StatisticsForFirstYearSecondArea) * @Counter end,
	intTotal_2_Y2 = case isnull(@StatisticsForSecondYearSecondArea, 0) when 0 then 0 else (intTotal_2_Y2 / @StatisticsForSecondYearSecondArea) * @Counter end,

	intChildren_2_Y1 = case isnull(@StatisticsForFirstYearSecondArea, 0) when 0 then 0 else (intChildren_2_Y1 / @Statistics17ForFirstYearSecondArea) * @Counter end,
	intChildren_2_Y2 = case isnull(@StatisticsForSecondYearSecondArea, 0) when 0 then 0 else (intChildren_2_Y2 / @Statistics17ForSecondYearSecondArea) * @Counter end
end

--- calculate %
update @ReportTable set
intTotal_1_Percent = case when intTotal_1_Y1  = 0 then 0.00 else (intTotal_1_Y2 - intTotal_1_Y1) / intTotal_1_Y1 end,
intChildren_1_Percent = case when intChildren_1_Y1 = 0 then 0.00 else (intChildren_1_Y2 - intChildren_1_Y1 ) / intChildren_1_Y1 end,


intTotal_2_Percent = case when intTotal_2_Y1 = 0 then 0.00 else (intTotal_2_Y2 - intTotal_2_Y1) / intTotal_2_Y1 end,
intChildren_2_Percent = case when intChildren_2_Y1 = 0 then 0.00 else (intChildren_2_Y2 - intChildren_2_Y1) / intChildren_2_Y1 end


	
if 	@Counter in (10000.00, 100000.00)
	select * from 	@ReportTable
else
	select 
		 idfsBaseReference	
		, intRowNumber
		, strDisease
		, strICD10		
		, strAdministrativeUnit1 
		, intTotal_1_Y1 intTotal_1_Y1
		, intTotal_1_Y2 intTotal_1_Y2
		, intTotal_1_Percent 
		, intChildren_1_Y1 intChildren_1_Y1
		, intChildren_1_Y2 intChildren_1_Y2
		, intChildren_1_Percent 
		, strAdministrativeUnit2 
		, intTotal_2_Y1  intTotal_2_Y1
		, intTotal_2_Y2  intTotal_2_Y2
		, intTotal_2_Percent 
		, intChildren_2_Y1 intChildren_2_Y1
		, intChildren_2_Y2  intChildren_2_Y2
		, intChildren_2_Percent 
		, intOrder			
	from @ReportTable	


END
	
