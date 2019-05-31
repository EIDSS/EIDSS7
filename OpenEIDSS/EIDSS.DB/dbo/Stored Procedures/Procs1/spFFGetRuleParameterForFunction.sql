

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetRuleParameterForFunction 
(		
	@LangID nvarchar(50) = Null
	,@idfRule Bigint
)	
AS
BEGIN	
	Set Nocount On;
	
	if (@LangID Is Null) set @LangID = 'en';
	
	declare @langid_int bigint
	
	set @langid_int = dbo.fnGetLanguageCode(@LangID);	
	
	Select 
		PF.[idfParameterForFunction]
		,PF.[idfsParameter]
		,PF.[idfsFormTemplate]
		,PF.[idfsRule]
		,PF.[intOrder]
		,PF.[rowguid]
		,P.[idfsParameterType]
		,B.[strDefault] as [DefaultName]
		,isnull(SNT.[strTextString], B.[strDefault]) AS [NationalName]
	From [dbo].[ffParameterForFunction] PF
	Inner Join [dbo].[ffParameter] P On PF.idfsParameter = P.idfsParameter And P.[intRowStatus] = 0
	Left Join dbo.trtBaseReference B  On B.[idfsBaseReference] = P.[idfsParameterCaption] And B.[intRowStatus] = 0
	Left Join dbo.trtStringNameTranslation SNT On (SNT.[idfsBaseReference] = P.[idfsParameterCaption] AND SNT.[idfsLanguage] = @langid_int) And SNT.[intRowStatus] = 0
	Where PF.[idfsRule] = @idfRule And PF.[intRowStatus] = 0   
End

