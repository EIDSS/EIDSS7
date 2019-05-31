





--##SUMMARY Returns representation of short address string of shared geolocation record.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 26.01.2014

--##RETURNS Returns text representation of geolocation record, depending on geolocation record Type


/*
--Example of function call:

DECLARE @GeoLocation BIGINT
SELECT dbo.fnGeoLocationSharedShortAddressString (
   'en'
  ,@GeoLocation
  ,null)

*/





CREATE        function fnGeoLocationSharedShortAddressString (
					@LangID  nvarchar(50),  --##PARAM @LangID - lanquage ID
					@GeoLocation bigint,   --##PARAM @GeoLocation - geolocation record ID
					@GeoLocationType bigint = null)  --##PARAM @GeoLocationType - desired Type of geolocation string. If NULL, the idfsGeoLocationType value of geolocation record is used 
returns nvarchar(1000)
as 
begin
DECLARE @PostalCode			nvarchar(200)
DECLARE @Street				nvarchar(200)
DECLARE @House				nvarchar(200)
DECLARE @Building			nvarchar(200)
DECLARE @Appartment			nvarchar(200)
DECLARE @blnForeignAddress	bit

select	@GeoLocationType = ISNULL(@GeoLocationType, tlbGeoLocationShared.idfsGeoLocationType),
		@PostalCode =  ISNULL(tlbGeoLocationShared.strPostCode,N''),
		@Street =  ISNULL(tlbGeoLocationShared.strStreetName,N''),
		@House =  ISNULL(tlbGeoLocationShared.strHouse,N''),
		@Building =  ISNULL(tlbGeoLocationShared.strBuilding,N''),
		@Appartment =  ISNULL(tlbGeoLocationShared.strApartment,N''),
		@blnForeignAddress = ISNULL(tlbGeoLocationShared.blnForeignAddress, 0)
from	tlbGeoLocationShared 
where	tlbGeoLocationShared.idfGeoLocationShared = @GeoLocation

if	isnull(@GeoLocationType, 0) <> 10036001
	set	@blnForeignAddress = 1

return dbo.fnCreateShortAddressString (
  @PostalCode
  ,@Street
  ,@House
  ,@Building
  ,@Appartment
  ,@blnForeignAddress
)
end
















