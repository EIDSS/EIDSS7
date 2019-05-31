

--##SUMMARY Posts data from DerivativeForSampleType form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.09.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfsSpeciesType bigint
DECLARE @idfsAnimalAge bigint


EXECUTE spAgeForSpecies_Post 
   @Action
  ,@idfsSpeciesType
  ,@idfsAnimalAge

*/

CREATE  PROCEDURE dbo.spAgeForSpecies_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfSpeciesTypeToAnimalAge bigint OUTPUT  --##PARAM @idfSpeciesTypeToAnimalAge - record ID
	,@idfsSpeciesType bigint OUTPUT  --##PARAM @idfsSpeciesType - species Type
	,@idfsAnimalAge bigint  --##PARAM @idfsAnimalAge - animal age reference
AS


IF @Action = 8
BEGIN
	DELETE FROM  dbo.trtSpeciesTypeToAnimalAgeToCP
	WHERE idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge 
	DELETE FROM trtSpeciesTypeToAnimalAge 
	WHERE idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge 
END
ELSE IF @Action = 16
BEGIN
		UPDATE trtSpeciesTypeToAnimalAge
		SET
			idfsSpeciesType = @idfsSpeciesType 
			,idfsAnimalAge = @idfsAnimalAge
		WHERE
			idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge 
END
ELSE IF @Action = 4
BEGIN

	IF EXISTS (SELECT  idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = @idfsSpeciesType AND idfsAnimalAge = @idfsAnimalAge)
	BEGIN
		SELECT  @idfSpeciesTypeToAnimalAge = idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = @idfsSpeciesType AND idfsAnimalAge = @idfsAnimalAge

		UPDATE trtSpeciesTypeToAnimalAge
		SET intRowStatus = 0 
		WHERE idfSpeciesTypeToAnimalAge = @idfSpeciesTypeToAnimalAge
		RETURN
	END

		EXEC spsysGetNewID @idfSpeciesTypeToAnimalAge OUTPUT

		INSERT INTO trtSpeciesTypeToAnimalAge(
			idfSpeciesTypeToAnimalAge,
			idfsSpeciesType,
			idfsAnimalAge
		)VALUES(
			@idfSpeciesTypeToAnimalAge,
			@idfsSpeciesType,
			@idfsAnimalAge
		)
		INSERT INTO trtSpeciesTypeToAnimalAgeToCP(
			idfSpeciesTypeToAnimalAge,
			idfCustomizationPackage
		)VALUES(
			@idfSpeciesTypeToAnimalAge,
			dbo.fnCustomizationPackage()
		)

END

RETURN 0


