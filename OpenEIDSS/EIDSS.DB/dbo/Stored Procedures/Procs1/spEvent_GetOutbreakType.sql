﻿



--##SUMMARY Returns object informaition related with OutbreakNotificationReceived event.
--##SUMMARY If event is related with human/vet case, the @CaseType parameter returns case Type ID from rftCaseType reference.
--##SUMMARY If event is related outbreak, the @CaseType parameter returns 1.
--##SUMMARY In other case @CaseType parameter returns NULL.


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfEventID bigint
DECLARE @idfObject bigint
DECLARE @EventType bigint
DECLARE @CaseType bigint


EXECUTE spEvent_GetOutbreakType
   @idfEventID
  ,@idfObject OUTPUT
  ,@EventType OUTPUT
  ,@CaseType OUTPUT

*/



CREATE          proc spEvent_GetOutbreakType(
	@idfEventID bigint, --##PARAM @idfEventID - event ID that should be checked
	@idfObject bigint = null out, --##PARAM @idfObject - returns ID of object to which event is belong (case or outbreak ID).
	@EventType bigint = null out, --##PARAM @EventType - returns event Type of event defined by @idfEventID
	@CaseType bigint = null out  --##PARAM @CaseType - returns NULL if event is not related with case/outbreak, case Type (from rftCaseType reference) if event is related with human/vet case or 1 if event is related with outbreak 
)
as


select	@idfObject = idfObjectID,
		@EventType = idfsEventTypeID
from 	tstEvent
where	idfEventID = @idfEventID
if @@ROWCOUNT = 0 
	return
if @idfObject is null 
	return
if @EventType = 10025018 --OutbreakNotificationReceived
begin
	declare @outbreakInfo varchar(50)
	select	@outbreakInfo = substring(strPayload, 0, 50)
	from	tstNotification
	where	idfNotification = @idfEventID
	BEGIN TRY
		set @idfObject = cast(@outbreakInfo AS BIGINT)
	END TRY
	BEGIN CATCH
		return
	END CATCH
end

SELECT
	@CaseType = idfsCaseType
FROM (
	select		10012001 AS idfsCaseType --human
	from		tlbHumanCase
	where		idfHumanCase = @idfObject
	UNION ALL
	select		idfsCaseType
	from		tlbVetCase
	where		idfVetCase = @idfObject
	) x
	

print 'CaseType = ' + IsNull(CAST(@CaseType AS NVARCHAR), N'')

if IsNull(@CaseType, 0) <> 0
	RETURN

IF EXISTS( SELECT * FROM tlbOutbreak WHERE idfOutbreak = @idfObject)
	SET @CaseType = 1 -- in such way we point to outpreak object here

return 




