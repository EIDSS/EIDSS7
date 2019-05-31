

CREATE            PROCEDURE dbo.spLabTest_CanDelete( 
	@ID as bigint,
	@Result as bit output
)
AS

if exists(
	select		tlbTesting.idfTesting
	from		tlbTesting
	inner join	tlbBatchTest
	on			tlbTesting.idfTesting=@ID and
				tlbBatchTest.idfBatchTest=tlbTesting.idfBatchTest and
				tlbTesting.intRowStatus=0 and
				(tlbBatchTest.idfsBatchStatus=10001001--Completed
				or tlbBatchTest.idfsBatchStatus=10001006)--Amended)
	)
	set @Result=0
else
if exists(
	select		tlbTesting.idfTesting
	from		tlbTesting
	where		tlbTesting.idfTesting=@ID and
				tlbTesting.intRowStatus=0 and
				tlbTesting.blnNonLaboratoryTest = 0 and
				(tlbTesting.idfsTestStatus=10001001--Completed
				or tlbTesting.idfsTestStatus=10001006)--Amended)
	)
	set @Result=0

else
if exists(
	select		tlbTesting.idfTesting
	from		tlbTesting
	inner join	dbo.tlbTestValidation
	on			tlbTesting.idfTesting=@ID and
				tlbTestValidation.idfTesting=tlbTesting.idfTesting and
				tlbTesting.intRowStatus=0 and
				tlbTestValidation.intRowStatus = 0
	)
	set @Result=0

else
	set @Result=1

IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
BEGIN
	DECLARE @DataValidationResult INT	
	EXEC @DataValidationResult = spLabTest_Validate @ID
	IF @DataValidationResult <> 0
		SET @Result = 0
END

return @Result


