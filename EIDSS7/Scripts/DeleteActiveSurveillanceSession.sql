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
if not exists (select * from sysobjects where name='zz_Backup_tflMonitoringSessionFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflMonitoringSessionFiltered from dbo.tflMonitoringSessionFiltered
		delete from zz_Backup_tflMonitoringSessionFiltered
		ALTER TABLE zz_Backup_tflMonitoringSessionFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tflObservationFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflObservationFiltered from dbo.tflObservationFiltered
		delete from zz_Backup_tflObservationFiltered
		ALTER TABLE zz_Backup_tflObservationFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tflFarmFiltered' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tflFarmFiltered from dbo.tflFarmFiltered
		delete from zz_Backup_tflFarmFiltered
		ALTER TABLE zz_Backup_tflFarmFiltered ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbBatchTest' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbBatchTest from dbo.tlbBatchTest
		delete from zz_Backup_tlbBatchTest
		ALTER TABLE zz_Backup_tlbBatchTest ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbFarm' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbFarm from dbo.tlbFarm
		delete from zz_Backup_tlbFarm
		ALTER TABLE zz_Backup_tlbFarm ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbHerd' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbHerd from dbo.tlbHerd
		delete from zz_Backup_tlbHerd
		ALTER TABLE zz_Backup_tlbHerd ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
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
if not exists (select * from sysobjects where name='zz_Backup_tlbMonitoringSession' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMonitoringSession from dbo.tlbMonitoringSession
		delete from zz_Backup_tlbMonitoringSession
		ALTER TABLE zz_Backup_tlbMonitoringSession ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbMonitoringSessionAction' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMonitoringSessionAction from dbo.tlbMonitoringSessionAction
		delete from zz_Backup_tlbMonitoringSessionAction
		ALTER TABLE zz_Backup_tlbMonitoringSessionAction ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbMonitoringSessionSummary' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMonitoringSessionSummary from dbo.tlbMonitoringSessionSummary
		delete from zz_Backup_tlbMonitoringSessionSummary
		ALTER TABLE zz_Backup_tlbMonitoringSessionSummary ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbMonitoringSessionSummaryDiagnosis' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMonitoringSessionSummaryDiagnosis from dbo.tlbMonitoringSessionSummaryDiagnosis
		delete from zz_Backup_tlbMonitoringSessionSummaryDiagnosis
		ALTER TABLE zz_Backup_tlbMonitoringSessionSummaryDiagnosis ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbMonitoringSessionSummarySample' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMonitoringSessionSummarySample from dbo.tlbMonitoringSessionSummarySample
		delete from zz_Backup_tlbMonitoringSessionSummarySample
		ALTER TABLE zz_Backup_tlbMonitoringSessionSummarySample ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbMonitoringSessionToDiagnosis' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbMonitoringSessionToDiagnosis from dbo.tlbMonitoringSessionToDiagnosis
		delete from zz_Backup_tlbMonitoringSessionToDiagnosis
		ALTER TABLE zz_Backup_tlbMonitoringSessionToDiagnosis ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbObservation' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbObservation from dbo.tlbObservation
		delete from zz_Backup_tlbObservation
		ALTER TABLE zz_Backup_tlbObservation ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbPensideTest' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbPensideTest from dbo.tlbPensideTest
		delete from zz_Backup_tlbPensideTest
		ALTER TABLE zz_Backup_tlbPensideTest ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbSpecies' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbSpecies from dbo.tlbSpecies
		delete from zz_Backup_tlbSpecies
		ALTER TABLE zz_Backup_tlbSpecies ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
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
if not exists (select * from sysobjects where name='zz_Backup_tlbTestValidation' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbTestValidation from dbo.tlbTestValidation
		delete from zz_Backup_tlbTestValidation
		ALTER TABLE zz_Backup_tlbTestValidation ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbVaccination' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbVaccination from dbo.tlbVaccination
		delete from zz_Backup_tlbVaccination
		ALTER TABLE zz_Backup_tlbVaccination ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
	END
if not exists (select * from sysobjects where name='zz_Backup_tlbVetCase' and xtype='U')
	BEGIN
		select top 1 * into zz_Backup_tlbVetCase from dbo.tlbVetCase
		delete from zz_Backup_tlbVetCase
		ALTER TABLE zz_Backup_tlbVetCase ADD ArchiveDateTime DATETIME NULL, ArchiveUser nvarchar(100) NULL,Category nvarchar(50) NULL,Action nvarchar(10) NULL,User_Request_Del_ID varchar(200);
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
set @LogMsg= @LogMsg + CHAR(13) + char(10) + 'End creating/cleaning/altering backup tables'

----select @LogMsg

--=============================================================
--deletion part with error trap
--=============================================================

----declare @LogMsg varchar(max)
----declare @LogErrMsg varchar (max)
set @LogMsg= isnull(@LogMsg,'')+ CHAR(13) + char(10) +'Finish previous script and start deletion part' 
BEGIN TRY  
    -- Generate divide-by-zero error.
	
	BEGIN TRANSACTION
		----========================================================
		--replace deletion code here
		--=========================================================  
		--JL: delete creating temp table part 

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Capture PrimaryKey information'
declare @context nvarchar(50)
set @context = 'DataArchiving'

--##########################################################################################################################
--##########################################################################################################################
----declare @idfMonitoringSession bigint
----set @idfMonitoringSession =52605700000000 ----- 39870001294---16580001294--8290001294
--##########################################################################################################################
--##########################################################################################################################

declare @idfMaterial table (idfMaterial bigint)
declare @idfMaterialDelete table (idfMaterial bigint)
declare @idfMaterialUpdate table (idfMaterial bigint)

---------JL:move these two id declare tables from bottom
declare @idfTransferOut table (idfTransferOut bigint)
declare @idfTransferOutMaterial table(idfMaterial bigint)
----------------------------------------------------------

declare @idfTesting table (idfTesting bigint)

declare @idfTestValidation table (idfTestValidation bigint)
declare @idfTestAmendmentHistory table (idfTestAmendmentHistory bigint)

declare @idfRootTesting table (idfTesting bigint)
declare @idfParentTesting table (idfTesting bigint)

declare @idfBatchTest table (idfBatchTest bigint)

declare @idfFarmDelete table (idfFarm bigint)
declare @idfFarmUpdate table (idfFarm bigint)
declare @idfFarmFiltered table(idfFarmFiltered bigint)
declare @idfFarmAddress table (idfFarm bigint)

declare @idfHerd table (idfHerd bigint)

declare @idfHuman table (idfHuman bigint)

declare @idfObservation table (idfObservation bigint)

declare @idfSpecies table(idfSpecies bigint)

declare @idfVaccination table (idfVaccination bigint)

declare @idfAnimal table(idfAnimal bigint)

declare @idfVetCase table(idfVetCase bigint)

declare @idfMonitoringSessionSummarySample table(idfMonitoringSessionSummary bigint)
declare @idfMonitoringSessionSummary table(idfMonitoringSessionSummary bigint)
declare @idfMonitoringSessionSummaryDiagnosis table(idfMonitoringSessionSummary bigint)

insert into @idfVetCase
select distinct idfVetCase from dbo.tlbVetCase where idfParentMonitoringSession = @idfMonitoringSession

insert into @idfMonitoringSessionSummaryDiagnosis
select D.idfMonitoringSessionSummary from dbo.tlbMonitoringSessionSummaryDiagnosis D
inner join dbo.tlbMonitoringSessionSummary S on S.idfMonitoringSessionSummary = D.idfMonitoringSessionSummary
where S.idfMonitoringSession = @idfMonitoringSession

insert into @idfMonitoringSessionSummarySample
select SS.idfMonitoringSessionSummary from dbo.tlbMonitoringSessionSummarySample SS
inner join dbo.tlbMonitoringSessionSummary S on S.idfMonitoringSessionSummary = SS.idfMonitoringSessionSummary
where S.idfMonitoringSession = @idfMonitoringSession

insert into @idfMonitoringSessionSummary
select idfMonitoringSessionSummary from dbo.tlbMonitoringSessionSummary where idfMonitoringSession = @idfMonitoringSession;

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

--  Material twisting here!

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------

-- get all the idfMaterial 
insert into @idfMaterial 
select idfMaterial from dbo.tlbMaterial where idfMonitoringSession = @idfMonitoringSession
	------------------------------------
--	select idfMaterial as total_ID  from @idfMaterial 
	------------------------------------
-- get all idfMaterial to be updated 
insert into @idfMaterialUpdate
select idfMaterial from dbo.tlbMaterial where idfMonitoringSession = @idfMonitoringSession and (idfVetCase is not null or idfHumanCase is not null)
or (idfMonitoringSession = @idfMonitoringSession and idfParentMaterial=idfRootMaterial) ---------JL:add one condittion here 
	------------------------------------
	---------JL: added debug view 
	--select idfMaterial as update_ID from  @idfMaterialUpdate
	------------------------------------
-- get idfmaterial to be deleted
insert into @idfMaterialDelete
select idfMaterial from @idfMaterial where idfMaterial not in (select * from @idfMaterialUpdate)
 	------------------------------------
	---------JL: added debug view
	--select idfMaterial as delet_ID from @idfMaterialDelete
	------------------------------------

insert into @idfTransferOutMaterial
select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfMaterial)

	------------------------------------
	---------JL: added debug view
	--select *  from @idfTransferOutMaterial
	------------------------------------
insert into @idfTransferOut
select idfTransferOut from dbo.tlbTransferOut where idfTransferOut in (select * from @idfTransferOutMaterial)
	------------------------------------
	---------JL: added debug view
	--select idfTransferOut  as transerout_ID from @idfTransferOut
	------------------------------------
--
--  Get idfTesting for all data to be removed
--
insert into @idfTesting
select distinct idfTesting from dbo.tlbTesting where idfMaterial in (select * from @idfMaterialDelete)

insert into @idfTestValidation
select distinct idfTestValidation from dbo.tlbTestValidation where idfTesting in (select * from @idfTesting)

--select * from @idfTestValidation

insert into @idfTestAmendmentHistory
select idfTestAmendmentHistory from dbo.tlbTestAmendmentHistory where idfTesting in (select * from @idfTesting)

insert into @idfFarmUpdate
select idfFarm from dbo.tlbFarm 
where idfMonitoringSession = @idfMonitoringSession 
and idfFarm in (select idfFarm from dbo.tlbVetCase)

insert into @idfFarmDelete
select idfFarm from dbo.tlbFarm 
where idfMonitoringSession = @idfMonitoringSession 
and idfFarm not in (select idfFarm from dbo.tlbVetCase union all select idfFarm from dbo.tlbMonitoringSessionSummary)

insert into @idfHuman 
select idfHuman from tlbFarm where idfFarm in (select * from @idfFarmDelete)

insert into @idfHerd
select distinct idfHerd from dbo.tlbHerd where idfFarm in (select * from @idfFarmDelete)

insert into @idfSpecies
select distinct idfSpecies from dbo.tlbSpecies 
where idfHerd in (select * from @idfHerd)
and (idfSpecies not in (select idfSpecies from dbo.tlbAnimal union all select idfSpecies from dbo.tlbMonitoringSessionSummary) )

insert into @idfVaccination
select distinct idfVaccination from dbo.tlbVaccination where idfVetCase is null and idfSpecies in (select * from @idfSpecies)

insert into @idfAnimal
select distinct idfAnimal from dbo.tlbAnimal where idfSpecies in (select * from @idfSpecies)

-- Farm Observations
insert into @idfObservation
select idfObservation from dbo.tlbFarm where idfFarm in (select * from @idfFarmDelete) and idfObservation is not null

-- Species Observations
insert into @idfObservation
select idfObservation 
from dbo.tlbSpecies S
inner join dbo.tlbHerd H on	S.idfHerd = H.idfHerd
where idfSpecies in (select * from @idfSpecies) and idfObservation is not null

-- Animal Observations
insert into @idfObservation
select idfObservation
from dbo.tlbAnimal 
where idfAnimal in (select * from @idfAnimal) and idfObservation is not null

insert into @idfFarmFiltered
select idfFarmFiltered from dbo.tflFarmFiltered where idfFarm in (select * from @idfFarmDelete)

--BatchTest
insert into @idfBatchTest
select distinct idfBatchTest from dbo.tlbTesting where idfTesting in (select * from @idfTesting) and idfBatchTest is not null




set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup to zz_Backup tables'
----------------------------------------------------------------------------
--
-- create archives got all Session-related tables 
--
----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbMonitoringSessionToDiagnosis'
insert into zz_Backup_tlbMonitoringSessionToDiagnosis
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', idfMonitoringSession from dbo.tlbMonitoringSessionToDiagnosis
where idfMonitoringSession = @idfMonitoringSession

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbMonitoringSessionSummary'
insert into zz_Backup_tlbMonitoringSessionSummary
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbMonitoringSessionSummary 
where idfMonitoringSessionSummary in (select * from @idfMonitoringSessionSummary)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbMonitoringSessionSummaryDiagnosis'
insert into zz_Backup_tlbMonitoringSessionSummaryDiagnosis
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbMonitoringSessionSummaryDiagnosis 
where idfMonitoringSessionSummary in (select * from @idfMonitoringSessionSummaryDiagnosis)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbMonitoringSessionSummarySample'
insert into zz_Backup_tlbMonitoringSessionSummarySample
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbMonitoringSessionSummarySample 
where idfMonitoringSessionSummary in (select * from @idfMonitoringSessionSummarySample)

----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbMonitoringSessionAction'
insert into zz_Backup_tlbMonitoringSessionAction
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbMonitoringSessionAction
where idfMonitoringSession = @idfMonitoringSession

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tflMonitoringSessionFiltered'
insert into zz_Backup_tflMonitoringSessionFiltered
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tflMonitoringSessionFiltered 
where idfMonitoringSession = @idfMonitoringSession

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbTestAmendmentHistory'
insert into zz_Backup_tlbTestAmendmentHistory
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbTestAmendmentHistory 
where idfTesting in (select * from @idfTesting)

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbTestValidation'
insert into zz_Backup_tlbTestValidation
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tstLocalSamplesTestsPreferences'
insert into zz_Backup_tstLocalSamplesTestsPreferences
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tstLocalSamplesTestsPreferences 
where idfTesting in (select * from @idfTesting)

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbTesting'
insert into zz_Backup_tlbTesting
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbTesting 
where idfTesting in (select * from @idfTesting)

-------------------------------------------------------------------------------- 
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup non root tlbMaterial'
insert into zz_Backup_tlbMaterial
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbMaterial 
where idfMaterial in (select * from @idfMaterial)
and idfMaterial != idfRootMaterial

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup root material to tlbMaterial'
insert into zz_Backup_tlbMaterial
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Update', @idfMonitoringSession from dbo.tlbMaterial 
where idfMaterial in (select * from @idfMaterial)
and idfMaterial = idfRootMaterial

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbPensideTest'
insert into zz_Backup_tlbPensideTest
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbPensideTest
where idfMaterial in (select * from @idfMaterialDelete)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbTransferOut'
insert into zz_Backup_tlbTransferOut
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbTransferOut 
where idfTransferOut in (select * from @idfTransferOut)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbTransferOutMaterial'
insert into zz_Backup_tlbTransferOutMaterial
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbTransferOutMaterial 
where idfTransferOut in (select * from @idfTransferOutMaterial)

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbMonitoringSession'
insert into zz_Backup_tlbMonitoringSession
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbMonitoringSession 
where idfMonitoringSession = @idfMonitoringSession

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tflFarmFiltered'
insert into zz_Backup_tflFarmFiltered
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tflFarmFiltered
where idfFarm in (select idfFarm from @idfFarmDelete)

--------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbFarm'
insert into zz_Backup_tlbFarm
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbFarm
where idfFarm in (select * from @idfFarmDelete)
union all
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Update', @idfMonitoringSession from dbo.tlbFarm
where idfFarm in (select * from @idfFarmUpdate)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbObservation'
insert into zz_Backup_tlbObservation
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbObservation
where idfObservation in (select idfObservation from @idfObservation)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbHerd'
insert into zz_Backup_tlbHerd
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbHerd
where idfHerd in (select idfHerd from @idfHerd)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbSpecies'
insert into zz_Backup_tlbSpecies
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbSpecies
where idfSpecies in (select idfSpecies from @idfSpecies)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbVetCase'
insert into zz_Backup_tlbVetCase
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Update', @idfMonitoringSession from dbo.tlbVetCase
where idfVetCase in (select * from @idfVetCase)

-------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbVaccination'
insert into zz_Backup_tlbVaccination
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbVaccination
where idfVaccination in (select * from @idfVaccination)

---------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tlbBatchTest'
insert into zz_Backup_tlbBatchTest
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tlbBatchTest
where idfBatchTest in (select * from @idfBatchTest)

---------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Backup tflTransferOutFiltered'
insert into zz_Backup_tflTransferOutFiltered
select *, getdate(), suser_name(), 'Active Surveillance Session Delete', 'Delete', @idfMonitoringSession from dbo.tflTransferOutFiltered
where idfTransferOut in (select * from @idfTransferOut)

-----------------------------------------------------------------------------------
--
-- set context to allow hard delete
--
--  START DELETE
--
----------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Set contect to DataArchiving and begin Deletes'

EXEC spSetContext @Context
----------------------------------------------------------------------------
-- delete/update from all Active Session - related tables 
--
----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMonitoringSessionToDiagnosis'
delete from dbo.tlbMonitoringSessionToDiagnosis
where idfMonitoringSession = @idfMonitoringSession

-----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tflMonitoringSessionFiltered'
delete from dbo.tflMonitoringSessionFiltered 
where idfMonitoringSession = @idfMonitoringSession

----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMonitoringSessionAction'
delete from dbo.tlbMonitoringSessionAction
where idfMonitoringSession = @idfMonitoringSession

----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMonitoringSessionSummarySample'
delete from dbo.tlbMonitoringSessionSummarySample
where idfMonitoringSessionSummary in (select idfMonitoringSessionSummary from dbo.tlbMonitoringSessionSummary where idfMonitoringSession = @idfMonitoringSession)

----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMonitoringSessionSummaryDiagnosis'
delete from dbo.tlbMonitoringSessionSummaryDiagnosis
where idfMonitoringSessionSummary in (select idfMonitoringSessionSummary from dbo.tlbMonitoringSessionSummary where idfMonitoringSession = @idfMonitoringSession)

----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMonitoringSessionSummary'
delete from dbo.tlbMonitoringSessionSummary
where idfMonitoringSession = @idfMonitoringSession

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTestAmendmentHistory'
delete from dbo.tlbTestAmendmentHistory 
where idfTesting in (select idfTesting from @idfTesting)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTestValidation'
delete from dbo.tlbTestValidation 
where idfTestValidation in (select * from @idfTestValidation)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTestAmendmentHistory'
delete from dbo.tlbTestAmendmentHistory 
where idfTestAmendmentHistory in (select * from @idfTestAmendmentHistory)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tstLocalSamplesTestsPreferences'
delete from dbo.tstLocalSamplesTestsPreferences 
where idfTesting in (select * from @idfTesting)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTesting, set idfMaterial to null'
update dbo.tlbTesting
set idfMaterial = null
where idfMaterial in (select * from @idfMaterialDelete)
delete from dbo.tlbTesting 
where idfTesting in (select idfTesting from @idfTesting)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Update tlbMaterial. set idfMonitoringSession to null'
update dbo.tlbMaterial
set idfMonitoringSession = null
where idfMaterial in (select * from @idfMaterialUpdate)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Update tlbMaterial, set idfMainTest to null'
update dbo.tlbMaterial
set idfMainTest = null
where idfMaterial in (select * from @idfMaterialDelete)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTesting'
delete from dbo.tlbTesting
where idfTesting in (select * from @idfTesting)


--------delete records
----insert into @idfTransferOut
----select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfMaterialDelete)
--------delete records
----insert into @idfTransferOut
----select idfTransferOut from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfMaterialDelete)
		
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tflTransferOutFiltered'
delete from dbo.tflTransferOutFiltered where idfTransferOut in (select * from @idfTransferOut)
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTransferOutMaterial'
----delete from dbo.tlbTransferOutMaterial where idfMaterial in (select * from @idfMaterialDelete)
delete from dbo.tlbTransferOutMaterial where idfTransferOut in (select * from @idfTransferOutMaterial)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbTransferOUT'
delete from dbo.tlbTransferOUT where idfTransferOut in (select * from @idfTransferOut)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbPensideTest'
delete from dbo.tlbPensideTest where idfMaterial in (select * from @idfMaterialDelete)
 
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMaterial'
----set up to do hard delete
DECLARE	@return_value int
declare @MList_delete table(
  idfMaterial bigint,
  strBarCode nvarchar(50),
  idfRootMaterial bigint,
  idfParentMaterial bigint,
  MLevel int
); 

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
  where M.idfMaterial in (select * from @idfMaterial)

  union all

  select  T.idfMaterial, T.strBarCode, T.idfRootMaterial, T.idfParentMaterial, M.Level + 1
  from dbo.tlbMaterial T 
  INNER JOIN MList M on T.idfParentMaterial = M.idfMaterial
 )

insert into @MList
select * from MList
order by idfMaterial

insert into @MList_delete
select * from @MList
where idfMaterial in (select * from @idfMaterialDelete)
or idfParentMaterial in (select * from @idfMaterialDelete)

-- tlbMaterial: null all the columns prior to delete
update dbo.tlbMaterial
set idfMonitoringSession = null
where idfMaterial in (select idfMaterial from @MList)

update dbo.tlbMaterial
set intRowStatus = 1
where idfMaterial in (select idfMaterial from @MList_delete)

DECLARE @parent_id bigint, @child_id  bigint ,@child_patID bigint,@sessionID bigint,@message varchar(max) , @inicntM int, @inicnt int

select @inicntM=(select max(mlevel) from @MList_delete ) --#TempList)
WHILE @inicnt <=@inicntM
  BEGIN	

	IF @inicnt =0 
		BEGIN
	  	  ----PRINT 'need to get next level:' + convert(varchar,@inicnt) + ' @inicntM: ' + convert(varchar,@inicntM);
		  delete tlbmaterial 
		  where  idfMaterial in
		  (
		  select idfmaterial from @MList_delete  --
		  where mlevel =@inicnt and 
		  (idfMaterial not in (select distinct idfParentMaterial from @MList_delete where not (idfParentMaterial is null) ))) 
		END
	ELSE	
		BEGIN
		----PRINT 'need to get next level:' + convert(varchar,@inicnt) + ' @inicntM: ' + convert(varchar,@inicntM);
			delete tlbmaterial 
			where  idfMaterial in
			(
			select idfmaterial from @MList_delete --#TempList
			where mlevel =@inicnt and 
			(idfMaterial not in (select distinct idfParentMaterial from @MList_delete where (mlevel =@inicnt and not (idfParentMaterial is null) ))))
		END

    SET @inicnt = @inicnt +1;
  END;
		
		---------first layer of child
delete from dbo.tlbMaterial 
WHERE idfMaterial in (select * from @idfMaterialDelete)  and not (idfParentMaterial is null) and (idfParentMaterial =idfRootMaterial) 

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Completed Material delete'
------------------------------------------------------------------------------

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbVaccination'
delete from dbo.tlbVaccination 
where idfVaccination in (select * from @idfVaccination)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tflFarmFiltered'
delete from dbo.tflFarmFiltered
where idfFarm in (select * from @idfFarmDelete)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbSpecies'
delete from dbo.tlbSpecies 
where idfSpecies in (select * from @idfSpecies)

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbHerd'
delete from dbo.tlbHerd 
where idfHerd in (select * from @idfHerd)
and idfHerd not in (select idfHerd from dbo.tlbSpecies)

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbVetCase'
update dbo.tlbVetCase
set idfParentMonitoringSession = null
where idfParentMonitoringSession = @idfMonitoringSession

------------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbFarm'
update dbo.tlbFarm
set idfMonitoringSession = null
where idfFarm in (select * from @idfFarmUpdate)
or idfFarm in (select idfFarm from dbo.tlbHerd where idfHerd in (select * from @idfHerd))

delete from dbo.tlbFarm 
where idfFarm in (select * from @idfFarmDelete)
and idfMonitoringSession = @idfMonitoringSession

update dbo.tlbFarm
set idfMonitoringSession = null
where idfMonitoringSession = @idfMonitoringSession

-----------------------------------------------------------------------------
set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Delete tlbMonitoringSession'
delete from dbo.tlbMonitoringSession
where idfMonitoringSession =@idfMonitoringSession

set @LogMsg= @LogMsg + CHAR(13) + char(10) +'Reset context back to null'
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