



--##SUMMARY Populates case parameters related with specifi system event.
--##SUMMARY Called by EventList form for opening case detail form related with event.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @idfEventID bigint
DECLARE @idfCase bigint
DECLARE @EventType bigint
DECLARE @CaseType bigint

SELECT TOP 1 @idfEventID = idfEventID
FROM tstEvent 
WHERE idfsEventTypeID = 10025014 OR idfsEventTypeID = 10025010 
	
EXECUTE spEvent_GetCaseType
   @idfEventID
  ,@idfCase OUTPUT
  ,@EventType OUTPUT
  ,@CaseType OUTPUT

Print @idfCase
Print @EventType
Print @CaseType
*/




CREATE          proc spEvent_GetCaseType(
	@idfEventID bigint, --##PARAM @idfEventID - event ID 
	@idfCase bigint = null out, --##PARAM @idfCase -  ID of case related with event, can be NULL
	@EventType bigint = null out, --##PARAM @EventType - event Type
	@CaseType bigint = 0 out,  --##PARAM @CaseType - case Type, if event related with case or NULL in other case
	@strInformationString nvarchar(200) = null out  --##PARAM @infoString - case Type, if event related with case or NULL in other case
)
as

select	@idfCase = idfObjectID,
		@EventType = idfsEventTypeID,
		@strInformationString = strInformationString
from 	tstEvent
where	idfEventID = @idfEventID
if @@ROWCOUNT = 0 
	return
if @idfCase is null 
	return
--if @EventType = 10056011 --'evtOutbreakNotificationReceived'
--begin
--	declare @outbreakInfo varchar(50)
--	select	@outbreakInfo = substring(strPayload, 0, 50)
--	from	dbo.tstNotification
--	where	idfNotification = @idfEventID
--	if ISNUMERIC(@outbreakInfo) = 1
--		set @idfCase = cast(@outbreakInfo as bigint)
--end

SELECT
	@CaseType = idfsCaseType
FROM (
	select		10012001 AS idfsCaseType --human
	from		tlbHumanCase
	where		idfHumanCase = @idfCase
	UNION ALL
	select		idfsCaseType
	from		tlbVetCase
	where		idfVetCase = @idfCase
	) x
	
return 




