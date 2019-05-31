
--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

create procedure	[dbo].[spSampleLogBook_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

select		COUNT(*) 
from		tlbMaterial
left join	tlbTesting
			on tlbMaterial.idfMaterial=tlbTesting.idfMaterial
			and tlbTesting.intRowStatus=0
			and IsNull(tlbTesting.blnNonLaboratoryTest, 0) <> 1
			and IsNull(tlbTesting.blnReadOnly, 0) <> 1
where		tlbMaterial.blnShowInLabList = 1
			and IsNull(tlbTesting.blnExternalTest, 0) <> 1
			and tlbMaterial.idfsCurrentSite = @SiteID
			and (tlbMaterial.idfsSampleStatus <> 10015008 --Deleted EFR5336, we sgould not display the samples in Deleted status without tests
				OR NOT tlbTesting.idfTesting IS NULL)

