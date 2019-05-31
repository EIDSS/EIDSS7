

--##SUMMARY Force user password

--##REMARKS Author: Kletkin.
--##REMARKS Create date: 31.05.2010

--##RETURNS @Result parameter returns the error Code
--##RETURNS 		0 - No errors
--##RETURNS 		2 - User with such login/password is not found
--##RETURNS 		7 - Invalid parameter. 

/*
--Example of procedure call:
*/

CREATE            PROCEDURE [dbo].[spSetPassword]( 
--	@Organization AS NVARCHAR(200),--##PARAM @Organization - organization abbreviation
--	@UserName AS NVARCHAR(200),--##PARAM @UserName - user login
	@UserID as bigint,--##PARAM @UserID user name
	@Password AS VARBINARY(MAX),--##PARAM @Password - user password
	@Result AS INTEGER OUTPUT--##PARAM @Result - returns extended result of login attempt. 0 means successfull login, other value is the error Code.
)
AS

if DATALENGTH (@Password)<20
begin
	set @Result=7
	return
end

--check permissions
--declare @right as int
--select	@right=tstObjectAccess.intPermission
--from	tstObjectAccess
--where	tstObjectAccess.idfActor=dbo.fnUserID() and
--		tstObjectAccess.intRowStatus=0 and
--		tstObjectAccess.idfsObjectID=10094013 and--system function user
--		tstObjectAccess.idfsObjectOperation=11111 --update
--		and tstObjectAccess.idfsOnSite = dbo.fnPermissionSite()

--find user

--declare @user bigint
--select	@user=idfUserID
--from	fnGetUserInfo(@Organization,@UserName)
/*
if @user is null
begin
	set @Result=2
	return
end
*/
declare @pid bigint

exec spsysGetNewID @pid out

insert into tstUserTableOldPassword(
		idfUserOldPassword,
		idfUserID,
		datExpiredDate,
		binOldPassword)
select	@pid,
		@UserID,
		getdate(),
		binPassword
from	tstUserTable
where	idfUserID=@UserID

update	tstUserTable
set		binPassword=@Password,
		datPasswordSet=getutcdate()
where	idfUserID=@UserID and
		intRowStatus=0

if @@ROWCOUNT=0
begin
	set @Result=2
	return
end

set @Result=0
return


