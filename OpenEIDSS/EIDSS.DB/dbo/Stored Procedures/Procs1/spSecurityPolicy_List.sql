

/*
exec spSecurityPolicy_List 'en'
*/

CREATE PROCEDURE [dbo].[spSecurityPolicy_List]
	@LangID nvarchar(50)
AS
BEGIN
/*	select	*
	from	tstGlobalSiteOptions*/
/*
	Select Policies.*,Ref.name as Description
	from
	(
		select	'AccountLockTimeout' as strName,dbo.fnPolicyValue('AccountLockTimeout') as strValue
		union
		select	'AccountTryCount' as strName,dbo.fnPolicyValue('AccountTryCount') as strValue
		union
		select	'PasswordAge' as strName,dbo.fnPolicyValue('PasswordAge') as strValue
		union
		select	'PasswordHistoryLength' as strName,dbo.fnPolicyValue('PasswordHistoryLength') as strValue
		union
		select	'PasswordMinimalLength' as strName,dbo.fnPolicyValue('PasswordMinimalLength') as strValue
		union
		select	'InactivityTimeout' as strName,dbo.fnPolicyValue('InactivityTimeout') as strValue
		union
		select	'ForcePasswordComplexity' as strName,dbo.fnPolicyValue('ForcePasswordComplexity') as strValue
		union
		select	'PasswordComplexityExpression' as strName,dbo.fnPolicyValue('PasswordComplexityExpression') as strValue
		union
		select	'PasswordComplexityDescription' as strName,dbo.fnPolicyValue('PasswordComplexityDescription') as strValue
	)	Policies
	left join	fnReference(@LangID,19000120) Ref
	on			Policies.strValue=cast(Ref.idfsReference as nvarchar(200))
*/
	
	declare		@scid bigint

	select		@scid=idfSecurityConfiguration
	from		fnPolicyValue()

	select		PolicyList.*,
				[Level].name as SecurityLevel
				--Ref.name as [Description]
	from		fnPolicyValue() PolicyList
	left join	fnReference(@LangID,19000119) [Level]
	on			[Level].idfsReference=PolicyList.idfsSecurityLevel
	--left join	fnReference(@LangID,19000120) Ref
	--on			Ref.idfsReference=PolicyList.idfsSecurityConfigurationDescription
	--where		@cid=PolicyList.idfSecurityConfiguration

	select		tstSecurityConfigurationAlphabet.*
				--Ref.name as [Description]
	from		tstSecurityConfigurationAlphabet
	inner join	tstSecurityConfigurationAlphabetParticipation
	on			tstSecurityConfigurationAlphabetParticipation.intRowStatus=0 and
				tstSecurityConfigurationAlphabet.intRowStatus=0 and
				tstSecurityConfigurationAlphabetParticipation.idfSecurityConfiguration=@scid
	--left join	fnReference(@LangID,19000118) Ref
	--on			Ref.idfsReference=dbo.tstSecurityConfigurationAlphabet.idfsSecurityConfigurationAlphabet
END

