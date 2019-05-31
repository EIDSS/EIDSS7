

--##SUMMARY Selects data for Vector Type->Collection methods  form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spSampleTypeForVectorType_SelectDetail

*/

CREATE  PROCEDURE spSampleTypeForVectorType_SelectLookup
(
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
--0 DerivativeForSampleType
SELECT 
		VT.[idfSampleTypeForVectorType]
      ,VT.[idfsSampleType]
      ,VT.[idfsVectorType]
      ,VT.intRowStatus
      , Isnull(RS.[name], RS.strDefault) As [SampleName]
      , Isnull(RV.[name], RV.strDefault) As [VectorName]
  FROM dbo.trtSampleTypeForVectorType VT
  Inner Join dbo.fnReference(@LangID, 19000087) RS On VT.idfsSampleType = RS.idfsReference
  Inner Join dbo.fnReference(@LangID, 19000140) RV On VT.idfsVectorType = RV.idfsReference
WHERE   VT.intRowStatus = 0 
--1 master Sample Type
SELECT 
	CAST (-1 as bigint) idfsVectorType
