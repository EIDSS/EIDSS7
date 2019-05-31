

--##SUMMARY Posts data from Vector Type->Collection methods form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfSampleTypeForVectorType bigint
DECLARE @idfsSampleType bigint
DECLARE @idfsVectorType bigint


EXECUTE spSampleTypeForVectorType_Post 
   @Action
  ,@idfSampleTypeForVectorType OUTPUT
  ,@idfsSampleType
  ,@idfsVectorType

*/

CREATE  PROCEDURE dbo.spSampleTypeForVectorType_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfSampleTypeForVectorType bigint OUTPUT  --##PARAM @idfSampleTypeForVectorType - record ID 
	,@idfsSampleType bigint  --##PARAM @idfsSampleType - Sample Type
	,@idfsVectorType bigint  --##PARAM @idfsVectorType - Derivative Type that can be created from sample
AS

IF @Action = 4
BEGIN
	IF EXISTS (SELECT  idfSampleTypeForVectorType FROM trtSampleTypeForVectorType WHERE idfsSampleType = @idfsSampleType AND idfsVectorType = @idfsVectorType)
	BEGIN
		SELECT  @idfSampleTypeForVectorType = idfSampleTypeForVectorType FROM trtSampleTypeForVectorType WHERE idfsSampleType = @idfsSampleType AND idfsVectorType = @idfsVectorType

		UPDATE trtSampleTypeForVectorType
		SET intRowStatus = 0 
		WHERE idfSampleTypeForVectorType = @idfSampleTypeForVectorType
		RETURN
	END
	IF @idfSampleTypeForVectorType IS NULL OR @idfSampleTypeForVectorType < 0
		EXEC spsysGetNewID @idfSampleTypeForVectorType OUTPUT
	

	INSERT INTO trtSampleTypeForVectorType
           (idfSampleTypeForVectorType
           ,idfsSampleType
           ,idfsVectorType
			)
     VALUES
           (@idfSampleTypeForVectorType
           ,@idfsSampleType
           ,@idfsVectorType
			)

	INSERT INTO trtSampleTypeForVectorTypeToCP
           (idfSampleTypeForVectorType
           ,idfCustomizationPackage
			)
     VALUES
           (@idfSampleTypeForVectorType
           ,dbo.fnCustomizationPackage()
			)
END

IF @Action = 8
BEGIN
	DELETE FROM trtSampleTypeForVectorTypeToCP WHERE idfSampleTypeForVectorType = @idfSampleTypeForVectorType
	DELETE FROM trtSampleTypeForVectorType WHERE idfSampleTypeForVectorType = @idfSampleTypeForVectorType
END

IF @Action = 16
BEGIN
	UPDATE trtSampleTypeForVectorType
	   SET 
		  idfsSampleType = @idfsSampleType
		  ,idfsVectorType = @idfsVectorType
	 WHERE 
			idfSampleTypeForVectorType = @idfSampleTypeForVectorType
END



