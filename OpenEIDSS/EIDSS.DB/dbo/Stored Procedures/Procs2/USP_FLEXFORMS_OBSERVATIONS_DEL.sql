
--*************************************************************
-- Name 				: USP_FLEXFORMS_OBSERVATIONS_DEL
-- Description			: Deletes observation object with related flexible form data.
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--Example of a call of procedure:

--DECLARE @idfObservation bigint

--EXECUTE spObservation_Delete @idfObservation
--*************************************************************
CREATE PROCEDURE [dbo].[USP_FLEXFORMS_OBSERVATIONS_DEL]
(
	@ID AS BIGINT --#PARAM @ID - observation ID
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		DELETE dbo.tlbActivityParameters
		WHERE idfObservation = @ID

		DELETE 
		FROM	tflObservationFiltered 
		WHERE idfObservation = @ID

		DELETE dbo.tlbObservation 
		WHERE idfObservation = @ID
	
			SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg = 
			   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   + ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			   + ' ErrorLine: ' +  convert(varchar,ISNULL(ERROR_LINE() ,''))
			   + ' ErrorMessage: '+ ERROR_MESSAGE()
			   ----SELECT @LogErrMsg

			  SELECT @returnCode, @returnMsg
	END CATCH
END

