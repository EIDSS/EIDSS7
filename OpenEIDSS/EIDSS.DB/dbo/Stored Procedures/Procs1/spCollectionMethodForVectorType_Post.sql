

--##SUMMARY Posts data from Vector Type->Collection methods form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfCollectionMethodForVectorType bigint
DECLARE @idfsCollectionMethod bigint
DECLARE @idfsVectorType bigint


EXECUTE spCollectionMethodForVectorType_Post 
   @Action
  ,@idfCollectionMethodForVectorType OUTPUT
  ,@idfsCollectionMethod
  ,@idfsVectorType

*/

CREATE  PROCEDURE dbo.spCollectionMethodForVectorType_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfCollectionMethodForVectorType bigint OUTPUT  --##PARAM @idfCollectionMethodForVectorType - record ID 
	,@idfsCollectionMethod bigint  --##PARAM @idfsCollectionMethod - Sample Type
	,@idfsVectorType bigint  --##PARAM @idfsVectorType - Derivative Type that can be created from sample
AS

IF @Action = 4
BEGIN
	IF @idfCollectionMethodForVectorType IS NULL OR @idfCollectionMethodForVectorType < 0
		EXEC spsysGetNewID @idfCollectionMethodForVectorType OUTPUT

	IF EXISTS (SELECT  idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsCollectionMethod = @idfsCollectionMethod AND idfsVectorType = @idfsVectorType)
	BEGIN
		SELECT  @idfCollectionMethodForVectorType = idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsCollectionMethod = @idfsCollectionMethod AND idfsVectorType = @idfsVectorType

		UPDATE trtCollectionMethodForVectorType
		SET intRowStatus = 0 
		WHERE idfCollectionMethodForVectorType = @idfCollectionMethodForVectorType
		RETURN
	END
	

	INSERT INTO trtCollectionMethodForVectorType
           (idfCollectionMethodForVectorType
           ,idfsCollectionMethod
           ,idfsVectorType
			)
     VALUES
           (@idfCollectionMethodForVectorType
           ,@idfsCollectionMethod
           ,@idfsVectorType
			)

	INSERT INTO trtCollectionMethodForVectorTypeToCP
           (idfCollectionMethodForVectorType
           ,idfCustomizationPackage
			)
     VALUES
           (@idfCollectionMethodForVectorType
           ,dbo.fnCustomizationPackage()
			)
END

IF @Action = 8
BEGIN
	DELETE FROM trtCollectionMethodForVectorTypeToCP WHERE idfCollectionMethodForVectorType = @idfCollectionMethodForVectorType
	DELETE FROM trtCollectionMethodForVectorType WHERE idfCollectionMethodForVectorType = @idfCollectionMethodForVectorType
END

IF @Action = 16
BEGIN
	UPDATE trtCollectionMethodForVectorType
	   SET 
		  idfsCollectionMethod = @idfsCollectionMethod
		  ,idfsVectorType = @idfsVectorType
	 WHERE 
			idfCollectionMethodForVectorType = @idfCollectionMethodForVectorType
END



