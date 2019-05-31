﻿

--##SUMMARY Returns the list of references of specific Type with minimal required columns set.
--##SUMMARY In contrast to fnReference function, it takes HACode as parameter
--##SUMMARY Returns intOrder column for futher sorting in calling procedure
--##SUMMARY The main usage of this function is calls from specific procedures that returns lookup records

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
SELECT * FROM dbo.fnReferenceLookup ('en', 19000019, 65)
SELECT * FROM dbo.fnReferenceLookup ('en', 19000019, 33)
*/



CREATE            function fnReferenceLookup(
						@LangID	nvarchar(50),	--##PARAM @LangID - reference language ID
						@type	bigint,			--##PARAM @type - reference Type (must correspond to one of trtReferenceType.idfsReference values)
						@HACode	int = null		--##PARAM @HACode - bit flag that defines Area of reference usage and can be used for reference filtration.
)
returns table
as
return(
select
			b.idfsBaseReference as idfsReference, 
			IsNull(c.strTextString, b.strDefault) as [name],
			b.strDefault, 
			b.intOrder
			,b.intHACode

from		dbo.trtBaseReference as b 
left join	dbo.trtStringNameTranslation as c 
on			b.idfsBaseReference = c.idfsBaseReference 
			and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		b.idfsReferenceType = @type 
			and b.intRowStatus = 0 
			and (@HACode = 0 or @HACode is null or intHACode is null or
			CASE 
			--1=animal, 32=LiveStock , 64=avian
			--below we assume that client will never pass animal bit without livstock or avian bits
			WHEN (b.intHACode & 97) > 1 THEN (~1 & b.intHACode) & @HACode -- if avian or livstock bits are set, clear animal bit in  b.intHA_Code
			WHEN (b.intHACode & 97) = 1 THEN (~1 & b.intHACode | 96) & @HACode --if only animal bit is set, clear clear animal bit and set both avian and livstock bits in  b.intHA_Code
			ELSE b.intHACode & @HACode  END >0)

)











