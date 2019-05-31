

--##SUMMARY SSubscribes client application to all events.
--##SUMMARY Called by EIDSS Client Agent or by EIDSS Notification Service to force them receiving all events.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXEC spEventLog_SubscribeToEvent '12345', 10025144
*/




CREATE            procedure [dbo].[spEventLog_SubscribeToEvent](
	@idfClientID as nvarchar(50)--##PARAM @ClientID - client application ID.
	,@idfsEventTypeID as bigint
)
as

IF NOT EXISTS (SELECT strClient FROM tstLocalClient WHERE strClient = @idfClientID)  
	INSERT INTO tstLocalClient (strClient) VALUES (@idfClientID)  
if Not Exists(Select * From tstEventSubscription 
				Where 
					tstEventSubscription.idfsEventTypeID = @idfsEventTypeID 
					and strClient = @idfClientID
			)
	INSERT tstEventSubscription (idfsEventTypeID, strClient)
	VALUES (@idfsEventTypeID, @idfClientID)




