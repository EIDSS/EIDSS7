



--##SUMMARY Deletes vector object.
--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 26.07.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spVector_Delete 
	@ID

*/




CREATE proc	[dbo].[spVector_Delete]
	@ID AS BIGINT --#PARAM @ID - vector ID
as

declare @idfLocation bigint
declare @idfObservation bigint

select @idfLocation = idfLocation
	,@idfObservation = idfObservation
from tlbVector
where idfVector = @ID

declare @sample_del bigint
declare Sample_Cursor Cursor local read_only forward_only for
	select		idfMaterial
	from		tlbMaterial
	where		tlbMaterial.idfVector=@ID
				and tlbMaterial.intRowStatus = 0
open Sample_Cursor
fetch next from Sample_Cursor into @sample_del
while @@FETCH_STATUS <>-1
begin
	exec spLabSample_Delete @sample_del
	fetch next from Sample_Cursor into @sample_del
end
close Sample_Cursor
deallocate Sample_Cursor


DELETE FROM  dbo.tlbVector WHERE idfVector = @ID

--delete  vector location record
exec spGeoLocation_Delete @idfLocation
exec spObservation_Delete @idfObservation
