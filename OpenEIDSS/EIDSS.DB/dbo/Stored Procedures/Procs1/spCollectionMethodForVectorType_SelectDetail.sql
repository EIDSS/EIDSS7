

--##SUMMARY Selects data for Vector Type->Collection methods  form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spCollectionMethodForVectorType_SelectDetail

*/

CREATE  PROCEDURE dbo.spCollectionMethodForVectorType_SelectDetail
AS
--0 DerivativeForSampleType
SELECT [idfCollectionMethodForVectorType]
      ,[idfsCollectionMethod]
      ,[idfsVectorType]
  FROM dbo.trtCollectionMethodForVectorType
WHERE   intRowStatus = 0 
--1 master Sample Type
SELECT 
	CAST (-1 as bigint) idfsVectorType






