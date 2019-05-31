

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetRuleParameterForAction 
(		
	@idfsRule Bigint
)	
AS
BEGIN	
	Set Nocount On;	
	
	Select 
		[idfParameterForAction]
		,[idfsRule]
		,[idfsRuleAction]      
		,[idfsParameter]
		,[idfsFormTemplate]	
	From [dbo].[ffParameterForAction]
	Where [idfsRule] = @idfsRule
				And [intRowStatus] = 0
   
End

