
CREATE FUNCTION [dbo].[fn_VsSession_GetVectorTypeIds]
(
	@idfVectorSurveillanceSession as bigint
)
RETURNS nvarchar(max)
as
Begin
	declare @summary  nvarchar(max)

	select @summary = isnull(@summary + '; ','') + Convert(Nvarchar(Max), Vector.idfsVectorType)
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

	return @summary;
End
