



create proc spLabBatch_Update
	@idfBatchTest bigint,
	@strBarcode varchar(200), 
	@idfsTestName bigint, 

	@datPerformedDate dateTime,
	--@idfPerformedByOffice bigint,
	@idfPerformedByPerson bigint = null,

	@datValidatedDate dateTime, 
	@idfValidatedByPerson bigint = null,
	@idfResultEnteredByOffice bigint,
	@idfResultEnteredByPerson bigint,
	@datModificationForArchiveDate datetime = null
as 


update	tlbBatchTest 
set 
		strBarcode = @strBarcode,
		idfsTestName = @idfsTestName,
		datPerformedDate = @datPerformedDate,
		--idfPerformedByOffice = @idfPerformedByOffice,
		idfPerformedByPerson = @idfPerformedByPerson,
		datValidatedDate = @datValidatedDate,
		idfValidatedByPerson = @idfValidatedByPerson,
		idfResultEnteredByOffice = @idfResultEnteredByOffice,
		idfResultEnteredByPerson = @idfResultEnteredByPerson,
		datModificationForArchiveDate = getdate()
where	idfBatchTest = @idfBatchTest


