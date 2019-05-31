

--##SUMMARY Selects list of field tests related with specific Vector Session.

--##REMARKS Author: Leonov E.
--##REMARKS Create date: 08.11.2011

--##RETURNS Doesn't use


CREATE       PROCEDURE [dbo].[spVectorFieldTest_SelectDetail]
(
	@idfVector AS BIGINT --##PARAM
	,@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
Begin
	
	Select		
		Test.idfPensideTest
		,Test.idfsPensideTestName
		,ISNULL(TestType.name, TestType.strDefault) as [strPensideTestTypeName]
		,Material.idfVectorSurveillanceSession
		,Material.idfVector
		,Vector.idfsVectorType
		,ISNULL(VectorType.name, VectorType.strDefault) as [strVectorTypeName]
		,Test.idfMaterial -- Sample ID	  
		,Material.strFieldBarcode -- Field Sample ID
		,Material.idfsSampleType
		,ISNULL(SampleType.name, SampleType.strDefault) as [strSampleName]	  
		,Material.datFieldCollectionDate -- Collection Date
		,Test.datTestDate -- Test Date
		,Test.idfsPensideTestCategory -- Test Category
		,ISNULL(TestCategory.name, TestCategory.strDefault) as [strPensideTestCategoryName]
		,Test.idfTestedByPerson
		,dbo.fnConcatFullName(CollectedByPerson.strFamilyName, CollectedByPerson.strFirstName, CollectedByPerson.strSecondName) AS [strCollectedByPerson]
		,Test.idfTestedByOffice
		,CollectedByOffice.name AS [strCollectedByOffice]
		,Test.idfsPensideTestResult -- Result
		,ISNULL(TestResult.name, TestResult.strDefault) as [strPensideTestResultName]
		,Test.idfsDiagnosis
		,ISNULL(Diagnosis.name, Diagnosis.strDefault) as [strDiagnosisName]
		,Null as [intOrder]
		,Vector.strVectorID as [strVectorID]
  From  dbo.tlbPensideTest Test
  Inner Join dbo.tlbMaterial Material On
	Material.idfMaterial = Test.idfMaterial
	AND Material.idfVector = @idfVector
	AND Material.intRowStatus = 0
  Inner Join dbo.tlbVector Vector On
	Material.idfVector = Vector.idfVector
	AND Vector.intRowStatus = 0
  Inner Join dbo.fnReference(@LangID,19000087) SampleType ON SampleType.idfsReference = Material.idfsSampleType
  Left Join dbo.fnReference(@LangID,19000105) TestResult ON TestResult.idfsReference = Test.idfsPensideTestResult
  Inner Join dbo.fnReference(@LangID,19000104) TestType ON TestType.idfsReference = Test.idfsPensideTestName--TypeTest.idfsTestCategory
  Left Join dbo.fnReference(@LangID,19000019) Diagnosis ON Diagnosis.idfsReference = Test.idfsDiagnosis
  Inner Join dbo.fnReference(@LangID,19000140) VectorType ON VectorType.idfsReference = Vector.idfsVectorType
  Left Join dbo.fnReference(@LangID,19000134) TestCategory ON TestCategory.idfsReference = Test.idfsPensideTestCategory
  Left Join	dbo.tlbPerson CollectedByPerson On CollectedByPerson.idfPerson = Test.idfTestedByPerson --and CollectedByPerson.intRowStatus = 0
  Left Join	dbo.tlbOffice Office On	Office.idfOffice = Test.idfTestedByOffice and Office.intRowStatus = 0
  Left Join	dbo.fnReference(@LangID,19000045) CollectedByOffice	On CollectedByOffice.idfsReference = Office.idfsOfficeName	

  WHERE Test.intRowStatus = 0

  Select
		row_number() over (order by idfsPensideTestName) As [ID]
		,Matrix.[idfsPensideTestName]
		,ISNULL(TestType.name, TestType.strDefault) as [strPensideTestTypeName]
		,Matrix.[idfsPensideTestResult]
		,ISNULL(TestResult.name, TestResult.strDefault) as [strPensideTestResultName]
  From dbo.[trtPensideTestTypeToTestResult] Matrix
  Inner Join dbo.fnReference(@LangID,19000104) TestType ON TestType.idfsReference = Matrix.idfsPensideTestName
  Inner Join dbo.fnReference(@LangID,19000105) TestResult ON TestResult.idfsReference = Matrix.idfsPensideTestResult
  WHERE Matrix.intRowStatus = 0  

end
