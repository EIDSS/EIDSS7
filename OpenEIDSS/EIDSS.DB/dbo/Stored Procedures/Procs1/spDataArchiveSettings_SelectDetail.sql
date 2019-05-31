

/*
exec spDataArchiveSettings_SelectDetail 
*/

CREATE PROCEDURE [dbo].[spDataArchiveSettings_SelectDetail]
	
AS
BEGIN
SELECT 
	ISNULL(idfsSite, 0) as idfsSite
	,ISNULL(min(CASE WHEN strName = N'Schedule' THEN strValue END), N'msgDataArchivingNotApplicable') As strSchedule
	,min(CASE WHEN strName = N'DataRelevanceInterval' THEN strValue END) As strDataRelevanceInterval

FROM dbo.tstGlobalSiteOptions
WHERE 
	strName in (N'DataRelevanceInterval',N'Schedule')
	AND intRowStatus = 0
GROUP BY ISNULL(idfsSite, 0)
UNION

SELECT
	0 as idfsSite
	, N'msgDataArchivingNotApplicable'  As strSchedule
	,CAST(NULL as nvarchar) As strDataRelevanceInterval
WHERE	
	NOT EXISTS (SELECT *
				FROM dbo.tstGlobalSiteOptions
				WHERE 
					strName in (N'DataRelevanceInterval',N'Schedule')
					AND intRowStatus = 0
				)
END

