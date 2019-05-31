

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveSectionTemplateRecursive
(
	@idfsSection BigInt
	,@idfsFormTemplate BigInt
	,@LangID  Nvarchar(50) = null
)
AS
BEGIN
	Set Nocount On;
	
	Declare @idfsParentSection Bigint
	Select @idfsParentSection = [idfsParentSection] From dbo.ffSection Where idfsSection = @idfsSection
	Exec dbo.spFFRemoveSectionTemplate @idfsSection,@idfsFormTemplate,@LangID
	If (@idfsParentSection Is Not null) Exec dbo.spFFRemoveSectionTemplate @idfsParentSection,@idfsFormTemplate,@LangID
End

