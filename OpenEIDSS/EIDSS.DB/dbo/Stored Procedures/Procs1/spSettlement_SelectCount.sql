
create procedure	[dbo].[spSettlement_SelectCount]
as

select	COUNT(*) 
from	dbo.gisBaseReference
where	idfsGISReferenceType = 19000004
	AND intRowStatus = 0
