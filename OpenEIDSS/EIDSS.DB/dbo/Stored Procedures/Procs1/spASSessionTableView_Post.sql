


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






CREATE             Proc	[dbo].[spASSessionTableView_Post]
	@Action int,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfAnimal BIGINT OUTPUT,  --##PARAM @idfAnimal - animal ID
	--@idfHerd BIGINT, --##PARAM @idfHerd - animal herd ID
	@idfsAnimalAge BIGINT, --##PARAM @idfsAnimalAge - animal age, reference to rftAnimalAgeList (19000005)
	@idfsAnimalGender BIGINT, --##PARAM @idfsAnimalGender - animal gender, reference to rftAnimalGenderList (19000007)
	@strAnimalCode NVARCHAR(200) OUTPUT, --##PARAM @strAnimalCode - animal barcode
	@idfSpecies BIGINT, --##PARAM @idfSpecies - animal species, reference to tlbSpecies table. Species defind by this value must be included to herd defined by @idfHerd
	@strName NVARCHAR(200), --##PARAM @strName - animal  name
	@strColor NVARCHAR(200), --##PARAM @strColor - animal color
	@strDescription NVARCHAR(200),
	@idfMaterial BIGINT OUTPUT, --##PARAM
	@idfsSampleType BIGINT, --##PARAM
	@datFieldCollectionDate DATETIME, --##PARAM
	@strFieldBarcode NVARCHAR(200) OUTPUT, --##PARAM
	@idfSendToOffice bigint=NULL,
	@idfMonitoringSession BIGINT, --##PARAM @idfMonitoringSession - ID of case to which animal belongs
	@idfFarm BIGINT = null
As
IF @Action = 16 OR @Action = 4--Modified or new
BEGIN
	IF ISNULL(@idfFarm, -1)>0
	UPDATE tlbFarm 
	SET 
		idfMonitoringSession = @idfMonitoringSession
	WHERE idfFarm=@idfFarm 
			and ISNULL(idfMonitoringSession,0) <> @idfMonitoringSession

	-- Post animal of it is defined
	IF NOT @idfAnimal IS NULL
	BEGIN
		IF ISNULL(@strAnimalCode,N'') = N'' OR LEFT(ISNULL(@strAnimalCode,N''),4)='(new'
			EXEC dbo.spGetNextNumber 10057004/*Animal*/, @strAnimalCode OUTPUT , NULL 
		IF EXISTS(SELECT * FROM tlbAnimal WHERE idfAnimal=@idfAnimal AND intRowStatus = 0)
		BEGIN
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
		ELSE
		BEGIN
			IF (@idfAnimal <= 0)
				EXEC spsysGetNewID @idfAnimal OUTPUT
		
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
		--Post sample if it is defined
		IF NOT @idfMaterial IS NULL
		BEGIN
			IF EXISTS(SELECT * FROM tlbMaterial WHERE idfMaterial=@idfMaterial AND intRowStatus = 0)
			BEGIN
				UPDATE	tlbMaterial
				set
						strFieldBarcode=@strFieldBarcode,
						idfsSampleType=@idfsSampleType,
						datFieldCollectionDate=@datFieldCollectionDate,
						idfSendToOffice=@idfSendToOffice,
						idfAnimal=@idfAnimal

				where	idfMaterial=@idfMaterial
			END
			ELSE
			BEGIN
				IF (@idfMaterial <= 0)
					EXEC spsysGetNewID @idfMaterial OUTPUT
				INSERT INTO	tlbMaterial(
								idfMaterial,
								idfRootMaterial,
								strFieldBarcode,
								idfsSampleType,
								idfMonitoringSession,
								idfAnimal,
								datFieldCollectionDate,
								idfSendToOffice
							)
				VALUES		(
								@idfMaterial,
								@idfMaterial,
								@strFieldBarcode,
								@idfsSampleType,
								@idfMonitoringSession,
								@idfAnimal,
								@datFieldCollectionDate,
								@idfSendToOffice
							)
			
			END

		END
	END
END
IF @Action = 8 --Delete
BEGIN

	IF NOT @idfMaterial IS NULL
		EXECUTE spLabSample_Delete 
			@idfMaterial
	DELETE tlbAnimal 
	WHERE 
		idfAnimal = @idfAnimal
		AND intRowStatus = 0
		AND NOT EXISTS(SELECT @idfMaterial FROM tlbMaterial WHERE idfAnimal = @idfAnimal AND intRowStatus = 0)
END










