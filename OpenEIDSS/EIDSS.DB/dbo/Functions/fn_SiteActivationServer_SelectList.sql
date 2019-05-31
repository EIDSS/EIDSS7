





--##SUMMARY Returns the list of availbale EIDSS sites.
--##SUMMARY Used by SiteActivationServerList form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.02.2010

--##RETURNS Doesn't use


/*
--Example of procedure call:
SELECT * FROM fn_SiteActivationServer_SelectList ('en')

*/



CREATE          function dbo.fn_SiteActivationServer_SelectList(
			@LangID as nvarchar(50)--##PARAM @LangID  - language ID
)
returns table 
as
return
select			tstSite.idfsSite, 
				tstSite.strSiteName,
				tstSite.idfsSiteType, 
				SiteType.[name] as strSiteType,
				tcpac.idfsCountry, 
				Country.[name] as Country,
				fnInstitution.[name], 
				tstSite.strServerName,
				tstSite.strHASCsiteID,
				tstSite.strSiteID
from			tstSite
join tstCustomizationPackage tcpac on
	tcpac.idfCustomizationPackage = tstSite.idfCustomizationPackage
inner join		fnGisReference(@LangID, 19000001/*'rftCountry'*/)  Country
on				Country.idfsReference = tcpac.idfsCountry
inner join	fnReferenceRepair(@LangID, 19000085/*'rftSiteType'*/) as SiteType
on				SiteType.idfsReference = tstSite.idfsSiteType
left outer join	fnInstitution(@LangID)
on				fnInstitution.idfOffice = tstSite.idfOffice

where			(	dbo.fnSiteType() = 10085003 /*GDR*/
					or tcpac.idfsCountry = (
							select	idfsCountry 
							from	tstSite 
							where	idfsSite = dbo.fnSiteID()))
				and tstSite.intRowStatus = 0 







