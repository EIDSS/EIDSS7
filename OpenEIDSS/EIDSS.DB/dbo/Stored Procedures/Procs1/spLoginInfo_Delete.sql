
CREATE PROCEDURE [dbo].[spLoginInfo_Delete]
(
	@idfUserID bigint
)
AS
Begin
	Delete from dbo.tstUserTable where idfUserID=@idfUserID
end
