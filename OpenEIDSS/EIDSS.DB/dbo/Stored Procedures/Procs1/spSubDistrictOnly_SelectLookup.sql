
/*
 exec spSubDistrictOnly_SelectLookup 'en', null, null
 
 7225
*/

create    PROCEDURE dbo.spSubDistrictOnly_SelectLookup
	@LangID		as nvarchar(50),
	@RegionID	as bigint = NULL ,
	@ParentID	as bigint = NULL ,
	@ID			as bigint = NULL

AS
SELECT	
	 districtRef.idfsReference	as idfsDistrict
	,districtRef.[name]			as strDistrictName
	,districtRef.ExtendedName	as strDistrictExtendedName
	,districtRef.ExtendedName	as strRayonExtendedName
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
join    gisDistrictSubdistrict as	subdistrict
	on	districtRef.idfsReference = subdistrict.idfsGeoObject
join	dbo.fnGisExtendedReferenceRepair(@LangID,19000002) as parentDistrictRef--'rftRayon' 
	on	parentDistrictRef.idfsReference = subdistrict.idfsParent	
	
WHERE (@RegionID is null or district.idfsRegion = @RegionID)	
	and (@ID is null or @ID = idfsParent)
	and (@ParentID is null or @ParentID = idfsRayon)
	and idfsParent is not null
	and district.idfsCountry in (select distinct idfsCountry from tstCustomizationPackage)
ORDER BY strDistrictName




