






--##SUMMARY Posts farm tree data. These data includes info about farm and its child herds/species
--##SUMMARY loaded by VetFarmTree_SelectDetail procedure

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

--DECLARE @Action int
--DECLARE @idfCase bigint
--DECLARE @idfParty bigint
--DECLARE @idfsPartyType bigint
--DECLARE @strName nvarchar(200)
--DECLARE @idfParentParty bigint
--DECLARE @idfObservation bigint
--DECLARE @intTotalAnimalQty int
--DECLARE @intSickAnimalQty int
--DECLARE @intDeadAnimalQty int
--DECLARE @strAverageAge nvarchar(200)
--DECLARE @datStartOfSignsDate datetime
--DECLARE @strNote nvarchar(2000)


--EXECUTE spVetFarmTree_Post
--   @Action
--  ,@idfCase
--  ,@idfParty
--  ,@idfsPartyType
--  ,@strName OUTPUT
--  ,@idfParentParty
--  ,@idfObservation
--  ,@intTotalAnimalQty
--  ,@intSickAnimalQty
--  ,@intDeadAnimalQty
--  ,@strAverageAge
--  ,@datStartOfSignsDate
--  ,@strNote
*/



CREATE              Proc	[dbo].[spVetFarmTree_Post]
		@Action int,   --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
		@idfCase bigint, --##PARAM @idfCase - ID of case to which animal belongs
		@idfMonitoringSession bigint, --##PARAM @idfMonitoringSession - ID of monitoring session to which animal belongs
		@idfParty bigint, --##PARAM @idfParty - reference to farm, herd or species record (depending on @idfsPartyType)
		@idfsPartyType bigint, --##PARAM @idfsPartyType - Type of posted record (can reference farm, herd or species)
		@strName nvarchar(200) OUTPUT, --##PARAM @strName - the the human readable name of the farm tree node. Displays farm Code, herd Code, of idfSpeciesType
		@idfParentParty bigint, --##PARAM @idfParentParty - ID of parent node
		@idfObservation bigint, --##PARAM @idfObservation - ID of observation related with current node
		@idfsFormTemplate bigint, --##PARAM @idfsFormTemplate - reference to template that was used last time for control measures flexible form 
		@intTotalAnimalQty int, --##PARAM @intTotalAnimalQty - Total Animal Qty related with current node
		@intSickAnimalQty int, --##PARAM @intSickAnimalQty - Sick Animal Qty related with current node
		@intDeadAnimalQty int, --##PARAM @intDeadAnimalQty - Dead Animal Qty related with current node
		@strAverageAge nvarchar(200), --##PARAM @strAverageAge - Average age of animal related with current node
		@datStartOfSignsDate datetime, --##PARAM @datStartOfSignsDate - date when signs was started
		@strNote nvarchar(2000), --##PARAM @strNote,
		@idfsCaseType bigint = null
As

DECLARE @CaseType AS BIGINT 
DECLARE @Observation Table
(
	idfObservation bigint
)

IF	NOT @idfMonitoringSession IS NULL AND 
	NOT EXISTS (SELECT idfMonitoringSession FROM tlbMonitoringSession WHERE idfMonitoringSession = @idfMonitoringSession)
	SET @idfMonitoringSession = NULL --session is not posted yet, the link will be set later

if(@idfsCaseType is null)
begin
	Select 
		@CaseType = idfsCaseType
	FROM tlbVetCase
	Where 
		idfVetCase=@idfCase
		and intRowStatus=0
end
else
begin
	set @CaseType = @idfsCaseType
end

SET @CaseType = ISNULL(@CaseType,0)

IF @idfsPartyType = 10072005 --'pptCaseFarm'
BEGIN
--	IF @Action = 16 --update
	EXEC spObservation_Post	@idfObservation, @idfsFormTemplate
	BEGIN
		UPDATE tlbFarm
		SET 
		  idfObservation = @idfObservation
		  ,intAvianSickAnimalQty = CASE WHEN @CaseType = 10012004/*avian*/ THEN @intSickAnimalQty ELSE intAvianSickAnimalQty END
		  ,intLivestockSickAnimalQty = CASE WHEN @CaseType <> 10012004/*avian*/ THEN @intSickAnimalQty ELSE intLivestockSickAnimalQty END
		  ,intAvianTotalAnimalQty = CASE WHEN @CaseType = 10012004/*avian*/ THEN @intTotalAnimalQty ELSE intAvianTotalAnimalQty END
		  ,intLivestockTotalAnimalQty = CASE WHEN @CaseType <> 10012004/*avian*/ THEN @intTotalAnimalQty ELSE intLivestockTotalAnimalQty END
		  ,intAvianDeadAnimalQty = CASE WHEN @CaseType = 10012004/*avian*/ THEN @intDeadAnimalQty ELSE intAvianDeadAnimalQty END
		  ,intLivestockDeadAnimalQty = CASE WHEN @CaseType <> 10012004/*avian*/ THEN @intDeadAnimalQty ELSE intLivestockDeadAnimalQty END
		  ,strNote = @strNote
		  ,idfMonitoringSession = @idfMonitoringSession	
		WHERE idfFarm = @idfParty
			AND intRowStatus = 0
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
			  ,intSickAnimalQty = @intSickAnimalQty
			  ,intTotalAnimalQty = @intTotalAnimalQty
			  ,intDeadAnimalQty = @intDeadAnimalQty
			  ,strNote = @strNote
		 WHERE idfHerd=@idfParty
	END
	IF @Action = 8 --Delete
	BEGIN
		--Animal observations
		insert into @Observation
		(
		idfObservation
		)
		SELECT
			tlbAnimal.idfObservation
		FROM tlbAnimal
		INNER JOIN tlbSpecies ON
			tlbAnimal.idfSpecies = tlbSpecies.idfSpecies
		WHERE 
			tlbSpecies.idfHerd = @idfParty
			AND tlbAnimal.intRowStatus = 0

		--Species observations
		insert into @Observation
		(
		idfObservation
		)
		SELECT
			idfObservation
		FROM tlbSpecies
		WHERE 
			tlbSpecies.idfHerd = @idfParty

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

		DELETE dbo.tlbActivityParameters
		WHERE 	idfObservation in (Select idfObservation from @Observation)

		delete	tlbObservation
		where	idfObservation in (Select idfObservation from @Observation)
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
		EXEC spObservation_Post	@idfObservation, @idfsFormTemplate
		UPDATE tlbSpecies
		   SET 
			  idfsSpeciesType = CAST(@strName AS bigint)
			  ,idfHerd = @idfParentParty
			  ,idfObservation = @idfObservation
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
		--Animal observations
		insert into @Observation
		(
		idfObservation
		)
		SELECT
			idfObservation
		FROM tlbAnimal
		WHERE 
			idfSpecies = @idfParty
			AND intRowStatus = 0

		--Species observations
		insert into @Observation
		(
		idfObservation
		)
		SELECT
			idfObservation
		FROM tlbSpecies
		WHERE 
			idfSpecies = @idfParty


		DELETE tlbAnimal 
		FROM tlbAnimal
		WHERE 
			idfSpecies = @idfParty
			AND intRowStatus = 0
			
		DELETE tlbSpecies 
		WHERE 
			idfSpecies = @idfParty
			AND intRowStatus = 0

		DELETE dbo.tlbActivityParameters
		WHERE 	idfObservation in (Select idfObservation from @Observation)

		delete	tlbObservation
		where	idfObservation in (Select idfObservation from @Observation)
	END


	IF @Action = 4
	BEGIN
		EXEC spObservation_Post	@idfObservation, @idfsFormTemplate

		--Species itself
		INSERT INTO tlbSpecies
				   (idfSpecies
				   ,idfsSpeciesType
				   ,idfHerd
				   ,idfObservation
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
				   ,@idfObservation
				   ,@datStartOfSignsDate
				   ,@strAverageAge
				   ,@intSickAnimalQty
				   ,@intTotalAnimalQty
				   ,@intDeadAnimalQty
				   ,@strNote)	
	END
END

