



-- ============================================================================
-- Name: USP_VET_SPECIES_GETDetail
-- Description:	Get a single species record. 
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     03/31/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VET_SPECIES_GETDetail] 
(
	@LangID							NVARCHAR(50), 
	@idfSpecies						BIGINT = NULL 
)
AS
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode				BIGINT = 0;

	BEGIN TRY  	
		SELECT 
									s.idfSpecies, 
									s.idfSpeciesActual, 
									s.idfsSpeciesType, 
									speciesType.name AS SpeciesTypeName, 
									s.idfHerd, 
									s.idfObservation, 
									s.datStartOfSignsDate, 
									s.strAverageAge, 
									s.intSickAnimalQty, 
									s.intTotalAnimalQty, 
									s.intDeadAnimalQty, 
									s.strNote, 
									s.intRowStatus, 
									s.strMaintenanceFlag 
		FROM						dbo.tlbSpecies s 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON							speciesType.idfsReference = s.idfsSpeciesType 
		WHERE						s.idfSpecies = @idfSpecies 
		AND							s.intRowStatus = 0;

		SELECT @returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET @returnCode = ERROR_NUMBER();
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
				+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT @returnCode, @returnMsg;
		END
	END CATCH;
END
