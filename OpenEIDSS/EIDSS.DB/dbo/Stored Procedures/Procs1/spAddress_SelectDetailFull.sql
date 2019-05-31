






CREATE         PROCEDURE dbo.spAddress_SelectDetailFull(
	@idfAddress AS bigint,
	@LangID As nvarchar(50)
)
AS
-- 0- Address
SELECT  
	idfGeoLocation, 
	strApartment, 
	strBuilding, 
	strHouse, 
	strPostCode, 
	strStreetName, 
	tlbGeoLocation.idfsCountry,
	idfsRegion,
	idfsRayon, 
	idfsSettlement,
	Country.[name] as strCountryName,
	Region.[name] as strRegionName,
	Rayon.[name] as strRayonName,
	Settlement.[name] as strSettlementName
FROM
	tlbGeoLocation
	left outer join	dbo.fnGisReference(@LangID,19000001) Country
		on	Country.idfsReference = tlbGeoLocation.idfsCountry
	left outer join	dbo.fnGisReference(@LangID,19000003) Region
		on	Region.idfsReference = tlbGeoLocation.idfsRegion
	left outer join	dbo.fnGisReference(@LangID,19000002) Rayon
		on	Rayon.idfsReference = tlbGeoLocation.idfsRayon
	left outer join	dbo.fnGisReference(@LangID,19000004) Settlement
		on	Settlement.idfsReference = tlbGeoLocation.idfsSettlement
WHERE
	idfGeoLocation = @idfAddress
	and tlbGeoLocation.intRowStatus = 0




