
-- ============================================================================
-- Name: USP_GBL_NOTIFICATION_GETList
--
-- Description:	Get notification list for various use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- Stephen Long     02/04/2019 Revamped for new API.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_NOTIFICATION_GETList] (
	@LanguageID NVARCHAR(50),
	@NotificationObjectTypeID BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@TargetSiteID BIGINT = NULL,
	@UserID BIGINT = NULL,
	@TargetUserID BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SELECT n.idfNotification AS NotificationID,
			n.idfsNotificationObjectType AS NotificationObjectTypeID,
			notificationObjectType.name AS NotificationObjectTypeName,
			n.idfsNotificationType AS NotificationTypeID,
			notificationType.name AS NotificationTypeName,
			n.idfsTargetSiteType AS TargetSiteTypeID,
			targetSiteType.name AS TargetSiteTypeName,
			n.idfUserID AS UserID,
			n.idfNotificationObject AS NotificationObjectID,
			n.idfTargetUserID AS TargetUserID,
			ISNULL(targetUserPerson.strFamilyName, N'') + ISNULL(' ' + targetUserPerson.strFirstName, '') + ISNULL(' ' + targetUserPerson.strSecondName, '') AS TargetUserPersonName,
			n.idfsTargetSite AS TargetSiteID,
			targetSite.strSiteName AS TargetSiteName,
			n.idfsSite AS SiteID,
			currentSite.strSiteName AS CurrentSiteName,
			n.datCreationDate AS CreateDate,
			n.datEnteringDate AS EnteredDate,
			n.strPayload AS Payload
		FROM dbo.tstNotification n
		LEFT JOIN dbo.tstUserTable AS u
			ON u.idfUserID = n.idfUserID
				AND u.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS targetUserPerson
			ON targetUserPerson.idfPerson = u.idfPerson
				AND targetUserPerson.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS targetSite
			ON targetSite.idfsSite = n.idfsTargetSite
				AND targetSite.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS currentSite
			ON currentSite.idfsSite = n.idfsSite
				AND currentSite.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000055) AS notificationObjectType
			ON notificationObjectType.idfsReference = n.idfsNotificationObjectType
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000056) AS notificationType
			ON notificationType.idfsReference = n.idfsNotificationType
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000085) AS targetSiteType
			ON targetSiteType.idfsReference = n.idfsTargetSiteType
		WHERE (
				(n.idfNotificationObject = @NotificationObjectTypeID)
				OR (@NotificationObjectTypeID IS NULL)
				)
			AND (
				(n.idfsSite = @SiteID)
				OR (@SiteID IS NULL)
				)
			AND (
				(n.idfsTargetSite = @TargetSiteID)
				OR (@TargetSiteID IS NULL)
				)
			AND (
				(n.idfUserID = @UserID)
				OR (@UserID IS NULL)
				)
			AND (
				(n.idfTargetUserID = @TargetUserID)
				OR (@TargetUserID IS NULL)
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END;