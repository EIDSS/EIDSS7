




-- ============================================================================
-- Name: USP_VET_HERD_GETDetail
-- Description:	Get herd detail (one record) for the avian and livestock 
-- veterinary disease enter and edit use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/01/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VET_HERD_GETDetail] 
(
	@LangID							NVARCHAR(50), 
	@SearchidfHerd					BIGINT = NULL 
)
AS
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode				BIGINT = 0;

	BEGIN TRY  	
		SELECT 
									h.idfHerd, 
									h.idfHerdActual, 
									h.idfFarm, 
									h.strHerdCode, 
									h.intSickAnimalQty, 
									h.intTotalAnimalQty, 
									h.intDeadAnimalQty, 
									h.strNote, 
									h.intRowStatus  
		FROM						dbo.tlbHerd h 
		LEFT JOIN					dbo.tlbHerdActual AS ha
		ON							ha.idfHerdActual = h.idfHerdActual AND ha.intRowStatus = 0 
		WHERE						h.idfHerd = CASE ISNULL(@SearchidfHerd, '') WHEN '' THEN h.idfHerd ELSE @SearchidfHerd END 
		AND							h.intRowStatus = 0;

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
