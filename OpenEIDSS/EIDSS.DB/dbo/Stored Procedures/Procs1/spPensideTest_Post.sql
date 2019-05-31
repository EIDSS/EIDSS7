



--##SUMMARY Posts penside tests data related with specific vet case.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 26.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
DECLARE @Action int
DECLARE @idfPensideTest bigint
DECLARE @idfVetCase bigint
DECLARE @idfAnimal bigint
DECLARE @idfSpecies bigint
DECLARE @idfsPensideTestResult bigint
DECLARE @idfsPensideTestName bigint
DECLARE @idfMaterial datetime


EXECUTE spPensideTest_Post 
   @Action
  ,@idfPensideTest
  ,@idfVetCase
  ,@idfAnimal
  ,@idfSpecies
  ,@idfsPensideTestResult
  ,@idfsPensideTestName
  ,@idfMaterial
*/

CREATE             Proc	[dbo].[spPensideTest_Post]
			@Action INT --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfPensideTest bigint --##PARAM @idfPensideTest - penside test record ID
			,@idfVetCase bigint --##PARAM @idfVetCase - ID of case to which vaccination belongs
			,@idfParty bigint --##PARAM @idfParty - ID of party to which test is applied (animal for LiveStock cases or species for avian cases)
			,@idfsPensideTestResult bigint --##PARAM @idfsPensideTestResult - penside test result, reference to rftPensideTestResult (19000105)
			,@idfsPensideTestName bigint --##PARAM  @idfsPensideTestName -penside test Type, reference to rftPensideTestType (19000104)
			,@idfMaterial bigint --##PARAM @idfMaterial - ID of sample to which test is applied
As

IF @Action = 16 --update
BEGIN
UPDATE tlbPensideTest
   SET 
--       idfVetCase = @idfVetCase
--      ,idfParty = @idfParty
      idfsPensideTestResult = @idfsPensideTestResult
      ,idfsPensideTestName = @idfsPensideTestName
      ,idfMaterial = @idfMaterial
WHERE 
	idfPensideTest = @idfPensideTest
	and intRowStatus = 0

END
ELSE IF @Action = 8 --delete
BEGIN
	DELETE tlbPensideTest WHERE idfPensideTest = @idfPensideTest
END

ELSE IF @Action = 4
BEGIN
	INSERT INTO tlbPensideTest
           (
			idfPensideTest
--           ,idfVetCase
--           ,idfParty
           ,idfsPensideTestResult
           ,idfsPensideTestName
           ,idfMaterial
			)
     VALUES
           (
			@idfPensideTest
--           ,@idfVetCase
--           ,@idfParty
           ,@idfsPensideTestResult
           ,@idfsPensideTestName
           ,@idfMaterial
			)

END

RETURN 0



