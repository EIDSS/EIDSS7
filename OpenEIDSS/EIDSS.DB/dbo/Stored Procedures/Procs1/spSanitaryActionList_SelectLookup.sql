



--exec dbo.spSanitaryActionList_SelectLookup 'en'


CREATE      procedure dbo.spSanitaryActionList_SelectLookup
	(@LangID as nvarchar(50))
as

select		b.idfsBaseReference as idfsReference, 
			IsNull(c.strTextString, b.strDefault) as [name], 
			s.strActionCode,
			b.intOrder,
			b.intRowStatus
from		dbo.trtBaseReference as b 
inner join	trtSanitaryAction s 
on			s.idfsSanitaryAction = b.idfsBaseReference 
left join	dbo.trtStringNameTranslation as c 
on			b.idfsBaseReference = c.idfsBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			and b.idfsReferenceType = 19000079--rftSanitaryActionList
where
			(b.intHACode is null or b.intHACode & 97 > 0)

order by	IsNull(b.intOrder, 0), [name] 




