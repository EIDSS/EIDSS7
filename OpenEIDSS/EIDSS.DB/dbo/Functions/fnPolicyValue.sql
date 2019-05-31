

/*
select * from dbo.fnPolicyValue()
*/

CREATE FUNCTION dbo.fnPolicyValue
(
)
RETURNS 
@ret TABLE 
(
	idfSecurityConfiguration bigint,
	idfsSecurityLevel bigint,
	intAccountLockTimeout int,
	intAccountTryCount int,
	intInactivityTimeout int,
	intPasswordAge int,
	intPasswordHistoryLength int,
	intPasswordMinimalLength int,
	intForcePasswordComplexity int
)
AS
BEGIN
declare @idfSecurityConfiguration bigint
declare @idfsSecurityLevel bigint
declare @intAccountLockTimeout int
declare @intAccountTryCount int
declare @intInactivityTimeout int
declare @intPasswordAge int
declare @intPasswordHistoryLength int
declare @intPasswordMinimalLength int
declare @intForcePasswordComplexity int

set @idfSecurityConfiguration=0
set @intAccountLockTimeout=15
set @intAccountTryCount=3
set @intInactivityTimeout=15
set @intPasswordAge=90
set @intPasswordHistoryLength=3
set @intPasswordMinimalLength=5
set @intForcePasswordComplexity=0

select	top 1
			@idfSecurityConfiguration=tstSecurityConfiguration.idfSecurityConfiguration,
			@idfsSecurityLevel=tstSecurityConfiguration.idfsSecurityLevel,
			@intAccountLockTimeout=tstSecurityConfiguration.intAccountLockTimeout,
			@intAccountTryCount=tstSecurityConfiguration.intAccountTryCount,
			@intInactivityTimeout=tstSecurityConfiguration.intInactivityTimeout,
			@intPasswordAge=tstSecurityConfiguration.intPasswordAge,
			@intPasswordHistoryLength=tstSecurityConfiguration.intPasswordHistoryLength,
			@intPasswordMinimalLength=tstSecurityConfiguration.intPasswordMinimalLength,
			@intForcePasswordComplexity=tstSecurityConfiguration.intForcePasswordComplexity
from		tstSecurityConfiguration
left join	trtBaseReference [Level]
on			[Level].idfsBaseReference=tstSecurityConfiguration.idfsSecurityLevel
where		tstSecurityConfiguration.intRowStatus=0
order by	[Level].intOrder desc,tstSecurityConfiguration.idfSecurityConfiguration

insert into @ret
select
	@idfSecurityConfiguration,
	@idfsSecurityLevel,
	@intAccountLockTimeout,
	@intAccountTryCount,
	@intInactivityTimeout,
	@intPasswordAge,
	@intPasswordHistoryLength,
	@intPasswordMinimalLength,
	@intForcePasswordComplexity

	RETURN 
END

