--*************************************************************
-- Name 				: USP_OMM_SESSION_Note_Delete
-- Description			: Deletes file objects, or the entire record for the specified note 
--          
-- Author               : Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_Parameters_Del]
(  
	@idfOutbreak				AS BIGINT,
	@OutbreakSpeciesTypeID		AS BIGINT = NULL
)  

AS  
	DECLARE	@returnCode					INT = 0;
	DECLARE @returnMsg					NVARCHAR(MAX) = 'SUCCESS';

	BEGIN

		BEGIN TRY  	
			IF @OutbreakSpeciesTypeID IS NULL
				BEGIN
					
					--DELETE 
					--FROM				OutbreakSpeciesParameter
					--WHERE
					--					idfOutbreak = @idfOutbreak

					UPDATE				OutbreakSpeciesParameter
					SET					intRowStatus = 1
					WHERE				idfOutbreak = @idfOutbreak

				END
			ELSE
				BEGIN

					--DELETE 
					--FROM				OutbreakSpeciesParameter
					--WHERE
					--					idfOutbreak = @idfOutbreak AND
					--					OutbreakSpeciesTypeID = @OutbreakSpeciesTypeID

					UPDATE				OutbreakSpeciesParameter
					SET					intRowStatus = 1
					WHERE				idfOutbreak = @idfOutbreak AND
										OutbreakSpeciesTypeID = @OutbreakSpeciesTypeID

				END

		END TRY  

		BEGIN CATCH 
			IF @@TRANCOUNT = 1 
				ROLLBACK;
			throw;
		END CATCH

		SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

	END


