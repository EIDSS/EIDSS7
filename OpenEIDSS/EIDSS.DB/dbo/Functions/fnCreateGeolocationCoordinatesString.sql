
--##SUMMARY Creates and returns text representation of geolocation coordinates in format  (<Longitude>, <Latitude>).

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 10.02.2016

/*
select dbo.fnCreateGeolocationCoordinatesString(41.55, 20.123454)
select dbo.fnCreateGeolocationCoordinatesString(NULL, 20.123454)
select dbo.fnCreateGeolocationCoordinatesString(NULL, NULL)

*/

CREATE FUNCTION [dbo].[fnCreateGeolocationCoordinatesString]
(
	@Longitude			float, --##PARAM @Longitude  - Longitude
	@Latitude			float --##PARAM @Latitude  - Latitude
)
RETURNS NVARCHAR(200)
AS
BEGIN
	return	N'(' + 
			REPLACE(CAST(ISNULL(@Longitude ,N'') AS DECIMAL(8, 5)), '0.00000', N'0')+ 
			N', '+
			REPLACE(CAST(ISNULL(@Latitude ,N'') AS DECIMAL(8, 5)), '0.00000', N'0')+
			N')'
END

