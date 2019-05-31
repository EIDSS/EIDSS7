
--*************************************************************
-- Name 				: FN_GBL_LKUP_GeoLoc_GetList
-- Description			: Selects all geolocation recodrs converting geolocation fields into the text fields in the passed language.
--						: Can be used in list forms for displaying geolocation information in one text field.
--						: Standard scenario of this function using is joining with main list object on idfGeoLocation field
--						: and futher output of returned geolocation string parts using fnCreateGeoLocationString function
--						: All text parameters should be in the language defined by @LangID.
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- SELECT * FROM FN_GBL_LKUP_GeoLoc_GetList('en')
--*************************************************************

CREATE FUNCTION [dbo].[FN_GBL_LKUP_GeoLoc_GetList](
	@LangID NVARCHAR(50) --##PARAM @LangID  - language ID
)
RETURNS TABLE
AS
RETURN
	(
	SELECT
		tlbGeoLocation.idfGeoLocation
		,tlbGeoLocation.idfsGeoLocationType
		,ISNULL(Country.[name], '') AS Country
		,ISNULL(Region.[name], '') AS Region
		,ISNULL(Rayon.[name], '') AS Rayon
		,ISNULL(SettlementType.[name], '') AS SettlementType
		,ISNULL(Settlement.[name], '') AS Settlement
		,ISNULL(tlbGeoLocation.dblLatitude, '') AS Latitude
		,ISNULL(tlbGeoLocation.dblLongitude, '') AS Longitude
		,ISNULL(tlbGeoLocation.strDescription, '') AS [Description]
		,ISNULL(tlbGeoLocation.strPostCode, '') AS PostalCode
		,ISNULL(tlbGeoLocation.strStreetName, '') AS Street
		,ISNULL(tlbGeoLocation.strHouse, '') AS House
		,ISNULL(tlbGeoLocation.strBuilding, '') AS Building
		,ISNULL(tlbGeoLocation.strApartment, '') AS Appartment
		,ISNULL(tlbGeoLocation.dblAlignment, '') AS Alignment
		,ISNULL(tlbGeoLocation.dblDistance, '') AS Distance
		,ISNULL(GroundType.[name], '') AS GroundType
		,ISNULL(blnForeignAddress, 0) AS blnForeignAddress
		,ISNULL(tlbGeoLocation.strForeignAddress, '') AS strForeignAddress
	FROM
		(
		tlbGeoLocation 
		LEFT JOIN fnGisReference(@LangID,19000001 ) AS Country ON
			Country.idfsReference = tlbGeoLocation.idfsCountry
		LEFT JOIN fnGisReference(@LangID, 19000003) AS Region ON
			Region.idfsReference = tlbGeoLocation.idfsRegion
		LEFT JOIN fnGisReference(@LangID, 19000002) AS Rayon ON
			Rayon.idfsReference = tlbGeoLocation.idfsRayon
		LEFT JOIN fnGisReference(@LangID, 19000004) AS Settlement ON
			Settlement.idfsReference = tlbGeoLocation.idfsSettlement
		LEFT JOIN fnReference(@LangID, 19000038) GroundType ON
			GroundType.idfsReference = tlbGeoLocation.idfsGroundType
		)
		LEFT JOIN
		(
		gisSettlement 
		INNER JOIN fnGisReference(@LangID, 19000005) AS SettlementType ON
			SettlementType.idfsReference = gisSettlement.idfsSettlementType
		) ON
			gisSettlement.idfsSettlement = tlbGeoLocation.idfsSettlement
	WHERE
		tlbGeoLocation.intRowStatus = 0
	)
