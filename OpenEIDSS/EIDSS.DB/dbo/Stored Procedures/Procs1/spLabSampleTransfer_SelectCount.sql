
--##SUMMARY Selects count of EIDSS Sites
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE [spLabSampleTransfer_SelectCount] 
	
*/

Create procedure	[dbo].[spLabSampleTransfer_SelectCount]
as
	select		COUNT(*) 
	FROM		tlbTransferOUT
	WHERE 		tlbTransferOUT.intRowStatus=0
