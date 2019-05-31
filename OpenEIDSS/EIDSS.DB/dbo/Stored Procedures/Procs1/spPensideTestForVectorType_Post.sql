

--##SUMMARY Posts data from Vector Type->Collection methods form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfPensideTestTypeForVectorType bigint
DECLARE @idfsPensideTestName bigint
DECLARE @idfsVectorType bigint


EXECUTE spPensideTestForVectorType_Post 
   @Action
  ,@idfPensideTestTypeForVectorType OUTPUT
  ,@idfsPensideTestName
  ,@idfsVectorType

*/

CREATE  PROCEDURE dbo.spPensideTestForVectorType_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfPensideTestTypeForVectorType bigint OUTPUT  --##PARAM @idfPensideTestTypeForVectorType - record ID 
	,@idfsPensideTestName bigint  --##PARAM @idfsPensideTestName - penside test Type
	,@idfsVectorType bigint  --##PARAM @idfsVectorType - Vector Type 
	AS

IF @Action = 4
BEGIN
	IF @idfPensideTestTypeForVectorType IS NULL OR @idfPensideTestTypeForVectorType < 0
		EXEC spsysGetNewID @idfPensideTestTypeForVectorType OUTPUT

	IF EXISTS (SELECT  idfPensideTestTypeForVectorType FROM trtPensideTestTypeForVectorType WHERE idfsPensideTestName = @idfsPensideTestName AND idfsVectorType = @idfsVectorType)
	BEGIN
		SELECT  @idfPensideTestTypeForVectorType = idfPensideTestTypeForVectorType FROM trtPensideTestTypeForVectorType WHERE idfsPensideTestName = @idfsPensideTestName AND idfsVectorType = @idfsVectorType

		UPDATE trtPensideTestTypeForVectorType
		SET intRowStatus = 0 
		WHERE idfPensideTestTypeForVectorType = @idfPensideTestTypeForVectorType
		RETURN
	END

	INSERT INTO trtPensideTestTypeForVectorType
           (idfPensideTestTypeForVectorType
           ,idfsPensideTestName
           ,idfsVectorType
			)
     VALUES
           (@idfPensideTestTypeForVectorType
           ,@idfsPensideTestName
           ,@idfsVectorType
			)

	INSERT INTO trtPensideTestTypeForVectorTypeToCP
           (idfPensideTestTypeForVectorType
           ,idfCustomizationPackage
			)
     VALUES
           (@idfPensideTestTypeForVectorType
           ,dbo.fnCustomizationPackage()
			)
END

IF @Action = 8
BEGIN
	DELETE FROM trtPensideTestTypeForVectorTypeToCP WHERE idfPensideTestTypeForVectorType = @idfPensideTestTypeForVectorType
	DELETE FROM trtPensideTestTypeForVectorType WHERE idfPensideTestTypeForVectorType = @idfPensideTestTypeForVectorType
END

IF @Action = 16
BEGIN
	UPDATE trtPensideTestTypeForVectorType
	   SET 
		  idfsPensideTestName = @idfsPensideTestName
		  ,idfsVectorType = @idfsVectorType
	 WHERE 
			idfPensideTestTypeForVectorType = @idfPensideTestTypeForVectorType
END



