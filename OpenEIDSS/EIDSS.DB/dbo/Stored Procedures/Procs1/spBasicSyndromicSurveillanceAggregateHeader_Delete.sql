
Create proc	[dbo].[spBasicSyndromicSurveillanceAggregateHeader_Delete]
	@ID AS BIGINT --#PARAM @ID - vector ID
as
DELETE FROM  dbo.[tlbBasicSyndromicSurveillanceAggregateDetail] WHERE idfAggregateHeader = @ID

DELETE FROM  dbo.[tflBasicSyndromicSurveillanceAggregateHeaderFiltered] WHERE idfAggregateHeader = @ID
DELETE FROM  dbo.[tlbBasicSyndromicSurveillanceAggregateHeader] WHERE idfAggregateHeader = @ID

