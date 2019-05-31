

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetRuleConstant 
(	
	@idfsRule Bigint
)	
AS
BEGIN	
	Set Nocount On;	
	
	Select 
		[idfRuleConstant]
		,[idfsRule]		
		,[varConstant]
	From [dbo].[ffRuleConstant] 
	Where [idfsRule] = @idfsRule
				 And [intRowStatus] = 0
   
End

