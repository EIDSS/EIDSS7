

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 28.07.2011


--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 19.09.2013
/*
exec spFreezerTree

*/

create    PROCEDURE [dbo].[spFreezerTree]
as
	declare @idfsSite bigint
	
	set @idfsSite = dbo.fnSiteID() 
	
	select		Locations.*,
				isnull(Usage.intUsed,0) as intUsed,
				cast(0 as int) as intRowStatus
	from		dbo.fn_RepositorySchema(null,null,null) Locations
	left join	(
				select idfSubdivision, count(*) as intUsed
				from	tlbMaterial
				where	tlbMaterial.idfsSite = @idfsSite
				group by idfSubdivision
				)Usage
	on			Usage.idfSubdivision=Locations.idfSubdivision






