

-- =============================================
-- Author:		Leonov E.N.
-- 
-- 
-- =============================================
CREATE PROCEDURE dbo.spFFGetParametersDeletedFromTemplate 
(	
	@idfObservation Bigint
	,@LangID Nvarchar(50)
)	
AS
BEGIN	
	Set Nocount On;
	
	Declare @idfsFormTemplate Bigint
	Select @idfsFormTemplate = idfsFormTemplate From dbo.tlbObservation Where idfObservation = @idfObservation
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);
	
    Select distinct 
			AP.idfsParameter
			, O.idfsFormTemplate
			, AP.idfObservation
			,B2.[strDefault] as [DefaultName]
			,B1.[strDefault] as [DefaultLongName]
			,IsNull(SNT2.[strTextString], B2.[strDefault]) AS [NationalName]
			,IsNull(SNT1.[strTextString], B1.[strDefault]) AS [NationalLongName]
			,P.idfsParameterType
			,P.intHACode
			, P.idfsEditor
			, PDO.intLeft
			, PDO.intTop
			, PDO.intWidth
			, PDO.intHeight
			, PDO.intLabelSize
			, PDO.intScheme
			, PDO.intOrder
			,@LangID As [langid]
			,P.idfsFormType
    From dbo.tlbActivityParameters AP 
		Left Join dbo.ffParameterForTemplate PT On PT.idfsParameter = AP.idfsParameter And PT.idfsFormTemplate = @idfsFormTemplate And PT.intRowStatus = 0
		Inner Join dbo.tlbObservation O On AP.idfObservation = O.idfObservation And O.intRowStatus = 0
		Inner Join dbo.ffParameter P On P.idfsParameter =AP.idfsParameter And P.intRowStatus = 0
		Inner Join dbo.ffParameterDesignOption PDO On (AP.idfsParameter = PDO.idfsParameter) And (PDO.idfsFormTemplate Is Null) And (PDO.idfsLanguage = dbo.fnFFGetDesignLanguageForParameter(@LangID, PT.[idfsParameter], @idfsFormTemplate)) And (PDO.intRowStatus = 0)
		Inner Join dbo.trtBaseReference B1  On B1.[idfsBaseReference] = P.[idfsParameter] And B1.[intRowStatus] = 0
		Left Join dbo.trtBaseReference B2  On B2.[idfsBaseReference] = P.[idfsParameterCaption] And B2.[intRowStatus] = 0
		Left Join dbo.trtStringNameTranslation SNT1 On (SNT1.[idfsBaseReference] = P.[idfsParameter] AND SNT1.[idfsLanguage] = @langid_int) And SNT1.[intRowStatus] = 0
		Left Join dbo.trtStringNameTranslation SNT2 On (SNT2.[idfsBaseReference] = P.[idfsParameterCaption] AND SNT2.[idfsLanguage] = @langid_int) And SNT2.[intRowStatus] = 0
   
	Where AP.intRowStatus = 0 
					And PT.idfsParameter Is Null
					And (AP.idfObservation = @idfObservation)
End

