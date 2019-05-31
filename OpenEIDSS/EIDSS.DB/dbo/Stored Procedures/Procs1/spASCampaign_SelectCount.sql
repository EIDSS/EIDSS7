
--##SUMMARY Selects count of Active Surveillance Campaigns

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spASCampaign_SelectCount 
	
*/


create procedure	[dbo].[spASCampaign_SelectCount]
as

select	COUNT(*) 
FROM	dbo.tlbCampaign
WHERE	intRowStatus = 0

