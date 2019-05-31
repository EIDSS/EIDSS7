
CREATE     PROCEDURE [dbo].[spSmphOrganizationTranslation_SelectLookup] 
	@lang nvarchar(32)
AS
select tlbOffice.idfOffice as id, Isnull(s2.strTextString, s1.strTextString) as tr, @lang as lg
from dbo.tlbOffice
left outer join	dbo.trtBaseReference as b1 
on				tlbOffice.idfsOfficeName = b1.idfsBaseReference
left join		dbo.trtStringNameTranslation as s1 
on				b1.idfsBaseReference = s1.idfsBaseReference
				and s1.idfsLanguage = dbo.fnGetLanguageCode('en')
left join		dbo.trtStringNameTranslation as s2 
on				b1.idfsBaseReference = s2.idfsBaseReference
				and s2.idfsLanguage = dbo.fnGetLanguageCode(@lang)


