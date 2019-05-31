
--##SUMMARY 

--##REMARKS Author: Zhdanova A.
--##REMARKS Modificateion date: 05.12.2011

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE [spSpecCreateTriggers2] 'trtDiagnosis', 2

EXECUTE [spSpecCreateTriggers2] 'tstObjectAccess'

EXECUTE [spSpecCreateTriggers2] 'tlbCase', 2

*/

create        proc [dbo].[spSpecCreateTriggers2](
	@TableName varchar(200),--##PARAM @TableName - input: name of table 
	@Print int = 0	--##PARAM @Print - input: ( 0 - create triggers, 1 - print triggers script, 2 - create & print)
	)
AS


EXEC dbo.spsysUpdateTableAndColumnListForAudit @TableName



declare @Bloc varchar(2000), @Sql varchar(8000),@Sql2 varchar(8000),@Sql3 varchar(8000),@Sql4 varchar(8000),@Sql5 varchar(8000),@Sql6 varchar(8000)
DECLARE @Sql7 varchar(8000),@Sql8 varchar(8000),@Sql9 varchar(8000),@Sql10 varchar(8000),@Sql11 varchar(8000),@Sql12 varchar(8000),@Sql13 varchar(8000)
DECLARE @Sql14 varchar(8000),@Sql15 varchar(8000)
declare @IDColumnName varchar(200),@IDColumnName2 varchar(200), @Column varchar(200)
DECLARE @TableN BIGINT, @IDColumnNameN BIGINT, @IDColumnName2N BIGINT, @ColumnN BIGINT
declare @BaseTableName varchar(200)
DECLARE @BaseTableN BIGINT
declare @IDBaseColumnName varchar(200)
declare @TriggerName varchar(200)
declare @Site bit, @Date bit, @Status BIT, @ModifDate bit, @MaintenanceFlag bit

set @Bloc = ''
set @Sql = ''
set @Sql2 = ''
set @Sql3 = ''
set @Sql4 = ''
set @Sql5 = ''
set @Sql6 = ''
set @Sql7 = ''
set @Sql8 = ''
set @Sql9 = ''
set @Sql10 = ''
set @Sql11 = ''
set @Sql12 = ''
set @Sql13 = ''
set @Sql14 = ''
set @Sql15 = ''

--- table name
if left(@TableName,4) = 'dbo.'
set @TableName = substring(@TableName,5,len(@TableName))

SELECT @TableN = [idfTable]
FROM [tauTable] WHERE [strName] = @TableName


--- primary key
set @IDColumnName2 = NULL
set @IDColumnName2N = NULL

declare _T cursor fast_forward for
select a.COLUMN_NAME
from INFORMATION_SCHEMA.KEY_COLUMN_USAGE as a
inner join INFORMATION_SCHEMA.TABLE_CONSTRAINTS as b
on a.CONSTRAINT_NAME = b.CONSTRAINT_NAME
where b.CONSTRAINT_TYPE = 'PRIMARY KEY'
and a.TABLE_NAME = @TableName
open _T

fetch next from _T into @IDColumnName

SELECT @IDColumnNameN = [idfColumn]
FROM [tauColumn] WHERE [strName] = @IDColumnName AND [idfTable] = @TableN 

if @@FETCH_Status=0
	BEGIN 
	fetch next from _T into @IDColumnName2
	SELECT @IDColumnName2N = [idfColumn]
	FROM [tauColumn] WHERE [strName] = @IDColumnName2 AND [idfTable] = @TableN 
	END 

close _T
deallocate _T

--- special columns
set @Site = 0
set @Date = 0
set @Status = 0
if exists(select *
from INFORMATION_SCHEMA.COLUMNS as a
where a.TABLE_NAME = @TableName and a.COLUMN_NAME  = 'idfsSite')
	set @Site = 1

if exists(select *
from INFORMATION_SCHEMA.COLUMNS as a
where a.TABLE_NAME = @TableName and a.COLUMN_NAME  = 'datEnteringDate')
	set @Date = 1

if exists(select *
from INFORMATION_SCHEMA.COLUMNS as a
where a.TABLE_NAME = @TableName and a.COLUMN_NAME  = 'intRowStatus')
	set @Status = 1
	
if exists(select *
from INFORMATION_SCHEMA.COLUMNS as a
where a.TABLE_NAME = @TableName and a.COLUMN_NAME  = 'datModificationForArchiveDate')
	set @ModifDate = 1
	
if exists(select *
from INFORMATION_SCHEMA.COLUMNS as a
where a.TABLE_NAME = @TableName and a.COLUMN_NAME  = 'strMaintenanceFlag')
	set @MaintenanceFlag = 1

------------------------------------------------------------------
--- base table
declare @Tname varchar(200), @Cname varchar(200), @RowStatus varchar(200)
declare @p int

set @BaseTableName = @TableName
set @IDBaseColumnName = @IDColumnName

IF @IDColumnName2N is null  --NOT  @Status = 1
begin
	set @p = 1
	while @p = 1
		begin
		select	@Tname = cc.name, @Cname = c.name, @RowStatus = d.COLUMN_NAME
		from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as a
		inner join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as a1 on a.CONSTRAINT_NAME = a1.CONSTRAINT_NAME
		left join INFORMATION_SCHEMA.KEY_COLUMN_USAGE as b1 on a.UNIQUE_CONSTRAINT_NAME = b1.CONSTRAINT_NAME
		left join sys.indexes as c1 on a.UNIQUE_CONSTRAINT_NAME = c1.name
		left join sys.index_columns as c2 on c2.object_id =c1.object_id and c2.index_id = c1.index_id
		left join sys.columns as c on c.object_id = c2.object_id and c.column_id = c2.column_id
		left join sys.objects as cc on c.object_id = cc.object_id
		left join INFORMATION_SCHEMA.COLUMNS as d on cc.name = d.TABLE_NAME and d.COLUMN_NAME = 'intRowStatus'
		where  a1.TABLE_NAME = @BaseTableName and a1.COLUMN_NAME=@IDBaseColumnName
			
		if @@rowcount = 0 set @p = 0
		
		if @Tname is not null and @Cname is not null
			begin
			set @BaseTableName = @Tname
			set @IDBaseColumnName = @Cname
			end
		else
			set @p = 0
		
		if @RowStatus is not null set @p = 0
		
--		PRINT @Tname

		end

	if @Print >=1 print '---- Base Table: ' + @BaseTableName
	if @Print >=1 print '---- Base ID Column: ' + @IDBaseColumnName 

	if @RowStatus is null
	begin
		set @BaseTableName = @TableName
		set @IDBaseColumnName = @IDColumnName
	end

	SELECT @BaseTableN = [idfTable]
	FROM [tauTable] WHERE [strName] = @BaseTableName
end			

------------------------------------------------------------------
------- INSERT ---------------------------------------------------

set @TriggerName = 'tr'+ @TableName + 'Insert'

set @Sql = '
if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + @TriggerName + ']'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)
drop trigger [dbo].[' + @TriggerName + ']'

if @Print >= 1 print @Sql
if @Print >= 1 print 'GO'
if (@Print >= 2 or @Print = 0) exec(@Sql)

set @Sql = '
create  trigger ' + @TriggerName + ' on dbo.'+ @TableName + '	
for insert
NOT FOR REPLICATION
as

declare @event bigint
DECLARE @context VARCHAR(50)
SET @context = dbo.fnGetContext()
'
set @Sql = @Sql + '
if((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1))
begin
	'
if (@Site = 1 or @Date = 1 or @Status = 1)
begin
	set @Sql = @Sql + '
	if (ISNULL(@context, '''') <> ''DataMigration'')
		update a
		set ' 
		if @Site = 1 set @Sql = @Sql + 'idfsSite = isnull(a.idfsSite, dbo.fnSiteID())'
		if @Date = 1
			begin
			if @Site = 1 set @Sql = @Sql + '
			,'
			set @Sql = @Sql + ' datEnteringDate = getdate()'
			end
		if @Status = 1
			begin
			if @Site = 1 or @Date = 1 set @Sql = @Sql + '
			,'
			set @Sql = @Sql + ' intRowStatus = 0'
			END
		if @ModifDate = 1
			begin
			if @Status = 1 or @Site = 1 or @Date = 1 set @Sql = @Sql + '
			,'
			set @Sql = @Sql + ' datModificationForArchiveDate = getdate()'
			end
		set @Sql = @Sql +
	'
		from dbo.'+ @TableName + ' as a inner join inserted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName 
		if @IDColumnName2 is not null
			set @Sql = @Sql + '
		and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2
end

set @Sql = @Sql + '

	exec [dbo].[spGetDataAuditEvent] @event output
'
		
	set @Sql = @Sql + '
	INSERT INTO dbo.tauDataAuditDetailCreate( idfDataAuditEvent, idfObjectTable, 
		idfObject, idfObjectDetail)
	select distinct @event,'+ CAST(@TableN AS VARCHAR(50)) +',
		a.'+@IDColumnName +','+ case when @IDColumnName2 is null then 'null' else ' a.'+@IDColumnName2 end + '
	from inserted as a	
	'

set @Sql = @Sql + '
end '

if @Print >= 1 print @Sql
if @Print >= 1 print 'GO'
if (@Print >= 2 or @Print = 0) exec(@Sql)

-------------------------------------------------------------------------------------------
------------------------------------------- DELETE ----------------------------------------
set @TriggerName = 'tr'+ @TableName + 'Delete'

set @Sql = '
if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + @TriggerName + ']'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)
drop trigger [dbo].[' + @TriggerName + ']'

if @Print >= 1 print @Sql
if @Print >= 1 print 'GO'
if (@Print >= 2 or @Print = 0) exec(@Sql)

--if @Status = 1 
	set @Sql = '
CREATE      trigger ' + @TriggerName + ' on dbo.'+ @TableName + '
INSTEAD OF  delete
NOT FOR REPLICATION
as

DECLARE @context VARCHAR(50)
SET @context = dbo.fnGetContext()

if((TRIGGER_NESTLEVEL()<2) AND (dbo.fnTriggersWork ()=1) AND (ISNULL(@context, '''') <> ''DataArchiving'') AND (ISNULL(@context, '''') <> ''DataMigration'') AND (ISNULL(@context, '''') <> ''ResolveConflict''))
begin
'


if (@Date = 1 or @Status = 1 OR @ModifDate = 1)
begin
	set @Sql = @Sql + '
	update a
	set ' 
	if @Date = 1
		begin
		set @Sql = @Sql + ' datEnteringDate = getdate()'
		end
	if @Status = 1
		begin
		if  @Date = 1 set @Sql = @Sql + '
		,'
		set @Sql = @Sql + ' intRowStatus = 1'
		END
	if @ModifDate = 1
		begin
		if @Status = 1 OR @Date = 1 set @Sql = @Sql + '
		,'
		set @Sql = @Sql + ' datModificationForArchiveDate = getdate()'
		end
	set @Sql = @Sql +
'
	from dbo.'+ @TableName + ' as a inner join deleted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName 
	if @IDColumnName2 is not null
		set @Sql = @Sql + '
	and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2
end

IF NOT @BaseTableName = @TableName
BEGIN 
----- Parent Status Update
set @Sql = @Sql + '

--- Parent Status Update
	update a
	set  intRowStatus = 1'
	set @Sql = @Sql +
'
	from dbo.'+ @BaseTableName + ' as a inner join deleted as b on a.' + @IDBaseColumnName + ' = b.' + @IDColumnName 
END 

set @Sql = @Sql + '


	declare @event bigint
	exec [dbo].[spGetDataAuditEvent] @event output
'
		
	set @Sql = @Sql + '
	INSERT INTO dbo.tauDataAuditDetailDelete( idfDataAuditEvent, idfObjectTable, 
		idfObject, idfObjectDetail)
	select distinct @event,'+ CAST(@TableN AS VARCHAR(50)) +',
		a.'+@IDColumnName +','+ case when @IDColumnName2 is null then 'null' else ' a.'+@IDColumnName2 end + '
	from deleted as a'


set @Sql = @Sql + '
end'

--if @Status = 1
--	begin 
	set @Sql = @Sql + '
else
delete a
from dbo.'+ @TableName + ' as a inner join deleted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName + '
'
	if @IDColumnName2 is not null
		set @Sql = @Sql + '
and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2
--	end

if @Print >= 1 print @Sql
if @Print >= 1 print 'GO'
if (@Print >= 2 or @Print = 0) exec(@Sql)

-----------------------------------------------------------------------------------------
------------- Update --------------------------------------------------------------------

set @Bloc = ''
set @Sql = ''
set @Sql2 = ''
set @Sql3 = ''
set @Sql4 = ''
set @Sql5 = ''
set @Sql6 = ''
set @Sql7 = ''
set @Sql8 = ''
set @Sql9 = ''
set @Sql10 = ''
set @Sql11 = ''
set @Sql12 = ''
set @Sql13 = ''
set @Sql14 = ''
set @Sql15 = ''

set @TriggerName = 'tr'+ @TableName + 'Update'

set @Sql = '
if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + @TriggerName + ']'') and OBJECTPROPERTY(id, N''IsTrigger'') = 1)
drop trigger [dbo].[' + @TriggerName + ']'

if @Print >= 1 print @Sql
if @Print >= 1 print 'GO'
if (@Print >= 2 or @Print = 0) exec(@Sql)


set @Sql = '
CREATE        trigger ' + @TriggerName + ' on dbo.'+ @TableName + '
FOR UPDATE
NOT FOR REPLICATION
as

IF (TRIGGER_NESTLEVEL()<2)
BEGIN

	DECLARE @context VARCHAR(50)
	SET @context = dbo.fnGetContext()

	DECLARE @NotMaintenanceFlagFieldUpdate BIT = 0
	IF EXISTS
	 ('

	DECLARE @UpdateCheck VARCHAR(8000) = ''

	DECLARE _UpdateCheckCursor CURSOR FAST_FORWARD FOR
	SELECT 
		a.COLUMN_NAME
	FROM INFORMATION_SCHEMA.COLUMNS AS a
	INNER JOIN [tauColumn] AS b
		ON a.COLUMN_NAME = b.[strName] COLLATE DATABASE_DEFAULT
	INNER JOIN [tauTable] AS c
		ON b.[idfTable] = c.[idfTable]
		AND a.TABLE_NAME = c.[strName] COLLATE DATABASE_DEFAULT
	WHERE a.TABLE_NAME = @TableName
		AND a.DATA_TYPE NOT IN ('text', 'ntext', 'xml', 'image')
		AND a.COLUMN_NAME NOT IN (ISNULL(@IDColumnName, ''), ISNULL(@IDColumnName2, ''), 'strMaintenanceFlag')
	ORDER BY ORDINAL_POSITION

	OPEN _UpdateCheckCursor
	FETCH NEXT FROM _UpdateCheckCursor INTO @Column
	WHILE @@fetch_status = 0
		BEGIN
			SET @UpdateCheck = @UpdateCheck + ', ' + @Column
			
			FETCH NEXT FROM _UpdateCheckCursor INTO @Column
		END
	CLOSE _UpdateCheckCursor
	DEALLOCATE _UpdateCheckCursor

	SET @Sql = @Sql + '
		SELECT ' + @IDColumnName
	 
	IF @IDColumnName2 IS NOT NULL
	SET @Sql = @Sql + ', ' + @IDColumnName2

	SET @Sql = @Sql + @UpdateCheck + ' FROM deleted
		EXCEPT
		SELECT '  + @IDColumnName
		
	IF @IDColumnName2 IS NOT NULL
	SET @Sql = @Sql + ', ' + @IDColumnName2

	SET @Sql = @Sql + @UpdateCheck + ' FROM inserted
	)
	SET @NotMaintenanceFlagFieldUpdate = 1
	'			





	if ( @ModifDate = 1)
	begin
		set @Sql = @Sql + '
	IF ((ISNULL(@context, '''') <> ''DataArchiving'') AND @NotMaintenanceFlagFieldUpdate = 1)	
			update a
			set ' 
		set @Sql = @Sql + 'datModificationForArchiveDate = getdate()'
		set @Sql = @Sql +
	'
			from dbo.'+ @TableName + ' as a inner join inserted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName 
		if @IDColumnName2 is not null
			set @Sql = @Sql + '
			and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2
	end

	set @Sql = @Sql + '
	if((dbo.fnTriggersWork ()=1) AND (ISNULL(@context, '''') <> ''DataMigration'') AND @NotMaintenanceFlagFieldUpdate = 1)
	begin
		if  (UPDATE(' + @IDColumnName + ') 
			and exists (select * from deleted as a 
				left join inserted as b on a.'+ @IDColumnName +' = b.'+ @IDColumnName +' where b.'+ @IDColumnName +' is null))'
	if @IDColumnName2 is not null set @Sql = @Sql + ' 
			or (UPDATE(' + @IDColumnName2 + ')
			and exists (select * from deleted as a 
				left join inserted as b on a.'+ @IDColumnName +' = b.'+ @IDColumnName +' 
				and a.'+ @IDColumnName2 +' = b.'+@IDColumnName2+' where b.'+@IDColumnName+' is null))'

	set @Sql = @Sql + '
			begin
			raiserror(''Update Trigger: Illegal data changing error!'',16,1)
			ROLLBACK TRANSACTION
			end
		else
			begin' 

	if ( @Date = 1)
	begin
		set @Sql = @Sql + '
			update a
			set ' 
		set @Sql = @Sql + ' datEnteringDate = getdate()'
		set @Sql = @Sql +
	'
			from dbo.'+ @TableName + ' as a inner join inserted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName 
		if @IDColumnName2 is not null
			set @Sql = @Sql + '
			and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2
	END


	set @Sql = @Sql + '
			
			declare @event bigint
			exec [dbo].[spGetDataAuditEvent] @event output

	'

	set @Sql2 = ''
	declare _C3 cursor fast_forward for
	select a.COLUMN_NAME, b.[idfColumn]
	from INFORMATION_SCHEMA.COLUMNS as a
	INNER JOIN [tauColumn] AS b
		ON a.COLUMN_NAME = b.[strName] COLLATE DATABASE_DEFAULT
	INNER JOIN [tauTable] AS c
		ON b.[idfTable] = c.[idfTable]
		AND a.TABLE_NAME = c.[strName] COLLATE DATABASE_DEFAULT
	where a.TABLE_NAME = @TableName
		and a.DATA_TYPE not in ('text', 'ntext')
		AND a.COLUMN_NAME NOT IN (ISNULL(@IDColumnName, ''), ISNULL(@IDColumnName2, ''))
	order by ORDINAL_POSITION

	open _C3
	fetch next from _C3 into @Column, @ColumnN
	while @@fetch_status = 0
		BEGIN
	--	PRINT @Column
			set @Bloc = '
			insert into dbo.tauDataAuditDetailUpdate(
				idfDataAuditEvent, idfObjectTable, idfColumn, 
				idfObject, idfObjectDetail, 
				strOldValue, strNewValue)
			select @event,'+cast(@TableN as varchar(50)) +', '+cast(@ColumnN as varchar(50)) +',
				a.'+@IDColumnName +','+ case when @IDColumnName2 is null then 'null' else 'a.'+@IDColumnName2 end + ',
				b.'+@Column +',a.'+@Column +' 
			from inserted as a full join deleted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName 

			if @IDColumnName2 is not null
				set @Bloc = @Bloc + '
			and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2 
			set @Bloc = @Bloc + '
			where (a.'+@Column+' <> b.'+@Column+') 
				or(a.'+@Column +' is not null and b.'+@Column +' is null)
				or(a.'+@Column +' is null and b.'+@Column +' is not null)
	'
		

		if len(@Sql)<6000 set @Sql = @Sql + @Bloc
		else if len(@Sql2)<6000 set @Sql2 = @Sql2 + @Bloc
			else if len(@Sql3)<6000 set @Sql3 = @Sql3 + @Bloc
				else if len(@Sql4)<6000 set @Sql4 = @Sql4 + @Bloc
					else if len(@Sql5)<6000 set @Sql5 = @Sql5 + @Bloc
						else if len(@Sql6)<6000 set @Sql6 = @Sql6 + @Bloc
						else if len(@Sql7)<6000 set @Sql7 = @Sql7 + @Bloc
						else if len(@Sql8)<6000 set @Sql8 = @Sql8 + @Bloc
						else if len(@Sql9)<6000 set @Sql9 = @Sql9 + @Bloc
						else if len(@Sql10)<6000 set @Sql10 = @Sql10 + @Bloc
						else if len(@Sql11)<6000 set @Sql11 = @Sql11 + @Bloc
						else if len(@Sql12)<6000 set @Sql12 = @Sql12 + @Bloc
						else if len(@Sql13)<6000 set @Sql13 = @Sql13 + @Bloc
						else if len(@Sql14)<6000 set @Sql14 = @Sql14 + @Bloc
						else if len(@Sql15)<6000 set @Sql15 = @Sql15 + @Bloc
							else raiserror('Too long string during update trigger creation!',16,1)

		fetch next from _C3 into @Column, @ColumnN
		end
	close _C3
	deallocate _C3

	if @Status = 1 --- looking for Restore!!!
	begin 
			set @Bloc = '
			insert into dbo.tauDataAuditDetailRestore(
				idfDataAuditEvent, idfObjectTable, 
				idfObject, idfObjectDetail)
			select @event,'+cast(@TableN as varchar(50)) +',
				a.'+@IDColumnName +','+ case when @IDColumnName2 is null then 'null' else 'a.'+@IDColumnName2 end + '
			from inserted as a full join deleted as b on a.' + @IDColumnName + ' = b.' + @IDColumnName 

			if @IDColumnName2 is not null
				set @Bloc = @Bloc + '
			and a.' + @IDColumnName2 + ' = b.' + @IDColumnName2
		
			set @Bloc = @Bloc + '
			where a.intRowStatus = 0 AND b.intRowStatus = 1 
	'

		if len(@Sql)<6000 set @Sql = @Sql + @Bloc
		else if len(@Sql2)<6000 set @Sql2 = @Sql2 + @Bloc
			else if len(@Sql3)<6000 set @Sql3 = @Sql3 + @Bloc
				else if len(@Sql4)<6000 set @Sql4 = @Sql4 + @Bloc
					else if len(@Sql5)<6000 set @Sql5 = @Sql5 + @Bloc
						else if len(@Sql6)<6000 set @Sql6 = @Sql6 + @Bloc
						else if len(@Sql7)<6000 set @Sql7 = @Sql7 + @Bloc
						else if len(@Sql8)<6000 set @Sql8 = @Sql8 + @Bloc
						else if len(@Sql9)<6000 set @Sql9 = @Sql9 + @Bloc
						else if len(@Sql10)<6000 set @Sql10 = @Sql10 + @Bloc
						else if len(@Sql11)<6000 set @Sql11 = @Sql11 + @Bloc
						else if len(@Sql12)<6000 set @Sql12 = @Sql12 + @Bloc
						else if len(@Sql13)<6000 set @Sql13 = @Sql13 + @Bloc
						else if len(@Sql14)<6000 set @Sql14 = @Sql14 + @Bloc
						else if len(@Sql15)<6000 set @Sql15 = @Sql15 + @Bloc
							else raiserror('Too long string during update trigger creation!',16,1)
	end

	set @Sql15 = @Sql15 + '
			end
	end
END
'

if @Print >= 1 
	begin
	print @Sql
	if @Sql2 <> '' print @Sql2
	if @Sql3 <> '' print @Sql3
	if @Sql4 <> '' print @Sql4
	if @Sql5 <> '' print @Sql5
	if @Sql6 <> '' print @Sql6
	if @Sql7 <> '' print @Sql7
	if @Sql8 <> '' print @Sql8
	if @Sql9 <> '' print @Sql9
	if @Sql10 <> '' print @Sql10
	if @Sql11 <> '' PRINT @Sql11
	if @Sql12 <> '' PRINT @Sql12
	if @Sql13 <> '' PRINT @Sql13
	if @Sql14 <> '' PRINT @Sql14
	if @Sql15 <> '' PRINT @Sql15
	print 'GO'
	end
if (@Print >= 2 or @Print = 0) exec(@Sql + @Sql2 + @Sql3 + @Sql4 + @Sql5 + @Sql6 + @Sql7 + @Sql8 + @Sql9 + @Sql10 + @Sql11 + @Sql12 + @Sql13 + @Sql14 + @Sql15)

