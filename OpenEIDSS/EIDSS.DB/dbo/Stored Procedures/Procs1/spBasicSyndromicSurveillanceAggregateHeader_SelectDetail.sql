
Create  PROCEDURE [dbo].[spBasicSyndromicSurveillanceAggregateHeader_SelectDetail](
	@idfAggregateHeader AS bigint
	,@LangID AS nvarchar(50)
)
AS
Begin
	Declare @dt Datetime
	Set Dateformat dmy
	Set @dt = '18990101'

	Select
	[idfAggregateHeader]
      ,[strFormID]
      ,[datDateEntered]
      ,Nullif(datDateLastSaved, @dt) [datDateLastSaved]
      ,[idfEnteredBy]
      ,[idfsSite]
      ,[intYear]
      ,[intWeek]
      ,[datStartDate]
      ,[datFinishDate]
      ,[datModificationForArchiveDate] 
	
	From [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
	Where
	idfAggregateHeader = @idfAggregateHeader and intRowStatus = 0
end
