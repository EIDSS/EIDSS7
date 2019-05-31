
--##SUMMARY Selects count of Event Log Events

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spEvent_SelectCount 
	
*/


create procedure	[dbo].[spEvent_SelectCount]
as

select		COUNT(*) 
from		tstEvent 
WHERE		tstEvent.idfsEventTypeID <> 10025001 --'evtLanguageChanged'

