USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_OMM_HerdSpecies_GetList]    Script Date: 5/10/2019 6:59:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================
-- Name: USP_OMM_HerdSpecies_GetList
--
-- Description: Gets a list of outbreak case reports.
--          
-- Author: Doug Albanese
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- 
--                           
-- ================================================================================================
ALTER PROCEDURE [dbo].[USP_OMM_HerdSpecies_GetList]
(
    @LangID							NVARCHAR(50),
	@idfFarmActual					BIGINT,
	@idfHerdActual					BIGINT = -1
)
AS
BEGIN
    DECLARE @returnCode INT = 0;
    DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

    BEGIN TRY
        
		IF @idfHerdActual = -1
			BEGIN
				SELECT
						ha.idfHerdActual,
						sa.idfSpeciesActual,
						ha.strHerdCode,
						sa.idfsSpeciesType,
						sa.intTotalAnimalQty,
						sa.intDeadAnimalQty,
						sa.intSickAnimalQty,
						sa.datStartOfSignsDate,
						sa.strNote
				FROM	
						tlbHerdActual ha
				LEFT JOIN tlbSpeciesActual sa
				ON		sa.idfHerdActual = ha.idfHerdActual
				WHERE
						idfFarmActual = @idfFarmActual AND
						ha.intRowStatus = 0 AND
						sa.intRowStatus = 0
			END
		ELSE
			BEGIN
				SELECT
						ha.idfHerdActual,
						sa.idfSpeciesActual,
						ha.strHerdCode,
						sa.idfsSpeciesType,
						sa.intTotalAnimalQty,
						sa.intDeadAnimalQty,
						sa.intSickAnimalQty,
						sa.datStartOfSignsDate,
						sa.strNote
				FROM	
						tlbHerdActual ha
				LEFT JOIN tlbSpeciesActual sa
				ON		sa.idfHerdActual = ha.idfHerdActual
				WHERE
						ha.idfFarmActual = @idfFarmActual AND
						ha.idfHerdActual = @idfHerdActual AND
						ha.intRowStatus = 0 AND
						sa.intRowStatus = 0
			END

				
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT = 1
            ROLLBACK;

        SET @returnCode = ERROR_NUMBER();
        SET @returnMsg
            = N'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + N' ErrorSeverity: '
              + CONVERT(VARCHAR, ERROR_SEVERITY()) + N' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
              + N' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '') + N' ErrorLine: '
              + CONVERT(VARCHAR, ISNULL(ERROR_LINE(), '')) + N' ErrorMessage: ' + ERROR_MESSAGE();

        SELECT @returnCode,
               @returnMsg;
    END CATCH;
END;
