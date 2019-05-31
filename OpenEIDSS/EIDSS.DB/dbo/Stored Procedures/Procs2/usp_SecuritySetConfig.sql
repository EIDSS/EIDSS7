
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/11/2017
-- Last modified by:		Joan Li
-- Description:				Created based on V6 spSecurityPolicy_Post: rename for V7
-- Testing code:
/*
========================================================HISTORY=========================================
Lamont Mitchell			1/23/19			Aliased Return Columns, Added Try Catch
----testing code:

DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_SecuritySetConfig]
		@ID = 123456,
		@intAccountLockTimeout = 1,
		@intAccountTryCount = 2,
		@intInactivityTimeout = 3,
		@intPasswordAge = 4,
		@intPasswordHistoryLength = 5,
		@intPasswordMinimalLength = 6,
		@intForcePasswordComplexity = 7
SELECT	'Return Value' = @return_value
GO

*/
--=====================================================================================================
CREATE PROCEDURE [dbo].[usp_SecuritySetConfig]
	--@strName nvarchar(200),
	--@strValue nvarchar(200)
	@ID bigint,
	@intAccountLockTimeout int,
	@intAccountTryCount int,
	@intInactivityTimeout int,
	@intPasswordAge int,
	@intPasswordHistoryLength int,
	@intPasswordMinimalLength int,
	@intForcePasswordComplexity int
AS
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;
BEGIN TRY

	UPDATE	tstSecurityConfiguration
	SET		
	intAccountLockTimeout=@intAccountLockTimeout,
	intAccountTryCount=@intAccountTryCount,
	intInactivityTimeout=@intInactivityTimeout,
	intPasswordAge=@intPasswordAge,
	intPasswordHistoryLength=@intPasswordHistoryLength,
	intPasswordMinimalLength=@intPasswordMinimalLength,
	intForcePasswordComplexity=@intForcePasswordComplexity
	WHERE	idfSecurityConfiguration=@ID
	SELECT @returnMsg 'ReturnMessage', @returnCode 'ReturnCode'
END TRY
BEGIN CATCH
THROW;
END CATCH

END


