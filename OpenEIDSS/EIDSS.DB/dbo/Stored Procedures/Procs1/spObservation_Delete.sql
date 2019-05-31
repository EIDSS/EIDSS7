


--##SUMMARY Deletes observation object with related flexible form data.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfObservation bigint

EXECUTE spObservation_Delete @idfObservation

*/



CREATE   PROC	spObservation_Delete
	@ID AS BIGINT --#PARAM @ID - observation ID
as

DELETE dbo.tlbActivityParameters
WHERE 
	idfObservation = @ID
delete from tflObservationFiltered where idfObservation = @ID
DELETE dbo.tlbObservation 
WHERE 
	idfObservation = @ID
	

