





CREATE     PROCEDURE [dbo].[spLabTest_Delete](
	@ID as bigint
)
AS
	delete from tlbTestValidation 
	where idfTesting = @ID
			and intRowStatus = 0

	delete from tlbTestAmendmentHistory
	where idfTesting = @ID
			and intRowStatus = 0
	
	
	--Delete unknown sample related with deleted test if there is no more tests linked with unknown samples
	DECLARE @sampleType bigint
	DECLARE @caseId bigint
	DECLARE @materialId bigint
	select 
		@sampleType = idfsSampleType
		,@materialId = m.idfMaterial
	from tlbMaterial m
	inner join tlbTesting t on t.idfMaterial = m.idfMaterial
	where t.idfTesting = @ID and t.intRowStatus = 0 and m.intRowStatus = 0

	if @sampleType = 10320001 /*Unknown sample */ and not exists (
		select * from tlbMaterial m 
		inner join tlbTesting t on t.idfMaterial = m.idfMaterial 
		where ((@materialId = m.idfMaterial ) and m.idfsSampleType = @sampleType and t.idfTesting<>@ID and t.intRowStatus = 0 and m.intRowStatus = 0)
		)
	BEGIN
		delete from tlbMaterial where idfMaterial = @materialId
	END

	delete from tlbTestValidation 
	where idfTesting = @ID
			and intRowStatus = 0

	delete from tlbTestAmendmentHistory
	where idfTesting = @ID
			and intRowStatus = 0
	
	
	declare @idfObservation bigint
	select @idfObservation = idfObservation
	from tlbTesting 
	where idfTesting = @ID
	
	exec	spObservation_Delete	@idfObservation

	delete
	from	tlbTesting
	where	tlbTesting.idfTesting=@ID
		AND intRowStatus = 0




