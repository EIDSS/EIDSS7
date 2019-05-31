


-- select * from fnGisReferenceRepair('ru',19000001)

CREATE          function fnGisReferenceRepair(@LangID  nvarchar(50), @type bigint)
returns table
as
return(

select
			b.idfsGISBaseReference as idfsReference, 
			IsNull(c.strTextString, b.strDefault) as [name],
			b.idfsGISReferenceType, 
			b.strDefault, 
			IsNull(c.strTextString, b.strDefault) as LongName,
			b.intOrder,
			b.intRowStatus

from		dbo.gisBaseReference as b 
left join	dbo.gisStringNameTranslation as c 
on			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		b.idfsGISReferenceType = @type
)











