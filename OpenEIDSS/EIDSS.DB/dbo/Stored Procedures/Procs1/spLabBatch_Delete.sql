

CREATE proc [dbo].[spLabBatch_Delete]
	@idfBatchTest bigint
as 
declare @idfObservation bigint
select @idfObservation = idfObservation from tlbBatchTest where idfBatchTest = @idfBatchTest
exec spObservation_Delete @idfObservation

delete from tlbBatchTest  where idfBatchTest = @idfBatchTest


