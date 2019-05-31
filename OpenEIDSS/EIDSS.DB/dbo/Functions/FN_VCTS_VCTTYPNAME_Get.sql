
--*************************************************************
-- Name 				: FN_VCTS_VCTTYPNAME_Get
-- Description			: Vector Surveillance Session - Vector Type Name
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- 
--*************************************************************

CREATE FUNCTION	[dbo].[FN_VCTS_VCTTYPNAME_Get]
(
	@idfVectorSurveillanceSession	AS BIGINT		--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID						AS NVARCHAR(50)	--##PARAM @LangID - language ID
)
RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @strVectors NVARCHAR(1000)

	SELECT 	@strVectors = ISNULL(@strVectors + '; ','') + ref_VectorType.[name]
	FROM (
			SELECT 
			DISTINCT idfsVectorType
			FROM	dbo.tlbVector
			WHERE	idfVectorSurveillanceSession = @idfVectorSurveillanceSession 
			AND		intRowStatus = 0 

			UNION

			SELECT 
			DISTINCT idfsVectorType
			FROM 	dbo.tlbVectorSurveillanceSessionSummary
			INNER JOIN	dbo.trtVectorSubType ON 
						tlbVectorSurveillanceSessionSummary.idfsVectorSubType = trtVectorSubType.idfsVectorSubType 
			AND		trtVectorSubType.intRowStatus = 0
			WHERE 	idfVectorSurveillanceSession = @idfVectorSurveillanceSession 
			AND 	tlbVectorSurveillanceSessionSummary.intRowStatus = 0
		) AS Vector
	 INNER JOIN dbo.fnReference(@LangID, 19000140) ref_VectorType ON 
				ref_VectorType.idfsReference = Vector.idfsVectorType

	RETURN @strVectors
END

