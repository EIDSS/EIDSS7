


--*************************************************************
-- Name 				: USP_AGG_CASE_DELETE
-- Description			: Deletes human aggregate case object.
--          
-- Author               : Arnold Kennedy
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:EXECUTE USP_AGG_CASE_DELETE  @ID
--	@ID is AggregateCaseID
--*************************************************************




CREATE  Procedure	[dbo].[USP_AGG_CASE_DELETE]
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

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'

	END TRY 
		BEGIN CATCH 
		IF @@TRANCOUNT > 0
			ROLLBACK;

		Throw;

	END CATCH
End