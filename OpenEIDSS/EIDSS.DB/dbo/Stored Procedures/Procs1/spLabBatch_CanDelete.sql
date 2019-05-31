

CREATE proc [dbo].[spLabBatch_CanDelete]
	@idfBatchTest bigint,
    @Result BIT OUT 
as 
	if (exists (select * from tlbBatchTest where idfsBatchStatus <> 10001001 and idfBatchTest = @idfBatchTest)
		and not exists (select * from tlbTesting where idfBatchTest = @idfBatchTest and intRowStatus = 0) )
		set @Result = 1
	else
		set @Result = 0

	IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
	BEGIN
		DECLARE @DataValidationResult INT	
		EXEC @DataValidationResult = spLabBatch_Validate @idfBatchTest
		IF @DataValidationResult <> 0
			SET @Result = 0
	END

	return @Result

