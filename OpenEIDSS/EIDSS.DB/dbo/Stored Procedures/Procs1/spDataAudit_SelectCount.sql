
--##SUMMARY Selects count of Data Audit Events

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spDataAudit_SelectCount 
	
*/

create procedure	[dbo].[spDataAudit_SelectCount]
as

select		COUNT(*) 
FROM		tauDataAuditEvent

