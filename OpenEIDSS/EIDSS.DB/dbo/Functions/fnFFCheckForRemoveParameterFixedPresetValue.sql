

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================

--##REMARKS Updated 30.05.2013 by Romasheva S.

create Function dbo.fnFFCheckForRemoveParameterFixedPresetValue
(
	@idfsParameterFixedPresetValue BigInt
)
RETURNS @ResultTable Table
(
		[ErrorMessage] nvarchar(400)	COLLATE database_default
)
AS
BEGIN
	
	declare	@ErrorMessage nvarchar(400)
		
	-- должны быть удалены все зависимые записи
	If Exists(Select Top 1 1 From dbo.tlbActivityParameters Where varValue = @idfsParameterFixedPresetValue	And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterFixedPresetValueRemove_Has_tlbActivityParameters';
	--If Exists(Select Top 1 1 From dbo.tlbAggrMatrixVersion Where varValue = @idfsParameterFixedPresetValue	And intRowStatus = 0) Set  @ErrorMessage	= 'ParameterFixedPresetValueRemove_Has_tlbAggrMatrixVersion';
	
	Insert into @ResultTable(ErrorMessage) Values (@ErrorMessage);	
	Return;
End

