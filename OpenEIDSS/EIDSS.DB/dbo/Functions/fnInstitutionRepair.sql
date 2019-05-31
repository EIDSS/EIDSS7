
CREATE       function [dbo].[fnInstitutionRepair](@LangID  nvarchar(50))
returns table
as
return( 

select			tlbOffice.idfOffice, 
				IsNull(s3.strTextString, b1.strDefault) as EnglishFullName,
				IsNull(s4.strTextString, b2.strDefault) as EnglishName,
				IsNull(s1.strTextString, b1.strDefault) as [FullName],
				IsNull(s2.strTextString, b2.strDefault) as [name],
				tlbOffice.idfsOfficeName,
				tlbOffice.idfsOfficeAbbreviation,
				tlbOffice.idfLocation,
				tlbOffice.strContactPhone,
				tlbOffice.intHACode, 
				tlbOffice.strOrganizationID,
				b1.strDefault, 
				tlbOffice.idfsSite,
				tlbOffice.intRowStatus,
				b2.intOrder
from			dbo.tlbOffice
left outer join	dbo.trtBaseReference as b1 
on				tlbOffice.idfsOfficeName = b1.idfsBaseReference
				--and b1.intRowStatus = 0
left join		dbo.trtStringNameTranslation as s1 
on				b1.idfsBaseReference = s1.idfsBaseReference
				and s1.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join		dbo.trtStringNameTranslation as s3 
on				b1.idfsBaseReference = s3.idfsBaseReference
				and s3.idfsLanguage = dbo.fnGetLanguageCode('en')

left outer join	dbo.trtBaseReference as b2 
on				tlbOffice.idfsOfficeAbbreviation = b2.idfsBaseReference
				--and b2.intRowStatus = 0
left join		dbo.trtStringNameTranslation as s2 
on				b2.idfsBaseReference = s2.idfsBaseReference
				and s2.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join		dbo.trtStringNameTranslation as s4 
on				b2.idfsBaseReference = s4.idfsBaseReference
				and s4.idfsLanguage = dbo.fnGetLanguageCode('en')
)



