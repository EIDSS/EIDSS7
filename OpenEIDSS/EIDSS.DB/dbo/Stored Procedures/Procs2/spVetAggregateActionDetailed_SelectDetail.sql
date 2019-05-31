


--##SUMMARY Selects data for VetAggregateActionDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 06.12.2009

--##REMARKS Update date: 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spVetAggregateActionDetailed_SelectDetail 
	@idfAggrCase

*/




create  proc	spVetAggregateActionDetailed_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as

--2 Default Diagnostic matrix version
SELECT idfVersion 
FROM	tlbAggrMatrixVersionHeader
WHERE 
		idfsMatrixType = 71460000000 --diagnostic section
		and intRowStatus = 0
		and blnIsActive = 1
ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC



--3 Default Prophylactic matrix version
SELECT idfVersion 
FROM	tlbAggrMatrixVersionHeader
WHERE 
		idfsMatrixType = 71300000000 --prophilactic section
		and intRowStatus = 0
		and blnIsActive = 1
ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC


--4 Default Sanitary matrix version
SELECT idfVersion 
FROM	tlbAggrMatrixVersionHeader
WHERE 
		idfsMatrixType = 71260000000 --Sanitary section
		and intRowStatus = 0
		and blnIsActive = 1
ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC




