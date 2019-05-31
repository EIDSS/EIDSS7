

--##SUMMARY Posts data from PensideTestForDiseaseDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 14.01.201

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spPensideTestForDisease_Post

*/

CREATE  PROCEDURE dbo.spPensideTestForDisease_Post
	 @Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfPensideTestForDisease bigint OUTPUT  --##PARAM @idfPensideTestForDisease - record ID 
	,@idfsPensideTestName bigint  --##PARAM @idfsPensideTestName - PensideTest Type
	,@idfsDiagnosis bigint  --##PARAM @idfsDiagnosis - Diagnosis ID
AS

IF @Action = 4
BEGIN
	IF @idfPensideTestForDisease IS NULL OR @idfPensideTestForDisease < 0
		EXEC spsysGetNewID @idfPensideTestForDisease OUTPUT

	INSERT INTO trtPensideTestForDisease (
				idfPensideTestForDisease
			   ,idfsPensideTestName
			   ,idfsDiagnosis
				)
		 VALUES
			   (
				@idfPensideTestForDisease
			   ,@idfsPensideTestName
			   ,@idfsDiagnosis
			   )
	INSERT INTO trtPensideTestForDiseaseToCP (
				idfPensideTestForDisease
			   ,idfCustomizationPackage
				)
		 VALUES
			   (
				@idfPensideTestForDisease
			   ,dbo.fnCustomizationPackage()
			   )
END

IF @Action = 8
BEGIN
	DELETE FROM trtPensideTestForDiseaseToCP WHERE idfPensideTestForDisease = @idfPensideTestForDisease
	DELETE FROM trtPensideTestForDisease WHERE idfPensideTestForDisease = @idfPensideTestForDisease
END

IF @Action = 16
BEGIN
	UPDATE trtPensideTestForDisease
	   SET 
		   idfsPensideTestName = @idfsPensideTestName
		  ,idfsDiagnosis = @idfsDiagnosis
	 WHERE 
			idfPensideTestForDisease = @idfPensideTestForDisease
END



