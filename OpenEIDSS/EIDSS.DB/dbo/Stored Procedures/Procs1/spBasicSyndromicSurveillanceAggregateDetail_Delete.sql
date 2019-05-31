
Create proc	[dbo].[spBasicSyndromicSurveillanceAggregateDetail_Delete]
	@ID AS BIGINT --#PARAM @ID - vector ID
as
DELETE FROM  dbo.[tlbBasicSyndromicSurveillanceAggregateDetail] WHERE idfAggregateDetail = @ID
