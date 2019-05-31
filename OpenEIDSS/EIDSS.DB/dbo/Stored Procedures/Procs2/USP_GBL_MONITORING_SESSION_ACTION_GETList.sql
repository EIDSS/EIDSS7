

-- ================================================================================================
-- Name: USP_GBL_MONITORING_SESSION_ACTION_GETList
-- Description:	Get monitoring session action list for the veterinary module monitoring session 
-- edit/enter use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/03/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_MONITORING_SESSION_ACTION_GETList] 
(
	@LanguageID						NVARCHAR(50), 
	@MonitoringSessionID			BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY  	
		SELECT						msa.idfMonitoringSessionAction AS MonitoringSessionActionID, 
									msa.idfMonitoringSession AS MonitoringSessionID, 
									msa.idfPersonEnteredBy AS PersonEnteredByID,
									ISNULL(p.strFamilyName, N'') + ISNULL(' ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS PersonEnteredByName,
									msa.idfsMonitoringSessionActionType AS MonitoringSessionActionTypeID, 
									monitoringSessionActionType.name AS MonitoringSessionActionTypeName, 
									msa.idfsMonitoringSessionActionStatus AS MonitoringSessionActionStatusTypeID,
									monitoringSessionActionStatus.name AS MonitoringSessionActionStatusTypeName, 
									msa.datActionDate AS ActionDate,
									msa.strComments AS Comments,
									msa.intRowStatus AS RowStatus,
									msa.strMaintenanceFlag AS MaintenanceFlag, 
									'R' AS RecordAction 
		FROM						dbo.tlbMonitoringSessionAction msa
		LEFT JOIN					dbo.tlbPerson AS p 
		ON							p.idfPerson = msa.idfPersonEnteredBy AND p.intRowStatus = 0
		LEFT JOIN					FN_GBL_ReferenceRepair(@LanguageID, 19000127) AS monitoringSessionActionType
		ON							monitoringSessionActionType.idfsReference = msa.idfsMonitoringSessionActionType
		LEFT JOIN					FN_GBL_ReferenceRepair(@LanguageID, 19000128) AS monitoringSessionActionStatus
		ON							monitoringSessionActionStatus.idfsReference = msa.idfsMonitoringSessionActionStatus
		WHERE						msa.idfMonitoringSession = CASE ISNULL(@MonitoringSessionID, '') WHEN '' THEN msa.idfMonitoringSession ELSE @MonitoringSessionID END
		AND							msa.intRowStatus = 0;
	END TRY  
	BEGIN CATCH 
		BEGIN
			;THROW;
		END
	END CATCH;
END
