-----------------------------------------------------------------
--
--
--  Delete VetCase
--  Mark Wilson, May 2017
--
--  input comma-separated string of session IDs
--  
--  DeleteVetCase.sql -- Mark Wilson and Joan Li
--
--  23May2017 -- Mark Wilson did following:
--  updated the tlbMaterial update - the code was setting idfMonitoringSession to null.  removed that 
--  
--
-----------------------------------------------------------------
declare @LogMsg varchar(max)
declare @LogErrMsg varchar(max)
Set @LogMsg=''
Set @LogErrMsg=''

set @LogMsg='start creating/cleaning/altering backup tables'

--v0
if not exists (select * from sysobjects where name='zz_Backup_tlbVetCase' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbVetCase from dbo.tlbVetCase
		delete from zz_Backup_tlbVetCase
		ALTER TABLE zz_Backup_tlbVetCase ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--v1
if not exists (select * from sysobjects where name='zz_Backup_tflVetCaseFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflVetCaseFiltered from dbo.tflVetCaseFiltered
		delete from zz_Backup_tflVetCaseFiltered
		ALTER TABLE zz_Backup_tflVetCaseFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--v2
if not exists (select * from sysobjects where name='zz_Backup_tlbVetCaseDisplayDiagnosis' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbVetCaseDisplayDiagnosis from dbo.tlbVetCaseDisplayDiagnosis
		delete from zz_Backup_tlbVetCaseDisplayDiagnosis
		ALTER TABLE zz_Backup_tlbVetCaseDisplayDiagnosis ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--v3
if not exists (select * from sysobjects where name='zz_Backup_tlbVetCaseLog' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbVetCaseLog from dbo.tlbVetCaseLog 
		delete from zz_Backup_tlbVetCaseLog
		ALTER TABLE zz_Backup_tlbVetCaseLog ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--v4
if not exists (select * from sysobjects where name='zz_Backup_tlbVaccination' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbVaccination from dbo.tlbVaccination
		delete from zz_Backup_tlbVaccination
		ALTER TABLE zz_Backup_tlbVaccination  ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--f1
if not exists (select * from sysobjects where name='zz_Backup_tlbAnimal' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbAnimal from dbo.tlbAnimal
		delete from zz_Backup_tlbAnimal
		ALTER TABLE zz_Backup_tlbAnimal ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--f2
if not exists (select * from sysobjects where name='zz_Backup_tlbSpecies' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbSpecies from dbo.tlbSpecies
		delete from zz_Backup_tlbSpecies
		ALTER TABLE zz_Backup_tlbSpecies ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--f3
if not exists (select * from sysobjects where name='zz_Backup_tlbHerd' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbHerd from dbo.tlbHerd
		delete from zz_Backup_tlbHerd
		ALTER TABLE zz_Backup_tlbHerd ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--f4
if not exists (select * from sysobjects where name='zz_Backup_tflFarmFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflFarmFiltered from dbo.tflFarmFiltered
		delete from zz_Backup_tflFarmFiltered
		ALTER TABLE zz_Backup_tflFarmFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--f5
if not exists (select * from sysobjects where name='zz_Backup_tlbFarm' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbFarm from dbo.tlbFarm
		delete from zz_Backup_tlbFarm
		ALTER TABLE zz_Backup_tlbFarm ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m1
if not exists (select * from sysobjects where name='zz_Backup_tlbPensideTest' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbPensideTest from dbo.tlbPensideTest
		delete from zz_Backup_tlbPensideTest
		ALTER TABLE zz_Backup_tlbPensideTest ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m2
if not exists (select * from sysobjects where name='zz_Backup_tflTransferOutFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflTransferOutFiltered from dbo.tflTransferOutFiltered
		delete from zz_Backup_tflTransferOutFiltered
		ALTER TABLE zz_Backup_tflTransferOutFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m3
if not exists (select * from sysobjects where name='zz_Backup_tlbTransferOutMaterial' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTransferOutMaterial from dbo.tlbTransferOutMaterial
		delete from zz_Backup_tlbTransferOutMaterial
		ALTER TABLE zz_Backup_tlbTransferOutMaterial ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m4
if not exists (select * from sysobjects where name='zz_Backup_tlbTransferOUT' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTransferOUT from dbo.tlbTransferOUT
		delete from zz_Backup_tlbTransferOUT
		ALTER TABLE zz_Backup_tlbTransferOUT ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m5
if not exists (select * from sysobjects where name='zz_Backup_tlbTestAmendmentHistory' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTestAmendmentHistory from dbo.tlbTestAmendmentHistory
		delete from zz_Backup_tlbTestAmendmentHistory
		ALTER TABLE zz_Backup_tlbTestAmendmentHistory ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m6
if not exists (select * from sysobjects where name='zz_Backup_tlbTestValidation' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTestValidation from dbo.tlbTestValidation
		delete from zz_Backup_tlbTestValidation
		ALTER TABLE zz_Backup_tlbTestValidation ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m7
if not exists (select * from sysobjects where name='zz_Backup_tstLocalSamplesTestsPreferences' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tstLocalSamplesTestsPreferences from dbo.tstLocalSamplesTestsPreferences
		delete from zz_Backup_tstLocalSamplesTestsPreferences
		ALTER TABLE zz_Backup_tstLocalSamplesTestsPreferences ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m8
if not exists (select * from sysobjects where name='zz_Backup_tlbTesting' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTesting from dbo.tlbTesting
		delete from zz_Backup_tlbTesting
		ALTER TABLE zz_Backup_tlbTesting ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
--m9
if not exists (select * from sysobjects where name='zz_Backup_tlbMaterial' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMaterial from dbo.tlbMaterial
		delete from zz_Backup_tlbMaterial
		ALTER TABLE zz_Backup_tlbMaterial ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END

--============================================================================================================

set @LogMsg= @LogMsg+ char(13) + char(10) +'End creating/cleaning/altering backup tables'

BEGIN TRY  

BEGIN TRANSACTION

declare @context nvarchar(50)
set @context = 'DataArchiving'
--#########################################################################################################################
--#########################################################################################################################
--declare @idfVetCase bigint
--set @idfVetCase = 52577260000000  ---52587840000000 --52589630000000 ---- idfParentMonitoringSession is not null for 52576230000000 --
--#########################################################################################################################
--#########################################################################################################################

declare @LogTable table
(
  Category nvarchar(50),
  TableName nvarchar(50),
  PKID bigint,
  RowsDeleted bigint,
  Runtime datetime,
  UserName nvarchar(100)

)
set @LogMsg= @LogMsg+ char(13) + char(10) +'Start declare variable tables holding deletion list of ID'
-- if VetCase ID has a parent Monitoring Session throw an exception and close shop
set @idfVetCase = (select idfVetCase from dbo.tlbVetCase where idfVetCase = @idfVetCase)

declare @strMonitoringSession nvarchar(50)
set @strMonitoringSession = (select M.strMonitoringSessionID from dbo.tlbVetCase VC join dbo.tlbMonitoringSession M on M.idfMonitoringSession = VC.idfParentMonitoringSession where idfVetCase = @idfVetCase)

--if @strMonitoringSession is not null 
--  Begin
--	set @LogMsg = 'This Vet Case is associated with Active Surveillance Session ' + @strMonitoringSession + '.  Please delete this Session prior to deleting the Vet Case.' 
--	RAISERROR (@LogMsg,1, -1) with log
--  End
--else
--	BEGIN  ----Start after checking  @strMonitoringSession and could go on
--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------

declare @idfMaterial table (idfMaterial bigint)
declare @idfMaterialDelete table (idfMaterial bigint)
declare @idfMaterialUpdate table (idfMaterial bigint)

declare @idfTransferOut table (idfTransferOut bigint)
declare @idfTransferOutMaterial table(idfMaterial bigint)

declare @idfTesting table (idfTesting bigint)

declare @idfTestValidation table (idfTestValidation bigint)
declare @idfTestAmendmentHistory table (idfTestAmendmentHistory bigint)

declare @idfFarmDelete table (idfFarm bigint)
declare @idfFarm table (idfFarm bigint)
declare @idfFarmFiltered table(idfFarmFiltered bigint)


declare @idfHerd table (idfHerd bigint)

declare @idfSpecies table (idfSpecies bigint)

declare @idfVaccination table (idfVaccination bigint)

declare @idfAnimal table(idfAnimal bigint)

declare @idfBatchTest table (idfBatchTest bigint)
set @LogMsg= @LogMsg+ char(13) + char(10) +'End declare variable tables holding deletion list of ID'
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

--  Material twisting here!

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Start inserting into variable tables.'
-- get all the idfMaterial 

insert into @idfMaterial 
select idfMaterial from dbo.tlbMaterial where idfVetCase = @idfVetCase

-- get all idfMaterial to be updated 

insert into @idfMaterialUpdate
select idfMaterial from dbo.tlbMaterial where idfVetCase = @idfVetCase and (idfHumanCase is not null)
or (idfVetCase = @idfVetCase and idfParentMaterial=idfRootMaterial) -- updated by MCW to fix special case 
-- get idfmaterial to be deleted

insert into @idfMaterialDelete
select idfMaterial from @idfMaterial where idfMaterial not in (select * from @idfMaterialUpdate)


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
  where M.idfMaterial in (select idfMaterial from dbo.tlbMaterial where idfVetCase = @idfVetCase)

  union all

  select  T.idfMaterial, T.strBarCode, T.idfRootMaterial, T.idfParentMaterial, M.Level + 1
  from dbo.tlbMaterial T 
  INNER JOIN MList M on T.idfParentMaterial = M.idfMaterial
 )

insert into @MList
select * from MList
order by idfMaterial


--
--  Get idfTesting for all data to be removed
--

insert into @idfTesting
select distinct idfTesting from dbo.tlbTesting where idfMaterial in (select * from @idfMaterialDelete)

insert into @idfTestValidation
select distinct idfTestValidation from dbo.tlbTestValidation where idfTesting in (select * from @idfTesting)

insert into @idfTestAmendmentHistory
select idfTestAmendmentHistory from dbo.tlbTestAmendmentHistory where idfTesting in (select * from @idfTesting)

insert into @idfFarm
select idfFarm from dbo.tlbVetCase 
where idfVetCase = @idfVetCase 

insert into @idfFarmDelete
select idfFarm from dbo.tlbFarm where idfFarm in (select * from @idfFarm) and idfMonitoringSession is null

insert into @idfHerd
select idfHerd from dbo.tlbHerd where idfFarm in (select * from @idfFarmDelete)

insert into @idfSpecies
select idfSpecies from dbo.tlbSpecies where idfHerd in (select * from @idfHerd)

insert into @idfVaccination
select distinct idfVaccination from dbo.tlbVaccination where idfVetCase = @idfVetCase

insert into @idfAnimal
select distinct idfAnimal from dbo.tlbAnimal where idfSpecies in (select * from @idfSpecies)

-----------------------------------------------------------------------------------------------------
-- Added by MCW
-----------------------------------------------------------------------------------------------------
insert into @idfTransferOutMaterial 
select idfMaterial from @MList

insert into @idfTransferOut 
select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfTransferOutMaterial)

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--BatchTest
insert into @idfBatchTest
select distinct idfBatchTest from dbo.tlbTesting where idfTesting in (select * from @idfTesting) and idfBatchTest is not null
set @LogMsg= @LogMsg+ char(13) + char(10) +'End inserting into variable tables.'
-----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------
--
-- create archives for VetCase-related tables 
--
----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Start Archiving data into zz_badkup tables.'
--v0------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbVetCase.'
insert into zz_Backup_tlbVetCase
select *, getdate(), suser_name(), 'VetCase Delete', '', @idfVetCase from dbo.tlbVetCase
where idfVetCase = @idfVetCase
--v1------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tflVetCaseFiltered.'
insert into zz_Backup_tflVetCaseFiltered
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from tflVetCaseFiltered
where idfVetCase =@idfVetCase
--v2------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from tlbVetCaseDisplayDiagnosis.'
insert into zz_Backup_tlbVetCaseDisplayDiagnosis
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from tlbVetCaseDisplayDiagnosis
where  idfVetCase =@idfVetCase
--v3------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbVetCaseLog.'
insert into zz_Backup_tlbVetCaseLog
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbVetCaseLog
where idfVetCase =@idfVetCase
---v4----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbVaccination.'
insert into zz_Backup_tlbVaccination
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbVaccination
where idfVaccination in ( select * from @idfVaccination)
--m1------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbPensideTest.'
insert into zz_Backup_tlbPensideTest
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbPensideTest
where idfMaterial in (select * from @idfMaterialDelete)
--m2-------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tflTransferOutFiltered.'
insert into zz_Backup_tflTransferOutFiltered
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tflTransferOutFiltered
where idfTransferOut in (select * from @idfTransferOut)
--m3------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbTransferOutMaterial.'
insert into zz_Backup_tlbTransferOutMaterial
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbTransferOutMaterial 
where idfMaterial in (select * from @idfTransferOutMaterial)
--m4------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbTransferOut .'
insert into zz_Backup_tlbTransferOut
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbTransferOut 
where idfTransferOut in (select * from @idfTransferOut)
--m5----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tflVetCaseFiltered.'
insert into zz_Backup_tlbTestAmendmentHistory
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbTestAmendmentHistory 
where idfTesting in (select * from @idfTesting)
--m6------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbTestValidation.'
insert into zz_Backup_tlbTestValidation
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)
--m7------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tstLocalSamplesTestsPreferences .'
insert into zz_Backup_tstLocalSamplesTestsPreferences
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tstLocalSamplesTestsPreferences 
where idfTesting in (select * from @idfTesting)
--m8------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbTesting .'
insert into zz_Backup_tlbTesting
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbTesting 
where idfTesting in (select * from @idfTesting)
------m9------------------------------------------------------------------------------ 
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbMaterial_1 .'
insert into zz_Backup_tlbMaterial
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbMaterial 
where idfMaterial in (select * from @idfMaterial) and idfMaterial = idfRootMaterial
--m9------------------------------------------------------------------------------ 
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbMaterial_2.'
insert into zz_Backup_tlbMaterial
select *, getdate(), suser_name(), 'VetCase Delete', 'Update', @idfVetCase from dbo.tlbMaterial 
where idfMaterial in (select * from @idfMaterial) and idfMaterial != idfRootMaterial
--f1-----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbAnimal.'
insert into zz_Backup_tlbAnimal
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbAnimal
where idfAnimal in (select idfSpecies from @idfAnimal) 
--f2-----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbSpecies.'
insert into zz_Backup_tlbSpecies
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbSpecies
where idfSpecies in (select idfSpecies from @idfSpecies)
--f3-----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.dbo.tlbHerd.'
insert into zz_Backup_tlbHerd
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbHerd
where idfHerd in (select idfHerd from @idfHerd)
--f4------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tflFarmFiltered.'
insert into zz_Backup_tflFarmFiltered
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tflFarmFiltered
where idfFarm in (select idfFarm from @idfFarmDelete)
---f5-----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Archiving data from dbo.tlbFarm.'
insert into zz_Backup_tlbFarm
select *, getdate(), suser_name(), 'VetCase Delete', 'Delete', @idfVetCase from dbo.tlbFarm
where idfFarm in (select * from @idfFarmDelete)

set @LogMsg= @LogMsg+ char(13) + char(10) +'End Archiving data into zz_badkup tables.'

-----------------------------------------------------------------------------------
--
-- set context to allow hard delete
--
--  START DELETE
--
----------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Start deletion from tables.'
EXEC spSetContext @Context
----------------------------------------------------------------------------
-- delete/update from all Active Session - related tables 
--
----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbVetCaseDisplayDiagnosis.'
delete from dbo.tlbVetCaseDisplayDiagnosis
where idfVetCase = @idfVetCase

-----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbVetCaseLog.'
delete from dbo.tlbVetCaseLog 
where idfVetCase = @idfVetCase

----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tflVetCaseFiltered.'
delete from dbo.tflVetCaseFiltered
where idfVetCase = @idfVetCase

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbTestAmendmentHistory.'
delete from dbo.tlbTestAmendmentHistory 
where idfTesting in (select idfTesting from @idfTesting)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbTestValidation.'
delete from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbTestAmendmentHistory.'
delete from dbo.tlbTestAmendmentHistory 
where idfTestAmendmentHistory in (select * from @idfTestAmendmentHistory)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tstLocalSamplesTestsPreferences.'
delete from dbo.tstLocalSamplesTestsPreferences 
where idfTesting in (select * from @idfTesting)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Update dbo.tlbTesting.'
update dbo.tlbTesting
set idfMaterial = null
where idfMaterial in (select * from @idfMaterialDelete)
delete from dbo.tlbTesting 
where idfTesting in (select idfTesting from @idfTesting)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Update dbo.tlbMaterial with idfMainTest.'
update dbo.tlbMaterial
set idfMainTest = null
where idfMaterial in (select * from @idfMaterialDelete)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbTesting.'
delete from dbo.tlbTesting
where idfTesting in (select * from @idfTesting)



----delete records
insert into @idfTransferOut
select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select idfMaterial from @MList)
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tflTransferOutFiltered.'		
delete from dbo.tflTransferOutFiltered where idfTransferOut in (select * from @idfTransferOut)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbTransferOutMaterial.'	
delete from dbo.tlbTransferOutMaterial where idfMaterial in (select idfMaterial from @MList)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbTransferOUT.'
delete from dbo.tlbTransferOUT where idfTransferOut in (select * from @idfTransferOut)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbPensideTest.'
delete from dbo.tlbPensideTest where idfMaterial in (select idfMaterial from @MList)


----set up to do hard delete
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from tlbMaterial.'

-- tlbMaterial: null all the columns prior to delete
update dbo.tlbMaterial
set idfMainTest = null,
	idfVetCase = null,
	idfAnimal = null,
	idfSpecies = null,
	idfMonitoringSession = null,
	intRowStatus = 1
where idfMaterial in (select idfMaterial from @MList)

DECLARE @parent_id bigint, @child_id  bigint ,@child_patID bigint,@sessionID bigint,@message varchar(max) , @inicntM int, @inicnt int

select @inicntM=(select max(mlevel) from @MList ) --#TempList)
WHILE @inicnt <=@inicntM
  BEGIN	

	IF @inicnt =0 
		BEGIN
	  	  ----PRINT 'need to get next level:' + convert(varchar,@inicnt) + ' @inicntM: ' + convert(varchar,@inicntM);
		  delete tlbmaterial 
		  where  idfMaterial in
		  (
		  select idfmaterial from @MList  --
		  where mlevel =@inicnt and 
		  (idfMaterial not in (select distinct idfParentMaterial from @MList where not (idfParentMaterial is null) ))) 
		END
	ELSE	
		BEGIN
		----PRINT 'need to get next level:' + convert(varchar,@inicnt) + ' @inicntM: ' + convert(varchar,@inicntM);
			delete tlbmaterial 
			where  idfMaterial in
			(
			select idfmaterial from @MList --#TempList
			where mlevel =@inicnt and 
			(idfMaterial not in (select distinct idfParentMaterial from @MList where (mlevel =@inicnt and not (idfParentMaterial is null) ))))
		END

    SET @inicnt = @inicnt +1;
  END;
		
		---------first layer of child
delete from dbo.tlbMaterial 
WHERE idfMaterial in (select * from @idfMaterialDelete)  and not (idfParentMaterial is null) and (idfParentMaterial =idfRootMaterial) 

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbVaccination.'
delete from dbo.tlbVaccination 
where idfVaccination in (select * from @idfVaccination)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tflFarmFiltered.'
delete from dbo.tflFarmFiltered
where idfFarm in (select * from @idfFarmDelete)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbAnimal .'
delete from dbo.tlbAnimal where idfAnimal in (select * from @idfAnimal) 

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbSpecies.'
delete from dbo.tlbSpecies 
where idfSpecies in (select * from @idfSpecies) and idfSpecies not in (select idfSpecies from dbo.tlbAnimal)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbHerd.'
delete from dbo.tlbHerd 
where idfHerd in (select * from @idfHerd)
and idfHerd not in (select idfHerd from dbo.tlbSpecies)

set @LogMsg= @LogMsg+ char(13) + char(10) +'Update dbo.tlbVetCase.'
update dbo.tlbVetCase
set idfParentMonitoringSession = null
where idfVetCase = @idfVetCase

-----------------------------------------------------------------------------
set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbVetCase.'
delete from dbo.tlbVetCase
where idfVetCase = @idfVetCase

set @LogMsg= @LogMsg+ char(13) + char(10) +'Delete from dbo.tlbFarm.'
delete from dbo.tlbFarm where idfFarm in (select * from @idfFarmDelete)
and idfMonitoringSession is null

set @LogMsg= @LogMsg+ char(13) + char(10) +'End deletion from tables.'

-- reset context
set @LogMsg= @LogMsg+ char(13) + char(10) +'Reset Context'
EXEC spSetContext ''

COMMIT  


END TRY  
BEGIN CATCH  
    -- Execute error retrieval routine. 
	IF @@TRANCOUNT = 0
		 select @LogMsg
	ELSE IF @@TRANCOUNT > 0
        ROLLBACK
	   set @LogErrMsg = 
	   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
	   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
	   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
	   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
	   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
	   + ' ErrorMessage: '+ ERROR_MESSAGE()
	   ----select @LogErrMsg
	   set @LogMsg= isnull(@LogMsg,'')+ char(13) + +@LogErrMsg

END CATCH; 
 select @LogMsg
