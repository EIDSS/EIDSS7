-- ===================================================================================================================================
-- NAME: USP_CONF_SPECIESTYPEANIMALAGEMATRIX_GETLIST
-- DESCRIPTION: Returns a list of species types to animal age matrices given a language id
-- AUTHOR: Ricky Moss
-- 
-- REVISION HISTORY
-- Name				Date		Description of change
-- -----------------------------------------------------------------------------------------------------------------------------------
-- Ricky Moss		04/16/2019	Initial Release
--
-- EXEC USP_CONF_SPECIESTYPEANIMALAGEMATRIX_GETLIST 'ar'
-- ===================================================================================================================================
ALTER PROCEDURE USP_CONF_SPECIESTYPEANIMALAGEMATRIX_GETLIST
(
	@langId NVARCHAR(50)
)
AS
BEGIN
	BEGIN TRY
		SELECT idfSpeciesTypeToAnimalAge, idfsSpeciesType, sbr.name AS strSpeciesType, idfsAnimalAge, aa.name AS strAnimalType FROM trtSpeciesTypeToAnimalAge saa
		JOIN FN_GBL_ReferenceRepair(@langId, 19000086) sbr
		ON saa.idfsSpeciesType = sbr.idfsReference
		JOIN FN_GBL_ReferenceRepair(@langId, 19000005) aa
		ON saa.idfsAnimalAge = aa.idfsReference
		WHERE saa.intRowStatus = 0
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END