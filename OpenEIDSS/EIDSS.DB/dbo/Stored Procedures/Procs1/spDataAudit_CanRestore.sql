

--##SUMMARY Checks if a Data Audit Event (Deleting) could be restore.
--##SUMMARY This procedure is called before restoring. Event can only be restored when the procedure allows it.
--##SUMMARY The event is allowed to restore, if:
--##SUMMARY 	- event type = 10016002 (Delete)
--##SUMMARY 	- current site type <> 10085007 (SS)
--##SUMMARY 	- the Main Object of the event dasn't be restored after the event posting
	
--##REMARKS Author: Zhdanova A.
--##REMARKS Date: 19.12.2011

--##RETURNS Returns 0 if the case can not be restored.
--##RETURNS Returns 1 if the case can be restored.


/*
--Example of procedure call:

    DECLARE @ID BIGINT
    DECLARE @Result INT
    
    select @ID = max(idfDataAuditEvent)
    from dbo.tauDataAuditEvent
    where idfsDataAuditEventType = 10016002
  --  and idfDataAuditEvent <>590001100
    
    print 'ID = '
    print @ID
	
    EXECUTE [spDataAudit_CanRestore] 
       @ID, @Result output
      
    PRINT   @Result

    print 'ID = 0'
    EXECUTE [spDataAudit_CanRestore] 
       0, @Result output
      
    PRINT   @Result
*/



create	procedure	[dbo].[spDataAudit_CanRestore]
( 
	@ID as bigint,--##PARAM  @ID - Event ID
	@Result as bit output --##PARAM  @Result 0 if the case can not be restored, 1 - otherwise
)
as
if	exists ( select * from  dbo.tauDataAuditEvent where idfDataAuditEvent = @ID and idfsDataAuditEventType = 10016002)
	and not exists(
		select *
		from dbo.tauDataAuditEvent as a
		inner join dbo.tauDataAuditEvent as b on a.idfMainObject = b.idfMainObject
			and a.datEnteringDate <= b.datEnteringDate
			and b.idfsDataAuditEventType = 10016005 --Restore
		where a.idfDataAuditEvent = @ID)
	and not exists(
		select *
		from dbo.tauDataAuditEvent as a
		inner join dbo.tauDataAuditEvent as b on a.idfMainObject = b.idfMainObject
			and a.datEnteringDate < b.datEnteringDate
			and b.idfsDataAuditEventType = 10016002 --delete
		where a.idfDataAuditEvent = @ID)
	and dbo.fnSiteType() <> 10085007
	set @Result = 1
else
	set @Result = 0

return @Result





