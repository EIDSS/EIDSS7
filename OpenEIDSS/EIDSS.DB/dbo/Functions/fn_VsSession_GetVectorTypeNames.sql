
CREATE FUNCTION [dbo].[fn_VsSession_GetVectorTypeNames]
(
	@idfVectorSurveillanceSession AS bigint--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
RETURNS nvarchar(1000)
AS
BEGIN
	declare @strVectors  nvarchar(1000)

	select @strVectors = isnull(@strVectors + '; ','') + ref_VectorType.[name]
	from (
	  select distinct idfsVectorType
	  from dbo.tlbVector
	  where idfVectorSurveillanceSession = @idfVectorSurveillanceSession and intRowStatus = 0 
	  union
	  select distinct idfsVectorType
	  from dbo.tlbVectorSurveillanceSessionSummary Vss
	  Inner Join dbo.trtVectorSubType Vst On Vss.idfsVectorSubType = Vst.idfsVectorSubType And Vst.intRowStatus = 0
	  where idfVectorSurveillanceSession = @idfVectorSurveillanceSession and Vss.intRowStatus = 0
	  ) as Vector
	  inner join dbo.fnReference(@LangID, 19000140) ref_VectorType
	  on ref_VectorType.idfsReference = Vector.idfsVectorType

	RETURN @strVectors
END
