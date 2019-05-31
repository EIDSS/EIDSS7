
-- ================================================================================================
-- Name: USP_ADMIN_FF_Observation_SET
-- Description: Inserts or updates the Observation ID.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    1/17/2019 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE USP_ADMIN_FF_Observation_SET
(	 
	 @idfObservation	bigint	--##PARAM @idfObservation Observation Id
	,@idfsFormTemplate	bigint	--##PARAM @idfsFormTemplate Id of flexible form template (reference to ffFormTemplate)
)
AS
BEGIN

	IF (@idfObservation is null) return;

	DECLARE 
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY

		BEGIN TRANSACTION;
		-- Post tlbObservation
		IF EXISTS	(
			SELECT	*
			FROM	tlbObservation
			WHERE	idfObservation = @idfObservation
					)
		BEGIN
			UPDATE	tlbObservation
			SET		idfsFormTemplate = @idfsFormTemplate
			WHERE	idfObservation = @idfObservation
					and isnull(idfsFormTemplate,0) != isnull(@idfsFormTemplate,0)
		END
		ELSE
		BEGIN

			INSERT INTO tlbObservation
			(	idfObservation,
				idfsFormTemplate
			)
			VALUES
			(	@idfObservation,
				@idfsFormTemplate
			)
		END
		COMMIT TRANSACTION;

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH

END

