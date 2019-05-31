




--##SUMMARY Selects data for AggregateCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.12.2009

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spAggregateCaseDetailed_SelectDetail 
	@idfAggrCase

*/




create  proc	spAggregateCaseDetailed_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as

--1 Default matrix version
SELECT idfVersion 
FROM	tlbAggrMatrixVersionHeader
WHERE 
		idfsMatrixType = 71190000000 --HumanCase section
		and intRowStatus = 0
		and blnIsActive = 1
ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC



