﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 14.09.09
-- Description:	Return list of Sections
-- =============================================
CREATE PROCEDURE dbo.spFFGetSectionTemplate
(	
	@idfsSection Bigint = NULL
	,@idfsFormTemplate Bigint = Null
	,@LangID  Nvarchar(50) = null
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	If (@LangID Is Null) Set @LangID = 'en';
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);
	
	Select
		ST.[idfsSection]
      ,S.[idfsParentSection]
      ,S.[idfsFormType]
      ,ST.[idfsFormTemplate]
      ,ST.[blnFreeze] As [blnFreeze]
      ,S.[blnFixedRowSet]
      ,SDO.[intLeft] As [intLeft]
      ,SDO.[intTop] As [intTop]
      ,SDO.[intWidth] As [intWidth]
      ,SDO.[intHeight] As [intHeight]
      ,SDO.[intCaptionHeight] As [intCaptionHeight]
      ,B.[strDefault] AS [DefaultName]
	  ,IsNull(SNT.[strTextString], B.[strDefault]) AS [NationalName]	
	  ,@LangID As [langid]
	  ,S.blnGrid
	  ,SDO.intOrder As [intOrder]
	  -- ��������� �� ���������� ��������� ������������� � ������������ ����� ��� �������� �� ���������
	  ,Cast(Case When dbo.fnFFGetDesignLanguageForParameter(@LangID, ST.[idfsSection], @idfsFormTemplate) = @langid_int Then 1 Else 0 End As Bit) As [blnIsRealStruct]  
  From [dbo].[ffSectionForTemplate] ST
  Left Join dbo.ffSectionDesignOption SDO On ST.idfsSection = SDO.idfsSection And ST.idfsFormTemplate = SDO.idfsFormTemplate And SDO.idfsLanguage = dbo.fnFFGetDesignLanguageForSection(@LangID, ST.[idfsSection], @idfsFormTemplate) And SDO.[intRowStatus] = 0
  Inner Join dbo.ffSection S On ST.idfsSection = S.idfsSection  And S.[intRowStatus] = 0
  Inner Join dbo.trtBaseReference B  ON B.[idfsBaseReference] = S.[idfsSection] And B.[intRowStatus] = 0
  Left Join dbo.trtStringNameTranslation SNT ON (SNT.[idfsBaseReference] = S.[idfsSection] AND SNT.idfsLanguage = @langid_int) And SNT.[intRowStatus] = 0
  Where
	((ST.[idfsFormTemplate] = @idfsFormTemplate ) Or (@idfsFormTemplate Is Null))
	And	
	((ST.[idfsSection] = @idfsSection Or @idfsSection Is Null))
	And	(ST.[intRowStatus] = 0)

	ORDER BY [NationalName]
End

