CREATE     function [dbo].[fnSiteID]()
returns bigint
as
begin
	declare @ret bigint
	select		@ret=isnull(tstLocalConnectionContext.idfsSite,cast(tstLocalSiteOptions.strValue as bigint))
	from		tstLocalSiteOptions
	left join	tstLocalConnectionContext
	on			tstLocalConnectionContext.strConnectionContext=dbo.fnGetContext()
	where		tstLocalSiteOptions.strName='SiteID'
	return @ret
end