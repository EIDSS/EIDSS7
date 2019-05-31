

CREATE PROCEDURE [dbo].[spLabSampleDestruction_SelectDetail]
	@LangID nvarchar(50),
	@destroy bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--DECLARE @status nvarchar(20)
	--SET @status='acsUndefined'
	IF @destroy=1
	BEGIN
		SELECT	*
		from	fnReference(@LangID,19000015)--rftContainerStatus
		WHERE	idfsReference in (10015009,10015008)--cotIsDestroyed,cotIsDeleted
	END
	ELSE
	BEGIN
		SELECT	*
		from	fnReference(@LangID,19000015)--rftContainerStatus
		WHERE	idfsReference in (10015003,10015002)--cotDestroy,cotDelete

	END

END

