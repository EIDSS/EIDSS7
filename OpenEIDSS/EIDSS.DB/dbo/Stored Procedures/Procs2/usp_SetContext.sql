
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/12/2017
-- Last modified by:		Joan Li
-- Description:				Created based on V6 spSetContext: rename for V7
-- Testing code:
/*
----testing code:
DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_SetContext]
		@ContextString = ' ' ---- N'abcd'
SELECT	'Return Value' = @return_value
GO
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[usp_SetContext]
	@ContextString varchar(50)

AS
BEGIN
	DECLARE @Context VARBINARY(128)
	IF @ContextString IS NULL OR @ContextString=''
		BEGIN
			SET @Context = CAST(@ContextString AS VARBINARY(128))
			SET CONTEXT_INFO @Context
			----debug view 
			----select @Context
			RETURN 0
		END	

	SET @Context = CAST(@ContextString AS VARBINARY(128))
	----debug view 
	----select @Context
	SET CONTEXT_INFO @Context
	RETURN 0
END
