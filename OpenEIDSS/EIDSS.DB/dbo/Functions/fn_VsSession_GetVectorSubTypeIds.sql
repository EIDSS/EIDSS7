
CREATE FUNCTION [dbo].[fn_VsSession_GetVectorSubTypeIds]
(
	@idfVectorSurveillanceSession as bigint
)
RETURNS nvarchar(max)
as
Begin
	declare @summary  nvarchar(max)

	select @summary = isnull(@summary + '; ','') + Convert(Nvarchar(Max), Vector.idfsVectorSubType)
	from (
	  select distinct idfsVectorSubType
	  from dbo.tlbVector
	  where idfVectorSurveillanceSession = @idfVectorSurveillanceSession and intRowStatus = 0
	  union
	  select distinct idfsVectorSubType
	  from dbo.tlbVectorSurveillanceSessionSummary
	  where idfVectorSurveillanceSession = @idfVectorSurveillanceSession and intRowStatus = 0
	  ) as Vector 

	return @summary;
End
