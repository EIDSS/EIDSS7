


-- select * from fnReferenceRepairWithNoneValue('ru',19000040)

create          function fnReferenceRepairWithNoneValue(@LangID  nvarchar(50), @type bigint)
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
			b.intOrder

from		dbo.trtBaseReference as b with(index=IX_trtBaseReference_RR)
left join	dbo.trtStringNameTranslation as c with(index=IX_trtStringNameTranslation_BL)
on			b.idfsBaseReference = c.idfsBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		b.idfsReferenceType = @type

union

select		-1 as idfsReference,
			-- Workaround. We dont need (none) anymore
			null, 
			@type as idfsReferenceType, 
			null as intHACode, 
			null, 
			null, 
			0 as intOrder


)
