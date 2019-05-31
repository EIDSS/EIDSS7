


--##SUMMARY Creates text representation of geolocation depending on geolocation Type.
--##SUMMARY Geolocation template is defined by @LangID parameter.
--##SUMMARY Can be used in detail forms where there is no need to display multipe rows with geolocation string.
--##SUMMARY All text parameters should be in the language defined by @LangID.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

SELECT dbo.fnCreateGeoLocationString (
 10036003 --'lctExactPoint'
  ,'Georgia' --@Country
  ,'Gali' --@Region
  ,'gg' --@Rayon
  ,'20' --@Latitude
  ,'30' --@Longitude
  ,N'' --@PostalCode
  ,N'' --@SettlementType
  ,N'sett' --@Settlement
  ,N'' --@Street
  ,N'' --@House
  ,N'' --@Building-
  ,N'' --@Appartment
  ,N'' --@Alignment
  ,N'' --@Distance
  ,0 --@blnForeignAddress
  ,N'' --@AddressString
  ,N'' --@From
  ,N'' --@Azimuth
  ,N'' --@At_distance_of
  ,N'' --@Km
)

*/


create        function fnCreateGeoLocationString(
						@LangID				nvarchar(50), --##PARAM @LangID  - language ID
						@GeoLocationType	bigint, --##PARAM @GeoLocationType  - Geolocation Type
						@Country			nvarchar(200), --##PARAM @Country  - Country name
						@Region				nvarchar(200), --##PARAM @Region  - Region name
						@Rayon				nvarchar(200), --##PARAM @Rayon  - Rayon name
						@Latitude			nvarchar(200), --##PARAM @Latitude  - Latitude
						@Longitude			nvarchar(200), --##PARAM @Longitude  - Longitude
						@PostalCode			nvarchar(200), --##PARAM @PostalCode  - Postal Code for address
						@SettlementType		nvarchar(200), --##PARAM @SettlementType  - Settlement Type for address
						@Settlement			nvarchar(200), --##PARAM @Settlement - Settlement name
						@Street				nvarchar(200), --##PARAM @Street  - Street name
						@House				nvarchar(200), --##PARAM @House  - Number of house
						@Building			nvarchar(200), --##PARAM @Building  - Number of building
						@Apartment			nvarchar(200), --##PARAM @Appartment  - Number of appartment
						@Alignment			nvarchar(200), --##PARAM @Alignment  - Azimuth of direction from nearest settlement for relative geolocation
						@Distance			nvarchar(200), --##PARAM @Distance  - Distance from nearest settlement for relative geolocation
						@blnForeignAddress	bit,
						@strForeignAddress	nvarchar(200)
						)
returns nvarchar(1000)
as
begin

declare @TempStr nvarchar(1000)
select	@TempStr =
		case @GeoLocationType
			when 10036003 --'lctExactPoint'
				then dbo.fnCreateExactPointString	(
							@Country,
							@Region,
							@Rayon,
							@SettlementType,
							@Settlement,
							@Latitude,
							@Longitude
													)
			when 10036004--'lctRelativePoint'
				then dbo.fnCreateRelativePointString	(
							@LangID,
							@Country,
							@Region,
							@Rayon,
							@SettlementType,
							@Settlement,
							@Alignment,
							@Distance
														)
			when 10036001 --'lctAddress'
				then 
				dbo.fnCreateAddressString	(
							@Country,
							@Region,
							@Rayon,
							@PostalCode,
							@SettlementType,
							@Settlement,
							@Street,
							@House,
							@Building,
							@Apartment,
							@blnForeignAddress,
							@strForeignAddress
											)
			else null
		end

return @TempStr
end



