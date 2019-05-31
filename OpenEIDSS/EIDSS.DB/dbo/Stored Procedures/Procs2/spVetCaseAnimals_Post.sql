


--##SUMMARY Posts animals data related with specific case.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009
--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011


--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @Action int
DECLARE @idfAnimal bigint
DECLARE @idfHerd bigint
DECLARE @idfsAnimalAge bigint
DECLARE @idfsAnimalGender bigint
DECLARE @strAnimalCode nvarchar(200)
DECLARE @strDescription nvarchar(200)
DECLARE @idfsAnimalCondition bigint
DECLARE @idfSpecies bigint
DECLARE @idfObservation bigint
DECLARE @idfsFormTemplate bigint
DECLARE @idfCase bigint


EXECUTE spVetCaseAnimals_Post
   @Action
  ,@idfAnimal
  ,@idfHerd
  ,@idfsAnimalAge
  ,@idfsAnimalGender
  ,@strAnimalCode
  ,@strDescription
  ,@idfsAnimalCondition
  ,@idfSpecies
  ,@idfObservation
  ,@idfsFormTemplate
  ,@idfCase

*/






CREATE             Proc	[dbo].[spVetCaseAnimals_Post]
	@Action int,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfAnimal BIGINT,  --##PARAM @idfAnimal - animal ID
	@idfHerd BIGINT, --##PARAM @idfHerd - animal herd ID
	@idfsAnimalAge BIGINT, --##PARAM @idfsAnimalAge - animal age, reference to rftAnimalAgeList (19000005)
	@idfsAnimalGender BIGINT, --##PARAM @idfsAnimalGender - animal gender, reference to rftAnimalGenderList (19000007)
	@strAnimalCode NVARCHAR(200) OUTPUT, --##PARAM @strAnimalCode - animal barcode
	@strDescription NVARCHAR(200), --##PARAM @strDescription - animal description, currently is not defined by client app
	@idfsAnimalCondition BIGINT, --##PARAM @idfsAnimalCondition - animal state, reference to  rftAnimalCondition (19000006)
	@idfSpecies BIGINT, --##PARAM @idfSpecies - animal species, reference to tlbSpecies table. Species defind by this value must be included to herd defined by @idfHerd
	@idfObservation BIGINT,--##PARAM @idfObservation - animal clinical signs, reference flexible form data
	@idfsFormTemplate BIGINT,--##PARAM @idfsFormTemplate - flexible form template ID
	@idfCase BIGINT, --##PARAM @idfCase - ID of case to which animal belongs
 	@uidOfflineCaseID uniqueidentifier = NULL

As
IF @Action = 16 --Modified
BEGIN

	--Observation
	EXECUTE spObservation_Post @idfObservation, @idfsFormTemplate

	--Animal itself
	UPDATE tlbAnimal
	SET 
		idfsAnimalAge=@idfsAnimalAge,
		idfsAnimalGender=@idfsAnimalGender,
		strDescription=@strDescription, 
		strAnimalCode=@strAnimalCode, 
		idfsAnimalCondition=@idfsAnimalCondition, 
		idfSpecies=@idfSpecies, 
		idfObservation=@idfObservation,
   		strReservedAttribute = convert(nvarchar(max),@uidOfflineCaseID)

	WHERE 	
		idfAnimal=@idfAnimal
		AND intRowStatus = 0
END
IF @Action = 8 --Delete
BEGIN
		SELECT	@idfObservation=idfObservation
		FROM	tlbAnimal
		WHERE 	
			idfAnimal=@idfAnimal
			AND intRowStatus = 0

		DELETE tlbAnimal 
		WHERE 
			idfAnimal = @idfAnimal
			AND intRowStatus = 0
			
		EXEC spObservation_Delete @idfObservation
END

IF @Action = 4
BEGIN
	--Observation
	EXECUTE spObservation_Post @idfObservation, @idfsFormTemplate

	--Animal itself
	IF ISNULL(@strAnimalCode,N'') = N'' OR LEFT(ISNULL(@strAnimalCode,N''),4)='(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057004/*Animal*/, @strAnimalCode OUTPUT , NULL 
	END
	INSERT INTO tlbAnimal
			(
				idfAnimal
			   ,idfsAnimalGender
			   ,idfsAnimalCondition
			   ,idfsAnimalAge
			   ,idfSpecies
			   ,idfObservation
			   ,strDescription
			   ,strAnimalCode
   			   ,strReservedAttribute 
			)
		 VALUES
			(
				@idfAnimal
			   ,@idfsAnimalGender
			   ,@idfsAnimalCondition
			   ,@idfsAnimalAge
			   ,@idfSpecies
			   ,@idfObservation
			   ,@strDescription
			   ,@strAnimalCode
			   ,convert(nvarchar(max),@uidOfflineCaseID)

			)	
END









