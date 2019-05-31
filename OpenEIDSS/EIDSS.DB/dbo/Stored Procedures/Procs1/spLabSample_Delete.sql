

CREATE PROCEDURE [dbo].[spLabSample_Delete] 
	@idfMaterial bigint
AS
BEGIN

declare @idfTest_del bigint
declare Test_Cursor Cursor local read_only forward_only for
	select		idfTesting
	from		tlbTesting
	where		idfMaterial = @idfMaterial
				and intRowStatus = 0
open Test_Cursor
fetch next from Test_Cursor into @idfTest_del
while @@FETCH_STATUS <>-1
begin
	exec spLabTest_Delete @idfTest_del
	fetch next from Test_Cursor into @idfTest_del
end
close Test_Cursor
deallocate Test_Cursor

delete from tlbPensideTest where idfMaterial = @idfMaterial


declare	@tlbTrnasferOut_del		table (idfTransferOut bigint not null primary key)
insert into @tlbTrnasferOut_del
(
idfTransferOut
)
select distinct tlbTransferOUT.idfTransferOut 
from tlbTransferOUT
inner join tlbTransferOutMaterial ON
	tlbTransferOUT.idfTransferOut = tlbTransferOutMaterial.idfTransferOut
where tlbTransferOutMaterial.idfMaterial = @idfMaterial
and tlbTransferOUT.intRowStatus = 0


delete from tlbTransferOutMaterial
where idfMaterial = @idfMaterial
and intRowStatus = 0

delete from tlbTransferOUT
where idfTransferOut in (select idfTransferOut from @tlbTrnasferOut_del)

delete	tlbMaterial
where	idfMaterial=@idfMaterial

END


