


--##SUMMARY Selects data for diagnosis lookup tables

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spDiagnosisAll_SelectLookup 'en'
*/


CREATE      procedure dbo.spDiagnosisAll_SelectLookup (
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
as
select	D.idfsDiagnosis
		, Diagnosis.name
		, D.strIDC10
		, D.strOIECode 
		, Diagnosis.intHACode
		, D.idfsUsingType
		, Diagnosis.intRowStatus
		, Diagnosis.intOrder
		, REPLACE (
			REPLACE(
					(
						SELECT
							HACodes.name + ', '  AS 'data()'
						FROM dbo.trtHACodeList HACodeList
						Inner Join dbo.fnReferenceRepair(@LangID, 19000040) HACodes On HACodeList.idfsCodeName = HACodes.idfsReference
						WHERE (Diagnosis.intHACode & HACodeList.intHACode = HACodeList.intHACode) 
							AND HACodeList.intHACode > 0
						ORDER BY HACodes.name
						FOR XML PATH ( '')
					) + '%'
				, ', %', '') 
			, '&amp;', 'and') As [HACode]
		, UsingType.name As [UsingTypeName]
		,D.blnZoonotic
		,CASE WHEN D.blnZoonotic = 1 THEN stYes.name ELSE stNo.name END AS strZoonotic
		,diagnosesGroup.idfsDiagnosisGroup
		,diagnosesGroup.strDiagnosesGroupName

From	dbo.fnReferenceRepair(@LangID, 19000019) Diagnosis--rftDiagnosis
Inner join dbo.trtDiagnosis D on D.idfsDiagnosis = Diagnosis.idfsReference
Inner join dbo.trtHACodeList HACodeList on (Diagnosis.intHACode & HACodeList.intHACode = HACodeList.intHACode) AND HACodeList.intHACode > 0
Inner Join dbo.fnReferenceRepair(@LangID, 19000020) UsingType On D.idfsUsingType = UsingType.idfsReference
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
and d_to_dg.idfsDiagnosis = D.idfsDiagnosis
order by d_to_dg.idfDiagnosisToDiagnosisGroup asc 
) as diagnosesGroup

GROUP BY D.idfsDiagnosis
		, Diagnosis.name
		, D.strIDC10
		, D.strOIECode 
		, Diagnosis.intHACode
		, D.idfsUsingType
		, Diagnosis.intRowStatus
		, Diagnosis.intOrder
		, UsingType.name
		, D.blnZoonotic
		, CASE WHEN D.blnZoonotic = 1 THEN stYes.name ELSE stNo.name END
		,diagnosesGroup.idfsDiagnosisGroup
		,diagnosesGroup.strDiagnosesGroupName
order by	Diagnosis.intOrder, Diagnosis.name
