


create proc spLabBatch_RemoveTest
 @idfBatchTest bigint,
 @idfTesting bigint
as

update	tlbTesting
set		idfBatchTest=null
		,idfsTestStatus = 10001005 --undefined
		,idfsTestResult = null
		,idfTestedByPerson = null
		,idfTestedByOffice = null
		,idfResultEnteredByPerson = null
		,idfResultEnteredByOffice = null

		
where	idfTesting=@idfTesting and idfBatchTest=@idfBatchTest


