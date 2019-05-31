
--##SUMMARY Returns the full list with all possible site relations

--##REMARKS Author: unknown
--##REMARKS Update date: 08.01.2012

--##RETURNS Table with list of site relation. 
--##RETURNS Relation type: 10084002 - parent,  10084001 - reported
--##RETURNS Relation site to itself added with type "reported"

/*
--Example of a call of function:
select * from [fnFiltered_FullSiteList] ()

*/

CREATE FUNCTION [dbo].[fnFiltered_FullSiteList]()
RETURNS TABLE 
AS 
RETURN 
/*SELECT DISTINCT
	parent.[strSiteID]	AS parentSiteID
	, parent.[idfsSite]	AS parentSite
	, related.strSiteID	AS relatedSiteID
	, related.idfsSite	AS relatedSite
	, 10084002			AS [idfsSiteRelationType]
FROM [tstSite] AS related
JOIN [tstSite] AS parent ON
	parent.idfsSite = related.idfsParentSite
	AND parent.intRowStatus = 0
WHERE related.[intRowStatus] = 0
UNION
SELECT DISTINCT 
	parent.[strSiteID] parentSiteID, 
	parent.[idfsSite] parentSite, 
	related.[strSiteID] relatedSiteID, 
	related.[idfsSite] relatedSite,
	10084001 [idfsSiteRelationType]
FROM [tstSiteRelation] AS a
INNER JOIN [tstSite] AS parent
ON a.[idfsSenderSite] = parent.[idfsSite] AND parent.[intRowStatus] = 0
INNER JOIN [tstSite] AS related
ON a.[idfsReceiverSite] = related.[idfsSite] AND related.[intRowStatus] = 0
--WHERE a.[intRowStatus] = 0
UNION 
SELECT [strSiteID],[idfsSite],[strSiteID],[idfsSite],10084001
FROM [tstSite]
WHERE [intRowStatus] = 0*/

select 1 a
