
--*************************************************************
-- Name 				: fnGeoLocationString
-- Description			: Returns text representation of geolocation record.
-- Author               : Joan Li
-- Revision History
--		Name			Date			Change Detail
--		Joan Li			10/24/2017		convert from v6: fnGeoLocationString
--
-- Testing code:
-- DECLARE @GeoLocation BIGINT
-- SELECT dbo.fnGeoLocationString ( 'en',52603000000000 ,NULL)
--*************************************************************


CREATE        function [dbo].[fnGeoLocationString] 
(
	@LangID				NVARCHAR(50),	--##PARAM @LangID - lanquage ID
	@GeoLocation		BIGINT,			--##PARAM @GeoLocation - geolocation record ID
	@GeoLocationType	BIGINT = NULL	--##PARAM @GeoLocationType - desired Type of geolocation string. If NULL, the idfsGeoLocationType value of geolocation record is used 
)  
returns nvarchar(1000)
as 
begin
DECLARE 
	 @Country				NVARCHAR(200)
	,@Region				NVARCHAR(200)
	,@Rayon					NVARCHAR(200)
	,@Latitude				NVARCHAR(200)
	,@Longitude				NVARCHAR(200)
	,@PostalCode			NVARCHAR(200)
	,@SettlementType		NVARCHAR(200)
	,@Settlement			NVARCHAR(200)
	,@Street				NVARCHAR(200)
	,@House					NVARCHAR(200)
	,@Building				NVARCHAR(200)
	,@Appartment			NVARCHAR(200)
	,@ResidentType			NVARCHAR(200)
	,@Alignment				NVARCHAR(200)
	,@Distance				NVARCHAR(200)
	,@blnForeignAddress		BIT
	,@strForeignAddress		NVARCHAR(200)

select	@GeoLocationType = ISNULL(@GeoLocationType, tlbGeoLocation.idfsGeoLocationType),
		@Country =  ISNULL(GeoLocation.Country,N''),
		@Region =  ISNULL(GeoLocation.Region,N''),
		@Rayon =  ISNULL(GeoLocation.Rayon,N''),
		@Latitude =  REPLACE(CAST(ISNULL(tlbGeoLocation.dblLatitude ,N'') AS DECIMAL(8, 5)), '0.00000', N'0'),
		@Longitude =  REPLACE(CAST(ISNULL(tlbGeoLocation.dblLongitude ,N'') AS DECIMAL(8, 5)), '0.00000', N'0'),
		@PostalCode =  ISNULL(tlbGeoLocation.strPostCode,N''),
		@SettlementType =  ISNULL(GeoLocation.SettlementType,N''),
		@Settlement =  ISNULL(GeoLocation.Settlement,N''),
		@Street =  ISNULL(tlbGeoLocation.strStreetName,N''),
		@House =  ISNULL(tlbGeoLocation.strHouse,N''),
		@Building =  ISNULL(tlbGeoLocation.strBuilding,N''),
		@Appartment =  ISNULL(tlbGeoLocation.strApartment,N''),
		@Alignment =  ISNULL(tlbGeoLocation.dblAlignment,N''),
		@Distance =  ISNULL(tlbGeoLocation.dblDistance,N''),
		@blnForeignAddress = ISNULL(tlbGeoLocation.blnForeignAddress, 0),
		@strForeignAddress =  ISNULL(tlbGeoLocation.strForeignAddress,N'')
from	tlbGeoLocation 
		inner join fnGeoLocationAsRow(@LangID) as GeoLocation
		on tlbGeoLocation.idfGeoLocation = GeoLocation.idfGeoLocation
where	tlbGeoLocation.idfGeoLocation = @GeoLocation
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

















