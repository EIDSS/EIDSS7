
CREATE FUNCTION [dbo].[FN_VSSESSION_VECTORTYPENAMES_GET]
(
	@idfVectorSurveillanceSession	AS BIGINT--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID						AS NVARCHAR(50)--##PARAM @LangID - language ID
)
RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @strVectors  NVARCHAR(1000)

	SELECT @strVectors = isnull(@strVectors + '; ','') + ref_VectorType.[name]
	FROM (
		  SELECT 
		  DISTINCT	idfsVectorType
		  FROM		dbo.tlbVector
		  WHERE		idfVectorSurveillanceSession = @idfVectorSurveillanceSession and intRowStatus = 0 
		  
		  UNION

		  SELECT 
		  DISTINCT		idfsVectorType
		  FROM			dbo.tlbVectorSurveillanceSessionSummary Vss
		  INNER JOIN	dbo.trtVectorSubType Vst ON Vss.idfsVectorSubType = Vst.idfsVectorSubType And Vst.intRowStatus = 0
		  WHERE			idfVectorSurveillanceSession = @idfVectorSurveillanceSession and Vss.intRowStatus = 0
		) AS Vector
	INNER JOIN dbo.fnReference(@LangID, 19000140) ref_VectorType
	ON ref_VectorType.idfsReference = Vector.idfsVectorType

	RETURN @strVectors
END
