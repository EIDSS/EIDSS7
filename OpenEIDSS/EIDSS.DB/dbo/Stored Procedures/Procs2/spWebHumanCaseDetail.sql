

CREATE PROCEDURE dbo.spWebHumanCaseDetail
	@ID nvarchar(100),
	@LangID nvarchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	select	*
	from	fnWebHumanCaseListEx(@LangID)
	where	strCaseID=@ID

END


