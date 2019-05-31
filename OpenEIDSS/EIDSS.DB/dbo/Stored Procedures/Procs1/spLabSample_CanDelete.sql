
CREATE PROCEDURE [dbo].[spLabSample_CanDelete]
	@idfMaterial bigint,
    @Result BIT OUT 
AS
	if (not exists (select * from tlbTesting where idfMaterial = @idfMaterial and intRowStatus = 0) )
		set @Result = 1
	else
		set @Result = 0

	IF ISNULL((SELECT strValue FROM tstGlobalSiteOptions WHERE strName = 'DataValidation' AND intRowStatus = 0), 0) = 1
	BEGIN
		DECLARE @DataValidationResult INT	
		EXEC @DataValidationResult = spLabSample_Validate @idfMaterial
		IF @DataValidationResult <> 0
			SET @Result = 0
	END

	return @Result
RETURN 0

