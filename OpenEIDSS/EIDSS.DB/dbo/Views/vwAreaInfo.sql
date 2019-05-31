
--=====================================================================
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				checking and testing for EIDSS7: related usp50
--                         Selects the translated list of areas names used in statistic forms from tables:
--                          gisCountry;gisRegion;gisRayon;gisSettlement;gisBaseReference;gisStringNameTranslation
--						   It is used in fn_Statistic_SelectList for displaying Area name related with statistic record
-- Testing code:
/*
SELECT * FROM  dbo.vwAreaInfo
*/
--=====================================================================
CREATE view [dbo].[vwAreaInfo]
as

--Country names
select 
	gisCountry.idfsCountry as idfsArea, 
	IsNull(scountry.strTextString, country.strDefault) as strAreaName, 
	gisCountry.idfsCountry,
	idfsRegion = 0,
	idfsRayon = 0,
	idfsSettlement = 0,
	10089001 as AreaType, 
	scountry.idfsLanguage  
from   gisCountry  
inner join gisBaseReference country ON
	gisCountry.idfsCountry = country.idfsGISBaseReference

left join gisStringNameTranslation scountry
on			country.idfsGISBaseReference = scountry.idfsGISBaseReference


--Region names
union
select 
	gisRegion.idfsRegion as idfsArea, 
	IsNull(sregion.strTextString, region.strDefault) as strAreaName, 
	gisRegion.idfsCountry,
	gisRegion.idfsRegion,
	idfsRayon = 0,
	idfsSettlement = 0,
	10089003 as AreaType, 
	sregion.idfsLanguage  
from   gisRegion  
inner join gisBaseReference region ON
	gisRegion.idfsRegion = region.idfsGISBaseReference

left join gisStringNameTranslation sregion
on			region.idfsGISBaseReference = sregion.idfsGISBaseReference


--Rayon names in format [Region], [Rayon]
union
select 
	gisRayon.idfsRayon as idfsArea, 
	IsNull(sregion.strTextString, region.strDefault)+ ', ' +IsNull(srayon.strTextString, rayon.strDefault) as strAreaName, 
	gisRayon.idfsCountry,
	gisRayon.idfsRegion,
	gisRayon.idfsRayon,
	idfsSettlement = 0,
	10089002 as AreaType, 
	srayon.idfsLanguage  
from   gisRayon  
inner join gisBaseReference rayon ON
	gisRayon.idfsRayon = rayon.idfsGISBaseReference
left join gisStringNameTranslation srayon
on			rayon.idfsGISBaseReference = srayon.idfsGISBaseReference
inner join gisBaseReference region ON
	gisRayon.idfsRegion = region.idfsGISBaseReference
left join gisStringNameTranslation sregion
on			region.idfsGISBaseReference = sregion.idfsGISBaseReference
			and sregion.idfsLanguage = srayon.idfsLanguage


--Settlement names in format [Region], [Rayon], [Settlement]
union
select 
	gisSettlement.idfsSettlement as idfsArea, 
	IsNull(sregion.strTextString, region.strDefault)+ ', ' +IsNull(srayon.strTextString, rayon.strDefault) + ', ' +IsNull(ssettlement.strTextString, settlement.strDefault) as strAreaName, 
	gisSettlement.idfsCountry,
	gisSettlement.idfsRegion,
	gisSettlement.idfsRayon,
	gisSettlement.idfsSettlement,
	10089004 as AreaType, 
	ssettlement.idfsLanguage  
from   gisSettlement  
inner join gisBaseReference settlement ON
	gisSettlement.idfsSettlement = settlement.idfsGISBaseReference

left join gisStringNameTranslation ssettlement
on			settlement.idfsGISBaseReference = ssettlement.idfsGISBaseReference
inner join gisBaseReference rayon ON
	gisSettlement.idfsRayon = rayon.idfsGISBaseReference

left join gisStringNameTranslation srayon
on			rayon.idfsGISBaseReference = srayon.idfsGISBaseReference
			and ssettlement.idfsLanguage = srayon.idfsLanguage
inner join gisBaseReference region ON
	gisSettlement.idfsRegion = region.idfsGISBaseReference

left join gisStringNameTranslation sregion
on			region.idfsGISBaseReference = sregion.idfsGISBaseReference
			and sregion.idfsLanguage = ssettlement.idfsLanguage


