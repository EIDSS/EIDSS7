


--##SUMMARY Deletes human aggregate case object.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 012.12.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spHumanAggregateCase_Delete 
	@ID

*/



CREATE   PROC	[dbo].[spHumanAggregateCase_Delete]
	@ID AS BIGINT --#PARAM @ID - aggregate case ID
as
DECLARE @idfObservation BIGINT
SELECT @idfObservation = idfCaseObservation
FROM tlbAggrCase
WHERE idfAggrCase = @ID

DELETE FROM tflAggrCaseFiltered WHERE idfAggrCase = @ID
DELETE FROM tlbAggrCase WHERE idfAggrCase = @ID

EXEC spObservation_Delete @idfObservation


