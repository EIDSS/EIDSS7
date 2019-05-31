--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 spDiagnosis_SelectLookup :  V7 USP68
--							Get lookup data from tables:trtDiagnosis;trtDiagnosisToDiagnosisGroup
/*
----testing code:
exec  usp_Diagnosis_GetLookup 'en', 32, 10020001 -- 'dutStandartCase'  (JL:two choice: 10020001;10020002)
----related fact data from
select distinct idfsusingtype  from trtDiagnosis  
select * from trtDiagnosisToDiagnosisGroup
*/
--=====================================================================================================

CREATE      procedure [dbo].[usp_Diagnosis_GetLookup] (
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@HACode as int = null,  --##PARAM @HACode - bit mask that defines Area where diagnosis are used (human, LiveStock or avian)
	@DiagnosisUsingType as bigint = NULL --##PARAM @DiagnosisUsingType - diagnosis Type (standard or aggregate)
)
as
select	trtDiagnosis.idfsDiagnosis
		, d.name
		, trtDiagnosis.strIDC10
		, trtDiagnosis.strOIECode 
		, d.intHACode
		, d.intRowStatus
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
where		(@HACode = 0 or @HACode is null or d.intHACode is null or (d.intHACode & @HACode) > 0)
			AND (@DiagnosisUsingType IS NULL OR trtDiagnosis.idfsDiagnosis IS NULL OR trtDiagnosis.idfsUsingType = @DiagnosisUsingType)
order by	d.intOrder, d.name  

