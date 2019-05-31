
--##SUMMARY Returns table of corresponditg between Sites and Rayons.

--##SUMMARY In the objective:
--##SUMMARY	"Vet Case data is always distributed across the sites of the same administrative Rayon. 
--##SUMMARY All organizations, where the value of the field Rayon equals 
--##SUMMARY to the Rayon of the Farm connected to the case, have to receive Vet Case data."
--##SUMMARY this function represents "sites of the administrative Rayon"

--##REMARKS Updated: Zhdanova A.
--##REMARKS Update date: 08.01.2012

--##RETURNS Table with list of sites of the administrative Rayon. 
--##RETURNS Use only last [idfsSite] for every existing [strSiteID] (for site reinstalletions)

/*
--Example of a call of function:
select * from [fnFiltered_RayonOrganizationList] ()
order by [strSiteID]

*/

CREATE FUNCTION [dbo].[fnFiltered_RayonOrganizationList]()
RETURNS TABLE 
AS 
RETURN 
SELECT a.[idfsSite], a.[strSiteID], c.[idfsRayon]
FROM (	SELECT [strSiteID], MAX([idfsSite]) AS [idfsSite] 
		FROM [tstSite] 
		GROUP BY [strSiteID]
	) AS a0
INNER JOIN [tstSite] AS a ON a0.[strSiteID] = a.[strSiteID]
INNER JOIN [tlbOffice] AS b ON a.[idfOffice] = b.[idfOffice]
INNER JOIN [tlbGeoLocationShared] AS c ON b.[idfLocation] = c.idfGeoLocationShared
WHERE a.[intRowStatus] = 0

