
--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 04.02.2012


/*
--Example of function call:

DECLARE @GeoLocation BIGINT
SELECT dbo.fnGeoLocationSharedString (
   'en'
  ,@GeoLocation
  ,null)

*/





CREATE        function [dbo].[fnGeoLocationSharedString] (
					@LangID  nvarchar(50),  --##PARAM @LangID - lanquage ID
					@GeoLocation bigint,   --##PARAM @GeoLocation - geolocation record ID
					@GeoLocationType bigint = null)  --##PARAM @GeoLocationType - desired Type of geolocation string. If NULL, the idfsGeoLocationType value of geolocation record is used 
returns nvarchar(1000)
as 
begin
DECLARE @Country			nvarchar(200)
DECLARE @Region				nvarchar(200)
DECLARE @Rayon				nvarchar(200)
DECLARE @Latitude			nvarchar(200)
DECLARE @Longitude			nvarchar(200)
DECLARE @PostalCode			nvarchar(200)
DECLARE @SettlementType		nvarchar(200)
DECLARE @Settlement			nvarchar(200)
DECLARE @Street				nvarchar(200)
DECLARE @House				nvarchar(200)
DECLARE @Building			nvarchar(200)
DECLARE @Appartment			nvarchar(200)
DECLARE @Alignment			nvarchar(200)
DECLARE @Distance			nvarchar(200)
DECLARE @blnForeignAddress	bit
DECLARE @strForeignAddress	nvarchar(200)

select	@GeoLocationType = ISNULL(@GeoLocationType, tlbGeoLocationShared.idfsGeoLocationType),
		@Country =  ISNULL(GeoLocation.Country,N''),
		@Region =  ISNULL(GeoLocation.Region,N''),
		@Rayon =  ISNULL(GeoLocation.Rayon,N''),
		@Latitude =  REPLACE(CAST(ISNULL(tlbGeoLocationShared.dblLatitude ,N'') AS DECIMAL(8, 5)), '0.00000', N'0'),
		@Longitude =  REPLACE(CAST(ISNULL(tlbGeoLocationShared.dblLongitude ,N'') AS DECIMAL(8, 5)), '0.00000', N'0'),		
		@PostalCode =  ISNULL(tlbGeoLocationShared.strPostCode,N''),
		@SettlementType =  ISNULL(GeoLocation.SettlementType,N''),
		@Settlement =  ISNULL(GeoLocation.Settlement,N''),
		@Street =  ISNULL(tlbGeoLocationShared.strStreetName,N''),
		@House =  ISNULL(tlbGeoLocationShared.strHouse,N''),
		@Building =  ISNULL(tlbGeoLocationShared.strBuilding,N''),
		@Appartment =  ISNULL(tlbGeoLocationShared.strApartment,N''),
		@Alignment =  ISNULL(tlbGeoLocationShared.dblAlignment,N''),
		@Distance =  ISNULL(tlbGeoLocationShared.dblDistance,N''),
		@blnForeignAddress = ISNULL(tlbGeoLocationShared.blnForeignAddress, 0),
		@strForeignAddress =  ISNULL(tlbGeoLocationShared.strForeignAddress,N'')
from	tlbGeoLocationShared 
		inner join fnGeoLocationSharedAsRow(@LangID) as GeoLocation
		on tlbGeoLocationShared.idfGeoLocationShared = GeoLocation.idfGeoLocationShared
where	tlbGeoLocationShared.idfGeoLocationShared = @GeoLocation
return dbo.fnCreateGeoLocationString (
   @LangID
  ,@GeoLocationType
  ,@Country
  ,@Region
  ,@Rayon
  ,@Latitude
  ,@Longitude
  ,@PostalCode
  ,@SettlementType
  ,@Settlement
  ,@Street
  ,@House
  ,@Building
  ,@Appartment
  ,@Alignment
  ,@Distance
  ,@blnForeignAddress
  ,@strForeignAddress)
end
