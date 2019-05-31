


--exec dbo.spProphilacticActionList_SelectLookup 'en'


CREATE      procedure spProphilacticActionList_SelectLookup
	(@LangID as nvarchar(50))
as

select		b.idfsBaseReference as idfsReference, 
			IsNull(c.strTextString, b.strDefault) as [name], 
			p.strActionCode,
			b.intOrder,
			b.intRowStatus
from		dbo.trtBaseReference as b 
inner join	dbo.trtProphilacticAction p 
on			p.idfsProphilacticAction = b.idfsBaseReference
left join	dbo.trtStringNameTranslation as c 
on			b.idfsBaseReference = c.idfsBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			and b.idfsReferenceType = 19000074--rftProphilacticActionList
where
			(b.intHACode is null or b.intHACode & 97 > 0)
order by	IsNull(b.intOrder, 0), [name] 




