

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 14.09.09
-- Description:	Return list of Parameters

--##REMARKS Update date: 30.05.2013 by Romasheva S.
-- =============================================

/*
exec dbo.spFFGetParameters 'en', null, 10034012
exec dbo.spFFGetParameters 'en', null, 10034023
exec dbo.spFFGetParameters 'en', null, 10034024
exec dbo.spFFGetParameters 'en', null, 10034021
exec dbo.spFFGetParameters 'en', null, 10034022
exec EIDSS_version6_actual.dbo.spFFGetParameters 'en', null, 10034022

*/
create procedure dbo.spFFGetParameters 
(
	@LangID nvarchar(50) = Null
	,@idfsSection bigint = Null
	,@idfsFormType bigint = Null
)	
as
begin	
	set nocount on;

	if (@LangID Is Null) set @LangID = 'en';
	
	declare @langid_int bigint
	
	set @langid_int = dbo.fnGetLanguageCode(@LangID);	

    select 
		P.[idfsParameter]
      ,P.[idfsSection] -- null
      ,P.[idfsFormType] 
      ,FPRO.[intScheme] -- 0
      ,P.[idfsParameterType] -- string const
      ,isnull(FR1.[name],FR1.[strDefault]) As [ParameterTypeName]  --   
      ,P.[idfsEditor] --,P.[intControlType] -- text box
      ,P.[idfsParameterCaption] -- null
      ,P.[intOrder] -- intorder from stub
      ,isnull(P.[strNote], '') as [strNote] -- null
      ,isnull(P.[intHACode], -1) As [intHACode] -- null
      ,FPRO.[intLabelSize] -- 0
      ,FPRO.[intTop] -- 0
      ,FPRO.[intLeft]-- 0
      ,FPRO.[intWidth] -- to column new field
      ,FPRO.[intHeight] -- 0
      ,FPRO.[idfsFormTemplate] -- null    
      ,P.[intRowStatus] --0
      ,isnull(B2.[strDefault], '') as [DefaultName]
      ,isnull(B1.[strDefault], '') as [DefaultLongName]
      ,isnull(SNT2.[strTextString], B2.[strDefault]) AS [NationalName]
	  ,isnull(SNT1.[strTextString], B1.[strDefault]) AS [NationalLongName]
	  ,@LangID As [langid]
	  ,1 as [IsRealParameter]
  from [dbo].[ffParameter] P
  Inner Join dbo.trtBaseReference B1  On B1.[idfsBaseReference] = P.[idfsParameter] And B1.[intRowStatus] = 0
  Inner Join dbo.ffParameterDesignOption FPRO On P.[idfsParameter] = FPRO.[idfsParameter] And FPRO.idfsLanguage = dbo.fnFFGetDesignLanguageForParameter(@LangID, P.[idfsParameter], null) And FPRO.[intRowStatus] = 0
  Left Join dbo.trtBaseReference B2  On B2.[idfsBaseReference] = P.[idfsParameterCaption] And B2.[intRowStatus] = 0
  Left Join dbo.fnReference(@LangID, 19000071 /*'rftParameterType'*/) FR1 On FR1.[idfsReference] = P.[idfsParameterType]
  Left Join dbo.trtStringNameTranslation SNT1 On (SNT1.[idfsBaseReference] = P.[idfsParameter] AND SNT1.[idfsLanguage] = @langid_int) And SNT1.[intRowStatus] = 0
  Left Join dbo.trtStringNameTranslation SNT2 On (SNT2.[idfsBaseReference] = P.[idfsParameterCaption] AND SNT2.[idfsLanguage] = @langid_int) And SNT2.[intRowStatus] = 0
  where
	(P.idfsSection = @idfsSection OR @idfsSection Is Null)
	and	(P.idfsFormType = @idfsFormType OR @idfsFormType Is Null)
	and (FPRO.idfsFormTemplate Is Null)	
	and (P.intRowStatus = 0)
	
	union all

	select
		mc.idfsMatrixColumn					as idfsParameter
      ,null									as idfsSection -- null
      ,mt.idfsFormType						as idfsFormType 
      ,0									as intScheme -- 0
      ,mc.idfsParameterType					as idfsParameterType -- string const
      ,ref_pt.[name]						as ParameterTypeName     
      ,mc.idfsEditor						as idfsEditor -- text box
      ,null									as idfsParameterCaption -- null
      ,mc.intColumnOrder					as intOrder -- intorder from stub
      ,null									as strNote -- null
      ,0									as intHACode -- null
      ,0									as intLabelSize -- 0
      ,0									as intTop -- 0
      ,0									as intLeft -- 0
      ,mc.intWidth							as intWidth -- 
      ,0									as intHeight -- 0
      ,null									as idfsFormTemplate -- null    
      ,0									as intRowStatus --0
      ,isnull(ref_mc.strDefault, '')					as DefaultName
      ,isnull(ref_mc.strDefault	, '')				as DefaultLongName
      ,isnull(ref_mc.[name], '')					as NationalName
	  ,isnull(ref_mc.[name], '')					as NationalLongName
	  ,@LangID								as [langid]
	  ,0 as [IsRealParameter]
	  
	from trtMatrixColumn mc
		inner join trtMatrixType mt
		on mt.idfsMatrixType = mc.idfsMatrixType
		and mt.intRowStatus = 0
	left join dbo.fnReference(@LangID, 19000071 /*rftParameterType*/) ref_pt 
		on ref_pt.[idfsReference] = mc.idfsParameterType
	left join dbo.fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_mc
		on ref_mc.[idfsReference] = mc.idfsMatrixColumn		
	where	mc.intRowStatus = 0	
			and mt.idfsFormType = @idfsFormType
			and @idfsSection is null

    order by [NationalName], P.[intOrder]-- 21, 9 

end

