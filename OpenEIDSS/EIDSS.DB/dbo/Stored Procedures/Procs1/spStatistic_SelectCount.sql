
--##SUMMARY Selects count of Active Surveillance Sessions

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spStatistic_SelectCount 
	
*/


create procedure	[dbo].[spStatistic_SelectCount]
as

select	COUNT(*) 
FROM	dbo.tlbStatistic
WHERE	intRowStatus = 0

