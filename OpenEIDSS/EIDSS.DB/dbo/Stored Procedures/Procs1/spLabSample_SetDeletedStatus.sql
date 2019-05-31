

CREATE PROCEDURE [dbo].[spLabSample_SetDeletedStatus]
	@idfMaterial bigint
AS
	UPDATE tlbMaterial
	SET idfsSampleStatus = 10015008
	WHERE idfMaterial = @idfMaterial
RETURN 0

