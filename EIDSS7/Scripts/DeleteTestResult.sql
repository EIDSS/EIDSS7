-----------------------------------------------------------------
--
--
--  Delete Test Result
--  Mark Wilson, June 2017
--
--  idfTestingID
--  
--  DeleteTestResult.sql
--
-----------------------------------------------------------------
declare @LogMsg varchar(max)
declare @LogErrMsg varchar(max)
Set @LogMsg=''
Set @LogErrMsg=''

set @LogMsg='start creating/cleaning/altering backup tables'
if not exists (select * from sysobjects where name='zz_Backup_tlbTestAmendmentHistory' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTestAmendmentHistory from dbo.tlbTestAmendmentHistory
		delete from zz_Backup_tlbTestAmendmentHistory
		ALTER TABLE zz_Backup_tlbTestAmendmentHistory ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbTesting' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTesting from dbo.tlbTesting
		delete from zz_Backup_tlbTesting
		ALTER TABLE zz_Backup_tlbTesting ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbBatchTest' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbBatchTest from dbo.tlbBatchTest
		delete from zz_Backup_tlbBatchTest
		ALTER TABLE zz_Backup_tlbBatchTest ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbTestValidation' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTestValidation from dbo.tlbTestValidation
		delete from zz_Backup_tlbTestValidation
		ALTER TABLE zz_Backup_tlbTestValidation ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tstLocalSamplesTestsPreferences' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tstLocalSamplesTestsPreferences from dbo.tstLocalSamplesTestsPreferences
		delete from zz_Backup_tstLocalSamplesTestsPreferences
		ALTER TABLE zz_Backup_tstLocalSamplesTestsPreferences ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
set @LogMsg= @LogMsg+ char(10) +'End creating/cleaning/altering backup tables'

----select @LogMsg

--=============================================================
--deletion part with error trap
--=============================================================
----this temp table only for my raising error test and delete 
Create table #TempFact (result int)
----declare @LogMsg varchar(max)
----declare @LogErrMsg varchar (max)
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Finish zz_Backup and start deletion' 
BEGIN TRY  
    -- Generate divide-by-zero error.
	
	BEGIN TRANSACTION
		----========================================================
		--replace deletion code here
		--=========================================================  
		set @LogMsg= @LogMsg+ char(10) +'Start first deletion'
		insert into  #TempFact (result) Values (30)
		set @LogMsg= @LogMsg+ char(10) +'Start second deletion'

drop table #TempFact
--use EIDSS_AJ

declare @context nvarchar(50)
set @context = 'DataArchiving'

--####################################################################################################################################################
--####################################################################################################################################################
--Declare @idfTesting bigint
----set @idfTesting = 52576850000000 --52575400000000 52575420000000 52575510000000 52575530000000 52575550000000 52575580000000 52575600000000 52575620000000
                                  --52576280000000 52576550000000 52576570000000 52576590000000 52576610000000 52576630000000 
--####################################################################################################################################################
--####################################################################################################################################################
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Declare ids to delete' 

declare @idfTestValidation table (idfTestValidation bigint)
declare @idfTestAmendmentHistory table (idfTestAmendmentHistory bigint)
declare @idfBatchTest table (idfBatchTest bigint)

set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Capture ids to delete' 

insert into @idfTestValidation
select distinct idfTestValidation from dbo.tlbTestValidation where idfTesting = @idfTesting

insert into @idfTestAmendmentHistory
select idfTestAmendmentHistory from dbo.tlbTestAmendmentHistory where idfTesting = @idfTesting

insert into @idfBatchTest
select distinct idfBatchTest from dbo.tlbTesting where idfTesting = @idfTesting and idfBatchTest is not null

----------------------------------------------------------------------------
--
-- create archives got all Testing-related tables 
--
----------------------------------------------------------------------------
--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTestAmendmentHistory' 
insert into zz_Backup_tlbTestAmendmentHistory
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfTesting from dbo.tlbTestAmendmentHistory 
where idfTesting = @idfTesting

--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTestValidation' 
insert into zz_Backup_tlbTestValidation
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfTesting from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)

--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tstLocalSamplesTestsPreferences' 
insert into zz_Backup_tstLocalSamplesTestsPreferences
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfTesting from dbo.tstLocalSamplesTestsPreferences 
where idfTesting = @idfTesting

--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTesting' 
insert into zz_Backup_tlbTesting
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfTesting from dbo.tlbTesting 
where idfTesting = @idfTesting

---------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbBatchTest' 
insert into zz_Backup_tlbBatchTest
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfTesting from dbo.tlbBatchTest
where idfBatchTest in (select * from @idfBatchTest)

-----------------------------------------------------------------------------------
--
-- set context to allow hard delete
--
--  START DELETE
--
----------------------------------------------------------------------------------

EXEC spSetContext @Context

----------------------------------------------------------------------------
-- delete/update from all Active Session - related tables 
----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tlbTestAmendmentHistory' 
--------------------------------------------------------------------------------------------------
delete from dbo.tlbTestAmendmentHistory 
where idfTesting = @idfTesting

--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tlbTestValidation' 
--------------------------------------------------------------------------------------------------
delete from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)

--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tlbTestAmendmentHistory' 
--------------------------------------------------------------------------------------------------
delete from dbo.tlbTestAmendmentHistory 
where idfTestAmendmentHistory in (select * from @idfTestAmendmentHistory)

--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tstLocalSamplesTestsPreferences' 
--------------------------------------------------------------------------------------------------
delete from dbo.tstLocalSamplesTestsPreferences 
where idfTesting =@idfTesting

--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tlbTesting' 
--------------------------------------------------------------------------------------------------
-- delete test
delete from dbo.tlbTesting 
where idfTesting =@idfTesting

-- reset context
EXEC spSetContext ''

COMMIT  
END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine. 
	IF @@TRANCOUNT > 0
        ROLLBACK
	   set @LogErrMsg = 
	   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
	   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
	   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
	   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
	   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
	   + ' ErrorMessage: '+ ERROR_MESSAGE()
	   ----select @LogErrMsg
	   set @LogMsg= isnull(@LogMsg,'')+ char(10)+@LogErrMsg
END CATCH; 
select @LogMsg