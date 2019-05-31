
CREATE PROCEDURE [dbo].[spAsChartSettingsSelectDetail]
(
	@idfView bigint
	,@LangID as nvarchar(50)
)
AS
Begin
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);

	Select [blbChartLocalSettings]
	from [dbo].[tasView]
	Where [idfView] = @idfView
		and [idfsLanguage] = @langid_int
End

