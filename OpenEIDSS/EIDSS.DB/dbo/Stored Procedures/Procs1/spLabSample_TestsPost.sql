
CREATE PROCEDURE [dbo].[spLabSample_TestsPost]
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
	@datReceivedDate datetime,
	@strContactPerson nvarchar(200),
	@idfPerformedByOffice as bigint 

AS

	EXEC spLabTestEditable_Post    @Action
								  ,@idfTesting
								  ,@idfsTestStatus
								  ,@idfsTestName
								  ,@idfsTestResult
								  ,@idfsTestCategory
								  ,@idfsDiagnosis
								  ,@idfMaterial
								  ,@idfObservation
								  ,@strNote
								  ,@datStartedDate
								  ,@datConcludedDate
								  ,@idfTestedByOffice
								  ,@idfTestedByPerson
								  ,@idfResultEnteredByOffice
								  ,@idfResultEnteredByPerson
								  ,@idfValidatedByOffice
								  ,@idfValidatedByPerson
								  ,@idfsFormTemplate
								  ,@blnNonLaboratoryTest
								  ,@blnExternalTest
  								  ,@datReceivedDate
								  ,@idfPerformedByOffice
								  ,@strContactPerson


RETURN 0
