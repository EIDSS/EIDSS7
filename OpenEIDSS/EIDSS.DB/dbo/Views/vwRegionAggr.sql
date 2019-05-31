
--##SUMMARY Selects the list of regions for aggregate cases. Include virtual regions. 
--##SUMMARY It is used in fnAggregateCaseList and in spRegion_SelectLookup

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.08.2013

--##RETURNS Doesn't use

/*
--Example of view call:

SELECT * FROM  dbo.vwRegionAggr
*/
CREATE VIEW [dbo].[vwRegionAggr]
	AS 
SELECT	b.idfsGISBaseReference as idfsRegion, 
		IsNull(c.strTextString, b.strDefault) as strRegionName, 
		gisRegion.strCode as strRegionCode, 
		gisRegion.idfsCountry, 
		b.intRowStatus,
		c.idfsLanguage
FROM	dbo.gisBaseReference as b 
left join	dbo.gisStringNameTranslation as c 
on			b.idfsGISBaseReference = c.idfsGISBaseReference
join 	gisRegion 
on	b.idfsGISBaseReference = gisRegion.idfsRegion 

WHERE	
	gisRegion.idfsCountry = dbo.fnCurrentCountry()
	and	b.idfsGISReferenceType = 19000003--'rftRegion'

	
union all

select
	region.idfsGISBaseReference as idfsRegion, 
	IsNull(c.strTextString, region.strDefault) as strRegionName, 
	null as strRegionCode,
	dbo.fnCurrentCountry() as idfsCountry, 
	region.intRowStatus,
	c.idfsLanguage
FROM	dbo.gisBaseReference as region  --'rftAggrRegion'
left join	dbo.gisStringNameTranslation as c 
on			region.idfsGISBaseReference = c.idfsGISBaseReference
where dbo.fnCurrentCountry() = 170000000	
AND region.idfsGISReferenceType =19000020  --'rftAggrRegion'
	

