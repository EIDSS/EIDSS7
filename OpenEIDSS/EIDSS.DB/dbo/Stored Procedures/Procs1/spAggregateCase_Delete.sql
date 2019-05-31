



--##SUMMARY Deletes human aggregate case object.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 07.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spAggregateCase_Delete 
	@ID

*/




CREATE                   proc	[dbo].[spAggregateCase_Delete]
(	
	@ID AS BIGINT --#PARAM @ID - aggregate case ID
	)
AS
DECLARE @returnCode		INT = 0 
DECLARE	@returnMsg		NVARCHAR(MAX) = 'SUCCESS' 
DECLARE @idfObservation BIGINT

BEGIN

	BEGIN TRY
	BEGIN TRANSACTION
		SELECT @idfObservation = idfCaseObservation
		FROM tlbAggrCase
		WHERE idfAggrCase = @ID

		delete from tflAggrCaseFiltered where idfAggrCase = @ID
		DELETE FROM tlbAggrCase WHERE idfAggrCase = @ID

		EXEC spObservation_Delete @idfObservation

		IF @@TRANCOUNT > 0 
		  COMMIT

		SELECT @returnCode ReturnCode, @returnMsg ReturnMessage

	END TRY 
		BEGIN CATCH 

		IF @@TRANCOUNT > 0
			ROLLBACK;

		Throw;

	END CATCH
End