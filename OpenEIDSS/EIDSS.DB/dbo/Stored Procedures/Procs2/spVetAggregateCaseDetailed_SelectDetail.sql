



--##SUMMARY Selects data for VetAggregateCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 01.12.2009

--##REMARKS Update date: 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spVetAggregateCaseDetailed_SelectDetail 
	@idfAggrCase

*/



create PROC	spVetAggregateCaseDetailed_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as

--Default matrix version
SELECT idfVersion 
FROM	tlbAggrMatrixVersionHeader
WHERE 
		idfsMatrixType = 71090000000 --VetCase section
		and intRowStatus = 0
		and blnIsActive = 1
ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC


