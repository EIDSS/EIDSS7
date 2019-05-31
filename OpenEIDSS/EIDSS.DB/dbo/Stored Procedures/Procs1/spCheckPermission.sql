

/*
declare @ret integer
exec @ret=spCheckPermission 0,0,0
select @ret
*/

CREATE PROCEDURE spCheckPermission
	@idfsSystemFunction bigint,
	@idfsObjectOperation bigint,
	@idfObjectID bigint
AS
BEGIN

	declare	@user bigint
	set @user=dbo.fnUserID()

	DECLARE @permission bit
	set		@permission=0

	declare	@Employee as bigint

	select	@Employee=tstUserTable.idfPerson
	from	tstUserTable
	where	tstUserTable.idfUserID=@user

	select	@permission=Case when intPermission=2 then 1 else 0 end
	from	fnEvaluatePermissions(@Employee)
	where	idfsSystemFunction=@idfsSystemFunction and idfsObjectOperation=@idfsObjectOperation

	exec spLogSecurityEvent
		@idfUserID=@user,
		@idfsAction=10110004,
		@success=@permission,
		@idfObjectID=@idfObjectID

	RETURN @permission

END

