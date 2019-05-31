

--##SUMMARY Selects data for Vector Type->Collection methods  form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spPensideTestForVectorType_SelectDetail

*/

CREATE  PROCEDURE dbo.spPensideTestForVectorType_SelectDetail
AS
--0 DerivativeForPensideTest
SELECT [idfPensideTestTypeForVectorType]
      ,[idfsPensideTestName]
      ,[idfsVectorType]
  FROM dbo.trtPensideTestTypeForVectorType
WHERE   intRowStatus = 0 







