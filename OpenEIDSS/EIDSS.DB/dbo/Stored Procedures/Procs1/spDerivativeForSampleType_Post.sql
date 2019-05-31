

--##SUMMARY Posts data from DerivativeForSampleType form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.09.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfDerivativeForSampleType bigint
DECLARE @idfsSampleType bigint
DECLARE @idfsDerivativeType bigint


EXECUTE spDerivativeForSampleType_Post 
   @Action
  ,@idfDerivativeForSampleType OUTPUT
  ,@idfsSampleType
  ,@idfsDerivativeType

*/

CREATE  PROCEDURE dbo.spDerivativeForSampleType_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfDerivativeForSampleType bigint OUTPUT  --##PARAM @idfDerivativeForSampleType - record ID 
	,@idfsSampleType bigint  --##PARAM @idfsSampleType - Sample Type
	,@idfsDerivativeType bigint  --##PARAM @idfsDerivativeType - Derivative Type that can be created from sample
AS

IF @Action = 4
BEGIN
	IF @idfDerivativeForSampleType IS NULL OR @idfDerivativeForSampleType < 0
		EXEC spsysGetNewID @idfDerivativeForSampleType OUTPUT

	IF EXISTS (SELECT  idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsSampleType = @idfsSampleType AND idfsDerivativeType = @idfsDerivativeType)
	BEGIN
		SELECT  @idfDerivativeForSampleType = idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsSampleType = @idfsSampleType AND idfsDerivativeType = @idfsDerivativeType

		UPDATE trtDerivativeForSampleType
		SET intRowStatus = 0 
		WHERE idfDerivativeForSampleType = @idfDerivativeForSampleType
		RETURN
	END
	
	IF EXISTS (SELECT  idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsSampleType = @idfsSampleType AND idfsDerivativeType = @idfsDerivativeType)
	BEGIN
		SELECT  @idfDerivativeForSampleType = idfDerivativeForSampleType FROM trtDerivativeForSampleType WHERE idfsSampleType = @idfsSampleType AND idfsDerivativeType = @idfsDerivativeType

		UPDATE trtDerivativeForSampleType
		SET intRowStatus = 0 
		WHERE idfDerivativeForSampleType = @idfDerivativeForSampleType
		RETURN
	END
	

	INSERT INTO trtDerivativeForSampleType
           (idfDerivativeForSampleType
           ,idfsSampleType
           ,idfsDerivativeType
			)
     VALUES
           (@idfDerivativeForSampleType
           ,@idfsSampleType
           ,@idfsDerivativeType
			)

	INSERT INTO trtDerivativeForSampleTypeToCP
           (idfDerivativeForSampleType
           ,idfCustomizationPackage
			)
     VALUES
           (@idfDerivativeForSampleType
           ,dbo.fnCustomizationPackage()
			)
END

IF @Action = 8
BEGIN
	DELETE FROM trtDerivativeForSampleTypeToCP WHERE idfDerivativeForSampleType = @idfDerivativeForSampleType
	DELETE FROM trtDerivativeForSampleType WHERE idfDerivativeForSampleType = @idfDerivativeForSampleType
END

IF @Action = 16
BEGIN
	UPDATE trtDerivativeForSampleType
	   SET 
		  idfsSampleType = @idfsSampleType
		  ,idfsDerivativeType = @idfsDerivativeType
	 WHERE 
			idfDerivativeForSampleType = @idfDerivativeForSampleType
END



