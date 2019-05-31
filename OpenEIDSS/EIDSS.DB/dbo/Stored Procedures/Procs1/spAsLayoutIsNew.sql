
CREATE PROCEDURE [dbo].[spAsLayoutIsNew]
	@LayoutID	as bigint
AS
	if(Exists (select * from tasLayoutSearchField where idflLayout = @LayoutID))
		RETURN 0
	else
		RETURN 1

