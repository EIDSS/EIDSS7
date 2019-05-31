--=====================================================================================================
-- Created by:				Joan Li
-- Description:				06/21/2017: check usp_HumanCaseDeduplication_GetDetail call this  V7 USP77: 
--                          Selects data from these tables: tlbGeoLocation(triggers);gisSettlement(triggers);
--                          from function: fnGisReference;fnReference
/*
----testing code:
select * from fnAddressAsRow('en')
*/
--=====================================================================================================
CREATE        function [dbo].[fnAddressAsRow](@LangID nvarchar(50))
returns table
as
return(

select		tlbGeoLocation.idfGeoLocation,
			IsNull(Country.[name], '') as Country,
			IsNull(Region.[name], '') as Region,
			IsNull(Rayon.[name], '') as Rayon,
			IsNull(tlbGeoLocation.strPostCode, '') as PostalCode,
			IsNull(SettlementType.[name], '') as SettlementType,
			IsNull(Settlement.[name], '') as Settlement,
			IsNull(tlbGeoLocation.strStreetName, '') as Street,
			IsNull(tlbGeoLocation.strHouse, '') as House,
			IsNull(tlbGeoLocation.strBuilding, '') as Building,
			IsNull(tlbGeoLocation.strApartment, '') as Appartment,
			blnForeignAddress,
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




