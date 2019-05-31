

--##SUMMARY Selects data for PensideTestForDiseaseDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 14.01.201

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spPensideTestForDisease_SelectDetail

*/

CREATE  PROCEDURE dbo.spPensideTestForDisease_SelectLookup
(
	@LangID As nvarchar(50)--##PARAM @LangID - language ID
)
AS
--0 PensideTestForDisease
SELECT 	idfPensideTestForDisease
		,idfsPensideTestName
		,idfsDiagnosis
		,ISNULL(TestType.name, TestType.strDefault) as [TestTypeName]
		,ISNULL(Diagnoses.name, Diagnoses.strDefault) as [DiagnosisName]
		,Matrix.intRowStatus
FROM dbo.trtPensideTestForDisease Matrix
Inner Join dbo.fnReferenceRepair(@LangID,19000104) TestType ON TestType.idfsReference = Matrix.idfsPensideTestName
Inner Join dbo.fnReferenceRepair(@LangID, 19000019) Diagnoses On  Diagnoses.idfsReference = Matrix.idfsDiagnosis
WHERE   Matrix.intRowStatus = 0
