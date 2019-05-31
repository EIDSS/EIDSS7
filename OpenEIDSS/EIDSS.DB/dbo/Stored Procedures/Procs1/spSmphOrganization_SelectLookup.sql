
/*
exec [dbo].[spSmphOrganization_SelectLookup] 
*/

CREATE     PROCEDURE [dbo].[spSmphOrganization_SelectLookup] 
AS
select tlbOffice.idfOffice as id, 19000046 as tp, tlbOffice.intHACode as ha, IsNull(s1.strTextString, b1.strDefault) as df, tlbOffice.intRowStatus as rs,
  CAST(ISNULL(g.idfsRegion, 0) as bigint) as idfsRegion,  
  CAST(ISNULL(g.idfsRayon, 0) as bigint) as idfsRayon 

from dbo.tlbOffice
left outer join	dbo.trtBaseReference as b1 
on				tlbOffice.idfsOfficeName = b1.idfsBaseReference
left join		dbo.trtStringNameTranslation as s1 
on				b1.idfsBaseReference = s1.idfsBaseReference
				and s1.idfsLanguage = dbo.fnGetLanguageCode('en')
left join       tlbGeoLocationShared g
on              tlbOffice.idfLocation = g.idfGeoLocationShared


