
--*************************************************************
-- Name 				: fnGeoLocationShortAddressString
-- Description			: Returns representation of short address string of geolocation record.
--						: Exec USP_GBL_LKUP_BaseRef_GetList 'EN','Geo Location Type': get hard coded info
-- Author               : Joan Li
-- Revision History
--		Name			Date			Change Detail
--		Joan Li			10/24/2017		convert from v6: fnGeoLocationShortAddressString
--
-- Testing code:
-- DECLARE @GeoLocation BIGINT
-- SELECT dbo.fnGeoLocationShortAddressString ( 'en',52603000000000 ,NULL)
--*************************************************************


CREATE        FUNCTION [dbo].[fnGeoLocationShortAddressString] 
(
	@LangID				NVARCHAR(50),	--##PARAM @LangID - lanquage ID
	@GeoLocation		BIGINT,			--##PARAM @GeoLocation - geolocation record ID
	@GeoLocationType	BIGINT = NULL	--##PARAM @GeoLocationType - desired Type of geolocation string. If NULL, the idfsGeoLocationType value of geolocation record is used 
)  
RETURNS NVARCHAR(1000)
AS 
BEGIN
DECLARE 
 @PostalCode			NVARCHAR(200)
,@Street				NVARCHAR(200)
,@House					NVARCHAR(200)
,@Building				NVARCHAR(200)
,@Appartment			NVARCHAR(200)
,@blnForeignAddress		BIT
,@l_GeoLocationType		NVARCHAR(200)


-----JL: replace the hard coded 10036001: which is the idfsBaseReference from trtBaseReference table
SELECT @l_GeoLocationType=(	SELECT tb.idfsBaseReference  FROM dbo.trtBaseReference tb inner JOIN dbo.trtReferenceType tt
							ON tb.idfsReferenceType=tt.idfsReferenceType
							AND tt.strReferenceTypeName IN ('Geo Location Type')
							AND tb.strDefault IN ('Foreign Address'))

SELECT	@GeoLocationType = ISNULL(@GeoLocationType, tlbGeoLocation.idfsGeoLocationType),
		@PostalCode =  ISNULL(tlbGeoLocation.strPostCode,N''),
		@Street =  ISNULL(tlbGeoLocation.strStreetName,N''),
		@House =  ISNULL(tlbGeoLocation.strHouse,N''),
		@Building =  ISNULL(tlbGeoLocation.strBuilding,N''),
		@Appartment =  ISNULL(tlbGeoLocation.strApartment,N''),
		@blnForeignAddress = ISNULL(tlbGeoLocation.blnForeignAddress, 0)
FROM	tlbGeoLocation
WHERE	tlbGeoLocation.idfGeoLocation = @GeoLocation

----IF	ISNULL(@GeoLocationType, 0) <> 10036001
	IF	ISNULL(@GeoLocationType, 0) <> @l_GeoLocationType
	SET	@blnForeignAddress = 1

RETURN dbo.fnCreateShortAddressString (
  @PostalCode
  ,@Street
  ,@House
  ,@Building
  ,@Appartment
  ,@blnForeignAddress
)
END

















