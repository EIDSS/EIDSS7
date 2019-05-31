


--##SUMMARY Selects matrix of Diagnoses Groups to Report Diagnoses Groups plus ungrouped items for "GG Comparative Report of several years by months" report

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 15.07.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spDiagnosesAndGroupsGGComparative_SelectLookup 'en'
*/


create procedure [dbo].[spDiagnosesAndGroupsGGComparative_SelectLookup] (
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
as 
begin

	declare	@idfsCustomReportType bigint = 10290053 /*GG Comparative Report of several years by months*/
	declare	@idfAttributeType	bigint

	select		@idfAttributeType = at.idfAttributeType
	from		trtAttributeType at
	where		at.strAttributeTypeName = N'RDG to SDG' collate Cyrillic_General_CI_AS

	declare @ResultTable table
	(		idfsDiagnosisOrDiagnosisGroup	bigint not null primary key
		,	idfsDiagnosisGroup				bigint
		,	[name]							nvarchar(2000) collate Cyrillic_General_CI_AS
		,	intOrder						int
		,	strIDC10						nvarchar(200) collate Cyrillic_General_CI_AS
		,	strOIECode						nvarchar(200) collate Cyrillic_General_CI_AS
		,	intHACode						int
		,	intRowStatus					int
		,	blnGroup						bit
		,	ordergroup						bigint
	)

insert into @ResultTable
-- Report Diagnoses Groups
select	  rdg.idfsReportDiagnosisGroup as idfsDiagnosisOrDiagnosisGroup
		, isnull(sdg.idfsDiagnosisGroup, 0) as idfsDiagnosisGroup
		, r_rdg.[name]
		, r_rdg.intOrder
		, rdg.strCode
		, rdg.strCode
		, isnull(r_rdg.intHACode, 2)	-- Human
		, cast(0 as int) as intRowStatus
		, cast(0 as bit) as blnGroup
		, isnull(sdg.idfsDiagnosisGroup, 1000000000000000) as ordergroup

from		fnReference(@LangID, 19000130) r_rdg	-- Report Diagnosis Group
inner join	trtReportDiagnosisGroup	rdg
on			rdg.idfsReportDiagnosisGroup = r_rdg.idfsReference
			and rdg.intRowStatus = 0
outer apply (
	select top 1
				r_dg.idfsReference as idfsDiagnosisGroup
	from		trtBaseReferenceAttribute bra
	inner join	fnReferenceRepair(@LangID, 19000156) r_dg	-- Diagnoses Groups
	on			cast(r_dg.idfsReference as nvarchar) collate Cyrillic_General_CI_AS = 
					cast(bra.varValue as nvarchar) collate Cyrillic_General_CI_AS
	where		bra.idfAttributeType = @idfAttributeType
				and bra.idfsBaseReference = rdg.idfsReportDiagnosisGroup
				and bra.strAttributeItem collate Cyrillic_General_CI_AS = 
						cast(@idfsCustomReportType as nvarchar) collate Cyrillic_General_CI_AS
	order by	bra.idfBaseReferenceAttribute asc
			) as sdg
where		exists	(
				select	*
				from	trtDiagnosisToGroupForReportType d_to_g_for_rt
				where	d_to_g_for_rt.idfsReportDiagnosisGroup = rdg.idfsReportDiagnosisGroup
						and d_to_g_for_rt.idfsCustomReportType = @idfsCustomReportType
					)
--union

--groups
insert into @ResultTable
select		r_dg.idfsReference as idfsDiagnosisOrDiagnosisGroup
			, 0 as idfsDiagnosisGroup
			, r_dg.[name]
			, r_dg.intOrder
			, N''
			, N'' 
			, isnull(r_dg.intHACode, 2)	-- Human
			, r_dg.intRowStatus
			, cast(1 as bit) as blnGroup
			, r_dg.idfsReference as ordergroup
from		fnReferenceRepair(@LangID, 19000156) r_dg	-- Diagnoses Groups
outer apply	(
	select top 1 rt.idfsDiagnosisOrDiagnosisGroup, rt.idfsDiagnosisGroup
	from		@ResultTable rt
	where		rt.idfsDiagnosisGroup = r_dg.idfsReference
				and rt.intRowStatus = 0
	order by	rt.idfsDiagnosisOrDiagnosisGroup asc
			) as rdg
where		rdg.idfsDiagnosisGroup is not null


update rt
set rt.intOrder = (1000*ParentGroupOrder.intOrder+case when rt.idfsDiagnosisGroup <> 0 then OrderWithinGroup.intOrder else 0 end)
from		@ResultTable rt
outer apply	(
	select		count(rt_samegroup.idfsDiagnosisOrDiagnosisGroup) as intOrder
	from		@ResultTable rt_samegroup
	where		rt_samegroup.idfsDiagnosisGroup = rt.idfsDiagnosisGroup
				and (	rt_samegroup.[name] collate Cyrillic_General_CI_AS < rt.[name] collate Cyrillic_General_CI_AS
						or	(	rt_samegroup.[name] collate Cyrillic_General_CI_AS = rt.[name] collate Cyrillic_General_CI_AS
								and rt_samegroup.idfsDiagnosisOrDiagnosisGroup <= rt.idfsDiagnosisOrDiagnosisGroup
							)
					)
			) OrderWithinGroup
outer apply	(
	select		rt_parentgroup.idfsDiagnosisOrDiagnosisGroup, row_number() over (order by rt_parentgroup.[name] asc, rt_parentgroup.idfsDiagnosisOrDiagnosisGroup asc) as intOrder
	from		@ResultTable rt_parentgroup
	where		rt_parentgroup.idfsDiagnosisGroup = 0
			) ParentGroupOrder
where	(	(	rt.idfsDiagnosisGroup = 0
				and rt.idfsDiagnosisOrDiagnosisGroup = ParentGroupOrder.idfsDiagnosisOrDiagnosisGroup
			)
			or	(	rt.idfsDiagnosisGroup <> 0
					and rt.idfsDiagnosisGroup = ParentGroupOrder.idfsDiagnosisOrDiagnosisGroup
				)
		) 

select 
		rt.idfsDiagnosisOrDiagnosisGroup
		,rt.idfsDiagnosisGroup
		,rt.[name]
		,rt.strIDC10
		,rt.strOIECode
		,rt.intHACode
		,rt.intRowStatus
		,rt.blnGroup
		,rt.intOrder
from	@ResultTable rt
order by	rt.intOrder

end

