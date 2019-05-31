
-- ============================================================================
-- Name: USP_VCT_ASMONITORINGSESSIONTOSAMPLETYPE_GETList
-- Description:	Get active surveillance monitoring session to sample type list 
-- for the veterinary module active surveillance edit/set up use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/17/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCT_ASMONITORINGSESSIONTOSAMPLETYPE_GETList] 
(
	@LangID							NVARCHAR(50), 
	@idfMonitoringSession			BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode				BIGINT = 0;

	BEGIN TRY  	
		SELECT						mst.MonitoringSessionToSampleType, 
									mst.idfMonitoringSession, 
									mst.idfsSpeciesType,
									speciesType.name AS SpeciesTypeName, 
									mst.idfsSampleType, 
									sampleType.name AS SampleTypeName, 
									mst.intOrder,
									mst.intRowStatus, 
									mst.strMaintenanceFlag, 
									'R' AS RecordAction 
		FROM						dbo.MonitoringSessionToSampleType mst 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000086) AS speciesType
		ON							speciesType.idfsReference = mst.idfsSpeciesType 
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000087) AS sampleType
		ON							sampleType.idfsReference = mst.idfsSampleType 
		WHERE						mst.idfMonitoringSession = @idfMonitoringSession 
		AND							mst.intRowStatus = 0;

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
