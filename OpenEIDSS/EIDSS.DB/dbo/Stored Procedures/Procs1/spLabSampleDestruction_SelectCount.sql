
--##SUMMARY Selects count of EIDSS Sites
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE [spLabSampleDestruction_SelectCount] 
	
*/

create procedure	[dbo].[spLabSampleDestruction_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

	select		COUNT(*) 
	from		tlbMaterial
	where		tlbMaterial.idfsSampleStatus in (10015003,10015002) and--cotDestroy,cotDelete
				tlbMaterial.idfsSite=@SiteID
