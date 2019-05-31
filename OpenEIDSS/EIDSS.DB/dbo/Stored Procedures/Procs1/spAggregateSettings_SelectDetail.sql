


--##SUMMARY Selects data for AggregateSettings form
--##SUMMARY that defines minimal adninistrative unit and period Type for different aggregate cases types.
--##SUMMARY If NULL is passed as input aggregate case Type, settings for this Type only is selected.
--##SUMMARY In other case all settings are selected.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 01.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @idfsAggrCaseType bigint
SET  @idfsAggrCaseType = 10102001
EXECUTE spAggregateSettings_SelectDetail 
	@idfsAggrCaseType

*/


CREATE       procedure dbo.spAggregateSettings_SelectDetail
			@idfsAggrCaseType bigint --##PARAM @idfsAggrCaseType - aggregate case Type
as
SELECT * FROM fnAggregateSettings(@idfsAggrCaseType)
	



