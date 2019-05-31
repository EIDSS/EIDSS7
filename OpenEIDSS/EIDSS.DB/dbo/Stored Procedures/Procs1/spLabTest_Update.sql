
 


create proc [dbo].[spLabTest_Update]
	@idfTesting bigint,
	@idfsTestResult bigint=null,
	@intTestNumber int=null,
	@idfsTestStatus bigint=null,
	@idfResultEnteredByPerson bigint,
	@idfsTestCategory bigint
as 

update	tlbTesting
set		
		idfsTestResult = IsNull(@idfsTestResult,idfsTestResult),
		idfsTestStatus = IsNull(@idfsTestStatus,idfsTestStatus),
		intTestNumber = @intTestNumber,
		idfResultEnteredByPerson = @idfResultEnteredByPerson,
		idfsTestCategory = @idfsTestCategory
where	idfTesting=@idfTesting

--update idfsYNTestsConducted in related cases if all linked lab tests are completed
if ISNULL(@idfsTestStatus,0) in (10001001, 10001006) --completed or amended
	EXEC spLabTest_UpdateCase @idfTesting




