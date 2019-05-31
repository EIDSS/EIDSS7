
--##SUMMARY Selects count of LabBatchs

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spLabBatch_SelectCount 
	
*/

create procedure	[dbo].[spLabBatch_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

select		COUNT(*) 
from		tlbBatchTest batch
where		batch.intRowStatus=0 
and			batch.idfsSite=@SiteID

