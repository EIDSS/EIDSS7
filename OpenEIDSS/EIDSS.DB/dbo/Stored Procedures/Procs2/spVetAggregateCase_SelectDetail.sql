



--##SUMMARY Selects data for VetAggregateCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 01.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spVetAggregateCase_SelectDetail 
	@idfAggrCase

*/



CREATE PROC	spVetAggregateCase_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as
-- Aggregate case
EXEC spAggregateCaseHeader_SelectDetail 	@idfAggrCase, 10102002 --Vet aggregate case
--Default matrix version
EXEC spVetAggregateCaseDetailed_SelectDetail @idfAggrCase

