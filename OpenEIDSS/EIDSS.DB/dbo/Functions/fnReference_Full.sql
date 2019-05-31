
-- select * from fnReference_Full ('en')

CREATE function [dbo].[fnReference_Full](@LangID	nvarchar(50))
returns table
as
return(
select		b.idfsBaseReference as idfsReference, 
			IsNull(c.strTextString, b.strDefault) as [name],
			b.idfsReferenceType, 
			b.intHACode, 
			b.strDefault, 
--			b.intRowStatus, 
			IsNull(c.strTextString, b.strDefault) as [LongName]

from		dbo.trtBaseReference as b 
left Join 	dbo.trtStringNameTranslation as c 
on			b.idfsBaseReference = c.idfsBaseReference
			and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		b.intRowStatus = 0 -- or intRowStatus is null) --    

)


