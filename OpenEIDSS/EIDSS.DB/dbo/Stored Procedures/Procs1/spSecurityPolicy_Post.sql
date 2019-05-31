

CREATE PROCEDURE [dbo].[spSecurityPolicy_Post]
	--@strName nvarchar(200),
	--@strValue nvarchar(200)
	@ID bigint,
	@intAccountLockTimeout int,
	@intAccountTryCount int,
	@intInactivityTimeout int,
	@intPasswordAge int,
	@intPasswordHistoryLength int,
	@intPasswordMinimalLength int,
	@intForcePasswordComplexity int
AS
BEGIN
/*	update	tstGlobalSiteOptions
	set		strValue=@strValue
	where	strName=@strName

	if @@rowcount=0
		insert into tstGlobalSiteOptions(strName,strValue)
		values (@strName,@strValue)*/

	update	tstSecurityConfiguration
	set		
	intAccountLockTimeout=@intAccountLockTimeout,
	intAccountTryCount=@intAccountTryCount,
	intInactivityTimeout=@intInactivityTimeout,
	intPasswordAge=@intPasswordAge,
	intPasswordHistoryLength=@intPasswordHistoryLength,
	intPasswordMinimalLength=@intPasswordMinimalLength,
	intForcePasswordComplexity=@intForcePasswordComplexity
	where	idfSecurityConfiguration=@ID
	
END

