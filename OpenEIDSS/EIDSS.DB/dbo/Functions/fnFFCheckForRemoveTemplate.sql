

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Function dbo.fnFFCheckForRemoveTemplate
(
	@idfsFormTemplate BigInt	
)
RETURNS @ResultTable Table
(
		[ErrorMessage] nvarchar(400)	COLLATE database_default
)
AS
BEGIN
	
	declare	@ErrorMessage nvarchar(400)
		
	-- если на шаблон завязаны какие-то данные, то удалять шаблон нельзя
	If Exists(Select Top 1 1 From dbo.fnFFCheckForTemplateHasObservations(@idfsFormTemplate)) Set  @ErrorMessage = 'TemplateRemove_Has_Observation'
		
	Insert into @ResultTable(ErrorMessage) Values (@ErrorMessage);	
	Return;
End

