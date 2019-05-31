
/*
 exec spDistrict_SelectLookup 'en', null, null
*/

create    PROCEDURE dbo.spDistrict_SelectLookup
	@LangID		as nvarchar(50),
	@RegionID	as bigint = NULL ,
	@ParentID	as bigint = NULL ,
	@ID			as bigint = NULL

AS
SELECT	
	 districtRef.idfsReference	as idfsDistrict
	,districtRef.[name]			as strDistrictName
	,districtRef.ExtendedName	as strDistrictExtendedName
	,subdistrict.idfsParent		as idfsParentDistrict
	,parentDistrictRef.[name]	as strParentDistrictName	
	,parentDistrictRef.ExtendedName	as strParentDistrictExtendedName
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
left join	dbo.fnGisExtendedReferenceRepair(@LangID,19000002) as parentDistrictRef--'rftRayon' 
	on	parentDistrictRef.idfsReference = subdistrict.idfsParent	
	
WHERE	
	district.idfsRegion = isnull(@RegionID, district.idfsRegion)
	AND (@ID IS NULL OR @ID = idfsParent)
	AND (@ParentID IS NULL OR @ParentID = idfsRayon)
	and district.idfsCountry in (select distinct idfsCountry from tstCustomizationPackage)
ORDER BY strDistrictName




