

--##SUMMARY Checks if EIDSS Notification Service is running.
--##SUMMARY When running, EIDSS Notification Service writes current DateTime to tstLocalSiteOptions table.
--##SUMMARY This procedure checks if this record exists and calculates difference betwen current time and time of last 
--##SUMMARY last EIDSS Notification Service activity. If this difference exceeds 20 sec, EIDSS Notification Service is considered as inactive
--##SUMMARY and new event of evtNotificationServiceNotRunning Type is written to event log table

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXEC spEventLog_IsNtfyServiceRunning '12345'
*/




CREATE        procedure dbo.spEventLog_IsNtfyServiceRunning( 
		@idfsClient VARCHAR(36) --##PARAM @idfsClient - client application ID, defined in application configuration file. If client ID is not defined there, client PC MAC addres is used as client ID.
)
as
DECLARE @LastNotificationDate as DATETIME
DECLARE @LastEventDate as DATETIME
DECLARE @EventID AS BIGINT

SELECT	@LastNotificationDate = datLastNotificationActivity
FROM	tstNotificationActivity

SELECT  @LastEventDate = getDate()

if  @LastNotificationDate IS NULL  OR DateDIFF(second,@LastNotificationDate, @LastEventDate)>200
	EXEC	spEventLog_CreateNewEvent
				@idfsEventTypeID = 10025114, --'evtNotificationServiceNotRunning',
				@idfObjectID = NULL,
				@strInformationString = NULL,
				@strNote = NULL,
				@ClientID = @idfsClient, 
				@datEventDatatime = NULL,
				@EventID = @EventID


