

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveRuleParameterForAction
(
	@idfsRule Bigint
    ,@idfsParameter Bigint
)
AS
BEGIN
	Set Nocount On;	
	
	Delete from dbo.ffParameterForAction		
	Where 
		idfsRule = @idfsRule
		And
		idfsParameter = @idfsParameter	
		
End

