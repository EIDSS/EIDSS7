

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveSectionTemplate
(
	@idfsSection BigInt
	,@idfsFormTemplate BigInt
	,@LangID  Nvarchar(50) = null
)
AS
BEGIN
	Set Nocount On;
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);	
	
	-- удаляем специфические данные из языковых таблиц
	Delete from dbo.ffSectionDesignOption
	Where
		idfsSection = @idfsSection 
		And
		idfsFormTemplate = @idfsFormTemplate
		And
		idfsLanguage = @langid_int

	If (@LangID = 'en') Begin	                    	
	        -- удаляем все языковые настройки
	        Delete From dbo.ffSectionDesignOption
			Where
				idfsSection = @idfsSection
				And
				idfsFormTemplate = @idfsFormTemplate
				
	        --            
			Delete from dbo.ffSectionForTemplate
			Where
				idfsSection = @idfsSection 
				And
				idfsFormTemplate = @idfsFormTemplate
	end	
	
		
End

