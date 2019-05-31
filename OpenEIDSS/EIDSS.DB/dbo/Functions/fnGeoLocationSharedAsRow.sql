
--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 04.02.2012


/*
--Example of a call of procedure:

select * from fnGeoLocationSharedAsRow ('en')

*/
CREATE        function [dbo].[fnGeoLocationSharedAsRow](
@LangID nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
as
return(

select		tlbGeoLocationShared.idfGeoLocationShared,
			tlbGeoLocationShared.idfsGeoLocationType,

			IsNull(Country.[name], '') as Country,
			IsNull(Region.[name], '') as Region,
			IsNull(Rayon.[name], '') as Rayon,
			IsNull(SettlementType.[name], '') as SettlementType,
			IsNull(Settlement.[name], '') as Settlement,
			IsNull(tlbGeoLocationShared.dblLatitude, '') as Latitude,
			IsNull(tlbGeoLocationShared.dblLongitude, '') as Longitude,
			IsNull(tlbGeoLocationShared.strDescription, '') as Description,
			IsNull(tlbGeoLocationShared.strPostCode, '') as PostalCode,
			IsNull(tlbGeoLocationShared.strStreetName, '') as Street,
			IsNull(tlbGeoLocationShared.strHouse, '') as House,
			IsNull(tlbGeoLocationShared.strBuilding, '') as Building,
			IsNull(tlbGeoLocationShared.strApartment, '') as Appartment,
			IsNull(tlbGeoLocationShared.dblAlignment, '') as Alignment,
			IsNull(tlbGeoLocationShared.dblDistance, '') as Distance,
			IsNull(GroundType.[name], '') as GroundType


from		(
		tlbGeoLocationShared 

		left join	fnGisReference(@LangID,19000001 ) Country --'rftCountry'
		on			Country.idfsReference = tlbGeoLocationShared.idfsCountry
		left join	fnGisReference(@LangID, 19000003) Region --'rftRegion'
		on			Region.idfsReference = tlbGeoLocationShared.idfsRegion
		left join	fnGisReference(@LangID, 19000002) Rayon --'rftRayon'
		on			Rayon.idfsReference = tlbGeoLocationShared.idfsRayon
		left join	fnGisReference(@LangID, 19000004) Settlement --'rftSettlement'
		on			Settlement.idfsReference = tlbGeoLocationShared.idfsSettlement
		left join	fnReference(@LangID, 19000038) GroundType --'rftGroundType'
		on			GroundType.idfsReference = tlbGeoLocationShared.idfsGroundType
	)
	left join	(
		gisSettlement 
		inner join fnGisReference(@LangID, 19000005) SettlementType --'rftSettlementType'
		on			SettlementType.idfsReference = gisSettlement.idfsSettlementType
	)on			gisSettlement.idfsSettlement = tlbGeoLocationShared.idfsSettlement


where		tlbGeoLocationShared.intRowStatus = 0

)
