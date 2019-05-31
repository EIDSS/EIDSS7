


--##SUMMARY Selects list of organizations for OrganizationList form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

SELECT * FROM fn_Organization_SelectList('en')
*/






CREATE    Function fn_Organization_SelectList(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return
select	
			Organization.idfOffice as idfInstitution,
			Organization.FullName,
			Organization.name,
			ISNULL([Address].name, [Address].strDefault) AS [Address],
			CAST (Organization.intHACode as bigint) as intHACode,
			Organization.strOrganizationID,
			Organization.intOrder
from		dbo.fnInstitution(@LangID) Organization
	
LEFT JOIN dbo.fnGeoLocationSharedTranslation(@LangID) [Address] ON
	[Address].idfGeoLocationShared = Organization.idfLocation
where Organization.intRowStatus = 0













