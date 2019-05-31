

--##SUMMARY Creates new notification record.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:

DECLARE @idfNotification bigint
DECLARE @idfsNotificationType bigint
DECLARE @idfUserID bigint
DECLARE @idfNotificationObject bigint
DECLARE @idfsNotificationObjectType bigint
DECLARE @idfTargetUserID bigint
DECLARE @idfsTargetSite bigint
DECLARE @idfsTargetSiteType bigint
DECLARE @idfsSite bigint
DECLARE @datEnteringDate datetime

SET @idfsNotificationType = 10056011
SET @idfsSite = 2
SET @datEnteringDate = GetDate()
SET @idfNotificationObject = 124550000000

EXECUTE spNotification_Create
   @idfNotification OUTPUT
  ,@idfsNotificationType
  ,@idfUserID
  ,@idfNotificationObject
  ,@idfsNotificationObjectType
  ,@idfTargetUserID
  ,@idfsTargetSite
  ,@idfsTargetSiteType
  ,@idfsSite
  ,@datEnteringDate
  ,N'124550000000' 

*/


CREATE                  PROCEDURE dbo.spNotification_Create
			 @idfNotification as bigint OUTPUT --##PARAM @idfNotification - notification record ID. IF NULL is passed, new ID is assigned inside procedure and returned to calling client
			,@idfsNotificationType as bigint --##PARAM @idfsNotificationType - notification Type
			,@idfUserID as bigint --##PARAM @idfUserID - ID of user that created notification
			,@idfNotificationObject as bigint --##PARAM @idfNotificationObject - ID of object related with notification
			,@idfsNotificationObjectType as bigint --##PARAM @idfNotificationObject - Type of object related with notification
			,@idfTargetUserID as bigint --##PARAM @idfTargetUserID - ID of user that should receive notification. Currently is not used.
			,@idfsTargetSite as bigint --##PARAM @idfsTargetSite - ID of site that should receive notification. Currently is not used.
			,@idfsTargetSiteType as bigint --##PARAM @idfsTargetSiteType - Type of site where notification should be processed. Currently is not used.
			,@idfsSite as bigint --##PARAM @idfsSite - ID of site where notification is created
			,@datEnteringDate DATETIME --##PARAM @datEnteringDate - date when notification was created first time (for notification that are transferred from intermediate sites)
			,@strPayload as text --##PARAM @strPayload - custom data related with notification
			,@idfsLoginSite bigint  --##PARAM @idfsSite - ID of organization login site where initial event that raise notification was created
AS
if @idfNotification IS NULL
	EXEC spsysGetNewID @idfNotification OUTPUT
declare @strLoginSite nvarchar(20)
if(not @idfsLoginSite is null)
	SET @strLoginSite = CAST(@idfsLoginSite as nvarchar)

INSERT INTO tstNotificationStatus
           (
			[idfNotification]
           ,[intProcessed]
           )
     VALUES
           (
			@idfNotification
           ,0 --intProcessed
           )
--We insert notification into tstNotificationShared
--if notification must be replicated to all sites.
--Currently these notification are:
--	Reference Table Changed
--	AVR Update
--	Settlement Changed

IF(@idfsNotificationType IN (
10056001--	Reference Table Changed
,10056013--	AVR Update
,10056014--	Settlement Changed
))
BEGIN
INSERT INTO tstNotificationShared
           (
			idfNotificationShared
           ,idfsNotificationObjectType
           ,idfsNotificationType
           ,idfsTargetSiteType
           ,idfUserID
           ,idfNotificationObject
           ,idfTargetUserID
           ,idfsTargetSite
           ,idfsSite
           ,datCreationDate
           ,datEnteringDate
           ,strPayload
		   ,strMaintenanceFlag
			)
     VALUES
           (
			@idfNotification
           ,@idfsNotificationObjectType
           ,@idfsNotificationType
           ,@idfsTargetSiteType
           ,@idfUserID
           ,@idfNotificationObject
           ,@idfTargetUserID
           ,@idfsTargetSite
           ,ISNULL(@idfsSite, dbo.fnSiteID())
           ,GETDATE() --@datCreationDate 
           ,@datEnteringDate
           ,@strPayload
		   ,@strLoginSite
			)

END
ELSE
BEGIN
--10056002	Test Results Received
--10056005	Case diagnosis changed notification
--10056006	Case status changed notification
--10056008	Human Case
--10056011	Outbreak
--10056012	Vet Case

INSERT INTO tstNotification
           (
			idfNotification
           ,idfsNotificationObjectType
           ,idfsNotificationType
           ,idfsTargetSiteType
           ,idfUserID
           ,idfNotificationObject
           ,idfTargetUserID
           ,idfsTargetSite
           ,idfsSite
           ,datCreationDate
           ,datEnteringDate
           ,strPayload
		   ,strMaintenanceFlag
			)
     VALUES
           (
			@idfNotification
           ,@idfsNotificationObjectType
           ,@idfsNotificationType
           ,@idfsTargetSiteType
           ,@idfUserID
           ,@idfNotificationObject
           ,@idfTargetUserID
           ,@idfsTargetSite
           ,ISNULL(@idfsSite, dbo.fnSiteID())
           ,GETDATE() --@datCreationDate 
           ,@datEnteringDate
           ,@strPayload
		   ,@strLoginSite
			)
	IF (@idfsNotificationType = 10056061) -- ForcedReplicationConfirmed
	BEGIN --update filtration record for created notification, it shall be delevered to target site
		declare @idfNotificationFiltered bigint
		EXEC spsysGetNewID @idfNotificationFiltered OUTPUT
		declare @idfSiteGroup bigint
		select Top 1 @idfSiteGroup = g.idfSiteGroup 
		from		tflSiteGroup g
		inner join	tflSiteToSiteGroup sg 
			on sg.idfSiteGroup = g.idfSiteGroup
		inner join	tstSite s 
			on s.idfsSite = sg.idfsSite
		where 
			sg.idfsSite = @idfsTargetSite 
			and g.idfsRayon is null
			and g.idfsCentralSite is null
			and s.idfsSiteType = 10085007 -- we should create filtration record on slvl level only
		if not @idfSiteGroup is null
			insert into tflNotificationFiltered(
			idfNotificationFiltered
			,idfNotification
			,idfSiteGroup
			)
			values(
			@idfNotificationFiltered
			,@idfNotification
			,@idfSiteGroup
			)

	END
	--Filtration procedure is called for insert into tstNotificationTable
	--EXEC spFiltered_CheckNotificationPost @idfNotification
END















