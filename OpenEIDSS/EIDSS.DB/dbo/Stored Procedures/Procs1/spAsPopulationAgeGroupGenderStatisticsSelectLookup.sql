

--##SUMMARY Select the latest population statistics for genders.

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsPopulationAgeGroupGenderStatisticsSelectLookup_test 'ru'

exec spAsPopulationAgeGroupGenderStatisticsSelectLookup 'ru'

*/ 
 
create procedure	[dbo].[spAsPopulationAgeGroupGenderStatisticsSelectLookup]
	@LangID	as nvarchar(50)
as
begin

declare @Country bigint
set	@Country = null

SELECT
	@Country = tcp1.idfsCountry
FROM tstCustomizationPackage tcp1
JOIN tstSite s ON
	s.idfCustomizationPackage = tcp1.idfCustomizationPackage
JOIN tstLocalSiteOptions lso ON
	lso.strName = N'SiteID'
	AND lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))

declare	@summaryPopulation table
(
	strAgeGroupGenderName	nvarchar(400) collate database_default not null primary key,
	idfsAgeGroup			bigint  null,
	idfsHumanGender			bigint  null,
	intValue				bigint  null,
	intYear					int null
)

declare	@population table
(
	strAgeGroupGenderName	nvarchar(400) collate database_default not null ,
	idfsAgeGroup			bigint not null,
	idfsHumanGender			bigint not null,
	intValue				bigint null,
	intYear					int null
)


declare 
	@intMinYear int,
	@intMaxYear int,
	@intYear int

declare @years table (
	intYear int not null primary key	
)

select @intMinYear = min(year(st.datStatisticStartDate)), @intMaxYear = max(year(st.datStatisticStartDate))
from	fnReference(@LangID, 19000043) hg		-- Human Gender
	cross  join 	-- 	Statistical Age Groups
	(
		 select   sag.*,
				  dag.name as strDiagnosisAgeGroupname,
				  dag.idfsReference as idfsDiagnosisAgeGroup
		 from fnReference(@LangID, 19000146) dag
		 inner join trtDiagnosisAgeGroupToStatisticalAgeGroup dag_sag
		 on dag_sag.idfsDiagnosisAgeGroup = dag.idfsReference
		 inner join fnReference(@LangID, 19000145) sag
		  on sag.idfsReference = dag_sag.idfsStatisticalAgeGroup

	) as ag

	left join	tlbStatistic st
	on			st.idfsMainBaseReference = hg.idfsReference
		  and st.idfsStatisticalAgeGroup = ag.idfsReference
				and st.idfsArea = @Country
				and st.idfsStatisticDataType = 39860000000	-- population by Gender and Age
				and st.idfsStatisticAreaType = 10089001		-- Country
				and st.idfsStatisticPeriodType = 10091005	-- Year
				and st.intRowStatus = 0
				

	left join	tlbStatistic st_max
	on			st_max.idfsMainBaseReference = hg.idfsReference
		  and st_max.idfsStatisticalAgeGroup = ag.idfsReference
				and st_max.idfsArea = @Country
				and st_max.idfsStatisticDataType = 39860000000	-- population by Gender and Age
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

---------------------------------
-- AgeGroup_Gender_Year
insert into	@population
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select		
		ag.strDiagnosisAgeGroupname + N'_' +  hg.[name] + IsNull(N'__' + cast(years.intYear as nvarchar(30)), N''),
		ag.idfsDiagnosisAgeGroup as idfsAgeGroup,
		hg.idfsReference as idfsHumanGender, 
		case	
			when	(stat.varValue is not null) or 
					(1 = ISNUMERIC(cast(stat.varValue as varchar(200))))
			then	cast(stat.varValue as bigint) 
			else	0
		end,
		years.intYear
from		fnReference(@LangID, 19000043) hg		-- Human Gender
	cross join @years years
	
	cross  join 	-- 	Statistical Age Groups
	(
		 select   sag.*,
				  dag.name as strDiagnosisAgeGroupname,
				  dag.idfsReference as idfsDiagnosisAgeGroup
		 from fnReference(@LangID, 19000146) dag
		 inner join trtDiagnosisAgeGroupToStatisticalAgeGroup dag_sag
		 on dag_sag.idfsDiagnosisAgeGroup = dag.idfsReference
		 inner join fnReference(@LangID, 19000145) sag
		  on sag.idfsReference = dag_sag.idfsStatisticalAgeGroup

	) as ag
	
	outer apply (
			select top 1
				st.datStatisticStartDate,
				st.varValue
			from tlbStatistic st
			left join	tlbStatistic st_max
			on			st_max.idfsMainBaseReference = hg.idfsReference
				  and st_max.idfsStatisticalAgeGroup = ag.idfsReference
						and st_max.idfsArea = @Country
						and st_max.idfsStatisticDataType = 39860000000	-- population by Gender and Age
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
				and st.idfsStatisticalAgeGroup = ag.idfsReference
				and st.idfsArea = @Country
				and st.idfsStatisticDataType = 39860000000	-- population by Gender and Age
				and st.idfsStatisticAreaType = 10089001		-- Country
				and st.idfsStatisticPeriodType = 10091005	-- Year
				and year(st.datStatisticStartDate) <= years.intYear
				and st.intRowStatus = 0
				and st_max.idfStatistic is null
			order by  st.datStatisticStartDate desc
	) as stat


-- AgeGroup_Gender_* (max year)
insert into	@population
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select		
	ag.strDiagnosisAgeGroupname + N'_' +  hg.[name]+ '__*',
	ag.idfsDiagnosisAgeGroup,
	hg.idfsReference, 
	p.intValue,
	null
from		fnReference(@LangID, 19000043) hg		-- Human Gender
	cross  join 	-- 	Statistical Age Groups
	(
		 select   sag.*,
				  dag.name as strDiagnosisAgeGroupname,
				  dag.idfsReference as idfsDiagnosisAgeGroup
		 from fnReference(@LangID, 19000146) dag
		 inner join trtDiagnosisAgeGroupToStatisticalAgeGroup dag_sag
		 on dag_sag.idfsDiagnosisAgeGroup = dag.idfsReference
		 inner join fnReference(@LangID, 19000145) sag
		  on sag.idfsReference = dag_sag.idfsStatisticalAgeGroup

	) as ag
	
	inner join @population p
	on p.idfsHumanGender = hg.idfsReference 
	and p.idfsAgeGroup = ag.idfsDiagnosisAgeGroup
	and p.intYear = @intMaxYear

							

-- get summary Population:
--		AgeGroup_Gender_Year
--		AgeGroup_Gender_* (max year)
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select	strAgeGroupGenderName,
		idfsAgeGroup,		
		idfsHumanGender,
		sum(intValue),
		intYear
from	@population 
group by strAgeGroupGenderName, idfsAgeGroup, idfsHumanGender, intYear



-- AgeGroup_*__Year
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select
	dag.name + '_*__' + cast(sp.intYear as varchar(20)),
	idfsAgeGroup,
	null,
	sum(case when year_AgeGroup_without_genderStat.blnIsNoStat = 1 then null else sp.intValue end),
	intYear
from @summaryPopulation sp
	inner join fnReference(@LangID, 19000146) dag
	on dag.idfsReference = sp.idfsAgeGroup
	outer apply (
		select top 1 '1' as blnIsNoStat
		from @summaryPopulation pp
		where	isnull(pp.intValue, -1 ) = -1 
				and pp.intYear = sp.intYear
				and pp.idfsAgeGroup = sp.idfsAgeGroup
	) year_AgeGroup_without_genderStat
where 
	sp.intYear is not null 
	and	sp.idfsHumanGender is not null 
	and sp.idfsAgeGroup is not null
group by sp.idfsAgeGroup, dag.name, intYear


-- AgeGroup_*__Year (max year)
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select
	dag.name + '_*__*' ,
	idfsAgeGroup,
	null,
	intValue,
	null
from @summaryPopulation sp
	inner join fnReference(@LangID, 19000146) dag
	on dag.idfsReference = sp.idfsAgeGroup
where 
	sp.intYear is not null 
	and	sp.idfsAgeGroup is not null 
	and	sp.idfsHumanGender is null 
	and sp.intYear = @intMaxYear



-- *_Gender__Year
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select
	'*_' + hg.name + '__' + cast(sp.intYear as varchar(20)),
	null,
	sp.idfsHumanGender,
	sum(case when year_Gender_without_AgeGroupStat.blnIsNoStat = 1 then null else sp.intValue end),
	intYear
from @summaryPopulation sp
	inner join fnReference(@LangID, 19000043) hg		-- Human Gender
	on hg.idfsReference = sp.idfsHumanGender
	outer apply (
		select top 1 '1' as blnIsNoStat
		from @summaryPopulation pp
		where	isnull(pp.intValue, -1 ) = -1 
				and pp.intYear = sp.intYear
				and pp.idfsHumanGender = sp.idfsHumanGender
	) year_Gender_without_AgeGroupStat
	
where 
	sp.intYear is not null 
	and sp.idfsHumanGender is not null 
	and sp.idfsAgeGroup is not null
group by sp.idfsHumanGender, hg.name, intYear


-- *_Gender__* (max year)
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select
	'*_' + hg.name + '__*',
	null,
	sp.idfsHumanGender,
	intValue,
	null
from @summaryPopulation sp
	inner join fnReference(@LangID, 19000043) hg		-- Human Gender
	on hg.idfsReference = sp.idfsHumanGender
where 
	sp.intYear is not null 
	and sp.idfsHumanGender is not null 
	and sp.idfsAgeGroup is null
	and sp.intYear = @intMaxYear


-- *_*__Year
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select
	'*_*__' + cast(sp.intYear as varchar(20)),
	null,
	null,
	sum(case when 
				year_Gender_without_AgeGroupStat.blnIsNoStat = 1 
				or year_AgeGroup_without_genderStat.blnIsNoStat = 1 
				then null 
				else sp.intValue 
	    end),
	sp.intYear
from @summaryPopulation sp
	outer apply (
		select top 1 '1' as blnIsNoStat
		from @summaryPopulation pp
		where	isnull(pp.intValue, -1 ) = -1 
				and pp.intYear = sp.intYear
				and pp.idfsHumanGender = sp.idfsHumanGender
	) year_Gender_without_AgeGroupStat
	
	outer apply (
		select top 1 '1' as blnIsNoStat
		from @summaryPopulation pp
		where	isnull(pp.intValue, -1 ) = -1 
				and pp.intYear = sp.intYear
				and pp.idfsAgeGroup = sp.idfsAgeGroup
	) year_AgeGroup_without_genderStat
	
where 
	sp.intYear is not null 
	and sp.idfsAgeGroup is not null 
	and sp.idfsHumanGender is not null
group by sp.intYear


-- *_*__* (max year)
insert into	@summaryPopulation
(	strAgeGroupGenderName,
	idfsAgeGroup,
	idfsHumanGender,
	intValue,
	intYear
)
select
	'*_*__*',
	null,
	null,
	sum(intValue),
	null
from @summaryPopulation sp
where 
	sp.intYear = @intMaxYear
	and sp.idfsAgeGroup is  null 
	and sp.idfsHumanGender is  null



select * from @summaryPopulation
order by strAgeGroupGenderName

end




