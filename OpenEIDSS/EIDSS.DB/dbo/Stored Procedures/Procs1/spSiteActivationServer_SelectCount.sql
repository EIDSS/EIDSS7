
--##SUMMARY Selects count of EIDSS Sites
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE [spSiteActivationServer_SelectCount] 
	
*/

create procedure	[dbo].[spSiteActivationServer_SelectCount]
as

declare @SiteID bigint
set @SiteID = dbo.fnSiteID()

select		COUNT(*) 
from			tstSite
where			(	dbo.fnSiteType() = 10085003 /*GDR*/
					or tstSite.idfCustomizationPackage = (
							select	idfCustomizationPackage 
							from	tstSite 
							where	idfsSite = @SiteID))
				and tstSite.intRowStatus = 0 
