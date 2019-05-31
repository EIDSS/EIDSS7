
CREATE PROCEDURE dbo.spLoginInfo_Post
(
	@Action int -- 4 - Added, 8 - Deleted, 16 - Modified
	,@idfUserID bigint
	,@idfPerson	bigint
	,@strAccountName nvarchar(200)
	,@binPassword	varbinary(50)
	,@datPasswordSet datetime
)
As begin

IF ISNULL(@idfUserID,-1)<0
BEGIN
	EXEC spsysGetNewID @idfUserID OUTPUT
END


-- Add or Modify
IF @Action = 4
BEGIN
	--@idfsSite of user table record must be initialized by site of person organization site
	--interface form prevents editing login info if person organization is not related with any site
	declare @idfsPersonSite bigint
	SELECT @idfsPersonSite = s.idfsSite
	FROM tlbPerson p  
	inner join tstSite s on s.idfOffice = p.idfInstitution and s.intRowStatus = 0
	where p.idfPerson = @idfPerson

	if (@datPasswordSet is null) Set @datPasswordSet = GETDATE();
	Insert into [dbo].[tstUserTable]
	(
		idfUserID
		,idfPerson
		,idfsSite
		,strAccountName
		,binPassword
		,datPasswordSet	
	)
	Values
	(
		@idfUserID
		,@idfPerson
		,@idfsPersonSite
		,@strAccountName
		,@binPassword
		,@datPasswordSet
	)
END
-- Modify
IF @Action = 16
BEGIN		
	Update [dbo].[tstUserTable]
	Set strAccountName = @strAccountName
		,binPassword = @binPassword
	Where idfUserID = @idfUserID
END
-- Delete
IF @Action = 8
BEGIN
	Exec [dbo].[spLoginInfo_Delete] @idfUserID
END

End
