
--##SUMMARY Selects count of EIDSS Sites
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE [spLabSample_SelectCount] 
	
*/

create procedure	[dbo].[spLabSample_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

select		COUNT(*) 
from		tlbMaterial
where		tlbMaterial.intRowStatus = 0
		and tlbMaterial.blnReadOnly<>1
		and	tlbMaterial.idfsSite=@SiteID
