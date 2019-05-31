
CREATE PROCEDURE [dbo].[spAsChartSettingsPost]
(
	@idfView bigint
	,@LangID as nvarchar(50)
	,@blbChartLocalSettings image
)
AS
Begin
	Declare @langid_int Bigint
	Set @langid_int = dbo.fnGetLanguageCode(@LangID);

	if not exists(Select top 1 1 from [dbo].[tasView] where [idfView] = @idfView and [idfsLanguage] = @langid_int) begin
		Insert into [dbo].[tasView]([idfView],[idfsLanguage],[idflLayout],[blbChartLocalSettings])
			Values(@idfView, @langid_int, @idfView, @blbChartLocalSettings)
	end else begin
		Update [dbo].[tasView]
			Set [blbChartLocalSettings] = @blbChartLocalSettings
			where [idfView] = @idfView and [idfsLanguage] = @langid_int
	End
End

