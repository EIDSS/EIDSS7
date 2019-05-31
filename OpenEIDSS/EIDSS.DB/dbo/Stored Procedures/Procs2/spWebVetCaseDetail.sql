

/*
exec spWebVetCaseDetail 0,'en'
*/

CREATE PROCEDURE dbo.spWebVetCaseDetail
	@ID nvarchar(200),
	@LangID nvarchar(50)
AS
BEGIN

	select	*
	from	fnWebVetCaseList(@LangID)
	where	strCaseID=@ID
END

