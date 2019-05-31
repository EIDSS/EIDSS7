
Create proc	[dbo].[spBasicSyndromicSurveillance_Delete]
	@ID AS BIGINT --#PARAM @ID - vector ID
as
DECLARE @idfHuman bigint
SELECT @idfHuman = idfHuman FROM  dbo.tlbBasicSyndromicSurveillance WHERE idfBasicSyndromicSurveillance = @ID
DELETE FROM  dbo.tflBasicSyndromicSurveillanceFiltered WHERE idfBasicSyndromicSurveillance = @ID
DELETE FROM  dbo.tlbBasicSyndromicSurveillance WHERE idfBasicSyndromicSurveillance = @ID
EXEC spPatient_Delete @idfHuman
