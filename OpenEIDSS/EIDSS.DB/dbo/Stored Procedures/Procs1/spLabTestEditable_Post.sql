
	


CREATE   PROCEDURE [dbo].[spLabTestEditable_Post](
	@Action INT,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@idfTesting as bigint,
	@idfsTestStatus as bigint,
	@idfsTestName as bigint,
	@idfsTestResult as bigint,
	@idfsTestCategory as bigint,
	@idfsDiagnosis as bigint,
	@idfMaterial as bigint,
	@idfObservation as bigint,
	@strNote as nvarchar(500),
	@datStartedDate as datetime,
	@datConcludedDate as datetime,
	@idfTestedByOffice as bigint,
	@idfTestedByPerson as bigint,
	@idfResultEnteredByOffice as bigint,
	@idfResultEnteredByPerson as bigint,
	@idfValidatedByOffice as bigint,
	@idfValidatedByPerson as bigint,
	@idfsFormTemplate as bigint,
	@blnNonLaboratoryTest as bit,
	@blnExternalTest as bit,
	@datReceivedDate as datetime,
	@idfPerformedByOffice as bigint,
	@strContactPerson as nvarchar(200),
	@blnIsMainSampleTest bit = null
)
as

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
			   ,[strNote]
			   ,[datStartedDate]
			   ,[datConcludedDate]
			   ,[idfTestedByOffice]
			   ,[idfTestedByPerson]
			   ,[idfResultEnteredByOffice]
			   ,[idfResultEnteredByPerson]
			   ,[idfValidatedByOffice]
			   ,[idfValidatedByPerson]
			   ,[blnNonLaboratoryTest]
			   ,[idfPerformedByOffice]
			   ,[datReceivedDate]
			   ,[strContactPerson]
			   ,[blnExternalTest]
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
			   ,@strNote
			   ,CASE WHEN (@blnNonLaboratoryTest = 1 OR @datStartedDate IS NULL) THEN  @datConcludedDate ELSE @datStartedDate END -- we can't define @datStartedDate in sample detail form, and use @datConcludedDate if @datStartedDate is not defined  
			   ,@datConcludedDate
			   ,@idfTestedByOffice
			   ,@idfTestedByPerson
			   ,@idfResultEnteredByOffice
			   ,@idfResultEnteredByPerson
			   ,@idfValidatedByOffice
			   ,@idfValidatedByPerson
			   ,@blnNonLaboratoryTest
			   ,@idfPerformedByOffice
			   ,@datReceivedDate
			   ,@strContactPerson
			   ,isnull(@blnExternalTest,0)
			   )
	--restore unknown sample if it was deeleted during previous form saving		   
	if (select tlbMaterial.idfsSampleType from tlbMaterial where idfMaterial = @idfMaterial and intRowStatus = 1) = 10320001 -- unknown
	begin
		UPDATE tlbMaterial
		SET
		   intRowStatus = 0
		WHERE [idfMaterial] = @idfMaterial
	end
	
	if ISNULL(@idfsTestStatus,0) in (10001001, 10001006) --completed or amended
		EXEC spLabTest_UpdateCase @idfTesting

end
else if (@Action = 8) -- delete
begin

	EXEC spLabTest_Delete @idfTesting
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
	  ,[strNote] = @strNote
	  ,[datStartedDate] = CASE WHEN (@blnNonLaboratoryTest = 1 OR @datStartedDate IS NULL) THEN  @datConcludedDate ELSE @datStartedDate END 
	  ,[datConcludedDate] = @datConcludedDate
	  ,[idfTestedByOffice] = @idfTestedByOffice
	  ,[idfTestedByPerson] = @idfTestedByPerson
	  ,[idfResultEnteredByOffice] = @idfResultEnteredByOffice
	  ,[idfResultEnteredByPerson] = @idfResultEnteredByPerson
	  ,[idfValidatedByOffice] = @idfValidatedByOffice
	  ,[idfValidatedByPerson] = @idfValidatedByPerson
	  ,[blnNonLaboratoryTest] = @blnNonLaboratoryTest
	  ,[blnExternalTest] = isnull(@blnExternalTest,0)
	  , idfPerformedByOffice = @idfPerformedByOffice
	  , datReceivedDate = @datReceivedDate
	  , strContactPerson = @strContactPerson
	WHERE [idfTesting] = @idfTesting
		
	
	--update idfsYNTestsConducted in related cases if all linked lab tests are completed
	if ISNULL(@idfsTestStatus,0) in (10001001, 10001006) --completed or amended
		EXEC spLabTest_UpdateCase @idfTesting

end

if @Action<> 8 And @blnIsMainSampleTest = 1
BEGIN
	UPDATE tlbMaterial 
	SET	idfMainTest = @idfTesting
	WHERE idfMaterial = @idfMaterial 
			AND ISNULL(idfMainTest, 0)<>ISNULL(@idfTesting,0)
			AND intRowStatus = 0
END

