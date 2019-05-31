
--*************************************************************
-- Name 				: FN_VCTS_VCTTYPID_Get
-- Description			: Vector Surveillance Session - Vector Type ID
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- select * from FN_VCTS_VCTTYPID_Get(@idfVectorSurveillanceSession)
--*************************************************************
CREATE FUNCTION [dbo].[FN_VCTS_VCTTYPID_Get]
(
	@idfVectorSurveillanceSession as BIGINT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @summary NVARCHAR(MAX)

	SELECT @summary = ISNULL(@summary + '; ','') + CONVERT(NVARCHAR(MAX), Vector.idfsVectorType)
	FROM (
			SELECT 
			DISTINCT	idfsVectorType
			FROM		dbo.tlbVector
			WHERE		idfVectorSurveillanceSession = @idfVectorSurveillanceSession 
			AND 		intRowStatus = 0

			UNION

			SELECT 
			DISTINCT 	idfsVectorType
			FROM 		dbo.tlbVectorSurveillanceSessionSummary
			INNER JOIN	dbo.trtVectorSubType On 
						tlbVectorSurveillanceSessionSummary.idfsVectorSubType = trtVectorSubType.idfsVectorSubType 	AND trtVectorSubType.intRowStatus = 0
			WHERE 		idfVectorSurveillanceSession = @idfVectorSurveillanceSession 
			AND 		tlbVectorSurveillanceSessionSummary.intRowStatus = 0
		) AS Vector 

		RETURN @summary;
END
