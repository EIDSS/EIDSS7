
-- ============================================================================
-- Name: USP_GBL_ASCAMPAIGNTOSAMPLETYPE_GETList
-- Description:	Get active surveillance campaign to sample type list 
-- for the veterinary module active surveillance edit/set up use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/30/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_ASCAMPAIGNTOSAMPLETYPE_GETList] 
(
	@LangID							NVARCHAR(50), 
	@idfCampaign					BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode				BIGINT = 0;

	BEGIN TRY  	
		SELECT						cst.CampaignToSampleTypeUID, 
									cst.idfCampaign, 
									cst.idfsSpeciesType,
									speciesType.name AS SpeciesTypeName, 
									cst.idfsSampleType, 
									sampleType.name AS SampleTypeName, 
									cst.intOrder,
									cst.intRowStatus, 
									cst.intPlannedNumber, 
									cst.strMaintenanceFlag, 
									'R' AS RecordAction 
		FROM						dbo.CampaignToSampleType cst
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON							speciesType.idfsReference = cst.idfsSpeciesType 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000087) AS sampleType
		ON							sampleType.idfsReference = cst.idfsSampleType 
		WHERE						cst.idfCampaign = @idfCampaign 
		AND							cst.intRowStatus = 0;

		SELECT						@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET						@returnCode = ERROR_NUMBER();
			SET						@returnMsg = 'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
									+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
									+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
									+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
									+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
									+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT					@returnCode, @returnMsg;
		END
	END CATCH;
END
