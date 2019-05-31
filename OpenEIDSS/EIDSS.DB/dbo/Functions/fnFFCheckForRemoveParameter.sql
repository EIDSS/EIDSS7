

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##REMARKS Updated 30.05.2013 by Romasheva S.


create Function [dbo].[fnFFCheckForRemoveParameter]
(
	@idfsParameter BigInt	
)
RETURNS @ResultTable Table
(
		[ErrorMessage] nvarchar(400)	COLLATE database_default
)
AS
BEGIN
	
	declare	@ErrorMessage nvarchar(400)
		

	--If Exists(Select Top 1 1 From dbo.ffParameterDesignOption Where idfsParameter = @idfsParameter) Exec dbo.spThrowException 'ParameterRemove_Has_ffParameterDesignOption_Rows';
	If Exists(Select Top 1 1 From dbo.tasQuerySearchField Where idfsParameter = @idfsParameter) Set  @ErrorMessage	=  'ParameterRemove_Has_tasQuerySearchField_Rows';
	If Exists(Select Top 1 1 From dbo.ffParameterForTemplate Where idfsParameter = @idfsParameter And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterRemove_Has_ffParameterForTemplate_Rows';
	If Exists(Select Top 1 1 From dbo.tlbActivityParameters Where idfsParameter = @idfsParameter And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterRemove_Has_tlbActivityParameters_Rows';
	--If Exists(Select Top 1 1 From dbo.tlbAggrMatrixVersion Where idfsParameter = @idfsParameter And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterRemove_Has_tlbAggrMatrixVersion_Rows';
	If Exists(Select Top 1 1 From dbo.ffParameterForFunction Where idfsParameter = @idfsParameter And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterRemove_ParameterForFunction';
	
	
	Insert into @ResultTable(ErrorMessage) Values (@ErrorMessage);	
	Return;
End

