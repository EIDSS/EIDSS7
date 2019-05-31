

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spFFRemoveParameterTemplate
(
	@idfsParameter Bigint
	,@idfsFormTemplate Bigint
	,@LangID  Nvarchar(50) = null
)
AS
BEGIN
	Set Nocount On;
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);
	
	-- удаляем специфические данные из языковых таблиц
	Delete from dbo.ffParameterDesignOption
	Where
		idfsParameter = @idfsParameter 
		And
		idfsFormTemplate = @idfsFormTemplate
		And
		idfsLanguage = @langid_int
		
	If (@LangID = 'en') Begin	                    	
	        -- удаляем все языковые настройки
	        Delete from dbo.ffParameterDesignOption
			Where
				idfsParameter = @idfsParameter 
				And
				idfsFormTemplate = @idfsFormTemplate
	        --
			Delete from dbo.ffParameterForTemplate
			Where
				idfsParameter = @idfsParameter 
				And
				idfsFormTemplate = @idfsFormTemplate
	end	
End

