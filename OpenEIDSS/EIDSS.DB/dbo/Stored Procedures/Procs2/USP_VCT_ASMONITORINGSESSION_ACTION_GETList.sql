
-- ============================================================================
-- Name: USP_VCT_ASMONITORINGSESSION_ACTION_GETList
-- Description:	Get active surveillance monitoring session action list for the 
-- veterinary module active surveillance edit/enter use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/03/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCT_ASMONITORINGSESSION_ACTION_GETList] 
(
	@LangID							NVARCHAR(50), 
	@idfMonitoringSession			BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode BIGINT = 0;

	BEGIN TRY  	
		SELECT						msa.idfMonitoringSessionAction, 
									msa.idfMonitoringSession, 
									msa.idfPersonEnteredBy,
									ISNULL(p.strFamilyName, N'') + ISNULL(' ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS PersonName,
									msa.idfsMonitoringSessionActionType, 
									monitoringSessionActionType.name AS MonitoringSessionActionTypeName, 
									msa.idfsMonitoringSessionActionStatus,
									monitoringSessionActionStatus.name AS MonitoringSessionActionStatusName, 
									msa.datActionDate,
									msa.strComments,
									msa.intRowStatus,
									msa.strMaintenanceFlag, 
									'R' AS RecordAction 
		FROM						dbo.tlbMonitoringSessionAction msa
		LEFT JOIN					dbo.tlbPerson AS p 
		ON							p.idfPerson = msa.idfPersonEnteredBy AND p.intRowStatus = 0
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000127) AS monitoringSessionActionType
		ON							monitoringSessionActionType.idfsReference = msa.idfsMonitoringSessionActionType
		LEFT JOIN					FN_GBL_ReferenceRepair(@LangID, 19000128) AS monitoringSessionActionStatus
		ON							monitoringSessionActionStatus.idfsReference = msa.idfsMonitoringSessionActionStatus
		WHERE						msa.idfMonitoringSession = CASE ISNULL(@idfMonitoringSession, '') WHEN '' THEN msa.idfMonitoringSession ELSE @idfMonitoringSession END
		AND							msa.intRowStatus = 0;

		SELECT						@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET						@returnCode = ERROR_NUMBER();
			SET						@returnMsg = 
									'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
									+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
									+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
									+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
									+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
									+ ' ErrorMessage: ' + ERROR_MESSAGE();

			SELECT					@returnCode, @returnMsg;
		END
	END CATCH;
END
