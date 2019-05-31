
--##SUMMARY Selects count of Repository Scheme Items
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE [spRepositoryScheme_SelectCount] 
	
*/

create procedure	[dbo].[spRepositoryScheme_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

select		COUNT(*) 
from		dbo.tlbFreezer
where		intRowStatus = 0 and
			idfsSite=@SiteID
