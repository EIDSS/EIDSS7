
create PROCEDURE [dbo].[spLaboratorySectionItem_Post](
	@Action INT,  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	@ID as bigint,

	@idfMaterial as bigint,
	@idfRootMaterial as bigint,
	@idfParentMaterial as bigint,
	@strBarcode as nvarchar(200) output,
	@idfsSampleType as bigint,
	@idfsSampleStatus as bigint,
	@idfsAccessionCondition as bigint,
	@idfAccesionByPerson as bigint,
	@datAccession as datetime,
	@idfSendToOffice as bigint,
	@idfSubdivision as bigint,
	@idfInDepartment as bigint,
	@idfHuman as bigint,
	@idfSpecies as bigint,
	@idfAnimal as bigint,
	@idfHumanCase as bigint,
	@idfVetCase as bigint,
	@idfMonitoringSession as bigint,
	@idfFieldCollectedByPerson as bigint,
	@idfFieldCollectedByOffice as bigint,
	@idfMainTest as bigint,
	@datFieldCollectionDate as datetime,
	@datFieldSentDate as datetime,
	@strFieldBarcode as nvarchar(200),
	@strCalculatedCaseID as nvarchar(200),
	@strCalculatedHumanName as nvarchar(200),
	@idfVectorSurveillanceSession as bigint,
	@idfVector as bigint,
	@idfDestroyedByPerson as bigint,
	@datEnteringDate as datetime,
	@datDestructionDate as datetime,
	@idfsDestructionMethod as bigint,
	@strSampleNote as nvarchar(500),
	@strCondition as nvarchar(500),
	@idfsSampleKind as bigint,
	@idfMarkedForDispositionByPerson as bigint,

	@idfSendToOfficeOut as bigint,
	@idfSendByPerson as bigint,
	@datSendDate as datetime,

	@idfTesting as bigint,
	@idfsTestStatus as bigint,
	@idfsTestName as bigint,
	@idfsTestResult as bigint,
	@idfsTestCategory as bigint,
	@idfsDiagnosis as bigint,
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
	@bTestDeleted as bit,
	@bTestInserted as bit output,
	@bTestInsertedFirst as bit output

)
AS 
begin


if (@Action = 4) -- insert
begin
	if not exists(select * from tlbMaterial where idfMaterial = @idfMaterial)
	begin
		if(ISNULL(@strBarcode,N'') = N'' OR LEFT(ISNULL(@strBarcode,N''),4)='(new')
		begin
			if @idfParentMaterial is null or @idfParentMaterial = 0
				exec dbo.spGetNextNumber 10057020 , @strBarcode OUTPUT, NULL --'Sample'
			else if @idfsSampleKind = 12675430000000 -- TranferredIn
				exec dbo.spGetNextNumber 10057020 , @strBarcode OUTPUT, NULL 
			else if @idfsSampleKind = 12675410000000 -- aliqute
				exec dbo.spGetNextSampleVariantNumber @idfParentMaterial, 'A', @strBarcode OUTPUT
			else if @idfsSampleKind = 12675420000000 -- derivative
				exec dbo.spGetNextSampleVariantNumber @idfParentMaterial, 'D', @strBarcode OUTPUT
		end

		INSERT INTO tlbMaterial
		(
			idfMaterial,
			idfsSampleType,
			idfRootMaterial,
			idfParentMaterial,
			idfHuman,
			idfSpecies,
			idfAnimal,
			idfHumanCase,
			idfVetCase,
			idfMonitoringSession,
			idfFieldCollectedByPerson,
			idfFieldCollectedByOffice,
			idfMainTest,
			datFieldCollectionDate,
			datFieldSentDate,
			strFieldBarcode,
			strCalculatedCaseID,
			strCalculatedHumanName,
			idfVectorSurveillanceSession,
			idfVector,
			idfSendToOffice,
			idfSubdivision,
			idfsSampleStatus,
			idfInDepartment,
			idfDestroyedByPerson,
			idfsAccessionCondition, 
			idfAccesionByPerson,
			datAccession,
			datEnteringDate,
			datDestructionDate,
			idfsDestructionMethod,
			strBarcode,
			strNote,
			strCondition,
			idfsSite,
			idfsCurrentSite,
			idfsSampleKind,
			idfMarkedForDispositionByPerson,
			datOutOfRepositoryDate
		)	
		VALUES
		(
			@idfMaterial,
			@idfsSampleType,
			@idfRootMaterial,
			@idfParentMaterial,
			@idfHuman,
			@idfSpecies,
			@idfAnimal,
			@idfHumanCase,
			@idfVetCase,
			@idfMonitoringSession,
			@idfFieldCollectedByPerson,
			@idfFieldCollectedByOffice,
			@idfMainTest,
			@datFieldCollectionDate,
			@datFieldSentDate,
			@strFieldBarcode,
			@strCalculatedCaseID,
			@strCalculatedHumanName,
			@idfVectorSurveillanceSession,
			@idfVector,
			@idfSendToOffice,
			@idfSubdivision,
			nullif(nullif(@idfsSampleStatus,-1),0),
			nullif(@idfInDepartment,0),
			@idfDestroyedByPerson,
			@idfsAccessionCondition, 
			@idfAccesionByPerson,
			@datAccession,
			@datEnteringDate,
			@datDestructionDate,
			nullif(@idfsDestructionMethod,0),
			@strBarcode,
			@strSampleNote,
			@strCondition,
			dbo.fnSiteID(),
			dbo.fnSiteID(),
			nullif(nullif(@idfsSampleKind,-1),0),
			@idfMarkedForDispositionByPerson,
			@datSendDate
		)
		
		IF EXISTS (
			SELECT tlbMaterial.idfMaterial
			FROM		tlbMaterial
			inner join	tlbHumanCase
			on			tlbHumanCase.idfHumanCase=@idfHumanCase and
						(tlbHumanCase.idfsYNSpecimenCollected is null 
							or tlbHumanCase.idfsYNSpecimenCollected <> 10100001)
			WHERE tlbMaterial.idfHumanCase = @idfHumanCase
				AND tlbMaterial.intRowStatus = 0
		)
		BEGIN
			UPDATE tlbHumanCase 
			SET idfsYNSpecimenCollected=10100001
			WHERE idfHumanCase=@idfHumanCase
		END
	end
end
--else 
--if (@Action = 8) -- delete
--begin
--end
--else 

if (@Action = 16) -- update
begin
		if(ISNULL(@strBarcode,N'') = N'' OR LEFT(ISNULL(@strBarcode,N''),4)='(new')
		begin
			if @idfParentMaterial is null or @idfParentMaterial = 0
				exec dbo.spGetNextNumber 10057020 , @strBarcode OUTPUT, NULL --'Sample'
			else if @idfsSampleKind = 12675430000000 -- TranferredIn
				exec dbo.spGetNextNumber 10057020 , @strBarcode OUTPUT, NULL 
			else if @idfsSampleKind = 12675410000000 -- aliqute
				exec dbo.spGetNextSampleVariantNumber @idfParentMaterial, 'A', @strBarcode OUTPUT
			else if @idfsSampleKind = 12675420000000 -- derivative
				exec dbo.spGetNextSampleVariantNumber @idfParentMaterial, 'D', @strBarcode OUTPUT
		end

		UPDATE tlbMaterial
		SET 
			idfsSampleType = @idfsSampleType,
			idfRootMaterial = @idfRootMaterial,
			idfParentMaterial = @idfParentMaterial,
			idfHuman = @idfHuman,
			idfSpecies = @idfSpecies,
			idfAnimal = @idfAnimal,
			idfHumanCase = @idfHumanCase,
			idfVetCase = @idfVetCase,
			idfMonitoringSession = @idfMonitoringSession,
			idfFieldCollectedByPerson = @idfFieldCollectedByPerson,
			idfFieldCollectedByOffice = @idfFieldCollectedByOffice,
			idfMainTest = @idfMainTest,
			datFieldCollectionDate = @datFieldCollectionDate,
			datFieldSentDate = @datFieldSentDate,
			strFieldBarcode = @strFieldBarcode,
			strCalculatedCaseID = @strCalculatedCaseID,
			strCalculatedHumanName = @strCalculatedHumanName,
			idfVectorSurveillanceSession = @idfVectorSurveillanceSession,
			idfVector = @idfVector,
			idfSendToOffice = @idfSendToOffice,
			idfSubdivision = @idfSubdivision,
			idfsSampleStatus = nullif(nullif(@idfsSampleStatus,-1),0),
			idfInDepartment = nullif(@idfInDepartment,0),
			idfDestroyedByPerson = @idfDestroyedByPerson,
			idfsAccessionCondition = @idfsAccessionCondition, 
			idfAccesionByPerson = @idfAccesionByPerson,
			datAccession = @datAccession,
			datEnteringDate = @datEnteringDate,
			datDestructionDate = @datDestructionDate,
			idfsDestructionMethod = nullif(@idfsDestructionMethod,0),
			strBarcode = @strBarcode,
			strNote = @strSampleNote,
			strCondition = @strCondition,
			idfsSite = dbo.fnSiteID(),
			idfsCurrentSite = dbo.fnSiteID(),
			idfsSampleKind = nullif(nullif(@idfsSampleKind,-1),0),
			idfMarkedForDispositionByPerson = @idfMarkedForDispositionByPerson,
			datOutOfRepositoryDate = @datSendDate
		WHERE idfMaterial = @idfMaterial
end



if (not @idfTesting is null)
begin
	select @idfResultEnteredByPerson = nullif(@idfResultEnteredByPerson,0)
	declare @idfUserID AS BIGINT
	select @idfUserID = dbo.fnUserID()
	
	if (@bTestDeleted = 1)
	BEGIN
		exec dbo.spLabTest_Delete @idfTesting

		IF EXISTS (SELECT * FROM dbo.tstLocalSamplesTestsPreferences
			WHERE idfMaterial = @idfMaterial AND idfTesting = @idfTesting AND idfUserID = @idfUserID)
			BEGIN
				UPDATE dbo.tstLocalSamplesTestsPreferences
				SET idfTesting = null
				WHERE idfMaterial = @idfMaterial AND idfTesting = @idfTesting AND idfUserID = @idfUserID
			END
	END
	else
	BEGIN
	
	declare @bCheckPref bit
	select @bCheckPref = @bTestInsertedFirst
	
	if @bTestInserted = 1 or @bTestInsertedFirst = 1
		select @Action = 4
	
	select @blnNonLaboratoryTest = ISNULL(@blnNonLaboratoryTest,0)
	select @bTestInserted = 0
	select @bTestInsertedFirst = 0
		
	exec dbo.spLabTestEditable_Post
		@Action,
		@idfTesting,
		@idfsTestStatus,
		@idfsTestName,
		@idfsTestResult,
		@idfsTestCategory,
		@idfsDiagnosis,
		@idfMaterial,
		@idfObservation,
		@strNote,
		@datStartedDate,
		@datConcludedDate,
		@idfTestedByOffice,
		@idfTestedByPerson,
		@idfResultEnteredByOffice,
		@idfResultEnteredByPerson,
		@idfValidatedByOffice,
		@idfValidatedByPerson,
		@idfsFormTemplate,
		@blnNonLaboratoryTest,
		@blnExternalTest,
		@datReceivedDate,
		@idfPerformedByOffice,
		@strContactPerson

		
	if @bCheckPref = 1
	BEGIN
		IF EXISTS (SELECT * FROM dbo.tstLocalSamplesTestsPreferences
			WHERE idfMaterial = @idfMaterial AND isnull(idfTesting,0) = 0 AND idfUserID = @idfUserID)
			BEGIN
				UPDATE dbo.tstLocalSamplesTestsPreferences
				SET idfTesting = @idfTesting
				WHERE idfMaterial = @idfMaterial AND isnull(idfTesting,0) = 0 AND idfUserID = @idfUserID
			END
	END
		
	END
end

end


