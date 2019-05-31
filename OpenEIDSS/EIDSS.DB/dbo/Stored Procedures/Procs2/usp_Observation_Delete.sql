--=====================================================================================================
-- Created by:				Joan Li
-- Description:				06/21/2017: Created based on V6 spObservation_Delete :  V7 USP75: call this
--                          delete from tables :tlbActivityParameters(triggers);tflObservationFiltered
/*
----testing code:
DECLARE @idfObservation bigint
EXECUTE usp_Observation_Delete @idfObservation

----related fact data from
select * from tlbActivityParameters
select * from tflObservationFiltered
*/
--=====================================================================================================

CREATE   PROC	[dbo].[usp_Observation_Delete]
	@ID AS BIGINT --#PARAM @ID - observation ID
as

	DELETE dbo.tlbActivityParameters
	WHERE 	idfObservation = @ID
	delete from tflObservationFiltered where idfObservation = @ID

	DELETE dbo.tlbObservation 
	WHERE 	idfObservation = @ID
	


