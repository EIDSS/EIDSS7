



--##SUMMARY Posts tests data related with specific case/AS session.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 09.01.2012


--##RETURNS Doesn't use

/*
--Example of procedure call:
*/

CREATE             PROCEDURE dbo.spCaseTest_Post
			@Action INT --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
			,@idfTesting bigint --##PARAM @idfTesting - test record ID
			,@idfObservation bigint --##PARAM @idfObservation - test observation id
			,@idfsFormTemplate bigint --##PARAM @idfsFormTemplate - test ff form template id
			,@idfsTestName bigint --##PARAM  @idfsTestName -test type
			,@idfsTestStatus bigint --##PARAM  @idfsTestStatus -test status
			,@idfsTestResult bigint --##PARAM  @idfsTestResult - test result
			,@idfsTestCategory bigint --##PARAM  @idfsTestCategory - test category
			,@idfMaterial bigint --##PARAM @idfMaterial - ID of sample to which test is applied
			,@idfsDiagnosis bigint --##PARAM @idfsDiagnosis - ID of test diagnosis
			,@idfResultEnteredByOffice bigint --##PARAM
			,@idfTestedByOffice bigint --##PARAM
			,@idfTestedByPerson bigint --##PARAM
			,@idfResultEnteredByPerson bigint --##PARAM
			,@blnNonLaboratoryTest bigint --##PARAM
			,@datStartedDate datetime --##PARAM
			,@datConcludedDate datetime --##PARAM
			,@blnIsMainSampleTest bit = null
As

if @blnNonLaboratoryTest<>1
	return -1

if (@Action = 4) -- insert
begin
	exec spObservation_Post @idfObservation, @idfsFormTemplate

	INSERT INTO tlbTesting
			   ([idfTesting]
			   ,[idfsTestName]
			   ,[idfsTestCategory]
			   ,[idfsTestResult]
			   ,[idfsTestStatus]
			   ,[idfsDiagnosis]
			   ,[idfMaterial]
			   ,[idfObservation]
			   ,[datStartedDate]
			   ,[datConcludedDate]
			   ,[idfTestedByOffice]
			   ,[idfTestedByPerson]
			   ,[idfResultEnteredByOffice]
			   ,[idfResultEnteredByPerson]
			   --,[idfValidatedByOffice]
			   --,[idfValidatedByPerson]
			   ,[blnNonLaboratoryTest]
			   )
		 VALUES
			   (@idfTesting
			   ,@idfsTestName
			   ,@idfsTestCategory
			   ,@idfsTestResult
			   ,@idfsTestStatus
			   ,@idfsDiagnosis
			   ,@idfMaterial
			   ,@idfObservation
			   ,@datStartedDate
			   ,@datConcludedDate
			   ,@idfTestedByOffice
			   ,@idfTestedByPerson
			   ,@idfResultEnteredByOffice
			   ,@idfResultEnteredByPerson
			   --,@idfValidatedByOffice
			   --,@idfValidatedByPerson
			   ,@blnNonLaboratoryTest
			   )

end
else if (@Action = 8) -- delete
begin
	DELETE FROM tlbTesting
		  WHERE [idfTesting] = @idfTesting
end
else if (@Action = 16) -- update
begin
	UPDATE tlbTesting
	SET
	   [idfsTestName] = @idfsTestName
	  ,[idfsTestCategory] = @idfsTestCategory
	  ,[idfsTestResult] = @idfsTestResult
	  ,[idfsTestStatus] = @idfsTestStatus
	  ,[idfsDiagnosis] = @idfsDiagnosis
	  ,[idfMaterial] = @idfMaterial
	  ,[idfObservation] = @idfObservation
	  ,[datStartedDate] = @datStartedDate
	  ,[datConcludedDate] = @datConcludedDate
	  ,[idfTestedByOffice] = @idfTestedByOffice
	  ,[idfTestedByPerson] = @idfTestedByPerson
	  ,[idfResultEnteredByOffice] = @idfResultEnteredByOffice
	  ,[idfResultEnteredByPerson] = @idfResultEnteredByPerson
	  --,[idfValidatedByOffice] = @idfValidatedByOffice
	  --,[idfValidatedByPerson] = @idfValidatedByPerson
	  ,[blnNonLaboratoryTest] = @blnNonLaboratoryTest
	WHERE [idfTesting] = @idfTesting

end

if @Action<> 8 And @blnIsMainSampleTest = 1
BEGIN
	UPDATE tlbMaterial 
	SET	idfMainTest = @idfTesting
	WHERE idfMaterial = @idfMaterial 
			AND ISNULL(idfMainTest, 0)<>ISNULL(@idfTesting,0)
			AND intRowStatus = 0
END
RETURN 0



