

--##SUMMARY Select the latest population statistics for genders.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 22.12.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:


exec spAsPopulationGenderStatisticsSelectLookup 'ru'

*/ 
 
create procedure	[dbo].[spAsPopulationGenderStatisticsSelectLookup]
	@LangID	as nvarchar(50)
as
begin


declare @Country bigint
set	@Country = null

select		@Country = tcp1.idfsCountry
from tstCustomizationPackage tcp1
	join tstSite s on
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
from		fnReference(@LangID, 19000043) hg		-- Human Gender
	left join	tlbStatistic st
	on			st.idfsMainBaseReference = hg.idfsReference
				and st.idfsArea = @Country
				and st.idfsStatisticDataType = 840900000000	-- population by Gender
				and st.idfsStatisticAreaType = 10089001		-- Country
				and st.idfsStatisticPeriodType = 10091005	-- Year
				and st.intRowStatus = 0

	left join	tlbStatistic st_max
	on			st_max.idfsMainBaseReference = hg.idfsReference
				and st_max.idfsArea = @Country
				and st_max.idfsStatisticDataType = 840900000000	-- population by Gender
				and st_max.idfsStatisticAreaType = 10089001		-- Country
				and st_max.idfsStatisticPeriodType = 10091005	-- Year
				and year(st_max.datStatisticStartDate) = year(st.datStatisticStartDate)
				and st_max.intRowStatus = 0
				and (	st_max.datStatisticStartDate > st.datStatisticStartDate
						or	(	st_max.datStatisticStartDate = st.datStatisticStartDate
								and st_max.idfStatistic > st.idfStatistic
							)
					)
where		st_max.idfStatistic is null



if @intMaxYear < year(getdate()) set @intMaxYear = year(getdate())

set @intYear = @intMinYear
while @intYear <= @intMaxYear and @intYear is not null
begin
	insert into @years values (@intYear)
	set @intYear = @intYear + 1	
end		

-- GenderName__Year
declare	@population table
(
	strGenderName	nvarchar(400) collate database_default not null primary key,
	idfsHumanGender	bigint	null,
	intValue		bigint	null,
	intYear			int		null
)

insert into	@population
(	strGenderName,
	idfsHumanGender,
	intValue,
	intYear
)
select		hg.[name] + 
				IsNull(N'__' + cast(years.intYear as nvarchar(30)), N''),
			hg.idfsReference, 
			case	
				when	stat.varValue is not null 
						and	SQL_VARIANT_PROPERTY(stat.varValue, 'BaseType') in 
							('bigint', 'int', 'smallint', 'tinyint')
					then	cast(stat.varValue as bigint) 
				else		0
			end,
			years.intYear
from		fnReference(@LangID, 19000043) hg		-- Human Gender
	cross join @years years

	outer apply	(
		select top 1
				st.datStatisticStartDate,
				st.varValue
			from tlbStatistic st

			left join	tlbStatistic st_max
			on			st_max.idfsMainBaseReference = hg.idfsReference
						and st_max.idfsArea = @Country
						and st_max.idfsStatisticDataType = 840900000000	-- population by Gender
						and st_max.idfsStatisticAreaType = 10089001		-- Country
						and st_max.idfsStatisticPeriodType = 10091005	-- Year
						and year(st_max.datStatisticStartDate) = year(st.datStatisticStartDate)
						and st_max.intRowStatus = 0
						and (	st_max.datStatisticStartDate > st.datStatisticStartDate
								or	(	st_max.datStatisticStartDate = st.datStatisticStartDate
										and st_max.idfStatistic > st.idfStatistic
									)
						)
					
			where 
					st.idfsMainBaseReference = hg.idfsReference
					and st.idfsArea = @Country
					and st.idfsStatisticDataType = 840900000000	-- population by Gender
					and st.idfsStatisticAreaType = 10089001		-- Country
					and st.idfsStatisticPeriodType = 10091005	-- Year
					and year(st.datStatisticStartDate) <= years.intYear
					and st.intRowStatus = 0
					and st_max.idfStatistic is null
		order by  st.datStatisticStartDate desc
	) stat


-- GenderName__*
insert into	@population
(	strGenderName,
	idfsHumanGender,
	intValue,
	intYear
)
select		hg.[name] + '__*',
			hg.idfsReference, 
			p.intValue,
			null
from fnReference(@LangID, 19000043) hg		-- Human Gender
	inner join @population p
	on p.idfsHumanGender = hg.idfsReference 
	and p.intYear = @intMaxYear


-- *__Year
insert into	@population
(	strGenderName,
	idfsHumanGender,
	intValue,
	intYear
)
select		'*' + '__' + cast(intYear as varchar(4)),
			null, 
			sum(case when year_without_stat.blnIsNoStatForYear = 1 then null else p.intValue end),
			p.intYear
from @population p
	outer apply (
		select top 1 '1' as blnIsNoStatForYear
		from @population pp
		where	isnull(pp.intValue, -1 ) = -1 
				and pp.intYear = p.intYear
	) year_without_stat
where p.intYear is not null
group by p.intYear



-- *__*
insert into	@population
(	strGenderName,
	idfsHumanGender,
	intValue,
	intYear
)
select		'*__*',
			null, 
			p.intValue,
			null
from		@population p
where p.idfsHumanGender is null 
and p.intYear = @intMaxYear




-------------------------------
select	strGenderName,
		idfsHumanGender,
		intValue,
		intYear
from	@population
order by 1

end


