
--*************************************************************
-- Name 				: USP_VCTS_FIELDTEST_GetDetail
-- Description			: Selects list of field tests related with specific Vector Observation
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
-- Harold Pryor   5/5/2018   Modified to retreive data from tlbTesting table
-- Harold Pryor   5/24/2018  Modified to retrieve TestedByPerson
--
-- Testing code:
--USP_VCTS_FIELDTEST_GetDetail idfTesting,'en'
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCTS_FIELDTEST_GetDetail]
(
	@idfTesting INT , --##PARAM
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
						Test.idfsTestCategory, 
						Test.idfTestedByOffice,  
						Test.idfsTestResult,     
						Test.idfTestedByPerson, 
						ISNULL(TestedByPerson.strFamilyName, N'') + ISNULL(' ' + TestedByPerson.strFirstName, '') + ISNULL(' ' +TestedByPerson.strSecondName, '') as strTestedByPersonName,
						Test.idfsDiagnosis 
		FROM			[dbo].[tlbTesting] Test
		--INNER JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000087) SampleType ON SampleType.idfsReference = Material.idfsSampleType
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000105) TestResult ON TestResult.idfsReference = Test.idfsTestResult     
		--INNER JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000104) TestType ON TestType.idfsReference = Test.idfsPensideTestName--TypeTest.idfsTestCategory
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000019) Diagnosis ON Diagnosis.idfsReference = Test.idfsDiagnosis 
		--INNER JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000140) VectorType ON VectorType.idfsReference = Vector.idfsVectorType
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000134) TestCategory ON TestCategory.idfsReference = Test.idfsTestCategory
		--LEFT JOIN		dbo.tlbPerson CollectedByPerson ON CollectedByPerson.idfPerson = Test.idfTestedByPerson --and CollectedByPerson.intRowStatus = 0
		LEFT JOIN	    FN_PERSON_SELECTLIST(@LangID) TestedByPerson ON TestedByPerson.idfEmployee = Test.idfTestedByPerson
		LEFT JOIN		dbo.tlbOffice Office ON	Office.idfOffice = Test.idfTestedByOffice and Office.intRowStatus = 0
		LEFT JOIN		dbo.FN_GBL_Reference_List_GET(@LangID,19000045) CollectedByOffice	ON CollectedByOffice.idfsReference = Office.idfsOfficeName	
		LEFT JOIN      dbo.tlbMaterial M on M.idfmaterial = Test.idfMaterial

		WHERE Test.intRowStatus = 0
		and Test.idfTesting = @idfTesting


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
