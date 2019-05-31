

/*
	select * from fn_BatchTest_SelectList('en')
*/

create function [dbo].[fn_BatchTest_SelectList](@LangID as nvarchar(50))
returns table 
as
return

select 
		batch.idfBatchTest,--a.idfActivity,
		batch.strBarcode,
		batch.idfsTestName,
		batch.idfsBatchStatus,
		--!!!!!!!!!!!!!!!TestCode = a.strActivityCode,
		TestName = TestType.name,
		batch.datPerformedDate,
		batch.datValidatedDate,
		TestsInBatchCount = Tests.TestCount,
		StatusName = StatusType.name

from		tlbBatchTest batch
left join
			(
			select		tlbTesting.idfBatchTest,count(*) as TestCount
			from		tlbTesting
			where		tlbTesting.intRowStatus=0
			group by	tlbTesting.idfBatchTest
			)Tests
on			Tests.idfBatchTest=batch.idfBatchTest
left join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestType --rftTestName
on			TestType.idfsReference = batch.idfsTestName
left join	dbo.fnReferenceRepair(@LangID, 19000001 ) StatusType --rftActivityStatus
on			StatusType.idfsReference = batch.idfsBatchStatus
where		batch.intRowStatus=0 
			and batch.idfsSite=dbo.fnSiteID()


