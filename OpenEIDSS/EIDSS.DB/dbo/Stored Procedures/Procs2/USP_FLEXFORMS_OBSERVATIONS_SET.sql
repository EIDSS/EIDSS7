--*************************************************************
-- Name 				: USP_FLEXFORMS_OBSERVATIONS_SET
-- Description			: Saves observation with its flexible form template.
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--Example of a call of procedure:
--DECLARE	@idfObservation		BIGINT
--DECLARE	@idfsFormTemplate	BIGINT
--EXEC USP_FLEXFORMS_OBSERVATIONS_SET
--			@idfObservation,
--			@idfsFormTemplate
--*************************************************************

CREATE PROCEDURE [dbo].[USP_FLEXFORMS_OBSERVATIONS_SET]
(	 @idfObservation	BIGINT	--##PARAM @idfObservation Observation Id
	,@idfsFormTemplate	BIGINT	--##PARAM @idfsFormTemplate Id of flexible form template (reference to ffFormTemplate)
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		IF (@idfObservation is null) RETURN;

		-- Post tlbObservation
		IF EXISTS	(SELECT * FROM tlbObservation WHERE idfObservation = @idfObservation)
			BEGIN
				UPDATE	tlbObservation
				SET		idfsFormTemplate = @idfsFormTemplate
				WHERE	idfObservation = @idfObservation
				AND		ISNULL(idfsFormTemplate,0) != ISNULL(@idfsFormTemplate,0)
			END
		ELSE
			BEGIN
				INSERT 
				INTO	tlbObservation
					(	
						idfObservation,
						idfsFormTemplate
					)
				VALUES
					(	@idfObservation,
						@idfsFormTemplate
					)
			END
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

