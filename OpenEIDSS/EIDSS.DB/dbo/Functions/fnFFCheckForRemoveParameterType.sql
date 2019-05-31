

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Function dbo.fnFFCheckForRemoveParameterType
(
	@idfsParameterType BigInt	
)
RETURNS @ResultTable Table
(
		[ErrorMessage] nvarchar(400)	COLLATE database_default
)
AS
BEGIN
	
	declare	@ErrorMessage nvarchar(400)
		
	-- должны быть удалены все зависимые записи
	If Exists(Select Top 1 1 From dbo.ffParameter Where idfsParameterType = @idfsParameterType And intRowStatus = 0) Set  @ErrorMessage	=  'ParameterTypeRemove_Has_ffParameter';
	If Exists(Select Top 1 1 From dbo.tlbActivityParameters Where varValue In
					(
						Select idfsParameterFixedPresetValue From dbo.ffParameterFixedPresetValue Where idfsParameterType = @idfsParameterType And intRowStatus = 0
					)
					And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterTypeRemove_Has_tlbActivityParameters';
	
	Insert into @ResultTable(ErrorMessage) Values (@ErrorMessage);	
	Return;
End

