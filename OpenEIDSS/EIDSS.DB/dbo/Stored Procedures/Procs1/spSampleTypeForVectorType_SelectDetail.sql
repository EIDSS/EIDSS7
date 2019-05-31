

--##SUMMARY Selects data for Vector Type->Collection methods  form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spSampleTypeForVectorType_SelectDetail

*/

CREATE  PROCEDURE dbo.spSampleTypeForVectorType_SelectDetail
AS
--0 DerivativeForSampleType
SELECT [idfSampleTypeForVectorType]
      ,[idfsSampleType]
      ,[idfsVectorType]
	  ,intRowStatus
  FROM dbo.trtSampleTypeForVectorType
WHERE   intRowStatus = 0 
--1 master Sample Type
SELECT 
	CAST (-1 as bigint) idfsVectorType






