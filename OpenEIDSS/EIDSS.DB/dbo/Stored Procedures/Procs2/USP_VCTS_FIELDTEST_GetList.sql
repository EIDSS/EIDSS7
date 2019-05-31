
--*************************************************************
-- Name 				: USP_VCTS_FIELDTEST_GetList
-- Description			: Selects list of field tests related with specific Vector
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
-- Harold Pryor   5/5/2018   Modified to retreive data from tlbTesting table
-- Harold Pryor   5/17/2018  Updated joins to FN_GBL_Reference_List_GET to get proper Vector data
-- Harold Pryor   5/18/2018  Updated to return strFieldBarcode from tlbMaterial table
-- Harold Pryor   5/24/2018  Modified to retrieve TestedByPerson
--
-- Testing code:
--USP_VCTS_FIELDTEST_GetList @idfVector,'en'
--*************************************************************
CREATE  PROCEDURE [dbo].[USP_VCTS_FIELDTEST_GetList]
(
	@idfVector	BIGINT , --##PARAM
	@LangID		AS NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	
			SELECT		Test.idfTesting,
			            M.strFieldBarcode,		
						Test.idfsTestName,
						TestType.name as strTestName,	
						Test.idfsTestCategory, 
						TestCategory.name as strTestCategoryName,
						Test.idfTestedByOffice,
						Office.idfsOfficeName as strTestedByOfficeName,
						Test.idfsTestResult,  
						TestResult.name as strTestResultName,   
						Test.idfTestedByPerson, 
						ISNULL(TestedByPerson.strFamilyName, N'') + ISNULL(' ' + TestedByPerson.strFirstName, '') + ISNULL(' ' +TestedByPerson.strSecondName, '') as strTestedByPersonName,
						Test.idfsDiagnosis ,
						Diagnosis.name as strDiagnosisName,
						'' as RecordAction  

		FROM			[dbo].[tlbTesting] Test
		INNER JOIN [dbo].[tlbMaterial] M on M.idfMaterial = Test.IdfMaterial 
		--INNER JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000087) SampleType ON SampleType.idfsReference = Material.idfsSampleType
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000105) TestResult ON TestResult.idfsReference = Test.idfsTestResult     
		INNER JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000097)  TestType ON TestType.idfsReference = Test.idfsTestName --Vector Type Test
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000019) Diagnosis ON Diagnosis.idfsReference = Test.idfsDiagnosis 
		--INNER JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000140) VectorType ON VectorType.idfsReference = Vector.idfsVectorType
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000134) TestCategory ON TestCategory.idfsReference = Test.idfsTestCategory
		--LEFT JOIN		dbo.tlbPerson CollectedByPerson ON CollectedByPerson.idfPerson = Test.idfTestedByPerson --and CollectedByPerson.intRowStatus = 0
		LEFT JOIN	    FN_PERSON_SELECTLIST(@LangID) TestedByPerson ON TestedByPerson.idfEmployee = Test.idfTestedByPerson
		LEFT JOIN		dbo.tlbOffice Office ON	Office.idfOffice = Test.idfTestedByOffice and Office.intRowStatus = 0
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000045) CollectedByOffice	ON CollectedByOffice.idfsReference = Office.idfsOfficeName	

		WHERE Test.intRowStatus = 0
		and M.idfVector = @idfVector
		and M.idfMaterial is not null 
		and M.intRowStatus = 0
		
		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH 
		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()
		SELECT @returnCode, @returnMsg
	END CATCH
END
