
--##SUMMARY Posts AS session summary record.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:

declare @p4 bigint
set @p4=1
declare @p5 nvarchar(50)
set @p5=N'FGETBTB0110011'
declare @p6 bigint
set @p6=4582390000000
exec spASSessionSummary_Post @Action=16,@idfMonitoringSessionSummary=2,@idfMonitoringSession=1,@idfFarm=@p4 output,@strFarmCode=@p5 output,@idfFarmActual=@p6 output,@idfSpecies=NULL,@idfsAnimalSex=NULL,@intSampledAnimalsQty=NULL,@intSamplesQty=NULL,@datCollectionDate=NULL,@intPositiveAnimalsQty=NULL
select @p4, @p5, @p6


*/

CREATE PROCEDURE [dbo].[spASSessionSummary_Post]
			@Action int --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
           ,@idfMonitoringSessionSummary bigint
           ,@idfMonitoringSession bigint
           ,@idfFarm bigint OUTPUT
           ,@strFarmCode NVARCHAR(50) OUTPUT
           ,@idfFarmActual bigint OUTPUT
           ,@idfSpecies bigint
           ,@idfsAnimalSex bigint
           ,@intSampledAnimalsQty int
           ,@intSamplesQty int
           ,@datCollectionDate datetime
           ,@intPositiveAnimalsQty int
AS
--Post farm data here because there is no special farm object for summary records
--We have 3 possible scenario for summary record farm creation
--1. User doesn't edit farm column. In this case we create new farm and its root copy
--Application can pass NULL or ID not existing farm as @idfFarm in this case. @idfFarmActual = NULL in this case
--2. User edits farm data by pressing ... button. In this farm is created already we should do nothing
--In this case both @idfFarm and @idfFarmActual maust be defined.
--3. User selects farm from existing root farms. If farm exited already at the moment of selection
--In this case @idfFarmActual must be not NULL, @idfFarm can be equal NULL or ID not existing farm
IF (@Action<>8) --insert or update
BEGIN
	-- Scenario 1. @idfFarmActual = NULL, new farm and its root copy should be created
/*	IF ISNULL(@idfFarmActual, -1)<0 
	BEGIN
		DECLARE @idfFarmAddress bigint
		DECLARE @idfOwner bigint
		DECLARE @idfRootOwner bigint
		IF @idfFarm IS NULL
			EXEC dbo.spsysGetNewID @idfFarm OUTPUT  
		
		EXEC dbo.spsysGetNewID @idfFarmAddress OUTPUT  
		EXEC dbo.spsysGetNewID @idfOwner OUTPUT  

		EXECUTE spFarmPanel_Post
			   4  -- @Action
			  ,@idfFarm  
			  ,@idfFarmActual OUTPUT  
			  ,1 -- fake @idfCase , that identifies that non root farm is created
			  ,NULL --@idfMonitoringSession  
			  ,NULL --@strContactPhone  
			  ,NULL --@strInternationalName  
			  ,NULL --@strNationalName  
			  ,@strFarmCode OUTPUT  
			  ,NULL --@strFax  
			  ,NULL --@strEmail  
			  ,@idfFarmAddress  
			  ,@idfOwner  
			  ,@idfRootOwner OUTPUT  
			  ,NULL --@strOwnerLastName  
			  ,NULL --@strOwnerFirstName  
			  ,NULL --@strOwnerMiddleName  
			  ,NULL --@idfsOwnershipStructure    
			  ,NULL --@idfsLivestockProductionType
			  ,NULL --@idfsGrazingPattern       
			  ,NULL --@idfsMovementPattern    
			  ,NULL --@idfsAvianFarmType    
			  ,NULL --@idfsAvianProductionType 
			  ,NULL --@idfsIntendedUse
			  ,NULL --@intBirdsPerBuilding 
			  ,NULL --@intBuidings 
			  ,0
			  ,32

	END*/
	-- Scenario 3.
	--If farm was selected from existing farms, we should copy root farm data to our farm
	IF (ISNULL(@idfFarm, -1)<0 
			OR NOT EXISTS(SELECT * FROM tlbFarm WHERE idfFarm = @idfFarm AND intRowStatus = 0) -- new farm was created
			OR EXISTS(SELECT * FROM tlbFarm WHERE idfFarm = @idfFarm AND ISNULL(idfFarmActual,-1) <> @idfFarmActual AND intRowStatus = 0) --farm was replaced by selecting new root farm
		)
	BEGIN

		EXECUTE spFarm_CopyRootToNormal
			   @idfFarmActual
			  ,@idfFarm OUTPUT --@idfTargetFarm
			  ,NULL -- @idfMonitoringSession = NULL	because summary farm doesn't refer session directly
		--Update @strFarmCode because it can be changed during previous operation
		SELECT @strFarmCode = strFarmCode FROM tlbFarm WHERE idfFarm = @idfFarm AND intRowStatus = 0
	END

END

IF (@Action = 4) --insert
	INSERT INTO tlbMonitoringSessionSummary
			   (idfMonitoringSessionSummary
			   ,idfMonitoringSession
			   ,idfFarm
			   ,idfSpecies
			   ,idfsAnimalSex
			   ,intSampledAnimalsQty
			   ,intSamplesQty
			   ,datCollectionDate
			   ,intPositiveAnimalsQty
			   )
		 VALUES
			   (@idfMonitoringSessionSummary
			   ,@idfMonitoringSession
			   ,@idfFarm
			   ,@idfSpecies
			   ,@idfsAnimalSex
			   ,@intSampledAnimalsQty
			   ,@intSamplesQty
			   ,@datCollectionDate
			   ,@intPositiveAnimalsQty
			   )
	
ELSE IF (@Action = 16) --update
	UPDATE tlbMonitoringSessionSummary
	   SET 
		   idfFarm = @idfFarm
		  ,idfSpecies = @idfSpecies
		  ,idfsAnimalSex = @idfsAnimalSex
		  ,intSampledAnimalsQty = @intSampledAnimalsQty
		  ,intSamplesQty = @intSamplesQty
		  ,datCollectionDate = @datCollectionDate
		  ,intPositiveAnimalsQty = @intPositiveAnimalsQty
	 WHERE 
		idfMonitoringSessionSummary = @idfMonitoringSessionSummary
	
ELSE IF (@Action = 8) --DELETE
BEGIN
	DELETE FROM tlbMonitoringSessionSummaryDiagnosis
	WHERE 
		idfMonitoringSessionSummary = @idfMonitoringSessionSummary
		AND intRowStatus = 0
	DELETE FROM tlbMonitoringSessionSummarySample
	WHERE 
		idfMonitoringSessionSummary = @idfMonitoringSessionSummary
		AND intRowStatus = 0
	DELETE FROM tlbMonitoringSessionSummary
	WHERE 
		idfMonitoringSessionSummary = @idfMonitoringSessionSummary
		AND intRowStatus = 0
	--TODO: farm deleting shall be performed after positing all summary records
	--EXEC spFarm_Delete @idfFarm
END
RETURN 0
