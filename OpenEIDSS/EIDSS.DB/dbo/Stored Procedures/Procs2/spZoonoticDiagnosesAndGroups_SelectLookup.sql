


--##SUMMARY Selects data for outbrak diagnosis lookup tables
--##SUMMARY If diagnosis doesn't comply input parameter filter, it is returned with intRowStatus 1
--##SUMMARY This si done to correctly display diagnosis with changed attributes


--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 12.04.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spZoonoticDiagnosesAndGroups_SelectLookup 'en'
*/


create procedure dbo.spZoonoticDiagnosesAndGroups_SelectLookup (
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
as 
Begin

	declare @ResultTable table (
		 idfsDiagnosisOrDiagnosisGroup	bigint not null
		,idfsDiagnosisGroup				bigint
		,name							nvarchar(2000)
		,intOrder						int
		,strIDC10						nvarchar(200)
		,intRowStatus					int
		,blnGroup						bit
		,ordergroup						bigint
	)	
	
--groups
insert into @ResultTable (
				idfsDiagnosisOrDiagnosisGroup, 
				idfsDiagnosisGroup, 
				name,
				strIDC10, 
				intRowStatus, 
				blnGroup,
				ordergroup
			)
select	  dn.idfsReference as idfsDiagnosisOrDiagnosisGroup
		, null as idfsDiagnosisGroup
		, dn.name
		, '' as strIDC10
		, dn.intRowStatus
		, 1 as blnGroup
		, row_number() over (order by dn.name) as ordergroup
from	dbo.fnReferenceRepair(@LangID, 19000156) dn --rftDiagnosisGroup	
where not exists (select * 
				from trtDiagnosis td 
					inner join trtDiagnosisToDiagnosisGroup tdtdg
					on tdtdg.idfsDiagnosis = td.idfsDiagnosis
					and tdtdg.intRowStatus = 0
					and td.idfsUsingType = 10020001
					and td.blnZoonotic = 0
                where tdtdg.idfsDiagnosisGroup = dn.idfsReference)

-- diagnoses
insert into @ResultTable (
				idfsDiagnosisOrDiagnosisGroup, 
				idfsDiagnosisGroup, 
				name,
				strIDC10, 
				intRowStatus, 
				blnGroup, 
				ordergroup
			)

select	  diag.idfsDiagnosis as idfsDiagnosisOrDiagnosisGroup
		, g.idfsDiagnosisGroup as idfsDiagnosisGroup
		, diag_ref.name
		, diag.strIDC10
		, diag_ref.intRowStatus
		, 0 as blnGroup
		, isnull(res.ordergroup, 100000)
from	dbo.fnReferenceRepair(@LangID, 19000019) diag_ref --rftDiagnosis
	inner join trtDiagnosis	diag 
	on diag.idfsDiagnosis = diag_ref.idfsReference
	and diag.idfsUsingType = 10020001
	and diag.blnZoonotic = 1
	outer apply (select top 1 gr.idfsDiagnosisGroup
					from	trtDiagnosisToDiagnosisGroup gr
						inner join @ResultTable rt_g
						on rt_g.idfsDiagnosisOrDiagnosisGroup = gr.idfsDiagnosisGroup
						and rt_g.blnGroup = 1
					where	gr.idfsDiagnosis = diag.idfsDiagnosis 
							and gr.intRowStatus = 0) as g
	left join @ResultTable res
	on res.idfsDiagnosisOrDiagnosisGroup = g.idfsDiagnosisGroup
	and res.blnGroup = 1

select 
	 idfsDiagnosisOrDiagnosisGroup
	,idfsDiagnosisGroup
	,name
	,strIDC10
	,intRowStatus
	,blnGroup
	,row_number() over (order by ordergroup, blnGroup desc, name) As intOrder
	from @ResultTable
End

