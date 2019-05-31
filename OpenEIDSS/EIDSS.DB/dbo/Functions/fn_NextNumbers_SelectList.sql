


--##SUMMARY Selects list of numbering objects for NextNumbersList form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

SELECT * FROM fn_NextNumbers_SelectList('en')
*/







CREATE     function dbo.fn_NextNumbers_SelectList(
	@LangID as nvarchar(50)--##PARAM @LangID - language ID
)
returns table 
as
return

select		nn.[idfsNumberName], 
			nn.[strPrefix], 
 			intNumberValue =
			case IsNull(nn.blnUseAlphaNumericValue, 0)
				when 0 then cast(IsNull(nn.[intNumberValue], 0) as varchar(100))
				when 1 then dbo.fnAlphaNumeric(IsNull(nn.[intNumberValue], 0), ISNULL(intMinNumberLength,4))
			end,
			nn.[intMinNumberLength], 
			fnReferenceRepair.[name] as strObjectName

from		dbo.tstNextNumbers nn

left join	fnReferenceRepair(@LangID, 19000057/*rftNumberingType*/) 
on			fnReferenceRepair.idfsReference = nn.idfsNumberName







