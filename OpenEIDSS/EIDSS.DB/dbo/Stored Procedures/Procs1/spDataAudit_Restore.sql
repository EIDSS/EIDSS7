
--##SUMMARY Restores records related with deleted object
--##SUMMARY
--##SUMMARY

--##REMARKS Author: Zurin M
--##REMARKS Create date: 14.11.2011
--##REMARKS Updated by: Zhdanova A
--##REMARKS Update date: 05.12.2011

--##RETURNS  0  success
--			 - 1 record was not deleted

/*
--Example of procedure call:

    DECLARE @ID BIGINT
    DECLARE @RC INT

	
    EXECUTE @RC = spDataAudit_Restore 
       @ID, 1
      
    PRINT   @RC
    
    select @ID = max(idfDataAuditEvent)
    from dbo.tauDataAuditEvent
    where idfsDataAuditEventType = 10016002
    
    print 'ID = '
    print @ID
	
    EXECUTE @RC = spDataAudit_Restore 
       @ID, 1
      
    PRINT   @RC
    
*/
create PROCEDURE [dbo].[spDataAudit_Restore]
	@idfDataAuditEvent bigint,--##PARAM @idfDataAuditEvent - ID of deleting event that mast be restore
	@Print int = 0 --##PARAM @Print  0 - execute, 1 - execute+print, 2 - print
AS
	DECLARE @auditEventType BIGINT
	SELECT @auditEventType= idfsDataAuditEventType FROM tauDataAuditEvent WHERE idfDataAuditEvent = @idfDataAuditEvent
	IF (@auditEventType IS NULL OR @auditEventType<> 10016002) --Delete
		RETURN -1 -- can't restore record because it was not deleted
	BEGIN TRAN
		--- create new event if it needed
		declare @event bigint
		set @event = null

		declare @context varchar(50)
		declare @context_b as varbinary(128)
		set @context = dbo.fnGetContext()

		select @event = idfDataAuditEvent
		from dbo.tstLocalConnectionContext
		where strConnectionContext = @context

		if @event is null
		or not exists(select * from tauDataAuditEvent WHERE idfDataAuditEvent = @event and [idfsDataAuditEventType] = 10016005) -- incorrect event type
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
			select 
				@event,
				[idfsDataAuditObjectType],
				10016005, --Restore
				[idfMainObject],
				[idfMainObjectTable],
				dbo.fnUserID(),
				dbo.fnSiteID(),
				getdate(),
				HOST_NAME()			
			FROM tauDataAuditEvent WHERE idfDataAuditEvent = @idfDataAuditEvent

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

		--- restore itself
		DECLARE @tableName varchar(200)
		DECLARE @RowStatusExist bit

		DECLARE crAuditDetail Cursor 
		FOR
			SELECT distinct tauTable.strName
			FROM tauDataAuditDetailDelete
			INNER JOIN tauTable 
				ON tauTable.idfTable = tauDataAuditDetailDelete.idfObjectTable
			WHERE 
				idfDataAuditEvent=@idfDataAuditEvent

		OPEN crAuditDetail
		FETCH NEXT FROM crAuditDetail INTO @tableName
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- print @tableName
			
			DECLARE @sql NVARCHAR(MAX)
			DECLARE @pkColumn NVARCHAR(100), @pkColumn2 NVARCHAR(100)
			DECLARE @index int

			SELECT @index = COUNT(*)
			from INFORMATION_SCHEMA.KEY_COLUMN_USAGE as a
			inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS as b
			on a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
			where b.CONSTRAINT_TYPE = 'PRIMARY KEY'
			and a.TABLE_NAME = 	@tableName
			
			IF (@index is null or @index > 2 or @index < 1)
			begin
				--print @index
				RAISERROR('Unsupported count of primary keys', 16,1)
			end
			ELSE IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=@tableName AND COLUMN_NAME = 'intRowStatus')
				RAISERROR('Table %s contains no intRowStatus column and can''t be restored', 0 --information only
					,1, @tableName)
			ELSE	
			BEGIN

				SELECT @pkColumn = a.COLUMN_NAME
				from INFORMATION_SCHEMA.KEY_COLUMN_USAGE as a
				inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS as b
				on a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
				where b.CONSTRAINT_TYPE = 'PRIMARY KEY'
				and a.TABLE_NAME = 	@tableName
				
				IF @index = 2
					SELECT @pkColumn2 = a.COLUMN_NAME
					from INFORMATION_SCHEMA.KEY_COLUMN_USAGE as a
					inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS as b
					on a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
					where b.CONSTRAINT_TYPE = 'PRIMARY KEY'
					and a.TABLE_NAME = 	@tableName
					and not @pkColumn = a.COLUMN_NAME
	--update Del 
	--set Del.intRowStatus = 0
	--from tauDataAuditDetailDelete as a
	--inner join tauDataAuditEvent as a1
	--	on a.idfDataAuditEvent = a1.idfDataAuditEvent

	--left join tauDataAuditDetailDelete as b -- last deleted (*) before current
	--	inner join tauDataAuditEvent as b1
	--	on b.idfDataAuditEvent = b1.idfDataAuditEvent
	--	left join tauDataAuditDetailDelete as bb -- try to connect to latest "delete" for check
	--		inner join tauDataAuditEvent as bb1
	--		on bb.idfDataAuditEvent = bb1.idfDataAuditEvent
	--	on b.idfObject = bb.idfObject and b1.datEnteringDate < bb1.datEnteringDate
	--	and bb1.idfDataAuditEvent <> 4575930000000 --!!!!!!!!
	--on a.idfObject = b.idfObject and a1.datEnteringDate > b1.datEnteringDate
	--and bb1.idfDataAuditEvent is null -- this record is last "delete" before current

	--left join tauDataAuditDetailRestore as c -- restore after (*) and before current
	--	inner join tauDataAuditEvent as c1
	--	on c.idfDataAuditEvent = c1.idfDataAuditEvent
	--on a.idfObject = c.idfObject and a1.datEnteringDate > c1.datEnteringDate and c1.datEnteringDate > b1.datEnteringDate	

	--inner join tlbFarmActual as Del
	--on a.idfObject = Del.idfFarmActual 
	--where (	b1.idfDataAuditEvent is null -- not deleted befor current at all
	--		or c1.idfDataAuditEvent is not null) -- this record was deleted before current and it restored
	--and a.idfDataAuditEvent = 4575930000000

				SET @sql = '
	update Del 
	set Del.intRowStatus = 0
	from tauDataAuditDetailDelete as a
	inner join tauDataAuditEvent as a1
	on a.idfDataAuditEvent = a1.idfDataAuditEvent

	left join tauDataAuditDetailDelete as b -- last deleted (*) before current
		inner join tauDataAuditEvent as b1
		on b.idfDataAuditEvent = b1.idfDataAuditEvent
		left join tauDataAuditDetailDelete as bb -- try to connect to latest "delete" for check
			inner join tauDataAuditEvent as bb1
			on bb.idfDataAuditEvent = bb1.idfDataAuditEvent
		on b.idfObject = bb.idfObject and b1.datEnteringDate < bb1.datEnteringDate
		and bb1.idfDataAuditEvent <> ' +CAST(@idfDataAuditEvent as NVARCHAR) +'
	on a.idfObject = b.idfObject and a1.datEnteringDate > b1.datEnteringDate
	and bb1.idfDataAuditEvent is null -- this record is last "delete" before current

	left join tauDataAuditDetailRestore as c -- restore after (*) and before current
		inner join tauDataAuditEvent as c1
		on c.idfDataAuditEvent = c1.idfDataAuditEvent
	on a.idfObject = c.idfObject and a1.datEnteringDate > c1.datEnteringDate and c1.datEnteringDate > b1.datEnteringDate	

	inner join ' + @tableName + ' as Del'
				IF @index = 2
					SET @sql = @sql + '
	on (a.idfObject = Del.'+ @pkColumn + ' and a.idfObjectDetail = Del.'+ @pkColumn2 + ')
		or (a.idfObject = Del.'+ @pkColumn2 + ' and a.idfObjectDetail = Del.'+ @pkColumn + ')'
				ELSE
					SET @sql = @sql + '
	on a.idfObject = Del.'+ @pkColumn + ' '
				SET @sql = @sql + '
	where (	b1.idfDataAuditEvent is null			-- not deleted befor current at all
			or bb1.idfDataAuditEvent is not null	-- this record is not last "delete" before current
			or c1.idfDataAuditEvent is not null)	-- this record is last "delete" before current and it restored
	and a.idfDataAuditEvent = ' +CAST(@idfDataAuditEvent as NVARCHAR)
														
				if @Print > 0 print @sql
				if @Print < 2 EXEC sp_executesql @sql
			END

			FETCH NEXT FROM crAuditDetail INTO @tableName
		END
		CLOSE crAuditDetail
		DEALLOCATE crAuditDetail


	COMMIT TRAN
RETURN 0
