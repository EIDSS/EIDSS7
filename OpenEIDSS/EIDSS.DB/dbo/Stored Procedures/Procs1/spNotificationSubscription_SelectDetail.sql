



--##SUMMARY Selects data for NotificationSubscription form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXEC spNotificationSubscription_SelectDetail  '12345', 'en'
*/




CREATE     PROCEDURE [dbo].[spNotificationSubscription_SelectDetail](
	@ClientID AS NVARCHAR(36), --##PARAM @ClientID - client application ID
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
CREATE TABLE [#tmpSubscription] (
	idfsEventTypeID bigint NOT NULL,
	strClient NVARCHAR(200) COLLATE database_default NOT NULL,
	EventName  NVARCHAR(200)COLLATE database_default NULL,
	Subscription Int NULL
	CONSTRAINT [constrain_10] PRIMARY KEY  NONCLUSTERED 
	(
		idfsEventTypeID,
		strClient
	)  ON [PRIMARY] 
) ON [PRIMARY]

INSERT INTO #tmpSubscription
SELECT
	idfsEventTypeID,
	@ClientID,
	[name],
	0 
FROM trtEventType
inner join 	fnReference(@LangID, 19000155) --'rftEventSubscriptions'
	on trtEventType.idfsEventSubscription = fnReference.idfsReference
WHERE 
	trtEventType.blnSubscription = 1

UPDATE #tmpSubscription
SET 
	#tmpSubscription.Subscription = 1
FROM
	tstEventSubscription
WHERE
	#tmpSubscription.idfsEventTypeID=tstEventSubscription.idfsEventTypeID
	AND tstEventSubscription.strClient = @ClientID

SELECT * From #tmpSubscription
ORDER BY idfsEventTypeID








