

--##SUMMARY Select the population statistics 
--##SUMMARY for all administrative levels by year (including empty year) .

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 02.09.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsPopulationStatisticsSelectLookup 'en'

*/ 
 
create procedure	[dbo].[spAsPopulationStatisticsSelectLookup]
	@LangID	as nvarchar(50)
as
begin

declare @Country bigint
set	@Country = null

select		@Country = tcp1.idfsCountry
FROM tstCustomizationPackage tcp1
JOIN tstSite s ON
	s.idfCustomizationPackage = tcp1.idfCustomizationPackage
inner join	tstLocalSiteOptions lso
on			lso.strName = N'SiteID'
			and lso.strValue = cast(s.idfsSite as nvarchar(200))


declare 
	@intMinYear int,
	@intMaxYear int,
	@intYear int

declare @years table (
	intYear int not null primary key	
)

select @intMinYear = min(year(st.datStatisticStartDate)), @intMaxYear = max(year(st.datStatisticStartDate))
from		(
	gisRayon ray 
	inner join	fnGisExtendedReference(@LangID, 19000002) ray_ref	-- rftRayon
	on			ray_ref.idfsReference = ray.idfsRayon
			)
	inner join	tlbStatistic st
	on			st.idfsArea = ray.idfsRayon
				and st.idfsStatisticDataType = 39850000000	-- population
				and st.idfsStatisticAreaType = 10089002		-- Rayon
				and st.idfsStatisticPeriodType = 10091005	-- Year
				and st.intRowStatus = 0
where		ray.idfsCountry = @Country

if @intMaxYear < year(getdate()) set @intMaxYear = year(getdate())

set @intYear = @intMinYear
while @intYear <= @intMaxYear and @intYear is not null
begin
	insert into @years values (@intYear)
	set @intYear = @intYear + 1	
end	


declare	@population table
(
	AdminUnitName	nvarchar(400) collate database_default not null primary key,
	idfsAdminUnit	bigint not null,
	intValue		bigint null,
	intYear			int null
)

---------- RAYONS		
-- all rayons -> all years (RayonName__Year)			
insert into	@population
(	AdminUnitName,
	idfsAdminUnit,
	intValue,
	intYear
)
select		ray_ref.ExtendedName + 
				IsNull(N'__' + cast(years.intYear as nvarchar(30)), N''),
			ray.idfsRayon, 
			case	
				when	stat.varValue is not null 
						and	SQL_VARIANT_PROPERTY(stat.varValue, 'BaseType') in 
							('bigint', 'int', 'smallint', 'tinyint')
					then	cast(stat.varValue as bigint) 
				else		null
			end,
			years.intYear
from		(
	gisRayon ray
	inner join	fnGisExtendedReference(@LangID, 19000002) ray_ref	-- rftRayon
	on			ray_ref.idfsReference = ray.idfsRayon
	
	cross join @years years
	)
	
	outer apply	(
		select top 1
				st.datStatisticStartDate,
				st.varValue
			from tlbStatistic st

			left join	tlbStatistic st_max
			on			st_max.idfsArea = ray.idfsRayon
						and st_max.idfsStatisticDataType = 39850000000	-- population
						and st_max.idfsStatisticAreaType = 10089002		-- Rayon
						and st_max.idfsStatisticPeriodType = 10091005	-- Year
						and year(st_max.datStatisticStartDate) = year(st.datStatisticStartDate)
						and st_max.intRowStatus = 0
						and (	st_max.datStatisticStartDate > st.datStatisticStartDate
								or	(	st_max.datStatisticStartDate = st.datStatisticStartDate
										and st_max.idfStatistic > st.idfStatistic
									)
						)
					
			where 
					st.idfsArea = ray.idfsRayon
					and st.idfsStatisticDataType = 39850000000	-- population
					and st.idfsStatisticAreaType = 10089002		-- Rayon
					and st.idfsStatisticPeriodType = 10091005	-- Year
					and year(st.datStatisticStartDate) <= years.intYear
					and st.intRowStatus = 0
					and st_max.idfStatistic is null
		order by  st.datStatisticStartDate desc
	) stat
where		ray.idfsCountry = @Country
		
-- all rayons -> max years (RayonName)			
insert into	@population
(	AdminUnitName,
	idfsAdminUnit,
	intValue,
	intYear
)
select		ray_ref.ExtendedName+'__*',
			ray.idfsRayon, 
			p.intValue,
			null
from		(
	gisRayon ray
		inner join	fnGisExtendedReference(@LangID, 19000002) ray_ref	-- rftRayon
		on			ray_ref.idfsReference = ray.idfsRayon
					and ray.idfsCountry = @Country
	)

	inner join @population p
	on p.idfsAdminUnit =  ray.idfsRayon
	and p.intYear = @intMaxYear
order by 1	
			
			
---------- REGIONS
-- all regions -> all years (RegionName__Year)		
insert into	@population
(	AdminUnitName,
	idfsAdminUnit,
	intValue,
	intYear
)
select		reg_ref.ExtendedName + IsNull(N'__' + cast(p.intYear as nvarchar(30)), N''),
			reg.idfsRegion, 
			sum(case when p_rayons_without_stats.blnIsNoStatForAllRayons = 1 then null else p.intValue end),
			p.intYear
from		@population p
	inner join	gisRayon ray
	on			ray.idfsRayon = p.idfsAdminUnit
	inner join	(
		gisRegion reg
			inner join	fnGisExtendedReference(@LangID, 19000003) reg_ref	-- rftRegion
			on			reg_ref.idfsReference = reg.idfsRegion
	)
	on			reg.idfsRegion = ray.idfsRegion
	
	outer apply (
			select top 1 '1' as blnIsNoStatForAllRayons
			from @population pp
				inner join gisRayon gr
				on gr.idfsRegion = reg.idfsRegion
				and pp.idfsAdminUnit = gr.idfsRayon
			where	isnull(pp.intValue, -1 ) = -1 
					and pp.intYear = p.intYear
			) as p_rayons_without_stats
where p.intYear is not null			
group by	reg_ref.ExtendedName, reg.idfsRegion, p.intYear
		  
		  
-- all regions -> max years (RegionName)			
insert into	@population
(	AdminUnitName,
	idfsAdminUnit,
	intValue,
	intYear
)
select		reg_ref.ExtendedName+ '__*',
			reg.idfsRegion, 
			p.intValue,
			null
from		(
	gisRegion reg
		inner join	fnGisExtendedReference(@LangID, 19000003) reg_ref	-- rftRegion
		on			reg_ref.idfsReference = reg.idfsRegion
					and reg.idfsCountry = @Country
	)

	inner join @population p
	on p.idfsAdminUnit =  reg.idfsRegion
	and p.intYear = @intMaxYear
	  
		  
---------- COUNTRY	  
-- for all country -> all years (CountryName__Year)				  
insert into	@population
(	AdminUnitName,
	idfsAdminUnit,
	intValue,
	intYear
)
select		cou_ref.ExtendedName + IsNull(N'__' + cast(p.intYear as nvarchar(30)), N''),
			cou.idfsCountry, 
			sum(case when p_regions_without_stats.blnIsNoStatForAllRegions = 1 then null else p.intValue end),
			p.intYear
from		@population p
	inner join	gisRegion reg
	on			reg.idfsRegion = p.idfsAdminUnit
	inner join	(
		gisCountry cou
		inner join	fnGisExtendedReference(@LangID, 19000001) cou_ref	-- rftCountry
		on			cou_ref.idfsReference = cou.idfsCountry
				)
	on			cou.idfsCountry = reg.idfsCountry

	outer apply (
		select top 1 '1' as blnIsNoStatForAllRegions
		from @population pp
			inner join gisRegion gr
			on gr.idfsCountry = cou.idfsCountry
			and pp.idfsAdminUnit = gr.idfsRegion
		where	isnull(pp.intValue, -1 ) = -1 
				and pp.intYear = p.intYear
		) as p_regions_without_stats
where p.intYear is not null			
group by	cou_ref.ExtendedName, cou.idfsCountry, p.intYear

-- for all country -> max years (CountryName)			
insert into	@population
(	AdminUnitName,
	idfsAdminUnit,
	intValue,
	intYear
)
select		cou_ref.ExtendedName + '__*',
			cou.idfsCountry, 
			p.intValue,
			null
from	(
		gisCountry cou
		inner join	fnGisExtendedReference(@LangID, 19000001) cou_ref	-- rftCountry
		on			cou_ref.idfsReference = cou.idfsCountry
				)

	inner join @population p
	on p.idfsAdminUnit =  cou.idfsCountry
	and p.intYear = @intMaxYear




----------------------------
select	AdminUnitName,
		idfsAdminUnit,
		intValue,
		intYear
from	@population
order by AdminUnitName

end


