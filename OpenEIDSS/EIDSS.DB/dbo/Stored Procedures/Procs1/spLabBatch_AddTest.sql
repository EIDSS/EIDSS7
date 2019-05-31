


create proc spLabBatch_AddTest
 @idfBatchTest bigint,
 @idfTesting bigint

as 

update	tlbTesting
set		idfBatchTest=@idfBatchTest, 
		idfsTestStatus = CASE	WHEN ISNULL(idfsTestStatus, 10001005) = 10001005 -- Not started
								THEN 10001004 --Preliminary
								ELSE idfsTestStatus END 
where	idfTesting=@idfTesting and idfBatchTest is null


