﻿


--##SUMMARY Posts animals data related with specific case.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @Action int
DECLARE @idfAnimal bigint
DECLARE @idfsAnimalAge bigint
DECLARE @idfsAnimalGender bigint
DECLARE @strAnimalCode nvarchar(200)
DECLARE @idfSpecies bigint
DECLARE @strName nvarchar(200)
DECLARE @strColor nvarchar(200)
DECLARE @idfMonitoringSession bigint


EXECUTE spASSessionAnimals_Post
   @Action
  ,@idfAnimal
  ,@idfsAnimalAge
  ,@idfsAnimalGender
  ,@strAnimalCode OUTPUT
  ,@idfSpecies
  ,@strName OUTPUT
  ,@strColor OUTPUT
  ,@idfMonitoringSession
*/






CREATE             Proc	[dbo].[spASSessionAnimals_Post]
	@Action int,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfAnimal BIGINT,  --##PARAM @idfAnimal - animal ID
	--@idfHerd BIGINT, --##PARAM @idfHerd - animal herd ID
	@idfsAnimalAge BIGINT, --##PARAM @idfsAnimalAge - animal age, reference to rftAnimalAgeList (19000005)
	@idfsAnimalGender BIGINT, --##PARAM @idfsAnimalGender - animal gender, reference to rftAnimalGenderList (19000007)
	@strAnimalCode NVARCHAR(200) OUTPUT, --##PARAM @strAnimalCode - animal barcode
	@idfSpecies BIGINT, --##PARAM @idfSpecies - animal species, reference to tlbSpecies table. Species defind by this value must be included to herd defined by @idfHerd
	@strName NVARCHAR(200), --##PARAM @strName - animal  name
	@strColor NVARCHAR(200), --##PARAM @strColor - animal color
	@idfMonitoringSession BIGINT, --##PARAM @idfMonitoringSession - ID of case to which animal belongs
	@strDescription NVARCHAR(200)
As
IF @Action = 16 --Modified
BEGIN

	--Animal itself
	UPDATE tlbAnimal
	SET 
		idfsAnimalAge=@idfsAnimalAge,
		idfsAnimalGender=@idfsAnimalGender,
		strAnimalCode=@strAnimalCode, 
		idfSpecies=@idfSpecies,
		strName = @strName,
		strColor = @strColor,
		strDescription = @strDescription
	WHERE 	
		idfAnimal=@idfAnimal
		AND intRowStatus = 0
END
IF @Action = 8 --Delete
BEGIN

		DELETE tlbAnimal 
		WHERE 
			idfAnimal = @idfAnimal
			--AND intRowStatus = 0
END

IF @Action = 4
BEGIN
	--Animal itself
	IF ISNULL(@strAnimalCode,N'') = N'' OR LEFT(ISNULL(@strAnimalCode,N''),4)='(new'
	BEGIN
		EXEC dbo.spGetNextNumber 10057004/*Animal*/, @strAnimalCode OUTPUT , NULL 
	END
	INSERT INTO tlbAnimal
			(
				idfAnimal
			   ,idfsAnimalGender
			   ,idfsAnimalAge
			   ,idfSpecies
			   ,strAnimalCode
			   ,strName
			   ,strColor
			   ,strDescription
				
			)
		 VALUES
			(
				@idfAnimal
			   ,@idfsAnimalGender
			   ,@idfsAnimalAge
			   ,@idfSpecies
			   ,@strAnimalCode
			   ,@strName
			   ,@strColor
			   ,@strDescription
			)	
END









