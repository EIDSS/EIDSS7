﻿
--##SUMMARY Selects all geolocation recodrs converting geolocation fields into the text fields in the passed language.
--##SUMMARY Can be used in list forms for displaying geolocation information in one text field.
--##SUMMARY Standard scenario of this function using is joining with main list object on idfGeoLocation field
--##SUMMARY and futher output of returned geolocation string parts using fnCreateGeoLocationString function

--##SUMMARY All text parameters should be in the language defined by @LangID.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.12.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

select * from fnGeoLocationAsRow ('en')

*/
CREATE        function fnGeoLocationAsRow(
@LangID nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
as
return(

select		tlbGeoLocation.idfGeoLocation,
			tlbGeoLocation.idfsGeoLocationType,

			IsNull(Country.[name], '') as Country,
			IsNull(Region.[name], '') as Region,
			IsNull(Rayon.[name], '') as Rayon,
			IsNull(SettlementType.[name], '') as SettlementType,
			IsNull(Settlement.[name], '') as Settlement,
			IsNull(tlbGeoLocation.dblLatitude, '') as Latitude,
			IsNull(tlbGeoLocation.dblLongitude, '') as Longitude,
			IsNull(tlbGeoLocation.strDescription, '') as Description,
			IsNull(tlbGeoLocation.strPostCode, '') as PostalCode,
			IsNull(tlbGeoLocation.strStreetName, '') as Street,
			IsNull(tlbGeoLocation.strHouse, '') as House,
			IsNull(tlbGeoLocation.strBuilding, '') as Building,
			IsNull(tlbGeoLocation.strApartment, '') as Appartment,
			IsNull(tlbGeoLocation.dblAlignment, '') as Alignment,
			IsNull(tlbGeoLocation.dblDistance, '') as Distance,
			IsNull(GroundType.[name], '') as GroundType,
			IsNull(blnForeignAddress, 0) as blnForeignAddress,
			IsNull(tlbGeoLocation.strForeignAddress, '') as strForeignAddress


from		(
		tlbGeoLocation 

		left join	fnGisReference(@LangID,19000001 ) Country --'rftCountry'
		on			Country.idfsReference = tlbGeoLocation.idfsCountry
		left join	fnGisReference(@LangID, 19000003) Region --'rftRegion'
		on			Region.idfsReference = tlbGeoLocation.idfsRegion
		left join	fnGisReference(@LangID, 19000002) Rayon --'rftRayon'
		on			Rayon.idfsReference = tlbGeoLocation.idfsRayon
		left join	fnGisReference(@LangID, 19000004) Settlement --'rftSettlement'
		on			Settlement.idfsReference = tlbGeoLocation.idfsSettlement
		left join	fnReference(@LangID, 19000038) GroundType --'rftGroundType'
		on			GroundType.idfsReference = tlbGeoLocation.idfsGroundType
	)
	left join	(
		gisSettlement 
		inner join fnGisReference(@LangID, 19000005) SettlementType --'rftSettlementType'
		on			SettlementType.idfsReference = gisSettlement.idfsSettlementType
	)on			gisSettlement.idfsSettlement = tlbGeoLocation.idfsSettlement


where		tlbGeoLocation.intRowStatus = 0

)



