

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetLines
(
	@LangID Nvarchar(50) = Null
	,@idfsFormTemplate Bigint = Null	 	
)	
AS
BEGIN	
	Set Nocount On;

	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);

    Select 
		DE.[idfDecorElement]
		,DE.[idfsDecorElementType]
		,@LangID As [langid]
		,DE.[idfsFormTemplate]
		,DE.[idfsSection]
		,DEL.[intLeft]
		,DEL.[intTop]
		,DEL.[intWidth]
		,DEL.[intHeight]		
		,DEL.[intColor]
		,DEL.[blnOrientation]
	From [dbo].[ffDecorElement] DE   
	Inner Join [dbo].[ffDecorElementLine] DEL ON DE.[idfDecorElement] = DEL.[idfDecorElement]  And DEL.[intRowStatus] = 0
    Where
	(DE.[idfsFormTemplate] = @idfsFormTemplate  Or @idfsFormTemplate Is null)
	And
	(DE.[idfsLanguage] = @langid_int Or @langid_int Is Null)
	 And DE.[intRowStatus] = 0
End

