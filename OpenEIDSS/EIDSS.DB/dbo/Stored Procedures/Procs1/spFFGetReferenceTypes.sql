

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 29.09.09
-- Description:
-- =============================================
CREATE PROCEDURE dbo.spFFGetReferenceTypes
(
	@LangID Nvarchar(50) = Null	
)	
AS
BEGIN	
	SET NOCOUNT ON;

	If (@LangID Is Null) Set @LangID = 'en';

	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);

	Select 
			RT.idfsReferenceType
			,BR.strDefault As [DefaultName]
			,Isnull(SNT.strTextString, BR.strDefault) As [NationalName]
			,@LangID As [langid]	
	From dbo.trtReferenceType RT 
	Inner Join dbo.trtBaseReference BR On RT.idfsReferenceType = BR.idfsBaseReference
	Inner Join dbo.trtStringNameTranslation SNT On SNT.idfsBaseReference = RT.idfsReferenceType And SNT.intRowStatus = 0 And SNT.idfsLanguage = @langid_int
	--Where ((RT.intStandard & 1 > 0)  Or (BR.idfsBaseReference In (19000079, 19000074)))
	--			And RT.intRowStatus = 0
	Where RT.intRowStatus = 0
	Order By [NationalName]
End

