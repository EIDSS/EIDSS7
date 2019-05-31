
--##SUMMARY Selects count of Outbreaks

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spOutbreak_SelectCount 
	
*/


create procedure	[dbo].[spOutbreak_SelectCount]
as

select	COUNT(*) 
FROM	dbo.tlbOutbreak
WHERE	intRowStatus = 0

