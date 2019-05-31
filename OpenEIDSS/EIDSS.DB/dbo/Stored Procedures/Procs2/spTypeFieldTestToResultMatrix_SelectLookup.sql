

--##SUMMARY 

--##REMARKS Author: Leonov E.
--##REMARKS Create date: 

--##RETURNS Doesn't use


CREATE PROCEDURE [dbo].[spTypeFieldTestToResultMatrix_SelectLookup]
(
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
Begin
  Select
		Isnull(row_number() over (order by idfsPensideTestName), 0) As [ID]
		,Matrix.[idfsPensideTestName]
		,ISNULL(TestType.name, TestType.strDefault) as [strPensideTestTypeName]
		,Matrix.[idfsPensideTestResult]
		,ISNULL(TestResult.name, TestResult.strDefault) as [strPensideTestResultName]
		,Matrix.blnIndicative
		,Matrix.intRowStatus
  From dbo.[trtPensideTestTypeToTestResult] Matrix
  Inner Join dbo.fnReference(@LangID,19000104) TestType ON TestType.idfsReference = Matrix.idfsPensideTestName
  Inner Join dbo.fnReference(@LangID,19000105) TestResult ON TestResult.idfsReference = Matrix.idfsPensideTestResult

end
