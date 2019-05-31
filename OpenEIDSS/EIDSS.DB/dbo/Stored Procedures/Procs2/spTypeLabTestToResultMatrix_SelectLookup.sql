

--##REMARKS UPDATED BY: 
--##REMARKS Date: 

create       PROCEDURE [dbo].[spTypeLabTestToResultMatrix_SelectLookup]
(	
	@LangID NVARCHAR(50)
)
As Begin
	Select 
		IsNull(row_number() over (order by idfsTestName), 0) As [ID]
		,Matrix.[idfsTestName]
		,ISNULL(TestType.name, TestType.strDefault) as [strTestTypeName]
		,Matrix.[idfsTestResult]
		,ISNULL(TestResult.name, TestResult.strDefault) as [strTestResultName]
		,Matrix.blnIndicative
		,Matrix.intRowStatus
	From dbo.[trtTestTypeToTestResult] Matrix
	Inner Join dbo.fnReference(@LangID,19000097) TestType ON TestType.idfsReference = Matrix.idfsTestName
	Inner Join dbo.fnReference(@LangID,19000096) TestResult ON TestResult.idfsReference = Matrix.idfsTestResult
end
