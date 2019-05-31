
--##SUMMARY Selects count of Patients
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spPatient_SelectCount 
	
*/

create procedure	[dbo].[spPatient_SelectCount]
as

select		COUNT(*) 
from		dbo.tlbHumanActual
WHERE		intRowStatus = 0
