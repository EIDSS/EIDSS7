

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFSaveRuleParameterForFunction 
(	
	 @idfParameterForFunction Bigint = Output
     ,@idfsParameter Bigint
     ,@idfsFormTemplate Bigint
     ,@idfsRule Bigint
     ,@intOrder int         
)	
AS
BEGIN	
	Set Nocount On;

	-- ���� id < 0, ������, ��� ��������� id � ����� �������� ��� �� ���������
	If (@idfParameterForFunction < 0) Exec dbo.[spsysGetNewID] @idfParameterForFunction Output
	If Not Exists (Select Top 1 1 From dbo.ffParameterForFunction Where [idfParameterForFunction] = @idfParameterForFunction) BEGIN
		 
		 Insert Into [dbo].[ffParameterForFunction]
			   (
		   			[idfParameterForFunction]
					,[idfsParameter]
					,[idfsFormTemplate]
					,[idfsRule]
					,[intOrder]
			   )
		 Values
			   (
			   		@idfParameterForFunction
					,@idfsParameter
					,@idfsFormTemplate
					,@idfsRule
					,@intOrder		   
			   )
	End Else BEGIN
	         	Update [dbo].[ffParameterForFunction]
				   Set 
						[intOrder] = @intOrder
						,[intRowStatus] = 0
					Where [idfParameterForFunction] = @idfParameterForFunction
	End
   
End

