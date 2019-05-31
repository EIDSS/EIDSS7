-- ===========================================================================================================================================
-- NAME: USP_CONF_SPECIESTYPEANIMALAGEMATRIX_SET
-- DESCRIPTION: Creates or updates an active species types to animal age matrix given an id, species types, and an animal age
-- AUTHOR: Ricky Moss
-- 
-- REVISION HISTORY
-- Name				Date		Description of change
-- ----------------------------------------------------------------------------------------------------------------------------------------
-- Ricky Moss		04/16/2019	Initial Release
--
-- USP_CONF_SPECIESTYPEANIMALAGEMATRIX_SET 838610000000, 837790000000, 838430000000
-- USP_CONF_SPECIESTYPEANIMALAGEMATRIX_SET NULL, 837860000000, 6618920000000
-- ===========================================================================================================================================
ALTER PROCEDURE USP_CONF_SPECIESTYPEANIMALAGEMATRIX_SET
(
	@idfSpeciesTypeToAnimalAge BIGINT = NULL,
	@idfsSpeciesType BIGINT,
	@idfsAnimalAge BIGINT
)
AS
DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
DECLARE @returnCode					BIGINT = 0;
DECLARE @SupressSelect TABLE
( 
	retrunCode int,
	returnMessage varchar(200)
)
BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsAnimalAge = @idfsAnimalAge AND idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND @idfSpeciesTypeToAnimalAge IS NULL) OR (EXISTS(SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsAnimalAge = @idfsAnimalAge AND idfsSpeciesType = @idfsSpeciesType AND idfSpeciesTypeToAnimalAge <> @idfSpeciesTypeToAnimalAge AND intRowStatus = 0) AND @idfSpeciesTypeToAnimalAge IS NOT NULL) 
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfSpeciesTypeToAnimalAge = (SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsAnimalAge = @idfsAnimalAge AND idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0)
		END
		ELSE IF (EXISTS(SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsAnimalAge = @idfsAnimalAge AND idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 1) AND @idfSpeciesTypeToAnimalAge IS NULL)
		BEGIN
			UPDATE trtSpeciesTypeToAnimalAge SET intRowStatus = 0 WHERE idfsAnimalAge = @idfsAnimalAge AND idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 1
			SELECT @idfSpeciesTypeToAnimalAge = (SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsAnimalAge = @idfsAnimalAge AND idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 1)
		END
		ELSE IF (EXISTS(SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge AND intRowStatus = 0))
		BEGIN
			UPDATE trtSpeciesTypeToAnimalAge SET idfsSpeciesType = @idfsSpeciesType, idfsAnimalAge = @idfsAnimalAge WHERE idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge AND intRowStatus = 0 
		END
		ELSE
		BEGIN			
		    INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtSpeciesTypeToAnimalAge', @idfSpeciesTypeToAnimalAge OUTPUT;

			INSERT INTO trtSpeciesTypeToAnimalAge (idfSpeciesTypeToAnimalAge, idfsSpeciesType, idfsAnimalAge, intRowStatus) VALUES (@idfSpeciesTypeToAnimalAge, @idfsSpeciesType, @idfsAnimalAge, 0)
			INSERT INTO trtSpeciesTypeToAnimalAgeToCP (idfSpeciesTypeToAnimalAge, idfCustomizationPackage) VALUES (@idfSpeciesTypeToAnimalAge, dbo.FN_GBL_CustomizationPackage_GET())
		END
		SELECT @returnCode 'returnCode', @returnMsg 'returnMessage', @idfSpeciesTypeToAnimalAge 'idfSpeciesTypeToAnimalAge'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END