
CREATE PROCEDURE dbo.spDeleteContextData
AS
	DECLARE @idfsConnectionContext AS VARCHAR(50)
	SELECT 	@idfsConnectionContext = dbo.fnGetContext()

	DELETE FROM dbo.tstLocalConnectionContext
	WHERE strConnectionContext = @idfsConnectionContext

RETURN 0

