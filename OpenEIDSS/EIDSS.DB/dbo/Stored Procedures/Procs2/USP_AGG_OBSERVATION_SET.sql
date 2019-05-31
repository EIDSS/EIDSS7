
--*************************************************************
-- Name 				: USP_AGG_OBSERVATION_SET
-- Description			: Saves observation with its flexible form template.
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_AGG_OBSERVATION_SET]
	(	 
	@idfObservation		BIGINT	--##PARAM @idfObservation Observation Id
	,@idfsFormTemplate	BIGINT	--##PARAM @idfsFormTemplate Id of flexible form template (reference to ffFormTemplate)
	)
AS

BEGIN

	BEGIN TRY  	

		IF (@idfObservation IS NULL) RETURN;

		-- Post tlbObservation
		IF EXISTS (SELECT * FROM tlbObservation WHERE idfObservation = @idfObservation)
			BEGIN
				UPDATE	
					tlbObservation
				SET		
					idfsFormTemplate = @idfsFormTemplate
				WHERE	
					idfObservation = @idfObservation
					AND 
					ISNULL(idfsFormTemplate,0) != ISNULL(@idfsFormTemplate,0)
			END
		ELSE 
			BEGIN
				INSERT INTO	tlbObservation
					(	
					idfObservation,
					idfsFormTemplate
					)
				VALUES
					(	
					@idfObservation,
					@idfsFormTemplate
					)
			END
	END TRY  

	BEGIN CATCH 

		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  

		SELECT   
			@ErrorMessage = ERROR_MESSAGE()
			,@ErrorSeverity = ERROR_SEVERITY()
			,@ErrorState = ERROR_STATE()

		RAISERROR 
			(
			@ErrorMessage,	-- Message text.  
			@ErrorSeverity, -- Severity.  
			@ErrorState		-- State.  
			); 
	END CATCH

END