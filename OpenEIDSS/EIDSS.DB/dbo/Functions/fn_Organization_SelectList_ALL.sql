


--==========================================================================================
--Note: 7/19/2017 JL: add this new function for showing all possible office no matter delete
--                    or not for version 7
/*
--Example of a call of procedure:

SELECT * FROM fn_Organization_SelectList_ALL('en')
select * from fn_Organization_SelectList('en')
*/
--==========================================================================================

CREATE    FUNCTION [dbo].[fn_Organization_SelectList_ALL](
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
RETURNS TABLE 
AS
RETURN
SELECT	
			Organization.idfOffice AS idfInstitution,
			Organization.FullName,
			Organization.name,
			ISNULL([Address].name, [Address].strDefault) AS [Address],
			CAST (Organization.intHACode AS BIGINT) AS intHACode,
			Organization.strOrganizationID,
			Organization.intOrder
FROM		dbo.fnInstitution(@LangID) Organization
	
LEFT JOIN dbo.fnGeoLocationSharedTranslation(@LangID) [Address] ON
	[Address].idfGeoLocationShared = Organization.idfLocation
------WHERE Organization.intRowStatus = 0

