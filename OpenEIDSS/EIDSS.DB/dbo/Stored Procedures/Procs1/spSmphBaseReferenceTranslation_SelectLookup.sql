

CREATE     PROCEDURE [dbo].[spSmphBaseReferenceTranslation_SelectLookup] 
	@idfsReferenceType bigint,
	@lang nvarchar(32)
AS
select br.idfsBaseReference as id, Isnull(bt.strTextString, br.strDefault) as tr, @lang as lg
from trtBaseReference br
left outer join trtStringNameTranslation bt on bt.idfsBaseReference = br.idfsBaseReference
and bt.idfsLanguage = dbo.fnGetLanguageCode(@lang)
where br.idfsReferenceType = @idfsReferenceType

