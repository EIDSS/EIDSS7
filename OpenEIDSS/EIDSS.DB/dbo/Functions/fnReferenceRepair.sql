
-- select * from fnReferenceRepair('ru',19000040)

-- Select all reference values - with deleted values
/*
Joan Li: 4/21/2017
modified: swith index table hint to with nolock 
*/
CREATE function [dbo].[fnReferenceRepair](@LangID  nvarchar(50), @type bigint)

returns table

as

return(



select

			b.idfsBaseReference as idfsReference, 

			IsNull(c.strTextString, b.strDefault) as [name],

			b.idfsReferenceType, 

			b.intHACode, 

			b.strDefault, 

			IsNull(c.strTextString, b.strDefault) as LongName,

			b.intOrder,

			b.intRowStatus



from		dbo.trtBaseReference as b with (nolock)  ------- with(index=IX_trtBaseReference_RR)

left join	dbo.trtStringNameTranslation as c with (nolock) -----with(index=IX_trtStringNameTranslation_BL)

on			b.idfsBaseReference = c.idfsBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)



where		b.idfsReferenceType = @type --and = 0 

)







