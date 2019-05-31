-----------------------------------------------------------------
--
--
--  Delete Active session
--  Mark Wilson, May 2017
--
--  input comma-separated string of session IDs
--  
--  DeleteActiveSessionMay_current_JL_Material.sql
--
-----------------------------------------------------------------
declare @LogMsg varchar(max)
declare @LogErrMsg varchar(max)
Set @LogMsg=''
Set @LogErrMsg=''

set @LogMsg='start creating/cleaning/altering backup tables'
if not exists (select * from sysobjects where name='zz_Backup_tlbMaterial' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMaterial from dbo.tlbMaterial
		delete from zz_Backup_tlbMaterial
		ALTER TABLE zz_Backup_tlbMaterial ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbTransferOUT' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTransferOUT from dbo.tlbTransferOUT
		delete from zz_Backup_tlbTransferOUT
		ALTER TABLE zz_Backup_tlbTransferOUT ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbTransferOutMaterial' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTransferOutMaterial from dbo.tlbTransferOutMaterial
		delete from zz_Backup_tlbTransferOutMaterial
		ALTER TABLE zz_Backup_tlbTransferOutMaterial ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbPensideTest' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbPensideTest from dbo.tlbPensideTest
		delete from zz_Backup_tlbPensideTest
		ALTER TABLE zz_Backup_tlbPensideTest ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
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
if not exists (select * from sysobjects where name='zz_Backup_tflTransferOutFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflTransferOutFiltered from dbo.tflTransferOutFiltered
		delete from zz_Backup_tflTransferOutFiltered
		ALTER TABLE zz_Backup_tflTransferOutFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
set @LogMsg= @LogMsg+ char(10) +'End creating/cleaning/altering backup tables'

----select @LogMsg

--=============================================================
--deletion part with error trap
--=============================================================
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Finish previous script and start deletion part' 
BEGIN TRY  
	
BEGIN TRANSACTION

declare @context nvarchar(50)
set @context = 'DataArchiving'

--####################################################################################################################################################
--####################################################################################################################################################
--Declare @idfMaterial bigint
--set @idfMaterial = 52606860000000 --52575400000000 52575420000000 52575510000000 52575530000000 52575550000000 52575580000000 52575600000000 52575620000000
                                  --52576280000000 52576550000000 52576570000000 52576590000000 52576610000000 52576630000000 
--####################################################################################################################################################
--####################################################################################################################################################
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Declare ids to delete' 
declare @idfMaterialDelete table (idfMaterial bigint)
declare @idfMaterialUpdate table (idfMaterial bigint)

declare @idfTransferOut table (idfTransferOut bigint)
declare @idfTransferOutMaterial table(idfMaterial bigint)

declare @idfTesting table (idfTesting bigint)

declare @idfTestValidation table (idfTestValidation bigint)
declare @idfTestAmendmentHistory table (idfTestAmendmentHistory bigint)

declare @idfBatchTest table (idfBatchTest bigint)

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

--  Material twisting here!

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Capture ids to delete' 
declare @MList table(
  idfMaterial bigint,
  strBarCode nvarchar(50),
  idfRootMaterial bigint,
  idfParentMaterial bigint,
  MLevel int
); 

with MList as
(
  select M.idfMaterial, M.strBarCode, M.idfRootMaterial, M.idfParentMaterial, 0 as Level
  from dbo.tlbMaterial M
  where M.idfMaterial = @idfMaterial

  union all

  select  T.idfMaterial, T.strBarCode, T.idfRootMaterial, T.idfParentMaterial, M.Level + 1
  from dbo.tlbMaterial T 
  INNER JOIN MList M on T.idfParentMaterial = M.idfMaterial
 )

insert into @MList
select * from MList
order by idfMaterial

------------------------------------------------------------------------------------------------------
-- Added by MCW to capture transferout and transferout Material
------------------------------------------------------------------------------------------------------
--insert into @idfTransferOutMaterial 
--select idfMaterial from @MList

insert into @idfTransferOutMaterial
select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select idfMaterial from @MList)


--insert into @idfTransferOut
--select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfTransferOutMaterial)

insert into @idfTransferOut
select idfTransferOut from dbo.tlbTransferOut where idfTransferOut in (select * from @idfTransferOutMaterial)
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------



--  Get idfTesting for all data to be removed
--
insert into @idfTesting
select distinct idfTesting from dbo.tlbTesting where idfMaterial in (select idfMaterial from @MList)

insert into @idfTestValidation
select distinct idfTestValidation from dbo.tlbTestValidation where idfTesting in (select * from @idfTesting)

--select * from @idfTestValidation

insert into @idfTestAmendmentHistory
select idfTestAmendmentHistory from dbo.tlbTestAmendmentHistory where idfTesting in (select * from @idfTesting)

--BatchTest
insert into @idfBatchTest
select distinct idfBatchTest from dbo.tlbTesting where idfTesting in (select * from @idfTesting) and idfBatchTest is not null


----------------------------------------------------------------------------
--
-- create archives got all Session-related tables 
--
----------------------------------------------------------------------------
--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTestAmendmentHistory' 
insert into zz_Backup_tlbTestAmendmentHistory
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbTestAmendmentHistory 
where idfTesting in (select * from @idfTesting)

--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTestValidation' 
insert into zz_Backup_tlbTestValidation
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)

--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tstLocalSamplesTestsPreferences' 
insert into zz_Backup_tstLocalSamplesTestsPreferences
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tstLocalSamplesTestsPreferences 
where idfTesting in (select * from @idfTesting)

--------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTesting' 
insert into zz_Backup_tlbTesting
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbTesting 
where idfTesting in (select * from @idfTesting)

-------------------------------------------------------------------------------- 
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbMaterial' 
insert into zz_Backup_tlbMaterial
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbMaterial 
where idfMaterial in (select idfMaterial from @MList)

set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbPensideTest' 
insert into zz_Backup_tlbPensideTest
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbPensideTest
where idfMaterial in (select * from @idfMaterialDelete)

set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTransferOut' 
insert into zz_Backup_tlbTransferOut
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbTransferOut 
where idfTransferOut in (select * from @idfTransferOut)

set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbTransferOutMaterial' 
insert into zz_Backup_tlbTransferOutMaterial
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbTransferOutMaterial 
where idfMaterial in (select * from @idfTransferOutMaterial)

---------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tlbBatchTest' 
insert into zz_Backup_tlbBatchTest
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tlbBatchTest
where idfBatchTest in (select * from @idfBatchTest)

---------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Backup tflTransferOutFiltered' 
insert into zz_Backup_tflTransferOutFiltered
select *, getdate(), suser_name(), 'Sample Delete', 'Delete', @idfMaterial from dbo.tflTransferOutFiltered
where idfTransferOut in (select * from @idfTransferOut)

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
--
----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tlbTestAmendmentHistory' 
--------------------------------------------------------------------------------------------------
delete from dbo.tlbTestAmendmentHistory 
where idfTesting in (select idfTesting from @idfTesting)

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
where idfTesting in (select * from @idfTesting)

--------------------------------------------------------------------------------------------------
set @LogMsg= isnull(@LogMsg,'')+ char(13) + char(10) +'Delete from tlbTesting' 
--------------------------------------------------------------------------------------------------
-- Remove reference to material samples that are being deleted
update dbo.tlbTesting
set idfMaterial = null
where idfMaterial in (select idfMaterial from @MList)

-- remove reference to test from sample being deleted
update dbo.tlbMaterial 
set idfMainTest = null
where idfMainTest in (select * from @idfTesting)
and idfMaterial in (select idfMaterial from @Mlist)

-- delete test
delete from dbo.tlbTesting 
where idfTesting in (select * from @idfTesting)

----delete records

delete from dbo.tflTransferOutFiltered where idfTransferOut in (select * from @idfTransferOut)


--update dbo.tlbTransferOutMaterial set intRowStatus = 1 where idfMaterial in (select idfMaterial from @MList)
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTransferOutMaterial'
----delete from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfMaterialDelete)
delete from dbo.tlbTransferOutMaterial where idfTransferOut in (select * from @idfTransferOutMaterial)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTransferOUT'
delete from dbo.tlbTransferOUT where idfTransferOut in (select * from @idfTransferOut)


--update dbo.tlbTransferOUT set intRowStatus = 1 where idfTransferOut in (select * from @idfTransferOut)


delete from dbo.tlbPensideTest where idfMaterial in (select idfMaterial from @MList)

-- tlbMaterial: null all the columns prior to delete
update dbo.tlbMaterial
set idfMonitoringSession = null,
    idfMainTest = null,
	idfHumanCase = null,
	idfVetCase = null,
	idfAnimal = null,
	idfSpecies = null,
	idfHuman = null,
	idfAccesionByPerson = null,
	idfDestroyedByPerson = null,
	idfInDepartment = null,
	intRowStatus = 1
where idfMaterial in (select idfMaterial from @MList)

DECLARE @inicntM int
set @inicntM=0
select @inicntM=(select max(mlevel) from @MList ) --#TempList)
WHILE @inicntM >=0
BEGIN	

IF @inicntM=0 
BEGIN
PRINT 'check' + convert(varchar,@inicntM) + ' @inicntM: ' ;
  delete tlbmaterial 
  where  idfMaterial in (select idfmaterial from @MList where Mlevel =@inicntM and idfMaterial != idfRootMaterial) 
  and idfParentMaterial != idfRootMaterial -- added by MCW for special case
END
ELSE	
BEGIN
PRINT 'delete' + convert(varchar,@inicntM) + ' @inicntM: ' ;
  delete tlbmaterial 
  where  idfMaterial in (select idfmaterial from @MList where Mlevel =@inicntM) 
  and idfParentMaterial != idfRootMaterial  -- added by MCW for special case
END

  SET @inicntM = @inicntM - 1;
END;

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