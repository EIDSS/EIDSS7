

--##SUMMARY Posts record from NotificationSubscription form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
DECLARE @idfsEventTypeID bigint
DECLARE @strClient nvarchar(36)
DECLARE @Subscription int

EXECUTE spNotificationSubscription_Post
   @idfsEventTypeID
  ,@strClient
  ,@Subscription

*/
CREATE   PROCEDURE [dbo].[spNotificationSubscription_Post]( 
	@idfsEventTypeID bigint,--##PARAM @idfsEventTypeID - event Type for subscription
	@strClient NVARCHAR(36),--##PARAM @strClient - client ID of application that is subscribed for notification receiving
	@Subscription as Integer--##PARAM @Subscription - 0 removes subscription for @idfsEventTypeID, any other value subscribes application for @idfsEventTypeID events receiving
	)
AS
if ISNULL(@Subscription,0) = 0 
	DELETE FROM tstEventSubscription
	WHERE idfsEventTypeID=@idfsEventTypeID AND strClient=@strClient 
ELSE IF NOT EXISTS(SELECT idfsEventTypeID from tstEventSubscription WHERE idfsEventTypeID=@idfsEventTypeID AND strClient=@strClient)
	INSERT INTO tstEventSubscription(
		idfsEventTypeID, 
		strClient
	)
	VALUES(
		@idfsEventTypeID,
		@strClient)
	



