


--##SUMMARY Selects data for diagnosis lookup tables
--##SUMMARY If diagnosis doesn't comply input parameter filter, it is returned with intRowStatus 1
--##SUMMARY This si done to correctly display diagnosis with changed attributes


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 09.10.2012

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spDiagnosisRepare_SelectLookup 'en', 32, 10020001 -- 'dutStandartCase'
*/


CREATE      procedure dbo.spDiagnosisRepare_SelectLookup (
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@HACode as int = null,  --##PARAM @HACode - bit mask that defines Area where diagnosis are used (human, LiveStock or avian)
	@DiagnosisUsingType as bigint = NULL, --##PARAM @DiagnosisUsingType - diagnosis Type (standard or aggregate)
	@blnZoonoticOnly bit = NULL
)
as
select	trtDiagnosis.idfsDiagnosis
		, d.name
		, trtDiagnosis.strIDC10
		, trtDiagnosis.strOIECode 
		, d.intHACode
		,CASE WHEN (@HACode = 0 or @HACode is null or d.intHACode is null or d.intHACode & @HACode > 0)
			AND (@DiagnosisUsingType IS NULL OR trtDiagnosis.idfsDiagnosis IS NULL OR trtDiagnosis.idfsUsingType = @DiagnosisUsingType)
			AND (@blnZoonoticOnly IS NULL OR (@blnZoonoticOnly = 1 and blnZoonotic = 1))
			THEN  d.intRowStatus
			ELSE 1 END AS intRowStatus
		,blnZoonotic
		,CASE WHEN blnZoonotic = 1 THEN stYes.name ELSE stNo.name END AS strZoonotic
		,diagnosesGroup.idfsDiagnosisGroup
		,diagnosesGroup.strDiagnosesGroupName
from	dbo.fnReferenceRepair(@LangID, 19000019) d--rftDiagnosis
inner join trtDiagnosis
	on trtDiagnosis.idfsDiagnosis = d.idfsReference
left join dbo.fnReference(@LangID, 19000100) stYes
	on stYes.idfsReference = 10100001
left join dbo.fnReference(@LangID, 19000100) stNo
	on stNo.idfsReference = 10100002
outer apply ( 
select top 1 
d_to_dg.idfsDiagnosisGroup, dg.[name] as strDiagnosesGroupName
from trtDiagnosisToDiagnosisGroup d_to_dg
inner join fnReferenceRepair('en', 19000156) dg -- Diagnoses Groups
on dg.idfsReference = d_to_dg.idfsDiagnosisGroup
where d_to_dg.intRowStatus = 0
and d_to_dg.idfsDiagnosis = trtDiagnosis.idfsDiagnosis
order by d_to_dg.idfDiagnosisToDiagnosisGroup asc 
) as diagnosesGroup
order by	d.intOrder, d.name  


