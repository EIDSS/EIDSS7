-- ================================================================================================
-- Name: USP_VCT_MONITORING_SESSION_ACTION_GETList
--
-- Description:	Get monitoring session action list for the veterinary module monitoring session 
-- edit/enter use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/03/2018 Initial release
-- Stephen Long     05/03/2019 Modified for API; removed maintenance flag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VCT_MONITORING_SESSION_ACTION_GETList] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT msa.idfMonitoringSessionAction AS MonitoringSessionActionID,
			msa.idfMonitoringSession AS MonitoringSessionID,
			msa.idfPersonEnteredBy AS EnteredByPersonID,
			ISNULL(p.strFamilyName, N'') + ISNULL(' ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS EnteredByPersonName,
			msa.idfsMonitoringSessionActionType AS MonitoringSessionActionTypeID,
			monitoringSessionActionType.name AS MonitoringSessionActionTypeName,
			msa.idfsMonitoringSessionActionStatus AS MonitoringSessionActionStatusTypeID,
			monitoringSessionActionStatus.name AS MonitoringSessionActionStatusTypeName,
			msa.datActionDate AS ActionDate,
			msa.strComments AS Comments,
			msa.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbMonitoringSessionAction msa
		LEFT JOIN dbo.tlbPerson AS p
			ON p.idfPerson = msa.idfPersonEnteredBy
				AND p.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000127) AS monitoringSessionActionType
			ON monitoringSessionActionType.idfsReference = msa.idfsMonitoringSessionActionType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000128) AS monitoringSessionActionStatus
			ON monitoringSessionActionStatus.idfsReference = msa.idfsMonitoringSessionActionStatus
		WHERE (
				(msa.idfMonitoringSession = @MonitoringSessionID)
				OR (@MonitoringSessionID IS NULL)
				)
			AND msa.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
