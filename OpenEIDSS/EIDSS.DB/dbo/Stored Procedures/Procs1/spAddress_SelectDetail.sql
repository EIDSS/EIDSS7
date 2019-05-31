






CREATE         PROCEDURE [dbo].[spAddress_SelectDetail](  
 @idfAddress AS bigint,
 @LangID  nvarchar(50)  
)  
AS  
  
  
SELECT  gl.idfGeoLocation,   
 strApartment,   
 strBuilding,   
 strHouse,   
 strPostCode,   
 strStreetName,   
 idfsCountry,  
 idfsRegion,  
 idfsRayon,   
 idfsSettlement,  
 strAddressStringTranslate = tr.[name],
 strAddressDefaultString = tr.strDefault,
 blnForeignAddress,
 strForeignAddress,
 dblLatitude,
 dblLongitude
FROM  
 tlbGeoLocation  gl JOIN fnGeoLocationTranslation(@LangID) tr
	on gl.idfGeoLocation = tr.idfGeoLocation
WHERE  
 gl.idfGeoLocation = @idfAddress  
 and intRowStatus = 0  
   
UNION ALL  
  
SELECT  gl.idfGeoLocationShared,   
 strApartment,   
 strBuilding,   
 strHouse,   
 strPostCode,   
 strStreetName,   
 idfsCountry,  
 idfsRegion,  
 idfsRayon,   
 idfsSettlement,  
 strAddressStringTranslate = tr.[name],
 strAddressDefaultString = tr.strDefault,
 blnForeignAddress,
 strForeignAddress,
 dblLatitude,
 dblLongitude
FROM  
 tlbGeoLocationShared  gl JOIN fnGeoLocationSharedTranslation(@LangID) tr
	on gl.idfGeoLocationShared = tr.idfGeoLocationShared
WHERE  
 gl.idfGeoLocationShared = @idfAddress  
 and intRowStatus = 0  
