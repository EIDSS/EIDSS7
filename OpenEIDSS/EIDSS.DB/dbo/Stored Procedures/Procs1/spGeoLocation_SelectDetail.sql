

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 15.08.2011

--##REMARKS UPDATED BY: Zolotareva N.
--##REMARKS Date: 26.12.2011


CREATE         PROCEDURE [dbo].[spGeoLocation_SelectDetail](  
 @idfGeoLocation AS bigint ,
 @LangID  nvarchar(50)  
)  
AS  
SELECT gl.[idfGeoLocation]  
      ,[idfsGroundType]  
      ,[idfsGeoLocationType]  
      ,[idfsCountry]  
      ,[idfsRegion]  
      ,[idfsRayon]  
      ,[idfsSettlement]  
      ,[idfsSite]  
      ,[strPostCode]  
      ,[strStreetName]  
      ,[strHouse]  
      ,[strBuilding]  
      ,[strApartment]  
      ,[strDescription]  
      ,[dblDistance]  
      ,[dblLatitude]  
      ,[dblLongitude]  
      ,CASE WHEN [idfsGeoLocationType] = 10036003 THEN NULL ELSE dblLatitude END AS dblRelLatitude  
      ,CASE WHEN [idfsGeoLocationType] = 10036003 THEN NULL ELSE [dblLongitude] END AS dblRelLongitude  
      ,[dblAccuracy]  
      ,[dblAlignment]
      ,[strAddressStringTranslate] = tr.[name]
	  ,[strAddressDefaultString] = tr.strDefault
	  ,blnForeignAddress
	  ,strForeignAddress  
  FROM tlbGeoLocation  gl JOIN fnGeoLocationTranslation(@LangID) tr
	on gl.idfGeoLocation = tr.idfGeoLocation
  WHERE gl.[idfGeoLocation] = @idfGeoLocation  
  AND intRowStatus = 0  
  
UNION ALL  
  
SELECT gl.[idfGeoLocationShared]  
      ,[idfsGroundType]  
      ,[idfsGeoLocationType]  
      ,[idfsCountry]  
      ,[idfsRegion]  
      ,[idfsRayon]  
      ,[idfsSettlement]  
      ,[idfsSite]  
      ,[strPostCode]  
      ,[strStreetName]  
      ,[strHouse]  
      ,[strBuilding]  
      ,[strApartment]  
      ,[strDescription]  
      ,[dblDistance]  
      ,[dblLatitude]  
      ,[dblLongitude]  
      ,CASE WHEN [idfsGeoLocationType] = 10036003 THEN NULL ELSE dblLatitude END AS dblRelLatitude  
      ,CASE WHEN [idfsGeoLocationType] = 10036003 THEN NULL ELSE [dblLongitude] END AS dblRelLongitude  
      ,[dblAccuracy]  
      ,[dblAlignment]  
      ,[strAddressStringTranslate] = tr.[name]
	  ,[strAddressDefaultString] = tr.strDefault        
	  ,blnForeignAddress
 	  ,strForeignAddress  
 FROM tlbGeoLocationShared   gl JOIN fnGeoLocationSharedTranslation(@LangID) tr
	on gl.idfGeoLocationShared = tr.idfGeoLocationShared
  WHERE gl.[idfGeoLocationShared] = @idfGeoLocation  
  AND intRowStatus = 0  
   
