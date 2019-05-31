

--##SUMMARY Selects data for custom report rows form lookup

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 27.01.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spCustomReportGroupsAndDiagnoses_SelectLookup 'en', 32, 10020001 -- 'dutStandartCase'
*/


CREATE procedure dbo.spCustomReportGroupsAndDiagnoses_SelectLookup (
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@HACode as int = null,  --##PARAM @HACode - bit mask that defines Area where diagnosis are used (human, LiveStock or avian)
	@DiagnosisUsingType as bigint = NULL --##PARAM @DiagnosisUsingType - diagnosis Type (standard or aggregate)
)
as 
Begin
	if (@DiagnosisUsingType = 0) Set @DiagnosisUsingType = null

	Declare @ResultTable Table (
		idfsDiagnosisOrDiagnosisGroup Bigint not null
		,idfsDiagnosisGroup Bigint
		,name Nvarchar(2000)
		,intOrder Int
		,strIDC10 Nvarchar(200)
		,strOIECode Nvarchar(200)
		,intHACode Int
		,intRowStatus Int
		,blnGroup Bit
		,ordergroup Bigint
		,[strHACode] Nvarchar(200)
		,[strUsingTypeName] Nvarchar(200)
		,[intIsDeleted] int
		,[strIsDeleted] Nvarchar(200)
	)	

Insert into @ResultTable
--diagnoses
select	  D.idfsDiagnosis as idfsDiagnosisOrDiagnosisGroup
		, isnull(g.idfsDiagnosisGroup, 0) as idfsDiagnosisGroup
		, dn.name
		, dn.intOrder
		, D.strIDC10
		, D.strOIECode 
		, dn.intHACode
		,CASE WHEN (@HACode = 0 or @HACode is null or dn.intHACode is null or 
			CASE 
						--1=animal, 32=LiveStock , 64=avian
						--below we assume that client will never pass animal bit without livstock or avian bits
						WHEN (dn.intHACode & 97) > 1 THEN (~1 & dn.intHACode) & @HACode -- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
						WHEN (dn.intHACode & 97) = 1 THEN (~1 & dn.intHACode | 96) & @HACode --if only animal bit is set, clear clear animal bit and set both avian and livstock bits in  b.intHA_Code
						ELSE dn.intHACode & @HACode  END >0)
			AND (@DiagnosisUsingType IS NULL OR D.idfsDiagnosis IS NULL OR D.idfsUsingType = @DiagnosisUsingType)
			THEN  dn.intRowStatus
			ELSE 1 END AS intRowStatus
		, 0 as blnGroup
		, isnull(g.idfsDiagnosisGroup, 1000000000000000) as ordergroup
		, REPLACE (
			REPLACE(
					(
						SELECT
							HACodes.name + ', '  AS 'data()'
						FROM dbo.trtHACodeList HACodeList
						Inner Join dbo.fnReferenceRepair(@LangID, 19000040) HACodes On HACodeList.idfsCodeName = HACodes.idfsReference
						WHERE (dn.intHACode & HACodeList.intHACode = HACodeList.intHACode) 
							AND HACodeList.intHACode > 0
						ORDER BY HACodes.name
						FOR XML PATH ( '')
					) + '%'
				, ', %', '') 
			, '&amp;', 'and') As [strHACode]
		,UsingType.name As [strUsingType]
		,YNU.idfsReference as [intIsDeleted]
		,YNU.name as [strIsDeleted]

from	dbo.fnReferenceRepair(@LangID, 19000019) dn --rftDiagnosis
inner join trtDiagnosis	D on D.idfsDiagnosis = dn.idfsReference
inner join dbo.fnReference(@LangID, 19000020) UsingType On D.idfsUsingType = UsingType.idfsReference
Inner join dbo.fnReference(@LangID, 19000100) YNU On (case when dn.intRowStatus = 0 then 10100002 else 10100001 end) = YNU.idfsReference
OUTER APPLY (SELECT TOP 1 *
 FROM trtDiagnosisToDiagnosisGroup gr
 WHERE gr.idfsDiagnosis = D.idfsDiagnosis) AS g

union

--groups
--Insert into @ResultTable
select	  dn.idfsReference as idfsDiagnosisOrDiagnosisGroup
		, 0 as idfsDiagnosisGroup
		, dn.name
		, dn.intOrder
		, ''
		, '' 
		, dn.intHACode
		, CASE WHEN @HACode = 0 or @HACode is null or dn.intHACode is null or dn.intHACode & @HACode > 0
			THEN  dn.intRowStatus
			ELSE 1 END AS intRowStatus
		, 1 as blnGroup
		, dn.idfsReference as ordergroup
		,'' as [strHACode]
		,'' as [strUsingTypeName]
		,YNU.idfsReference as [intIsDeleted]
		,YNU.name as [strIsDeleted]
from	dbo.fnReferenceRepair(@LangID, 19000130) dn --rftCustomReportDiagnosisGroup
Inner join dbo.fnReference(@LangID, 19000100) YNU On (case when dn.intRowStatus = 0 then 10100002 else 10100001 end) = YNU.idfsReference


	Select 
	idfsDiagnosisOrDiagnosisGroup
		,idfsDiagnosisGroup
		,name
		,strIDC10
		,strOIECode
		,intHACode
		,intRowStatus
		,blnGroup
		,[strHACode]
		,[strUsingTypeName]
		,[intIsDeleted]
		,[strIsDeleted]
		,row_number() over (order by ordergroup,idfsDiagnosisGroup,	intOrder, name) As intOrder
		from @ResultTable
End

