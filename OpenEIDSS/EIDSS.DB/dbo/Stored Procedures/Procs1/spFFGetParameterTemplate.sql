

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 14.09.09
-- Update: Gorodentseva: 10.02.2016
-- Description
/*
exec dbo.spFFGetParameterTemplate null, null, 'en'

*/
-- =============================================
CREATE PROCEDURE dbo.spFFGetParameterTemplate
(	
	@idfsParameter Bigint = Null
	,@idfsFormTemplate Bigint = Null
	,@LangID  Nvarchar(50) = Null
)	
AS
BEGIN	
	Set Nocount On;
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);	
	
	Select 
		PT.[idfsParameter]
      ,P.[idfsSection]
      ,P.[idfsFormType]
      ,P.[intHACode]
      ,PT.[idfsFormTemplate]
      ,PT.[idfsEditMode]
      ,P.[idfsEditor]
      ,P.[idfsParameterType]
      ,PDO.[intLeft]
      ,PDO.[intTop]
      ,PDO.[intWidth]
      ,PDO.[intHeight]
      ,PDO.[intScheme]
      ,PDO.[intLabelSize]
      ,PDO.[intOrder]
      ,isnull(B.[strDefault], '') as [DefaultName]
      ,isnull(B1.[strDefault], '') as [DefaultLongName]
      ,isnull(SNT.[strTextString], B.[strDefault]) AS [NationalName]
	  ,isnull(SNT1.[strTextString], B1.[strDefault]) AS [NationalLongName]
	  ,@LangID As [langid]
	  ,IsNull(PT.blnFreeze,0) As [blnFreeze]	  
	  ,Cast(Case When dbo.fnFFGetDesignLanguageForParameter(@LangID, PT.[idfsParameter], @idfsFormTemplate) = @langid_int Then 1 Else 0 End As Bit) As [blnIsRealStruct] 
	  ,P.idfsParameterCaption	
  From [dbo].[ffParameterForTemplate] PT
  Inner Join dbo.ffParameterDesignOption PDO On PT.idfsParameter = PDO.idfsParameter And PT.idfsFormTemplate = PDO.idfsFormTemplate And PDO.idfsLanguage = dbo.fnFFGetDesignLanguageForParameter(@LangID, PT.[idfsParameter], @idfsFormTemplate)  And PDO.[intRowStatus] = 0
  Inner Join dbo.ffParameter P On PT.idfsParameter = P.idfsParameter And P.[intRowStatus] = 0
  Inner Join dbo.trtBaseReference B  ON B.[idfsBaseReference] = P.idfsParameterCaption And B.[intRowStatus] = 0
  Inner Join dbo.trtBaseReference B1  On B1.[idfsBaseReference] = P.[idfsParameter] And B1.[intRowStatus] = 0
  Left Join dbo.trtStringNameTranslation SNT On SNT.[idfsBaseReference] = P.idfsParameterCaption And SNT.idfsLanguage = @langid_int And SNT.[intRowStatus] = 0
  Left Join dbo.trtStringNameTranslation SNT1 On (SNT1.[idfsBaseReference] = P.[idfsParameter] AND SNT1.[idfsLanguage] = @langid_int) And SNT1.[intRowStatus] = 0
  Where	
	(PT.[idfsFormTemplate] = @idfsFormTemplate OR @idfsFormTemplate Is Null)
	And	
	(PT.[idfsParameter] = @idfsParameter OR @idfsParameter Is Null)
	And
	PT.intRowStatus = 0	

	ORDER BY PDO.[intOrder]

End

