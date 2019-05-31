

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

create       PROCEDURE [dbo].[spVectorLabTest_SelectDetail]
(
	@idfVector AS Bigint,
	@LangID NVARCHAR(50)
)
As Begin
	select 
		Test.idfTesting
		,Test.idfsTestName
		,Isnull(TestName.name, TestName.strDefault) as [strTestName]
		,Material.idfMaterial
		,Material.idfVector
		,Vector.strVectorID
		,Material.strBarcode -- LAB Sample ID
		,Material.strFieldBarcode -- Field Sample ID
		,Material.idfsSampleType -- Sample Type
		,ISNULL(SampleType.name, SampleType.strDefault) as [strSampleType]
		,Material.datFieldCollectionDate -- Collection Date
		,Material.datAccession
		,Isnull(Test.datConcludedDate, Test.datStartedDate) As [datStartedDate] -- Test Date
		,Test.idfsTestCategory -- Test Category
		,ISNULL(TestCategory.name, TestCategory.strDefault) as [strTestCategory]
		,Test.idfTestedByPerson
		,dbo.fnConcatFullName(TestedByPerson.strFamilyName, TestedByPerson.strFirstName, TestedByPerson.strSecondName) AS [strTestedByPerson]
		,Test.idfTestedByOffice
		,TestedByOffice.name AS [strTestedByOffice]
		,Test.idfsTestResult
		,ISNULL(TestResult.name, TestResult.strDefault) as [strTestResultName]
		,Test.idfsDiagnosis
		,ISNULL(Diagnosis.name, Diagnosis.strDefault) as [strDiagnosisName]
		,Vector.idfsVectorType
		,ISNULL(VectorType.name, VectorType.strDefault) as [strVectorTypeName]		
	from		dbo.tlbTesting Test
	Inner Join dbo.tlbMaterial Material 
		On 
		Test.idfMaterial = Material.idfMaterial 
		And Material.intRowStatus = 0
		And Material.idfVector = @idfVector
		Inner Join dbo.fnReference(@LangID,19000087) SampleType ON SampleType.idfsReference = Material.idfsSampleType
		Left Join	dbo.tlbPerson TestedByPerson On TestedByPerson.idfPerson = Test.idfTestedByPerson --and TestedByPerson.intRowStatus = 0
		Left Join	dbo.tlbOffice Office On	Office.idfOffice = Test.idfTestedByOffice and Office.intRowStatus = 0
		Left Join	dbo.fnReference(@LangID,19000046) TestedByOffice	On TestedByOffice.idfsReference = Office.idfsOfficeName
		Left Join dbo.fnReference(@LangID,19000096) TestResult ON TestResult.idfsReference = Test.idfsTestResult
		Left Join dbo.fnReference(@LangID,19000019) Diagnosis ON Diagnosis.idfsReference = Test.idfsDiagnosis
		left join	fnReference(@LangID,19000097) TestName On Test.idfsTestName=TestName.idfsReference		
		left join	fnReference(@LangID,19000095) TestCategory on	Test.idfsTestCategory=TestCategory.idfsReference
		Inner Join dbo.tlbVector Vector On Material.idfVector = Vector.idfVector And Vector.intRowStatus=0
		Inner Join dbo.fnReference(@LangID,19000140) VectorType ON VectorType.idfsReference = Vector.idfsVectorType
		
				
	Where Test.intRowStatus = 0

	Select 
		row_number() over (order by idfsTestName) As [ID]
		,Matrix.[idfsTestName]
		,ISNULL(TestType.name, TestType.strDefault) as [strPensideTestTypeName]
		,Matrix.[idfsTestResult]
		,ISNULL(TestResult.name, TestResult.strDefault) as [strPensideTestResultName]
	From dbo.[trtTestTypeToTestResult] Matrix
	Inner Join dbo.fnReference(@LangID,19000104) TestType ON TestType.idfsReference = Matrix.idfsTestName
	Inner Join dbo.fnReference(@LangID,19000105) TestResult ON TestResult.idfsReference = Matrix.idfsTestResult
	WHERE Matrix.intRowStatus = 0
	
end

