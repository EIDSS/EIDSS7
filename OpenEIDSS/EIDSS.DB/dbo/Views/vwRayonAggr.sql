
--##SUMMARY Selects the list of rayons for aggregate cases. Include virtual rayons. 
--##SUMMARY It is used in fnAggregateCaseList and in spRayon_SelectLookup

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.08.2013

--##RETURNS Doesn't use

/*
--Example of view call:

SELECT * FROM  dbo.vwRayonAggr
*/
CREATE VIEW [dbo].[vwRayonAggr]
	AS 
	SELECT	b.idfsGISBaseReference as idfsRayon, 
		IsNull(c.strTextString, b.strDefault) as strRayonName, 
		gisRayon.idfsRegion, 
		gisRayon.idfsCountry, 
		b.intRowStatus,
		c.idfsLanguage
FROM	dbo.gisBaseReference as b 
left join	dbo.gisStringNameTranslation as c 
on			b.idfsGISBaseReference = c.idfsGISBaseReference
join 	gisRayon 
on	b.idfsGISBaseReference = gisRayon.idfsRayon 
join 	gisCountry
on	gisRayon.idfsCountry = gisCountry.idfsCountry

WHERE	
	gisRayon.idfsCountry = dbo.fnCurrentCountry()
	and	b.idfsGISReferenceType = 19000002--'rftRayon'

	
union all

select
	rayon.idfsGISBaseReference as idfsRayon, 
	IsNull(c.strTextString, rayon.strDefault) as strRayonName, 
	region.idfsGISBaseReference as idfsRegion,
	dbo.fnCurrentCountry() as idfsCountry, 
	rayon.intRowStatus,
	c.idfsLanguage
FROM	dbo.gisBaseReference as rayon
left join	dbo.gisStringNameTranslation as c 
on			rayon.idfsGISBaseReference = c.idfsGISBaseReference
cross join dbo.gisBaseReference as region  --'rftAggrRegion'
where dbo.fnCurrentCountry() = 170000000	
AND rayon.idfsGISReferenceType =  19000021--'rftAggrRayon'
AND region.idfsGISReferenceType =19000020  --'rftAggrRegion'
	

