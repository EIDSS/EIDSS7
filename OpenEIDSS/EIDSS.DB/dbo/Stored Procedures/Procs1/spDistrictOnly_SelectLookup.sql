
/*
 exec spDistrictOnly_SelectLookup 'ru', null, null
 

*/

create    PROCEDURE dbo.spDistrictOnly_SelectLookup
	@LangID		as nvarchar(50),
	@RegionID	as bigint = NULL ,
	@ID			as bigint = NULL

AS
SELECT	
	 districtRef.idfsReference	as idfsDistrict
	,districtRef.[name]			as strDistrictName
	,districtRef.ExtendedName	as strDistrictExtendedName
	,districtRef.ExtendedName	as strRayonExtendedName
	,district.idfsRegion		as idfsProvince
	,province.ExtendedName		as strProvinceExtendedName
	,district.idfsCountry		as idfsCountry
	,country.name				as strCountryName
	,districtRef.intRowStatus
	
FROM	dbo.fnGisExtendedReferenceRepair(@LangID,19000002) as districtRef--'rftRayon' 
join 	gisRayon as district
	on	districtRef.idfsReference = district.idfsRayon 
join 	gisCountry
	on	district.idfsCountry = gisCountry.idfsCountry
join dbo.fnGisExtendedReferenceRepair(@LangID,19000003) as province
	on	province.idfsReference = district.idfsRegion
join dbo.fnGisReferenceRepair(@LangID,19000001) as country
	on country.idfsReference = district.idfsCountry
left join    gisDistrictSubdistrict as	subdistrict
	on	districtRef.idfsReference = subdistrict.idfsGeoObject
	
WHERE	(@RegionID is null or district.idfsRegion = @RegionID)
	and (@ID is null or @ID = idfsParent)
	and district.idfsCountry in (select distinct idfsCountry from tstCustomizationPackage)
	and subdistrict.idfsParent is null 
ORDER BY strDistrictName






