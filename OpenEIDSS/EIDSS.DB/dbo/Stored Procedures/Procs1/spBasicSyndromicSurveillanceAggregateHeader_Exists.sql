
CREATE PROCEDURE [dbo].[spBasicSyndromicSurveillanceAggregateHeader_Exists](
	@idfAggregateHeader AS bigint
	,@intWeek AS int
	,@intYear AS int
	,@idfsSite AS bigint
)
AS
Begin
if exists (
	Select *
	From [dbo].[tlbBasicSyndromicSurveillanceAggregateHeader]
	Where
	idfAggregateHeader <> @idfAggregateHeader 
	and intRowStatus = 0 
	and intWeek = @intWeek
	and intYear = @intYear
	and idfsSite = @idfsSite
	)
	return 1
return 0
end
