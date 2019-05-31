

create proc [dbo].[spGetDataAuditEvent](@event bigint output)
as
begin

set @event = null

declare @context varchar(50)
declare @context_b as varbinary(128)
set @context = dbo.fnGetContext()

select @event = idfDataAuditEvent
from dbo.tstLocalConnectionContext
where strConnectionContext = @context

IF NOT EXISTS (SELECT * FROM tauDataAuditEvent tdae WHERE tdae.idfDataAuditEvent = @event)
SET @event = NULL

if @event is null
begin
	exec dbo.[spsysGetNewID] @event output
	insert  into [tauDataAuditEvent] (
		[idfDataAuditEvent],
		[idfsDataAuditObjectType],
		[idfsDataAuditEventType],
		[idfMainObject],
		[idfMainObjectTable],
		[idfUserID],
		[idfsSite],
		[datEnteringDate],
		[strHostname]
	) 
	values
		(@event,
		NULL,
		10016004, --'daeFreeDataUpdate'
		null,
		null,
		dbo.fnUserID(),
		dbo.fnSiteID(),
		getdate(),
		HOST_NAME()
		)

	IF  @context is NULL OR @context = ''
		SET  @context = NewID()
		
	IF NOT EXISTS(SELECT * FROM dbo.[tstLocalConnectionContext] WHERE [strConnectionContext] = @context)
	BEGIN
		insert into dbo.[tstLocalConnectionContext](strConnectionContext,idfDataAuditEvent)
		values(@context, @event)
		set @context_b = cast(cast (@context as varchar(50)) as varbinary(128))
		SET CONTEXT_INFO @context_b
	END 
	ELSE 
		update dbo.[tstLocalConnectionContext]
		set idfDataAuditEvent = @event
		where strConnectionContext = @context
end
end









