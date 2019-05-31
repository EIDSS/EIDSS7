/*
6/7/2017: check the code and result
-- select * from fnGisReference('en',19000001)
*/
CREATE          function [dbo].[fnGisReference](@LangID  nvarchar(50), @type bigint)
returns table
as

return(
select

			b.idfsGISBaseReference as idfsReference, 
			IsNull(c.strTextString, b.strDefault) as [name],
			b.idfsGISReferenceType, 
			b.strDefault, 
			IsNull(c.strTextString, b.strDefault) as LongName,
			b.intOrder
from		dbo.gisBaseReference as b 
left join	dbo.gisStringNameTranslation as c 
on			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	AND c.intRowStatus = 0
where		b.idfsGISReferenceType = @type

	AND b.intRowStatus = 0

)






















