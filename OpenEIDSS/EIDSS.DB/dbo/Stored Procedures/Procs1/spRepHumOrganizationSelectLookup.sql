


--##SUMMARY Selects lookup list of organizations for AZ Hum reports.

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Doesn't use


/*
--Example of procedure call:
exec spRepHumOrganizationSelectLookup 'en', NULL
exec spRepHumOrganizationSelectLookup 'en', 867

*/

create      PROCEDURE dbo.spRepHumOrganizationSelectLookup
	@LangID As nvarchar(50), --##PARAM @LangID - language ID
	@ID as bigint = NULL --##PARAM @ID - organization ID, if not null only record with this organization is selected

as
	declare @CountryID bigint
	
	select		@CountryID = tcp1.idfsCountry
 	FROM tstCustomizationPackage tcp1
	JOIN tstSite s ON
		s.idfCustomizationPackage = tcp1.idfCustomizationPackage
 	inner join	tstLocalSiteOptions lso
 	on			lso.strName = N'SiteID'
 				and lso.strValue = cast(s.idfsSite as nvarchar(20))
 				
 				
	select
		ts.idfsSite AS idfInstitution
		,[name]
		, fir.intRowStatus
  
	from tstSite ts
	join tstCustomizationPackage tcpac on
		tcpac.idfCustomizationPackage = ts.idfCustomizationPackage
	join dbo.fnInstitutionRepair(@LangID) fir	
		on fir.idfOffice = ts.idfOffice
		and tcpac.idfsCountry = @CountryID
		and ts.intFlags = 1
	join trtBaseReference tbr1
	on tbr1.idfsBaseReference = fir.idfsOfficeAbbreviation  
	where ts.idfsSite = ISNULL(@ID, ts.idfsSite)
	order by fir.name


--STUB result
--seloect
--	Organization.idfOffice AS idfInstitution
--	, [name]
--	,  Organization.intRowStatus
--FROM dbo.fnInstitutionRepair(@LangID) Organization
--JOIN trtBaseReference tbr ON
--	tbr.idfsBaseReference = Organization.idfsOfficeName
--WHERE Organization.idfOffice = ISNULL(@ID, Organization.idfOffice)
--ORDER BY Organization.name
