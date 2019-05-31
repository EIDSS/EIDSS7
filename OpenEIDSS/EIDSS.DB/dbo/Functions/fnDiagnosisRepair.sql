


--##SUMMARY Selects data for diagnosis lookup tables

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:

Select *from fnDiagnosisRepair ('en', 32, 10020001) -- 'dutStandartCase'
*/


CREATE      function dbo.fnDiagnosisRepair (
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@HACode as int = null,  --##PARAM @HACode - bit mask that defines Area where diagnosis are used (human, LiveStock or avian)
	@DiagnosisUsingType as bigint = NULL --##PARAM @DiagnosisUsingType - diagnosis Type (standard or aggregate)
)
returns table

as 
return(
select	trtDiagnosis.idfsDiagnosis
		,ref.name
		,trtDiagnosis.strIDC10
		,trtDiagnosis.strOIECode 
		,ref.intHACode
		,ref.intRowStatus
from	dbo.fnReferenceRepair(@LangID, 19000019) ref --rftDiagnosis
inner join trtDiagnosis
	on trtDiagnosis.idfsDiagnosis = ref.idfsReference
where		(@HACode = 0 or @HACode is null or intHACode is null or 
			CASE 
						--1=animal, 32=LiveStock , 64=avian
						--below we assume that client will never pass animal bit without livstock or avian bits
						WHEN (intHACode & 97) > 1 THEN (~1 & intHACode) & @HACode -- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
						WHEN (intHACode & 97) = 1 THEN (~1 & intHACode | 96) & @HACode --if only animal bit is set, clear clear animal bit and set both avian and livstock bits in  b.intHA_Code
						ELSE intHACode & @HACode  END >0)
			AND (@DiagnosisUsingType IS NULL OR trtDiagnosis.idfsDiagnosis IS NULL OR trtDiagnosis.idfsUsingType = @DiagnosisUsingType)

)
