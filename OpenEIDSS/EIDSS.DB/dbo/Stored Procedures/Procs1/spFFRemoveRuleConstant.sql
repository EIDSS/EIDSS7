

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveRuleConstant
(
	@idfRuleConstant Bigint
)
AS
BEGIN
	Set Nocount On;	
	
	Delete from dbo.ffRuleConstant	
	Where 
		[idfRuleConstant] = @idfRuleConstant
		
END

