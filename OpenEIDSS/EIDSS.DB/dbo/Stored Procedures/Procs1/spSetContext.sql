

CREATE PROCEDURE dbo.spSetContext(@ContextString varchar(50))
AS
	DECLARE @Context VARBINARY(128)

	IF @ContextString IS NULL OR @ContextString=''
		BEGIN
			SET @Context = CAST(@ContextString AS VARBINARY(128))
			SET CONTEXT_INFO @Context
			RETURN 0
		END
		
	SET @Context = CAST(@ContextString AS VARBINARY(128))
	SET CONTEXT_INFO @Context

RETURN 0
