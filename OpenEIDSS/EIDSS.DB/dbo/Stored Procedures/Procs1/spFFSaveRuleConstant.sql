

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFSaveRuleConstant 
(	
	@idfRuleConstant Bigint Output
	,@idfsRule Bigint	
	,@varConstant Sql_variant
)	
AS
BEGIN	
	Set Nocount On;	
	
	-- ���� id < 0, ������, ��� ��������� id � ����� �������� ��� �� ���������
	If (@idfRuleConstant < 0) Exec dbo.[spsysGetNewID] @idfRuleConstant Output
	If Not Exists (Select Top 1 1 From dbo.ffRuleConstant Where [idfRuleConstant] = @idfRuleConstant) BEGIN
		 Insert Into [dbo].[ffRuleConstant]
			   (
			   		[idfRuleConstant]
		   			,[idfsRule]					
					,[varConstant]
			   )
		 Values
			   (
			   		@idfRuleConstant
			   		,@idfsRule					
					,@varConstant		   
			   )
	End Else BEGIN
	         	Update [dbo].[ffRuleConstant]
				   Set 						
						[varConstant] = @varConstant
						,[intRowStatus] = 0
					Where [idfRuleConstant] = @idfRuleConstant
	End
   
End

