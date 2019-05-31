--*************************************************************
-- Name 				: USP_GBL_DATAAUDITEVENT_SET
-- Description			: SET Address
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:

--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_DATAAUDITEVENT_SET]
(
	@event BIGINT OUTPUT
)
AS
BEGIN

	SET @event = NULL

	DECLARE @context VARCHAR(50)
	DECLARE @context_b as VARBINARY(128)
	SET @context = dbo.fnGetContext()

	SELECT @event = idfDataAuditEvent
	FROM dbo.tstLocalConnectionContext
	WHERE strConnectionContext = @context

	IF NOT EXISTS (SELECT * FROM tauDataAuditEvent tdae WHERE tdae.idfDataAuditEvent = @event)
	SET @event = NULL

	IF @event IS NULL
	BEGIN
		EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tauDataAuditEvent', @event OUTPUT
		INSERT  
		INTO [tauDataAuditEvent] 
			(
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
		VALUES
			(@event,
			NULL,
			10016004, --'daeFreeDataUpdate'
			NULL,
			NULL,
			dbo.fnUserID(),
			dbo.fnSiteID(),
			getdate(),
			HOST_NAME()
			)

		IF  @context IS NULL OR @context = ''
			SET  @context = NewID()
		
		IF NOT EXISTS(SELECT * FROM dbo.[tstLocalConnectionContext] WHERE [strConnectionContext] = @context)
			BEGIN
				INSERT INTO dbo.[tstLocalConnectionContext](strConnectionContext,idfDataAuditEvent)
				VALUES(@context, @event)
				SET @context_b = cast(cast (@context as VARCHAR(50)) as VARBINARY(128))
				SET CONTEXT_INFO @context_b
			END 
		ELSE 
			BEGIN
				update dbo.[tstLocalConnectionContext]
				SET idfDataAuditEvent = @event
				WHERE strConnectionContext = @context
			END
	END
END









