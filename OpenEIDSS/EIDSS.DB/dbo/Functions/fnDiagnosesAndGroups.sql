
--##REMARKS Author:Vorobiev E.V.
--##REMARKS Create date: 23.12.2013

--##RETURNS Doesn't use

/*
--Example of procedure call:

Select * from fnDiagnosesAndGroups('en')
*/

CREATE FUNCTION dbo.fnDiagnosesAndGroups (
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table

as 
return(


--diagnoses
select	  d.idfsDiagnosis as idfsDiagnosisOrDiagnosisGroup
		, isnull(g.idfsDiagnosisGroup, 0) as idfsDiagnosisGroup
		, dn.name
		, dn.intOrder
		, d.strIDC10
		, d.strOIECode 
		, dn.intHACode
		,CASE WHEN (intHACode is null or 
			CASE 
						--1=animal, 32=LiveStock , 64=avian
						--below we assume that client will never pass animal bit without livstock or avian bits
						WHEN (intHACode & 97) > 1 THEN (~1 & intHACode) -- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
						WHEN (intHACode & 97) = 1 THEN (~1 & intHACode | 96) --if only animal bit is set, clear clear animal bit and set both avian and livstock bits in  b.intHA_Code
						ELSE intHACode  END >0)
			THEN  dn.intRowStatus
			ELSE 1 END AS intRowStatus
		, 0 as blnGroup
		, isnull(g.idfsDiagnosisGroup, 1000000000000000) as ordergroup

from	dbo.fnReferenceRepair(@LangID, 19000019) dn --rftDiagnosis
inner join trtDiagnosis	d on d.idfsDiagnosis = dn.idfsReference
OUTER APPLY (SELECT TOP 1 *
 FROM trtDiagnosisToDiagnosisGroup gr
 WHERE gr.idfsDiagnosis = d.idfsDiagnosis) AS g

union

--groups
select	  dn.idfsReference as idfsDiagnosisOrDiagnosisGroup
		, 0 as idfsDiagnosisGroup
		, dn.name
		, dn.intOrder
		, ''
		, '' 
		, dn.intHACode
		, CASE WHEN (intHACode is null or 
			CASE 
						--1=animal, 32=LiveStock , 64=avian
						--below we assume that client will never pass animal bit without livstock or avian bits
						WHEN (intHACode & 97) > 1 THEN (~1 & intHACode) -- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
						WHEN (intHACode & 97) = 1 THEN (~1 & intHACode | 96) --if only animal bit is set, clear clear animal bit and set both avian and livstock bits in  b.intHA_Code
						ELSE intHACode  END >0)
			THEN  dn.intRowStatus
			ELSE 1 END AS intRowStatus
		, 1 as blnGroup
		, dn.idfsReference as ordergroup

from	dbo.fnReferenceRepair(@LangID, 19000156) dn --rftDiagnosisGroup

)
