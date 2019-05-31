
--##SUMMARY Returns text representation of geolocation record coordinates in format (<Longitude>, <Latitude>).

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 10.02.2016

--##RETURNS Returns text representation of geolocation record, depending on geolocation record Type
CREATE FUNCTION [dbo].[fnGeoLocationCoordinatesString]
(
	@GeoLocation BIGINT   --##PARAM @GeoLocation - geolocation record ID
)
RETURNS NVARCHAR(200)
AS
BEGIN
	DECLARE @Latitude	FLOAT
	DECLARE @Longitude	FLOAT
	SELECT	
			@Latitude =  tlbGeoLocation.dblLatitude,
			@Longitude =  tlbGeoLocation.dblLongitude
	FROM	tlbGeoLocation 
	WHERE	tlbGeoLocation.idfGeoLocation = @GeoLocation

	RETURN dbo.fnCreateGeolocationCoordinatesString(@Longitude,@Latitude)
END

