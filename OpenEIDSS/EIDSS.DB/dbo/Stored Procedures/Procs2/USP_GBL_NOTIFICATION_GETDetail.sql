





-- ============================================================================
-- Name: USP_GBL_NOTIFICATION_GETDetail
-- Description:	Get notification detail (one record) for various use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_NOTIFICATION_GETDetail] 
(
	@LangID									NVARCHAR(50), 
	@idfNotification						BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT						
											n.idfNotification,
											n.idfsNotificationObjectType, 
											notificationObjectType.name AS NotificationObjectTypeName, 
											n.idfsNotificationType, 
											notificationType.name AS NotificationTypeName, 
											n.idfsTargetSiteType, 
											targetSiteType.name AS TargetSiteTypeName, 
											n.idfUserID, 
											n.idfNotificationObject,
											n.idfTargetUserID, 
											ISNULL(targetUserPerson.strFamilyName, N'') + ISNULL(' ' + targetUserPerson.strFirstName, '') + ISNULL(' ' + targetUserPerson.strSecondName, '') AS TargetUserPersonName,
											n.idfsTargetSite, 
											targetSite.strSiteName AS TargetSiteName, 
											n.idfsSite,
											currentSite.strSiteName AS TargetSiteName, 
											n.datCreationDate, 
											n.datEnteringDate, 
											n.strPayload, 
											n.datModificationForArchiveDate, 
											n.strMaintenanceFlag
		FROM								dbo.tstNotification n 
		LEFT JOIN							dbo.tstUserTable AS u 
		ON									u.idfUserID = n.idfUserID AND u.intRowStatus = 0
		LEFT JOIN							dbo.tlbPerson AS targetUserPerson 
		ON									targetUserPerson.idfPerson = u.idfPerson AND targetUserPerson.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS targetSite
		ON									targetSite.idfsSite = n.idfsTargetSite AND targetSite.intRowStatus = 0
		LEFT JOIN							dbo.tstSite AS currentSite
		ON									currentSite.idfsSite = n.idfsSite AND currentSite.intRowStatus = 0
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000055) AS notificationObjectType
		ON									notificationObjectType.idfsReference = n.idfsNotificationObjectType
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000056) AS notificationType
		ON									notificationType.idfsReference = n.idfsNotificationType 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000085) AS targetSiteType
		ON									targetSiteType.idfsReference = n.idfsTargetSiteType 
		WHERE								n.idfNotification = @idfNotification;

		SELECT @returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET @returnCode = ERROR_NUMBER();
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT @returnCode, @returnMsg;
		END
	END CATCH;
END
