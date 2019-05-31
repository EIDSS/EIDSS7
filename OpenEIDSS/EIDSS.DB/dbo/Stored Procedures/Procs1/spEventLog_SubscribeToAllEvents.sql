

--##SUMMARY SSubscribes client application to all events.
--##SUMMARY Called by EIDSS Client Agent or by EIDSS Notification Service to force them receiving all events.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXEC spEventLog_SubscribeToAllEvents '12345'
*/




CREATE            procedure [dbo].[spEventLog_SubscribeToAllEvents](
	@idfClientID as nvarchar(50)--##PARAM @ClientID - client application ID.
)
as

IF NOT EXISTS (SELECT strClient FROM tstLocalClient WHERE strClient = @idfClientID)  
	INSERT INTO tstLocalClient (strClient) VALUES (@idfClientID)  

INSERT tstEventSubscription (
	idfsEventTypeID, strClient
	)  
	SELECT idfsReference, @idfClientID  
	FROM fnReference('en', 19000025) as EventType --'rftEventType'  
	WHERE Not Exists(Select * From tstEventSubscription Where tstEventSubscription.idfsEventTypeID = EventType.idfsReference 
	And strClient = @idfClientID)




