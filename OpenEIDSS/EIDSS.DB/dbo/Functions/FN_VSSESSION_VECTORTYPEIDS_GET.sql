
CREATE FUNCTION [dbo].[FN_VSSESSION_VECTORTYPEIDS_GET]
(
	@idfVectorSurveillanceSession AS BIGINT
)
RETURNS NVARCHAR(max)
AS
BEGIN
	DECLARE @summary  NVARCHAR(max)

	SELECT @summary = isnull(@summary + '; ','') + Convert(NVARCHAR(Max), Vector.idfsVectorType)
	FROM (
			  SELECT 
			  DISTINCT	idfsVectorType
			  FROM		dbo.tlbVector
			  WHERE		idfVectorSurveillanceSession = @idfVectorSurveillanceSession and intRowStatus = 0

			  UNION

			  SELECT 
			  DISTINCT		idfsVectorType
			  FROM			dbo.tlbVectorSurveillanceSessionSummary Vss
			  INNER JOIN	dbo.trtVectorSubType Vst ON Vss.idfsVectorSubType = Vst.idfsVectorSubType 
							AND Vst.intRowStatus = 0
			  WHERE			idfVectorSurveillanceSession = @idfVectorSurveillanceSession and Vss.intRowStatus = 0
		  ) AS Vector 

	RETURN @summary
END
