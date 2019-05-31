-- =============================================
-- Author:		Steven Verner
-- Create date: 03.27.2019
-- Description:	Retrieves the current security configuration.
-- =============================================
CREATE PROCEDURE USP_SecurityConfiguration_Get 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP  1 
		 [SecurityPolicyConfigurationUID]
		,[MinPasswordLength]
		,[EnforcePasswordHistoryCount]
		,[MinPasswordAgeDays]
		,[ForceUppercaseFlag]
		,[ForceLowercaseFlag]
		,[ForceNumberUsageFlag]
		,[ForceSpecialCharactersFlag]
		,[AllowUseOfSpaceFlag]
		,[PreventSequentialCharacterFlag]
		,[PreventUsernameUsageFlag]
		,[LockoutThld]
		,[LockoutDurationMinutes]
		,[MaxSessionLength]
		,[SesnIdleTimeoutWarnThldMins]
		,[SesnIdleCloseoutThldMins]
		,[intRowStatus]
		,[rowguid]
		,[AuditCreateUser]
		,[AuditCreateDTM]
		,[AuditUpdateUser]
		,[AuditUpdateDTM]
		,[SourceSystemNameID]
		,[SourceSystemKeyValue]
	  FROM [dbo].[SecurityPolicyConfiguration]
	  ORDER BY SecurityPolicyConfigurationUID Desc
  
END
