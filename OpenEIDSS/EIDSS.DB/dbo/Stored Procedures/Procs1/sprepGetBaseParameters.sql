

--##SUMMARY This procedure returns language, country and organization information related with current site.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 30.11.2009

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec dbo.sprepGetBaseParameters @LangID='ka'   ,@OrganizationId=709150000000

*/ 
 
create PROCEDURE [dbo].[sprepGetBaseParameters]
	@LangID varchar(36),
	@OrganizationId bigint = null,
	@SiteID as bigint = null
AS
BEGIN
	declare @Language nvarchar(200)
	select		@Language = rf.[name] 
	from		dbo.fnReferenceRepair(@LangID, 19000049) rf
	where		rf.idfsReference = dbo.fnGetLanguageCode(@LangID)

	select		@Language				as [strLanguageName], 
				rfCountry.[name]		as [strCountryName], 
				fnInstitution.FullName	as [strOrganizationName],
				'dd/MM/yyyy'			as [strDateFormat], -- no need to localize on the server side
				'HH:mm'					as [strTimeFormat],-- no need to localize on the server side
				rfCountry.idfsReference	as [idfsCountry]
				
				
	FROM		dbo.fnGisReference(@LangID,19000001)  as rfCountry--'rftCountry'  
	inner join	gisCountry  
	on			rfCountry.idfsReference = gisCountry.idfsCountry  
	join tstCustomizationPackage tcpac on
		tcpac.idfsCountry = gisCountry.idfsCountry
	inner join	tstSite   
	on			tstSite.idfCustomizationPackage =   tcpac.idfCustomizationPackage
	inner join	dbo.fnReference(@LangID, 19000085) --rftSiteType  
	on			tstSite.idfsSiteType = fnReference.idfsReference  
	inner join	dbo.fnInstitution(@LangID)   
	on			@OrganizationId is null and tstSite.idfOffice = fnInstitution.idfOffice 
	or 			fnInstitution.idfOffice = @OrganizationId 
	where		tstSite.idfsSite =  ISNULL(@SiteID, dbo.fnSiteID())

END

