

--##SUMMARY This procedure returns geo information related with current site.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 02.02.2011

--##RETURNS Don't use  

/*
--Example of a call of procedure:

exec spRepHumFormN1Location 'ru'


*/ 
 
CREATE PROCEDURE [dbo].[spRepHumFormN1Location]
	@LangID varchar(36)
AS
BEGIN


 	select		tLoc.idfsCountry,
				tLoc.idfsRegion, 
				tLoc.idfsRayon, 
				tLoc.idfsSettlement, 
				rfCountry.[name]	as strCountry,
				rfRegion.[name]		as strRegion,
				rfRayon.[name]		as strRayon,
				rfSettlement.[name]	as strSettlement
	from 		tstSite					as tSite
	 left join	dbo.fnInstitution(@LangID) as	fnInst
			on	tSite.idfOffice = fnInst.idfOffice
	 left join	dbo.tlbGeoLocationShared			as tLoc
			on	fnInst.idfLocation = tLoc.idfGeoLocationShared
 	 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/)as  rfCountry 
			on	rfCountry.idfsReference = tLoc.idfsCountry
	 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/) as  rfRegion 
			on	rfRegion.idfsReference = tLoc.idfsRegion
	 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)  as rfRayon 
			on	rfRayon.idfsReference = tLoc.idfsRayon
	 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) as rfSettlement
			on	rfSettlement.idfsReference = tLoc.idfsSettlement
	where	tSite.idfsSite = dbo.fnSiteID()
END

