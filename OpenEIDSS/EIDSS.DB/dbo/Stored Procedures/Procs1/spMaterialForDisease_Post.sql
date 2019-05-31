

--##SUMMARY Posts data from disease -> material matrix (Material_For_DiseaseDetail form)

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
EXECUTE spMaterialForDisease_Post
*/


CREATE   PROCEDURE dbo.spMaterialForDisease_Post
			 @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
           ,@idfMaterialForDisease bigint --##PARAM @idfMaterialForDisease - posted record ID
           ,@idfsSampleType bigint --##PARAM @idfsSampleType - specimen Type, reference to rftSpecimenType (19000087)
           ,@idfsDiagnosis bigint --##PARAM @idfsDiagnosis - diagnosis ID
           ,@intRecommendedQty int --##PARAM @intRecommendedQty - reccomended qty of specimens to collect

AS
IF @Action = 4 -- add record
BEGIN
	INSERT INTO trtMaterialForDisease
           (
			idfMaterialForDisease
           ,idfsSampleType
           ,idfsDiagnosis
           ,intRecommendedQty
			)
     VALUES
           (@idfMaterialForDisease
           ,@idfsSampleType
           ,@idfsDiagnosis
           ,@intRecommendedQty
			)
	INSERT INTO trtMaterialForDiseaseToCP
           (
			idfMaterialForDisease
           ,idfCustomizationPackage
			)
     VALUES
           (@idfMaterialForDisease
           ,dbo.fnCustomizationPackage()
			)
END
ELSE IF @Action = 8 --delete
BEGIN
	DELETE FROM trtMaterialForDiseaseToCP WHERE idfMaterialForDisease = @idfMaterialForDisease
	DELETE FROM trtMaterialForDisease WHERE idfMaterialForDisease = @idfMaterialForDisease
END
ELSE IF @Action = 16 --update
	UPDATE trtMaterialForDisease
	   SET 
		   idfsSampleType = @idfsSampleType
		  ,idfsDiagnosis = @idfsDiagnosis
		  ,intRecommendedQty = @intRecommendedQty
	 WHERE 
			idfMaterialForDisease = @idfMaterialForDisease



