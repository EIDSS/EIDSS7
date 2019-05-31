

--##SUMMARY Selects all unprocessed records from tstNotification table.
--##SUMMARY Record is considered as unprocessed if there is no correspodent record in the tstNotificationStatus table with intProcessed = 1.
--##SUMMARY tstNotificationStatus table is not replicated and is used by site notification service to mark local processed records.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXEC spNotification_SelectUnprocessed 511
*/


CREATE                  PROCEDURE dbo.spNotification_SelectUnprocessed
	@idfsSite bigint
AS
-- if notification status doesn't exist - insert it
INSERT INTO tstNotificationStatus
           (
			[idfNotification]
           ,[intProcessed]
           )
SELECT 	idfNotification,0
		from	tstNotification
		where	not exists (select 1 from tstNotificationStatus
		                    where tstNotificationStatus.idfNotification=tstNotification.idfNotification
		                   )
UNION
SELECT 	idfNotificationShared,0
		from	tstNotificationShared
		where	not exists (select 1 from tstNotificationStatus
		                    where tstNotificationStatus.idfNotification=tstNotificationShared.idfNotificationShared
		                   )

-- set session_id of running replications
declare	@AdminDBName nvarchar(200)
set	@AdminDBName = DB_NAME()+'_Admin'

declare	@admincmd nvarchar(max)
set	@admincmd = N'update tstNotificationStatus
set intSessionID = f.idfAttempt
from tstNotificationStatus s
inner join tstNotification n on n.idfNotification = s.idfNotification
inner join [' + @AdminDBName + '].dbo.logNotificationToReplicationAttempt f on f.idfsSite = n.idfsSite and f.idfNotification = s.idfNotification
where s.intSessionID is NULL
and ISNULL(s.intProcessed, 0) <> 1'

exec sp_executesql @admincmd

set	@admincmd = N'update tstNotificationStatus
set intSessionID = f.idfAttempt
from tstNotificationStatus s
inner join tstNotificationShared n on n.idfNotificationShared = s.idfNotification
inner join [' + @AdminDBName + '].dbo.logNotificationToReplicationAttempt f on f.idfsSite = n.idfsSite and f.idfNotification = s.idfNotification
where s.intSessionID is NULL
and ISNULL(s.intProcessed, 0) <> 1'

exec sp_executesql @admincmd

-- set 0 if session_id is not running now
set	@admincmd = N'update tstNotificationStatus
set intSessionID = 0
where ISNULL(idfNotification, 0) not in (
  select idfNotification
  from  [' + @AdminDBName + '].dbo.logNotificationToReplicationAttempt
)
and ISNULL(intProcessed, 0) <> 1 and ISNULL(intSessionID, 0) <> 0'

exec sp_executesql @admincmd

-- tstNotification
Select		n.idfNotification, 
		idfUserID, 
		n.idfsSite, 
		datCreationDate, 
		datEnteringDate, 
		strPayload, 
		idfsNotificationType,
		ISNULL(s.intProcessed,0) AS intProcessed,
		idfsTargetSite,
		idfsTargetSiteType,
		idfTargetUserID,
		idfsNotificationObjectType,
		idfNotificationObject,
		st.idfsSiteType,
		n.strMaintenanceFlag,
		CAST(CASE WHEN st.idfsParentSite = @idfsSite THEN 1 ELSE 0 END as BIT) as blnChildNotification
From		tstNotification n
INNER Join	tstNotificationStatus s ON
		s.idfNotification = n.idfNotification
inner join tstSite st on n.idfsSite = st.idfsSite
Where 
	n.idfsSite<>@idfsSite 
	and ISNULL(s.intProcessed,0)<>1 
	and ISNULL(s.intSessionID,0)=0
	and DATEDIFF(day, n.datCreationDate, getdate())<=10
UNION ALL 
Select		
		ns.idfNotificationShared as idfNotification, 
		idfUserID, 
		ns.idfsSite, 
		datCreationDate, 
		datEnteringDate, 
		strPayload, 
		idfsNotificationType,
		ISNULL(s.intProcessed,0) AS intProcessed,
		idfsTargetSite,
		idfsTargetSiteType,
		idfTargetUserID,
		idfsNotificationObjectType,
		idfNotificationObject,
		st.idfsSiteType,
		ns.strMaintenanceFlag,
		CAST(CASE WHEN st.idfsParentSite = @idfsSite THEN 1 ELSE 0 END as BIT) as blnChildNotification
From	tstNotificationShared ns
INNER Join	tstNotificationStatus s ON
		s.idfNotification = ns.idfNotificationShared
inner join tstSite st on 
		ns.idfsSite = st.idfsSite
Where 
	ns.idfsSite<>@idfsSite 
	and ISNULL(s.intProcessed,0)<>1
	and ISNULL(s.intSessionID,0)=0
	and DATEDIFF(day, ns.datCreationDate, getdate())<=10


