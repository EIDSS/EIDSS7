
--##SUMMARY Selects count of Lab Tests
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spLabTest_SelectCount 
	
*/

CREATE procedure	[dbo].[spLabTest_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

select		COUNT(*) 'LABTESTCOUNT'
from		tlbTesting
inner join	tlbMaterial
on			tlbMaterial.idfMaterial=tlbTesting.idfMaterial
where		tlbTesting.intRowStatus=0
			and tlbTesting.blnNonLaboratoryTest<>1
			and tlbTesting.blnReadOnly<>1
			and tlbMaterial.intRowStatus=0
			and IsNull(tlbTesting.blnExternalTest, 0) <> 1
			and tlbMaterial.idfsSite=@SiteID


