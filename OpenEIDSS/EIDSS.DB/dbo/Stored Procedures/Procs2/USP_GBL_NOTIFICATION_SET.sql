
-- ============================================================================
-- Name: USP_GBL_NOTIFICATION_SET
--
-- Description:	Inserts or updates notification, notification shared and 
-- notification filtered for various use cases.
-- 
-- Field Notes:
--
-- Notification Object - ID of record such as human disease report
-- Notification Object Type - type of record associated with the object such as
--   human disease report, veterinary disease report, outbreak, etc.
-- Target User ID - currently not used.
-- Target Site - currenty not used.
-- Target Site Type - currently not used.
-- Entering date - date when notification was created first time (for 
--   notification that are transferred from intermediate sites).
-- strPayload - custom data related with notification
-- LoginSite - ID of organization login site where initial event that raise 
--   notification was created
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/01/2018 Initial release.
-- Stephen Long     02/04/2019 Revamped for new API.
-- Stephen Long     03/01/2019 Made notification ID required.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_NOTIFICATION_SET] (
	@LanguageID NVARCHAR(50),
	@NotificationID BIGINT,
	@NotificationTypeID BIGINT = NULL,
	@UserID BIGINT = NULL,
	@NotificationObjectID BIGINT = NULL,
	@NotificationObjectTypeID BIGINT = NULL,
	@TargetUserID BIGINT = NULL,
	@TargetSiteID BIGINT = NULL,
	@TargetSiteTypeID BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@Payload NVARCHAR(MAX) = NULL,
	@LoginSite NVARCHAR(20) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnCode INT = 0;
		DECLARE @ReturnMessage NVARCHAR(MAX) = 'SUCCESS';
		DECLARE @SupressSelect TABLE (
			ReturnCode INT,
			ReturnMessage NVARCHAR(MAX),
			ID BIGINT
			);

		BEGIN TRANSACTION;

		IF NOT EXISTS (
				SELECT *
				FROM dbo.tstNotification
				WHERE idfNotification = @NotificationID
				)
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tstNotification',
				@NotificationID OUTPUT;

			INSERT INTO dbo.tstNotificationStatus (
				idfNotification,
				intProcessed
				)
			VALUES (
				@NotificationID,
				0
				);

			-- Notifications are added to tstNotificationShared if the notification must be replicated to all sites.
			-- Currently these notification types are: Reference Table Change, AVR Update and Settlement Change.
			IF (
					@NotificationTypeID IN (
						10056001, -- Reference Table Change
						10056013, -- AVR Update
						10056014 -- Settlement Change
						)
					)
			BEGIN
				INSERT INTO dbo.tstNotificationShared (
					idfNotificationShared,
					idfsNotificationObjectType,
					idfsNotificationType,
					idfsTargetSiteType,
					idfUserID,
					idfNotificationObject,
					idfTargetUserID,
					idfsTargetSite,
					idfsSite,
					datCreationDate,
					datEnteringDate,
					strPayload,
					strMaintenanceFlag
					)
				VALUES (
					@NotificationID,
					@NotificationObjectTypeID,
					@NotificationTypeID,
					@TargetSiteTypeID,
					@UserID,
					@NotificationObjectID,
					@TargetUserID,
					@TargetSiteID,
					@SiteID,
					GETDATE(),
					GETDATE(),
					@Payload,
					@LoginSite
					);
			END;
			ELSE
			BEGIN
				--10056002	Test Results Received
				--10056005	Case Diagnosis Change
				--10056006	Case Status Change
				--10056008	Human Disease Report Case
				--10056011	Outbreak Report
				--10056012	Veterinary Disease Report Case
				--10056062  Lab Test Result Rejected
				INSERT INTO dbo.tstNotification (
					idfNotification,
					idfsNotificationObjectType,
					idfsNotificationType,
					idfsTargetSiteType,
					idfUserID,
					idfNotificationObject,
					idfTargetUserID,
					idfsTargetSite,
					idfsSite,
					datCreationDate,
					datEnteringDate,
					strPayload,
					strMaintenanceFlag
					)
				VALUES (
					@NotificationID,
					@NotificationObjectTypeID,
					@NotificationTypeID,
					@TargetSiteTypeID,
					@UserID,
					@NotificationObjectID,
					@TargetUserID,
					@TargetSiteID,
					@SiteID,
					GETDATE(),
					GETDATE(),
					CONVERT(TEXT, @Payload),
					@LoginSite
					);
			END;

			IF (@NotificationTypeID = 10056061) -- ForcedReplicationConfirmed
			BEGIN -- Update filtration record for created notification, it will be delivered to the target site.
				DECLARE @NotificationFilteredID BIGINT;

				EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tflNotificationFiltered',
					@NotificationFilteredID OUTPUT;

				DECLARE @SiteGroupID BIGINT;

				SELECT TOP 1 @SiteGroupID = g.idfSiteGroup
				FROM dbo.tflSiteGroup g
				INNER JOIN dbo.tflSiteToSiteGroup AS sg
					ON sg.idfSiteGroup = g.idfSiteGroup
				INNER JOIN dbo.tstSite AS s
					ON s.idfsSite = sg.idfsSite
				WHERE sg.idfsSite = @TargetSiteID
					AND g.idfsRayon IS NULL
					AND g.idfsCentralSite IS NULL
					AND s.idfsSiteType = 10085007;-- Create filtration record on slvl level only.

				IF NOT @SiteGroupID IS NULL
				BEGIN
					INSERT INTO dbo.tflNotificationFiltered (
						idfNotificationFiltered,
						idfNotification,
						idfSiteGroup
						)
					VALUES (
						@NotificationFilteredID,
						@NotificationID,
						@SiteGroupID
						);
				END;
			END;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		THROW;
	END CATCH;

	SELECT @ReturnCode ReturnCode,
		@ReturnMessage ReturnMessage;
END;