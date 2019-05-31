

--##SUMMARY Posts data from TestForDiseaseDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 06.04.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spTestForDisease_Post

*/

CREATE  PROCEDURE dbo.spTestForDisease_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfTestForDisease bigint OUTPUT  --##PARAM @idfTestForDisease - record ID 
	,@idfsTestCategory bigint  --##PARAM @idfsTestCategory - TestForDisease Type
	,@idfsTestName bigint  --##PARAM @idfsTestName - Test Type
	,@idfsSampleType bigint  --##PARAM @idfsSampleType - Specimen Type
	,@idfsDiagnosis bigint  --##PARAM @idfsDiagnosis - Diagnosis ID
	,@intRecommendedQty int  --##PARAM @intRecommendedQty - recommended tests qty
AS

IF @Action = 4
BEGIN
	IF @idfTestForDisease IS NULL OR @idfTestForDisease < 0
		EXEC spsysGetNewID @idfTestForDisease OUTPUT

	INSERT INTO trtTestForDisease (
				idfTestForDisease
			   ,idfsTestCategory
			   ,idfsTestName
			   ,idfsSampleType
			   ,idfsDiagnosis
			   ,intRecommendedQty
				)
		 VALUES
			   (
				@idfTestForDisease
			   ,@idfsTestCategory
			   ,@idfsTestName
			   ,@idfsSampleType
			   ,@idfsDiagnosis
			   ,@intRecommendedQty
			   )
	INSERT INTO trtTestForDiseaseToCP (
				idfTestForDisease
			   ,idfCustomizationPackage
				)
		 VALUES
			   (
				@idfTestForDisease
			   ,dbo.fnCustomizationPackage()
			   )
END

IF @Action = 8
BEGIN
	DELETE FROM trtTestForDiseaseToCP WHERE idfTestForDisease = @idfTestForDisease
	DELETE FROM trtTestForDisease WHERE idfTestForDisease = @idfTestForDisease
END

IF @Action = 16
BEGIN
	UPDATE trtTestForDisease
	   SET 
		  idfsTestCategory = @idfsTestCategory
		  ,idfsTestName = @idfsTestName
		  ,idfsSampleType = @idfsSampleType
		  ,idfsDiagnosis = @idfsDiagnosis
		  ,intRecommendedQty = @intRecommendedQty
	 WHERE 
			idfTestForDisease = @idfTestForDisease
END



