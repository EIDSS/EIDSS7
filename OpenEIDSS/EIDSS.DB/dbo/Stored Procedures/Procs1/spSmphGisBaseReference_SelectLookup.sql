

CREATE     PROCEDURE [dbo].[spSmphGisBaseReference_SelectLookup] 
	@idfsCountry bigint
AS
select b.idfsGISBaseReference as id, b.idfsGISReferenceType as tp, 
c.idfsCountry as cn, 0 as rg, 0 as rn, b.strDefault as df, b.intRowStatus as rs, isnull(b.intOrder,0) as rd
from gisBaseReference b
inner join gisCountry c on c.idfsCountry = b.idfsGISBaseReference
where c.idfsCountry = @idfsCountry
union all
select b.idfsGISBaseReference as id, b.idfsGISReferenceType as tp, 
c.idfsCountry as cn, c.idfsRegion as rg, 0 as rn, b.strDefault as df, b.intRowStatus as rs, isnull(b.intOrder,0) as rd
from gisBaseReference b
inner join gisRegion c on c.idfsRegion = b.idfsGISBaseReference
where c.idfsCountry = @idfsCountry
union all
select b.idfsGISBaseReference as id, b.idfsGISReferenceType as tp, 
c.idfsCountry as cn, d.idfsRegion as rg, d.idfsRayon as rn, b.strDefault as df, b.intRowStatus as rs, isnull(b.intOrder,0) as rd
from gisBaseReference b
inner join gisRayon d on d.idfsRayon = b.idfsGISBaseReference
inner join gisRegion c on c.idfsRegion = d.idfsRegion
where c.idfsCountry = @idfsCountry
union all
select b.idfsGISBaseReference as id, b.idfsGISReferenceType as tp, 
c.idfsCountry as cn, c.idfsRegion as rg, d.idfsRayon as rn, b.strDefault as df, b.intRowStatus as rs, isnull(b.intOrder,0) as rd
from gisBaseReference b
inner join gisSettlement e on e.idfsSettlement = b.idfsGISBaseReference
inner join gisRayon d on d.idfsRayon = e.idfsRayon
inner join gisRegion c on c.idfsRegion = d.idfsRegion
where c.idfsCountry = @idfsCountry

