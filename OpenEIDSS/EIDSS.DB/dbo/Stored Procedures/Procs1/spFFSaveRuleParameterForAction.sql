

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFSaveRuleParameterForAction 
(		
	@idfParameterForAction Bigint Output
	,@idfsRule Bigint
    ,@idfsFormTemplate Bigint
	,@idfsParameter Bigint
    ,@idfsRuleAction Bigint
)	
AS
BEGIN	
	Set Nocount On;	
	
	-- ���� id < 0, ������, ��� ��������� id � ����� �������� ��� �� ���������
	If (@idfParameterForAction < 0) Exec dbo.[spsysGetNewID] @idfParameterForAction Output
	
	If Not Exists (Select Top 1 1 From dbo.ffParameterForAction Where [idfParameterForAction] = @idfParameterForAction) BEGIN
		 
		 Insert Into [dbo].[ffParameterForAction]
			   (
		   			[idfParameterForAction]
					,[idfsRule]
					,[idfsFormTemplate]
					,[idfsParameter]
					,[idfsRuleAction]
			   )
		 Values
			   (
			   		@idfParameterForAction
					,@idfsRule
					,@idfsFormTemplate
					,@idfsParameter
					,@idfsRuleAction
			   )
	End Else BEGIN
	         	Update [dbo].[ffParameterForAction]
				   Set 
						[idfsRuleAction] = @idfsRuleAction
						,[intRowStatus] = 0
					Where [idfParameterForAction] = @idfParameterForAction
	End
   
End

