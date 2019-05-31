




--##SUMMARY Selects data for AggregateCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spAggregateCaseDummy_SelectDetail 
	@idfAggrCase

*/




create proc	spAggregateCaseDummy_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as
	select isnull(@idfAggrCase,0) as idfAggrCase

