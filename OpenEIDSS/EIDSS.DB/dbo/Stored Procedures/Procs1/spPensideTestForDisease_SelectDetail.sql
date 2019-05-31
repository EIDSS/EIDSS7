

--##SUMMARY Selects data for PensideTestForDiseaseDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 14.01.201

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spPensideTestForDisease_SelectDetail

*/

CREATE  PROCEDURE dbo.spPensideTestForDisease_SelectDetail
AS
--0 PensideTestForDisease
SELECT 	idfPensideTestForDisease,
	idfsPensideTestName,
	idfsDiagnosis

FROM dbo.trtPensideTestForDisease
inner join trtBaseReference	as PensideTestType on
	PensideTestType.idfsBaseReference = trtPensideTestForDisease.idfsPensideTestName
	and PensideTestType.intRowStatus = 0
	and PensideTestType.idfsReferenceType = 19000104 --PensideTest Type
WHERE   trtPensideTestForDisease.intRowStatus = 0 






