
--##SUMMARY Create address string with private data from geo information
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 20.08.2012

--##RETURNS String with address

/*
--Example of procedure call:
exec spGetPersonalDataAddress 100, 1, 'ru'
*/
CREATE PROCEDURE [dbo].[spGetPersonalDataAddress]
	@idfGeoLocation bigint, 
	@blnShowSettlement as bit,
	@LangID as nvarchar(10)
AS
	SELECT 
	CASE WHEN(@blnShowSettlement = 1) THEN 
		ISNULL(ref_Country.name,N'') + ISNULL(N', ' + ref_Region.name, N'') + ISNULL(N', ' + ref_Rayon.name, N'') + ISNULL(N', ' + ref_Settlement.name, N'') + (N', *') ELSE
		ISNULL(ref_Country.name,N'') + ISNULL(N', ' + ref_Region.name, N'') + ISNULL(N', ' + ref_Rayon.name, N'')  + (N', *')END
		AS strAddress
	
	from tlbGeoLocation
		left join fnGisReferenceRepair(@LangID, 19000001) as ref_Country
		on ref_Country.idfsReference = tlbGeoLocation.idfsCountry

		left join fnGisReferenceRepair(@LangID, 19000003) as ref_Region
		on ref_Region.idfsReference = tlbGeoLocation.idfsRegion
  
		left join fnGisReferenceRepair(@LangID, 19000002) as ref_Rayon
		on ref_Rayon.idfsReference = tlbGeoLocation.idfsRayon

		left join fnGisReferenceRepair(@LangID, 19000004) as ref_Settlement
		on ref_Settlement.idfsReference = tlbGeoLocation.idfsSettlement
where idfGeoLocation = @idfGeoLocation

RETURN 0
