

CREATE proc [dbo].[spLabBatch_Create]
	@idfBatchTest bigint,
	@idfsTestName bigint,
	@idfPerformedByOffice bigint,
	@strBarcode nvarchar(200) output,
	@idfObservation bigint
as 

-- Get barcode number for new Batch
DECLARE @SiteID bigint
set @SiteID = dbo.fnSiteID()

if(ISNULL(@strBarcode,N'') = N'' OR LEFT(ISNULL(@strBarcode,N''),4)='(new')
	exec dbo.spGetNextNumber 10057005 , @strBarcode OUTPUT, NULL --'nbtBatchTest'

insert into	tlbObservation(idfObservation) values(@idfObservation)

insert into	tlbBatchTest(
		idfBatchTest,
		strBarcode,
		idfsTestName,
		idfPerformedByOffice,	
		idfObservation,
		idfsBatchStatus,
		idfsSite
)
values(
		@idfBatchTest,
		@strBarcode,
		@idfsTestName,
		@idfPerformedByOffice,
		@idfObservation,
		10001003, --In Process
		@SiteID
)


