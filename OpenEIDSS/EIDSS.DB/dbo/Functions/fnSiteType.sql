


--##SUMMARY Returns the Type of current site.
--##SUMMARY It tries to read SiteType option from tstLocalSiteOptions table firstly. 
--##SUMMARY If site Type is not defined (or defined incorrectly) there 
--##SUMMARY the default site Type form tstSite table is returned

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.02.2010

--##RETURNS Type of the current site or 0 if current site is not found


/*
--Example of function call:
SELECT dbo.fnSiteType()

*/




CREATE     function fnSiteType()
returns bigint
as
begin

declare @SiteType bigint
declare @strSiteType NVARCHAR(36)
set @strSiteType = dbo.fnSiteOption('SiteType', N'0')
IF ISNUMERIC(@strSiteType) = 1
	SET @SiteType = CAST(@strSiteType as BIGINT)
ELSE
	SET @SiteType = 0

if IsNull(@SiteType, 0) = 0
begin
	select	@SiteType = idfsSiteType
	from	dbo.tstSite 
	where	idfsSite = dbo.fnSiteID()
end

return ISNULL(@SiteType,0)

end








