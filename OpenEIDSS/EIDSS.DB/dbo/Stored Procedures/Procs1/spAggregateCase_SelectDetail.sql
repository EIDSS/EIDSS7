




--##SUMMARY Selects data for AggregateCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spAggregateCase_SelectDetail 
	@idfAggrCase

*/




CREATE  proc	spAggregateCase_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as
-- Aggregate case
EXEC spAggregateCaseHeader_SelectDetail 	@idfAggrCase, 10102001 --Aggregate case

--1 Default matrix version
EXEC spAggregateCaseDetailed_SelectDetail @idfAggrCase

