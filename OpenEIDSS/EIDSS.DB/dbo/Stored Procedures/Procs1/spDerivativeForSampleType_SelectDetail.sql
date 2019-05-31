

--##SUMMARY Selects data for DerivativeForSampleType form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 116.09.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spDerivativeForSampleType_SelectDetail

*/

CREATE  PROCEDURE dbo.spDerivativeForSampleType_SelectDetail
AS
--0 DerivativeForSampleType
SELECT [idfDerivativeForSampleType]
      ,[idfsSampleType]
      ,[idfsDerivativeType]
      ,[intRowStatus]
  FROM trtDerivativeForSampleType
WHERE   intRowStatus = 0 
--1 master Sample Type
SELECT 
	CAST (-1 as bigint) idfsSampleType






