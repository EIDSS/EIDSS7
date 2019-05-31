



--##SUMMARY Selects new events for passed client application.
--##SUMMARY Can be called by EIDSS, EIDSS Client Agent or by EIDSS Notification Service.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXEC spEventLog_SelectNewEvents 'en', '00110A967B9A', 0
*/

CREATE            procedure [dbo].[spEventLog_SelectNewEvents](
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@ClientID as nvarchar(50), --##PARAM @ClientID - client application ID, defined in application configuration file. If client ID is not defined there, client PC MAC addres is used as client ID.
	@IsNotificationClient as BIT --##PARAM @IsNotificationClient - bit flag that identifies was this procedure from EIDSS notification service or not
)
as

begin tran T1

declare @LastEvent as bigint
--declare @LastEventStr as nvarchar(200)
declare @CurrLastEvent as bigint
declare @idfUserID as bigint

select	@idfUserID = idfUserID 
from	tstUserTable 
where	strAccountName = SYSTEM_USER

set @CurrLastEvent = 0

select top 1 @CurrLastEvent = isnull(idfEventID, 0) 
from		tstEventActive
order by	idfEventID desc

print 'Last Reported Event = ' + convert(nvarchar(200), @CurrLastEvent)


IF @IsNotificationClient = 1 
BEGIN
	IF (select count(*) from tstNotificationActivity) > 0
		UPDATE	tstNotificationActivity
		SET		datLastNotificationActivity = GETDATE()
	ELSE
		INSERT INTO tstNotificationActivity (datLastNotificationActivity)
		VALUES (GetDate())	
END

select
	@LastEvent = idfLastEvent
from tstEventClient
where strClient = @ClientID

if @@ROWCOUNT = 0
begin
	print 'insert new event num ' + @ClientID + ',' + convert(nvarchar(200), @CurrLastEvent)
	insert into tstEventClient (strClient, idfLastEvent)
	values (@ClientID, @CurrLastEvent)
	commit tran T1
	return -1
end
else if @LastEvent is null
begin
	print 'update last event num ' + @ClientID + ',' + convert(nvarchar(200), @CurrLastEvent)
	update	tstEventClient
	set		idfLastEvent = @CurrLastEvent
	where	strClient = @ClientID
	commit tran T1
	return -1
end

print 'update last event num 1' + @ClientID + ',' + convert(nvarchar(200), @CurrLastEvent)

update	tstEventClient
set		idfLastEvent = @CurrLastEvent
where	strClient = @ClientID


if @@ERROR <> 0
begin
	print 'ERROR'
	if @@TRANCOUNT < 2
		rollback tran T1
	else
		commit tran T1
	return -1
end

print 'select all events after' + convert(nvarchar(200), @LastEvent)

if @LastEvent <> @CurrLastEvent
	select		idfEventID, 
				tstEventActive.idfsEventTypeID, 
				EventType.[name] as EventName, 
				idfObjectID, 
				strInformationString, 
				strNote, 
				datEventDatatime, 
				N'Any User' as TargetUser,
				tstEventActive.strClient,
				idfUserID,
				IsNull(tstEventActive.intProcessed, 0) as intProcessed,
				d.name as strDiagnosis,
				tstEventActive.idfsDiagnosis,
				region.name as strRegion,
				idfsRegion,
				rayon.name as strRayon,
				idfsRayon,
				tstSite.strSiteID as strSiteID,
				tstEventActive.idfsSite,
				tstSite.strHASCsiteID as strHASCsiteID,
				idfsLoginSite
	from		tstEventActive
	inner join	dbo.tstEventSubscription 
	on			tstEventSubscription.idfsEventTypeID = tstEventActive.idfsEventTypeID
	inner join trtEventType 
	on trtEventType.idfsEventTypeID = tstEventActive.idfsEventTypeID
	and trtEventType.intRowStatus=0
	join		fnReference(@LangID, 19000025) EventType --'rftEventType'
	on			EventType.idfsReference = tstEventActive.idfsEventTypeID
	LEFT join dbo.fnDiagnosisRepair(@LangID, null, null) d
	On			d.idfsDiagnosis = tstEventActive.idfsDiagnosis
	LEFT join dbo.fnGisReferenceRepair(@LangID, 19000002) rayon
	On			rayon.idfsReference = tstEventActive.idfsRayon
	LEFT join dbo.fnGisReferenceRepair(@LangID, 19000003) region
	On			region.idfsReference = tstEventActive.idfsRegion
	left join tstSite 
	on			tstSite.idfsSite = tstEventActive.idfsSite

	where		tstEventSubscription.strClient = @ClientID
				and tstEventActive.idfEventID > @LastEvent
				and tstEventActive.idfEventID <= @CurrLastEvent
				and (trtEventType.blnSubscription  = 1 or @IsNotificationClient = 1)
	UNION
	select		idfEventID, 
				tstEventActive.idfsEventTypeID, 
				EventType.[name] as EventName, 
				idfObjectID, 
				strInformationString, 
				strNote, 
				datEventDatatime, 
				N'Any User' as TargetUser,
				tstEventActive.strClient,
				idfUserID,
				IsNull(tstEventActive.intProcessed, 0) as intProcessed,
				N'' as strDiagnosis,
				idfsDiagnosis,
				N'' as strRegion,
				idfsRegion,
				N'' as strRayon,
				idfsRayon,
				N'' as strSiteID,
				CAST(NULL as bigint) as idfsSite,
				N'' as strHASCsiteID,
				CAST(NULL as bigint) as idfsLoginSite
	from		tstEventActive
	join		fnReference('en', 19000025) EventType --'rftEventType'
	on			EventType.idfsReference = tstEventActive.idfsEventTypeID

	WHERE 
				tstEventActive.idfsEventTypeID = 10025001 --'evtLanguageChanged'
				and tstEventActive.idfEventID > @LastEvent
				and tstEventActive.idfEventID <= @CurrLastEvent
				AND tstEventActive.strClient = @ClientID
	order by	tstEventActive.idfEventID desc
else
	select		idfEventID, 
				tstEventActive.idfsEventTypeID, 
				CAST(NULL AS NVARCHAR(200)) as EventName, 
				idfObjectID, 
				strInformationString, 
				strNote, 
				datEventDatatime, 
				N'Any User' as TargetUser,
				tstEventActive.strClient,
				idfUserID,
				IsNull(tstEventActive.intProcessed, 0) as intProcessed,
				CAST(NULL AS NVARCHAR(200)) as strDiagnosis,
				tstEventActive.idfsDiagnosis,
				CAST(NULL AS NVARCHAR(200)) as strRegion,
				idfsRegion,
				CAST(NULL AS NVARCHAR(200)) as strRayon,
				idfsRayon,
				CAST(NULL AS NVARCHAR(200)) as strSiteID,
				tstEventActive.idfsSite,
				CAST(NULL AS NVARCHAR(200)) as strHASCsiteID,
				tstEventActive.idfsLoginSite
	from		tstEventActive 
				where idfEventID IS NULL

commit tran T1




