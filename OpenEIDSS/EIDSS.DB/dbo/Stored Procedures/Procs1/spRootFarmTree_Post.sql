






--##SUMMARY Posts farm tree data. These data includes info about farm and its child herds/species
--##SUMMARY loaded by [spRootFarmTree_SelectDetail] procedure
--##SUMMARY These data are accessible only for actual (root) farm, not related to case

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Gorodentseva T. no animals information is associated with tlbFarmActual now
--##REMARKS Date: 24.07.2012

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

DECLARE @Action int
DECLARE @idfCase bigint
DECLARE @idfParty bigint
DECLARE @idfsPartyType bigint
DECLARE @strName nvarchar(200)
DECLARE @idfParentParty bigint
DECLARE @idfObservation bigint
DECLARE @intTotalAnimalQty int
DECLARE @intSickAnimalQty int
DECLARE @intDeadAnimalQty int
DECLARE @strAverageAge nvarchar(200)
DECLARE @datStartOfSignsDate datetime
DECLARE @strNote nvarchar(2000)


EXECUTE spRootFarmTree_Post
   @Action
  ,@idfCase
  ,@idfParty
  ,@idfsPartyType
  ,@strName OUTPUT
  ,@idfParentParty
  ,@idfObservation
  ,@intTotalAnimalQty
  ,@intSickAnimalQty
  ,@intDeadAnimalQty
  ,@strAverageAge
  ,@datStartOfSignsDate
  ,@strNote
*/



CREATE              Proc	[dbo].[spRootFarmTree_Post]
		@Action int,   --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
		@idfParty bigint, --##PARAM @idfParty - reference to farm, herd or species record (depending on @idfsPartyType)
		@idfsPartyType bigint, --##PARAM @idfsPartyType - Type of posted record (can reference farm, herd or species)
		@strName nvarchar(200) OUTPUT, --##PARAM @strName - the the human readable name of the farm tree node. Displays farm Code, herd Code, of idfSpeciesActualType
		@idfParentParty bigint, --##PARAM @idfParentParty - ID of parent node
		@intTotalAnimalQty int, --##PARAM @intTotalAnimalQty - Total Animal Qty related with current node
		@intSickAnimalQty int, --##PARAM @intSickAnimalQty - Sick Animal Qty related with current node
		@intDeadAnimalQty int, --##PARAM @intDeadAnimalQty - Dead Animal Qty related with current node
		@strAverageAge nvarchar(200), --##PARAM @strAverageAge - Average age of animal related with current node
		@datStartOfSignsDate datetime, --##PARAM @datStartOfSignsDate - date when signs was started
		@strNote nvarchar(2000), --##PARAM @strNote
		@HACode	int--##PARAM @HACode - HA Code of posted tree node (livetock or animal)

As
/*IF (@idfsPartyType = 10072005 AND EXISTS (SELECT idfFarmActual FROM tlbFarmActual WHERE idfFarmActual = @idfParty))
	OR (@idfsPartyType = 10072003 AND EXISTS ( SELECT idfFarmActual FROM tlbFarmActual WHERE idfFarmActual = @idfParentParty))
	OR (@idfsPartyType = 10072004 AND EXISTS (SELECT tlbFarmActual.idfFarmActual FROM tlbFarmActual 
											INNER JOIN tlbHerdActual ON tlbHerdActual.idfFarmActual = tlbFarmActual.idfFarmActual
											WHERE tlbHerdActual.idfHerdActual = @idfParentParty))
BEGIN
	IF @idfsPartyType = 10072005 --'pptCaseFarm'
	BEGIN
	--	IF @Action = 16 --update
		BEGIN
			UPDATE tlbFarmActual
			SET 
			   intAvianSickAnimalQty = CASE WHEN (@HACode & 64)<>0 /*avian*/ THEN @intSickAnimalQty ELSE intAvianSickAnimalQty END
			  ,intLivestockSickAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN intLivestockSickAnimalQty ELSE @intSickAnimalQty END
			  ,intAvianTotalAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN @intTotalAnimalQty ELSE intAvianTotalAnimalQty END
			  ,intLivestockTotalAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN intLivestockTotalAnimalQty ELSE @intTotalAnimalQty END
			  ,intAvianDeadAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN @intDeadAnimalQty ELSE intAvianDeadAnimalQty END
			  ,intLivestockDeadAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN intLivestockDeadAnimalQty ELSE @intDeadAnimalQty END
			  ,strNote = @strNote
			WHERE idfFarmActual = @idfParty
		END
		IF @@ROWCOUNT=0
			RAISERROR ('ivalid post operation for farm in farm tree', 16, 1)

	END

	IF @idfsPartyType = 10072003 --'pptCaseHerd'
	BEGIN
		IF @Action = 16
		BEGIN
			UPDATE tlbHerdActual
			   SET  
				  idfFarmActual = @idfParentParty
				  ,strHerdCode = @strName
				  ,intSickAnimalQty = @intSickAnimalQty
				  ,intTotalAnimalQty = @intTotalAnimalQty
				  ,intDeadAnimalQty = @intDeadAnimalQty
				  ,strNote = @strNote
			 WHERE idfHerdActual=@idfParty
		END
		IF @Action = 8 --Delete
		BEGIN
				
			DELETE tlbSpeciesActual 
			WHERE 
				tlbSpeciesActual.idfHerdActual = @idfParty

			DELETE tlbHerdActual 
			WHERE 
				tlbHerdActual.idfHerdActual = @idfParty

		END

		IF @Action = 4
		BEGIN
				IF ISNULL(@strName,N'') = N'' OR LEFT(ISNULL(@strName,N''),4)='(new'
				BEGIN
					EXEC dbo.spGetNextNumber 10057013, @strName OUTPUT , NULL --N'Herd'
				END

			--Herd itself
				INSERT INTO tlbHerdActual
						   (
							idfHerdActual
						   ,idfFarmActual
						   ,strHerdCode
						   ,intSickAnimalQty
						   ,intTotalAnimalQty
						   ,intDeadAnimalQty
						   ,strNote)
					 VALUES
						   (
							@idfParty
						   ,@idfParentParty
						   ,@strName
						   ,@intSickAnimalQty
						   ,@intTotalAnimalQty
						   ,@intDeadAnimalQty
						   ,@strNote)
		END
		
	END


	IF @idfsPartyType = 10072004 --'Species'
	BEGIN
		IF @Action = 16
		BEGIN
			UPDATE tlbSpeciesActual
			   SET 
				  idfsSpeciesType = CAST(@strName AS bigint)
				  ,idfHerdActual = @idfParentParty
				  ,datStartOfSignsDate = @datStartOfSignsDate
				  ,strAverageAge = @strAverageAge
				  ,intSickAnimalQty = @intSickAnimalQty
				  ,intTotalAnimalQty = @intTotalAnimalQty
				  ,intDeadAnimalQty = @intDeadAnimalQty
				  ,strNote = @strNote
			 WHERE idfSpeciesActual = @idfParty
		END
		IF @Action = 8 --Delete
		BEGIN
				
			DELETE tlbSpeciesActual 
			WHERE 
				idfSpeciesActual = @idfParty
		END


		IF @Action = 4
		BEGIN

			--Species itself
			INSERT INTO tlbSpeciesActual
					   (idfSpeciesActual
					   ,idfsSpeciesType
					   ,idfHerdActual
					   ,datStartOfSignsDate
					   ,strAverageAge
					   ,intSickAnimalQty
					   ,intTotalAnimalQty
					   ,intDeadAnimalQty
					   ,strNote)
				 VALUES
					   (@idfParty
					   ,CAST(@strName AS bigint)
					   ,@idfParentParty
					   ,@datStartOfSignsDate
					   ,@strAverageAge
					   ,@intSickAnimalQty
					   ,@intTotalAnimalQty
					   ,@intDeadAnimalQty
					   ,@strNote)	
		END
	END
END
ELSE
BEGIN
*/
	IF @idfsPartyType = 10072005 --'pptCaseFarm'
	BEGIN
	--	IF @Action = 16 --update
		BEGIN
			UPDATE tlbFarm
			SET 
			   intAvianSickAnimalQty = CASE WHEN (@HACode & 64)<>0 /*avian*/ THEN @intSickAnimalQty ELSE intAvianSickAnimalQty END
			  ,intLivestockSickAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN intLivestockSickAnimalQty ELSE @intSickAnimalQty END
			  ,intAvianTotalAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN @intTotalAnimalQty ELSE intAvianTotalAnimalQty END
			  ,intLivestockTotalAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN intLivestockTotalAnimalQty ELSE @intTotalAnimalQty END
			  ,intAvianDeadAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN @intDeadAnimalQty ELSE intAvianDeadAnimalQty END
			  ,intLivestockDeadAnimalQty = CASE WHEN (@HACode & 64)<>0/*avian*/ THEN intLivestockDeadAnimalQty ELSE @intDeadAnimalQty END
			  ,strNote = @strNote
			WHERE idfFarm = @idfParty
		END
		IF @@ROWCOUNT=0
			RAISERROR ('ivalid post operation for farm in farm tree', 16, 1)

	END

	IF @idfsPartyType = 10072003 --'pptCaseHerd'
	BEGIN
		IF @Action = 16
		BEGIN
			UPDATE tlbHerd
			   SET  
				  idfFarm = @idfParentParty
				  ,strHerdCode = @strName
				  ,intSickAnimalQty = @intSickAnimalQty
				  ,intTotalAnimalQty = @intTotalAnimalQty
				  ,intDeadAnimalQty = @intDeadAnimalQty
				  ,strNote = @strNote
			 WHERE idfHerd=@idfParty
		END
		IF @Action = 8 --Delete
		BEGIN
				
			DELETE tlbSpecies 
			WHERE 
				tlbSpecies.idfHerd = @idfParty

			DELETE tlbHerd 
			WHERE 
				tlbHerd.idfHerd = @idfParty

		END

		IF @Action = 4
		BEGIN
				IF ISNULL(@strName,N'') = N'' OR LEFT(ISNULL(@strName,N''),4)='(new'
				BEGIN
					EXEC dbo.spGetNextNumber 10057013, @strName OUTPUT , NULL --N'Herd'
				END

			--Herd itself
				INSERT INTO tlbHerd
						   (
							idfHerd
						   ,idfFarm
						   ,strHerdCode
						   ,intSickAnimalQty
						   ,intTotalAnimalQty
						   ,intDeadAnimalQty
						   ,strNote)
					 VALUES
						   (
							@idfParty
						   ,@idfParentParty
						   ,@strName
						   ,@intSickAnimalQty
						   ,@intTotalAnimalQty
						   ,@intDeadAnimalQty
						   ,@strNote)
		END
		
	END


	IF @idfsPartyType = 10072004 --'Species'
	BEGIN
		IF @Action = 16
		BEGIN
			UPDATE tlbSpecies
			   SET 
				  idfsSpeciesType = CAST(@strName AS bigint)
				  ,idfHerd = @idfParentParty
				  ,datStartOfSignsDate = @datStartOfSignsDate
				  ,strAverageAge = @strAverageAge
				  ,intSickAnimalQty = @intSickAnimalQty
				  ,intTotalAnimalQty = @intTotalAnimalQty
				  ,intDeadAnimalQty = @intDeadAnimalQty
				  ,strNote = @strNote
			 WHERE idfSpecies = @idfParty
		END
		IF @Action = 8 --Delete
		BEGIN
				
			DELETE tlbSpecies 
			WHERE 
				idfSpecies = @idfParty
		END


		IF @Action = 4
		BEGIN

			--Species itself
			INSERT INTO tlbSpecies
					   (idfSpecies
					   ,idfsSpeciesType
					   ,idfHerd
					   ,datStartOfSignsDate
					   ,strAverageAge
					   ,intSickAnimalQty
					   ,intTotalAnimalQty
					   ,intDeadAnimalQty
					   ,strNote)
				 VALUES
					   (@idfParty
					   ,CAST(@strName AS bigint)
					   ,@idfParentParty
					   ,@datStartOfSignsDate
					   ,@strAverageAge
					   ,@intSickAnimalQty
					   ,@intTotalAnimalQty
					   ,@intDeadAnimalQty
					   ,@strNote)	
		END
	END
/*END*/









