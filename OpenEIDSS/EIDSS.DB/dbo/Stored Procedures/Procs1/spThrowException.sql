

CREATE PROCEDURE [dbo].[spThrowException]
	@ErrorMessage	nvarchar(3900)
AS	
	Set @ErrorMessage = '???' + @ErrorMessage + '???'
	raiserror(@ErrorMessage,16, 1)
RETURN 0

