--=====================================================================================================
-- Created by:				Joan Li
-- Description:				06/21/2017: Created based on V6 spHumanAggregateCase_Delete :  V7 USP75
--                          call this SP: usp_Observation_Delete 
--                          delete from tables :tflAggrCaseFiltered;tlbAggrCase(triggers)
/*
----testing code:
DECLARE @ID bigint
EXECUTE spHumanAggregateCase_Delete 
	@ID
----related fact data from
select * from tlbAggrCase
select * from  tflAggrCaseFiltered
*/
--=====================================================================================================
/*Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					12/31/2018							Surpressed Selects from SP's  moved Outputs in signature and moved as Outputs from internal selects  to  final Select statements
*******************************************************/

CREATE   PROC	[dbo].[usp_HumanAggregateCase_Delete]
	@ID AS BIGINT --#PARAM @ID - aggregate case ID
as
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0 
	DECLARE @idfObservation BIGINT

	BEGIN TRY
	SELECT @idfObservation = idfCaseObservation
	FROM tlbAggrCase
	WHERE idfAggrCase = @ID

	DELETE FROM tflAggrCaseFiltered WHERE idfAggrCase = @ID
	DELETE FROM tlbAggrCase WHERE idfAggrCase = @ID

	EXEC usp_Observation_Delete @idfObservation

   SELECT @returnCode 'ReturnCode', @returnMsg 'RetunMessage'
   END TRY
   BEGIN CATCH
   THROW
   END CATCH

END