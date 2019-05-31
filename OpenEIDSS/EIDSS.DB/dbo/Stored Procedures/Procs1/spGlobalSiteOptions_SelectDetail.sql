
CREATE     PROCEDURE [dbo].[spGlobalSiteOptions_SelectDetail] 
AS
SELECT 
	 strName
	,strValue 
FROM tstGlobalSiteOptions
WHERE intRowStatus = 0
