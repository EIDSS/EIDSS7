
--##SUMMARY Posts farm tree data. These data includes info about farm and its child herds/species
--##SUMMARY loaded by VetFarmTree_SelectDetail procedure

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

DECLARE @Action int
DECLARE @idfMonitoringSession bigint
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


EXECUTE spASFarmTree_Post
   @Action
  ,@idfMonitoringSession
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



CREATE              Proc	[dbo].[spASFarmTree_Post]
		@Action int,   --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
		@idfMonitoringSession bigint, --##PARAM @idfMonitoringSession - ID of monitoring session to which animal belongs
		@idfParty bigint, --##PARAM @idfParty - reference to farm, herd or species record (depending on @idfsPartyType)
		@idfsPartyType bigint, --##PARAM @idfsPartyType - Type of posted record (can reference farm, herd or species)
		@strName nvarchar(200) OUTPUT, --##PARAM @strName - the the human readable name of the farm tree node. Displays farm Code, herd Code, of idfSpeciesType
		@idfParentParty bigint, --##PARAM @idfParentParty - ID of parent node
		@intTotalAnimalQty int, --##PARAM @intTotalAnimalQty - Total Animal Qty related with current node
		@strNote nvarchar(2000) --##PARAM @strNote
As

DECLARE 
   @idfHerdActual BIGINT
	,@idfFarmActual BIGINT
	,@idfSpeciesActual BIGINT

IF	NOT @idfMonitoringSession IS NULL AND 
	NOT EXISTS (SELECT idfMonitoringSession FROM tlbMonitoringSession WHERE idfMonitoringSession = @idfMonitoringSession)
	SET @idfMonitoringSession = NULL --session is not posted yet, the link will be set later
	
	
IF @idfsPartyType = 10072005 --'pptCaseFarm'
BEGIN
	IF @Action <>8 --if we insert or update farm node 
	BEGIN
		UPDATE tlbFarm
		SET 
		  intLivestockTotalAnimalQty = @intTotalAnimalQty
		  ,strNote = @strNote
		  ,idfMonitoringSession = @idfMonitoringSession	
		WHERE idfFarm = @idfParty
		
		--update fa 
		--set 
		--   fa.intLivestockTotalAnimalQty = @intTotalAnimalQty
		--from   tlbFarmActual fa
		--  inner join tlbFarm on
		--    tlbFarm.idfFarmActual = fa.idfFarmActual
		--WHERE tlbFarm.idfFarm = @idfParty
	END
END

IF @idfsPartyType = 10072003 --'pptCaseHerd'
BEGIN
	IF @Action = 16
	BEGIN
		UPDATE tlbHerd
		   SET  
			  idfFarm = @idfParentParty
			  ,strHerdCode = @strName
			  ,intTotalAnimalQty = @intTotalAnimalQty
			  ,strNote = @strNote
		 WHERE idfHerd=@idfParty
	END
	
	IF @Action = 8 --Delete
	BEGIN
		DELETE tlbAnimal 
		FROM tlbAnimal
		INNER JOIN tlbSpecies ON
			tlbAnimal.idfSpecies = tlbSpecies.idfSpecies
		WHERE 
			tlbSpecies.idfHerd = @idfParty
			AND tlbAnimal.intRowStatus = 0
			
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
			
			
			--select @idfFarmActual = fa.idfFarmActual 
			--from tlbFarmActual fa
			--  inner join tlbFarm f on
			--    f.idfFarmActual = fa.idfFarmActual and
			--    f.idfFarm = @idfParentParty
			/*SELECT TOP 1 @idfHerdActual = idfHerdActual
			from tlbHerdActual 
			where strHerdCode = @strName
				and intRowStatus = 0*/
			--IF @idfHerdActual is null
			--begin
			--EXEC dbo.spsysGetNewID @idfHerdActual OUT
			--INSERT INTO tlbHerdActual
			--		   (
			--	  		idfHerdActual
			--		   ,idfFarmActual
			--		   ,strHerdCode
			--		   ,intTotalAnimalQty
			--		   ,strNote
			--		   )
			--	 VALUES
			--		   (
			--		  	@idfHerdActual
			--		   ,@idfFarmActual
			--		   ,@strName
			--		   ,@intTotalAnimalQty
			--		   ,@strNote
			--		   )
			--end
 		--Herd itself
			INSERT INTO tlbHerd
					   (
				  		idfHerd
				  	 ,idfHerdActual
					   ,idfFarm
					   ,strHerdCode
					   ,intTotalAnimalQty
					   ,strNote
					   )
				 VALUES
					   (
					  	@idfParty
					   ,NULL
					   ,@idfParentParty
					   ,@strName
					   ,@intTotalAnimalQty
					   ,@strNote
					   )
					   
					   
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
			  ,intTotalAnimalQty = @intTotalAnimalQty
			  ,strNote = @strNote
		 WHERE idfSpecies = @idfParty
		 
		 
	END
	IF @Action = 8 --Delete
	BEGIN
		DELETE tlbAnimal 
		FROM tlbAnimal
		WHERE 
			idfSpecies = @idfParty
			AND intRowStatus = 0
			
		DELETE tlbSpecies 
		WHERE 
			idfSpecies = @idfParty
	END


	IF @Action = 4
	BEGIN

    /*select @idfHerdActual = ha.idfHerdActual
    from tlbHerdActual ha
      inner join tlbHerd 
      on tlbHerd.idfHerdActual = ha.idfHerdActual
	  WHERE
         tlbHerd.idfHerd = @idfParentParty
		 and tlbHerd.intRowStatus = 0
		 and ha.intRowStatus = 0

	select @idfSpeciesActual = idfSpeciesActual
	from tlbSpeciesActual
	where
		idfsSpeciesType = CAST(@strName AS bigint)
		and idfHerdActual = @idfHerdActual
		and intRowStatus = 0*/
	--if @idfSpeciesActual is null
	--begin
	--	EXEC dbo.spsysGetNewID @idfSpeciesActual OUT
         
	--	INSERT INTO tlbSpeciesActual
	--			   (idfSpeciesActual
	--			   ,idfsSpeciesType
	--			   ,idfHerdActual
	--			   ,intTotalAnimalQty
	--			   ,strNote)
	--		 VALUES
	--			   (@idfSpeciesActual
	--			   ,CAST(@strName AS bigint)
	--			   ,@idfHerdActual
	--			   ,@intTotalAnimalQty
	--			   ,@strNote)	
	--end

		INSERT INTO tlbSpecies
				   (idfSpecies
				   ,idfSpeciesActual
				   ,idfsSpeciesType
				   ,idfHerd
				   ,intTotalAnimalQty
				   ,strNote)
			 VALUES
				   (@idfParty
				   ,NULL--@idfSpeciesActual
				   ,CAST(@strName AS bigint)
				   ,@idfParentParty
				   ,@intTotalAnimalQty
				   ,@strNote)	
	END
END

