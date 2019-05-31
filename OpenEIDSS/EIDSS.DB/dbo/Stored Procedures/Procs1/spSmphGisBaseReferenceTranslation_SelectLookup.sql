

CREATE     PROCEDURE [dbo].[spSmphGisBaseReferenceTranslation_SelectLookup] 
	@idfsCountry bigint,
	@lang nvarchar(32)
AS
select b.idfsGISBaseReference as id, Isnull(o.strTextString, b.strDefault) as tr, @lang as lg
from gisBaseReference b
inner join gisCountry c on c.idfsCountry = b.idfsGISBaseReference
left join	dbo.gisStringNameTranslation as o
    on b.idfsGISBaseReference = o.idfsGISBaseReference and o.idfsLanguage = dbo.fnGetLanguageCode(@lang)
where c.idfsCountry = @idfsCountry
union all
select b.idfsGISBaseReference as id, o.strTextString as tr, @lang as lg
from gisBaseReference b
inner join gisRegion c on c.idfsRegion = b.idfsGISBaseReference
left join	dbo.gisStringNameTranslation as o
    on b.idfsGISBaseReference = o.idfsGISBaseReference and o.idfsLanguage = dbo.fnGetLanguageCode(@lang)
where c.idfsCountry = @idfsCountry
union all
select b.idfsGISBaseReference as id, Isnull(o.strTextString, b.strDefault) as tr, @lang as lg
from gisBaseReference b
inner join gisRayon d on d.idfsRayon = b.idfsGISBaseReference
inner join gisRegion c on c.idfsRegion = d.idfsRegion
left join	dbo.gisStringNameTranslation as o
    on b.idfsGISBaseReference = o.idfsGISBaseReference and o.idfsLanguage = dbo.fnGetLanguageCode(@lang)
where c.idfsCountry = @idfsCountry
union all
select b.idfsGISBaseReference as id, Isnull(o.strTextString, b.strDefault) as tr, @lang as lg
from gisBaseReference b
inner join gisSettlement e on e.idfsSettlement = b.idfsGISBaseReference
inner join gisRayon d on d.idfsRayon = e.idfsRayon
inner join gisRegion c on c.idfsRegion = d.idfsRegion
left join	dbo.gisStringNameTranslation as o
    on b.idfsGISBaseReference = o.idfsGISBaseReference and o.idfsLanguage = dbo.fnGetLanguageCode(@lang)
where c.idfsCountry = @idfsCountry

