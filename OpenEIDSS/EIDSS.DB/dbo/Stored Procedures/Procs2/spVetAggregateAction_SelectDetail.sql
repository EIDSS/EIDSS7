


--##SUMMARY Selects data for VetAggregateActionDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 06.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
EXECUTE spVetAggregateAction_SelectDetail 
	@idfAggrCase

*/




CREATE  proc	spVetAggregateAction_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
as

-- 0/1 Aggregate case/ aggregate settings
EXEC spAggregateCaseHeader_SelectDetail 	@idfAggrCase, 10102003 --Vet aggregate action

--2 Default Diagnostic matrix version
EXEC spVetAggregateActionDetailed_SelectDetail @idfAggrCase

--2 Default Diagnostic matrix version
--3 Default Prophylactic matrix version
--4 Default Sanitary matrix version

