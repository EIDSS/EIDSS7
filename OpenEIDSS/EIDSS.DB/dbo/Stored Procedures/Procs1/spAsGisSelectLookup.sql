

--##SUMMARY select layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsGisSelectLookup 'en'

*/ 
 
CREATE PROCEDURE [dbo].[spAsGisSelectLookup]
	@LangID	as nvarchar(50)
AS
BEGIN
	select		fnCountry.idfsReference,
				fnCountry.idfsGISReferenceType,
				fnCountry.ExtendedName,
				null as dblLatitude,
				null as dblLongitude,
				fnCountry.idfsReference as idfsCountry				
	from		fnGisExtendedReference(@LangID,19000001) as fnCountry
union			
	select		fnRegion.idfsReference,
				fnRegion.idfsGISReferenceType,
				fnRegion.ExtendedName,
				null as dblLatitude,
				null as dblLongitude,
				gisCountry.idfsCountry				
	from		fnGisExtendedReference(@LangID,19000003) as fnRegion
	inner join	gisRegion 
	on			gisRegion.idfsRegion = fnRegion.idfsReference 
				AND gisRegion.intRowStatus = 0
	inner join 	gisCountry
	on			gisRegion.idfsCountry = gisCountry.idfsCountry
				AND gisCountry.intRowStatus = 0
	join tstCustomizationPackage tcpac on
		tcpac.idfsCountry = gisRegion.idfsCountry
	inner join	tstSite
	on			tstSite.idfCustomizationPackage = tcpac.idfCustomizationPackage
	and			tstSite.idfsSite=dbo.fnSiteID()
union		
	select		fnRayon.idfsReference,
				fnRayon.idfsGISReferenceType,
				fnRayon.ExtendedName	,
				null as dblLatitude,
				null as dblLongitude,
				gisCountry.idfsCountry				
	from		fnGisExtendedReference(@LangID,19000002) as fnRayon
	inner join	gisRayon 
	on			gisRayon.idfsRayon = fnRayon.idfsReference 
				AND gisRayon.intRowStatus = 0
	inner join 	gisCountry
	on			gisRayon.idfsCountry = gisCountry.idfsCountry
				AND gisCountry.intRowStatus = 0
	join tstCustomizationPackage tcpac on
		tcpac.idfsCountry = gisRayon.idfsCountry
	inner join	tstSite
	on			tstSite.idfCustomizationPackage = tcpac.idfCustomizationPackage
	and			tstSite.idfsSite=dbo.fnSiteID()
union	
	select		fnSettlement.idfsReference,
				fnSettlement.idfsGISReferenceType,
				fnSettlement.ExtendedName,
				gisSettlement.dblLatitude,
				gisSettlement.dblLongitude,
				gisCountry.idfsCountry				
	from		fnGisExtendedReference(@LangID,19000004) as fnSettlement
	inner join	gisSettlement 
	on			gisSettlement.idfsSettlement = fnSettlement.idfsReference 
				AND gisSettlement.intRowStatus = 0
	inner join 	gisCountry
	on			gisSettlement.idfsCountry = gisCountry.idfsCountry
				AND gisCountry.intRowStatus = 0
	join tstCustomizationPackage tcpac on
		tcpac.idfsCountry = gisSettlement.idfsCountry
	inner join	tstSite
	on			tstSite.idfCustomizationPackage = tcpac.idfCustomizationPackage 
	and			tstSite.idfsSite=dbo.fnSiteID()
END

