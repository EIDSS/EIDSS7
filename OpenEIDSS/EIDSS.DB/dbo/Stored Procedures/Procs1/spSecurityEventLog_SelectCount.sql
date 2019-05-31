
--##SUMMARY Selects count of Security Event Log Event
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE [spSecurityEventLog_SelectCount] 
	
*/

create procedure	[dbo].[spSecurityEventLog_SelectCount]
as

select		COUNT(*) 
From		[dbo].[tstSecurityAudit] 

