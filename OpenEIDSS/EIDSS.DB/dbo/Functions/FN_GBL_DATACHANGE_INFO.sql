
--=========================================================================
--Checked by: Joan Li 
--Checked on: 6/21/2017
--Note: create for V7 internal DB DML change data date and user
/*
----Example of function call:
DECLARE @WhoWhen varchar(400)
SELECT @WhoWhen= dbo.FN_GBL_DATACHANGE_INFO (NULL)
----SELECT @WhoWhen= dbo.FN_GBL_DATACHANGE_INFO(N'lij')
Select @WhoWhen
*/
--=========================================================================
CREATE FUNCTION [dbo].[FN_GBL_DATACHANGE_INFO]
(
	@User VARCHAR(100) =null
)
RETURNS NVARCHAR(400)
AS
	BEGIN
		RETURN  'On: ' + CONVERT(VARCHAR,CONVERT(VARCHAR,GETDATE(),101)) + ' ' + CONVERT(VARCHAR,GETDATE(),108) + ' By: '+  CONVERT(VARCHAR, ISNULL(@User,SYSTEM_USER))
	END




