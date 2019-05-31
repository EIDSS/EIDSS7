
CREATE PROCEDURE [dbo].[spLabSample_BarcodeExists]( 
	@idfMaterial as bigint
	,@strBarcode AS nvarchar(30)
)
AS

BEGIN
declare @idfsSite bigint
select @idfsSite = idfsCurrentSite from tlbMaterial where idfMaterial = @idfMaterial
if @idfsSite is null
	select @idfsSite = dbo.fnSiteID()

select top 1 idfMaterial from dbo.tlbMaterial
where 
	strBarcode = @strBarcode 
	and idfMaterial<>@idfMaterial 
	and idfsCurrentSite = @idfsSite
	and idfsSampleStatus <> 10015002
	and idfsSampleStatus <> 10015008
	and intRowStatus = 0 
END
