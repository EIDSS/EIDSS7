

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Function dbo.fnFFCheckForRemoveSection
(
	@idfsSection BigInt	
)
RETURNS @ResultTable Table
(
		[ErrorMessage] nvarchar(400)	COLLATE database_default
)
AS
BEGIN
	
	declare	@ErrorMessage nvarchar(400)
		
	-- должны быть удалены все зависимые записи
	If Exists(Select Top 1 1 From dbo.ffDecorElement Where idfsSection = @idfsSection And intRowStatus = 0) Set  @ErrorMessage	= 'SectionRemove_Has_ffDecorElement_Rows';
	If Exists(Select Top 1 1 From dbo.ffParameter Where idfsSection = @idfsSection And intRowStatus = 0) Set  @ErrorMessage	= 'SectionRemove_Has_ffParameter_Rows';
	If Exists(Select Top 1 1 From dbo.ffSection Where idfsParentSection = @idfsSection And intRowStatus = 0) Set  @ErrorMessage	= 'SectionRemove_Has_ffSection_ParentSection_Rows';
	--If Exists(Select Top 1 1 From dbo.ffSectionDesignOption Where idfsSection = @idfsSection) Exec dbo.spThrowException 'SectionRemove_Has_ffSectionDesignOption_Rows';
	If Exists(Select Top 1 1 From dbo.ffSectionForTemplate Where idfsSection = @idfsSection And intRowStatus = 0) Set  @ErrorMessage	= 'SectionRemove_Has_ffSectionForTemplate_Rows';
	
	Insert into @ResultTable(ErrorMessage) Values (@ErrorMessage);	
	Return;
End

