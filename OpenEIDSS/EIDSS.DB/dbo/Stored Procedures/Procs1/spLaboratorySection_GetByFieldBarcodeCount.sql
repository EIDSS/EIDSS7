


create PROCEDURE dbo.spLaboratorySection_GetByFieldBarcodeCount
	@strFieldBarcode AS NVARCHAR(50),  --##PARAM @strFieldBarcode
	@idfSendToOffice BIGINT
as

Declare @idfMaterial bigint
Declare @rowCount int

select top 2 @idfMaterial = idfMaterial
from tlbMaterial
where
	tlbMaterial.intRowStatus = 0
	and tlbMaterial.strFieldBarcode = @strFieldBarcode
	and isnull(tlbMaterial.idfSendToOffice,0) = isnull(nullif(@idfSendToOffice,0), isnull(tlbMaterial.idfSendToOffice,0))
	and isnull(tlbMaterial.idfsSampleStatus,0) = 0 -- not accessioned
	and isnull(tlbMaterial.idfsAccessionCondition,0) = 0 -- not accessioned

select @rowCount = @@ROWCOUNT

if @rowCount = 0
	select @idfMaterial = 0
else if @rowCount > 1
	select @idfMaterial = -1

select @idfMaterial


