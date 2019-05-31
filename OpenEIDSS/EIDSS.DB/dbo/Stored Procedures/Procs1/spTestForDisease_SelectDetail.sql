

--##SUMMARY Selects data for TestForDiseaseDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 06.04.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spTestForDisease_SelectDetail

*/

CREATE  PROCEDURE dbo.spTestForDisease_SelectDetail
AS
--0 TestForDisease
SELECT 	idfTestForDisease,
	idfsTestName,
	idfsDiagnosis, 
	idfsTestCategory, 
	intRecommendedQty
FROM dbo.trtTestForDisease
inner join trtBaseReference	as TestType on
	TestType.idfsBaseReference = trtTestForDisease.idfsTestName
	and TestType.intRowStatus = 0
	and TestType.idfsReferenceType = 19000097 --Test Type
WHERE   trtTestForDisease.intRowStatus = 0 
--1 master Diagnosis
SELECT 
	CAST (-1 as bigint) idfsDiagnosis






