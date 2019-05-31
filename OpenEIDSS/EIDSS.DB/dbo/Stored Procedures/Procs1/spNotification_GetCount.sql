



--##SUMMARY Returns record with count of unprocessed notifications that was not created on the current site.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfsSite AS bigint
EXEC spNotification_GetCount @idfsSite
*/



CREATE              PROCEDURE dbo.spNotification_GetCount( 
		@idfsSite AS bigint  --##PARAM @idfsSite - site ID
)
AS

SELECT
(
Select Count(n.idfNotification) From tstNotification n
LEFT OUTER Join tstNotificationStatus s
	ON s.idfNotification = n.idfNotification
Where 
	n.idfsSite <> @idfsSite 
	AND ISNULL(s.intProcessed,0) <> 1 AND ISNULL(s.intSessionID,0) = 0 
)
+
(
Select Count(n.idfNotificationShared) From tstNotificationShared n
LEFT OUTER Join tstNotificationStatus s
	ON s.idfNotification = n.idfNotificationShared
Where 
	n.idfsSite <> @idfsSite 
	AND ISNULL(s.intProcessed,0) <> 1 AND ISNULL(s.intSessionID,0) = 0
)
	

