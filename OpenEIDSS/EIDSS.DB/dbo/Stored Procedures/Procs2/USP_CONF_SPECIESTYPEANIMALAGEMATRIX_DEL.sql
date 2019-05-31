-- ========================================================================================================================================
-- NAME: USP_CONF_SPECIESTYPEANIMALAGEMATRIX_DEL
-- DESCRIPTION: Removes an active species types to animal age matrix given an id and the ability to delete regardless of being referenced. 
-- AUTHOR: Ricky Moss
-- 
-- REVISION HISTORY
-- Name				Date		Description of change
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Ricky Moss		04/16/2019	Initial Release
--
-- USP_CONF_SPECIESTYPEANIMALAGEMATRIX_DEL 838610000000, 0
-- ========================================================================================================================================
ALTER PROCEDURE USP_CONF_SPECIESTYPEANIMALAGEMATRIX_DEL
(
	@idfSpeciesTypeToAnimalAge BIGINT,
	@deleteAnyway BIT
)
AS
DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
DECLARE @returnCode					BIGINT = 0;
BEGIN
	BEGIN TRY
		UPDATE trtSpeciesTypeToAnimalAge SET intRowStatus = 1 WHERE idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge
		SELECT @returnCode 'returnCode', @returnMsg 'returnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END