

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetRuleFunctions 
(	
	@count Int = Null
	,@LangID  Nvarchar(50) = Null
)	
AS
BEGIN	
	Set Nocount On;	
	
	If (@count = -1) Set @count = Null;
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);
	
	Select 
		[idfsRuleFunction]	
		,[strMask]
		,IsNull(SNT.strTextString, [strMask]) As [strMaskNational]
		,[intNumberOfParameters]
		,0 as [intRowStatus]
	From dbo.ffRuleFunction RF
	Inner Join dbo.trtStringNameTranslation SNT On RF.idfsRuleFunction = SNT.idfsBaseReference And SNT.idfsLanguage = @langid_int
	Where ([intNumberOfParameters] = @count Or @count Is Null)
				And SNT.[intRowStatus] = 0
   
End

