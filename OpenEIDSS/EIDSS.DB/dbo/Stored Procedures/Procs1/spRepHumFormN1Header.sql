

--##SUMMARY This procedure returns Header (Page 1) for Form N1

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

--January - March, 2014  Shahbuz, Nakhichevan AR
exec spRepHumFormN1Header 'en', 2014, 'January','March', 1344350000000, 1345100000000, null

--January, 2014  Air Transport CHE
exec spRepHumFormN1Header 'en', 2014, 'January','January', null, null, 867


--2014  Air Transport CHE
exec spRepHumFormN1Header 'en', 2014, '','', null, null, 867

-- 2014  Baku, Nizami (Baku)
exec spRepHumFormN1Header 'en', 2014, '','', 1344330000000, 1344390000000, null

-- 2014  Ordubad, Nakhichevan AR
exec spRepHumFormN1Header 'en', 2014, '','', 1344350000000, 1345120000000, null

-- 2014  Absheron  -- other!!
exec spRepHumFormN1Header 'en', 2014, '','', 1344340000000, 1344490000000, null

-- 2014  Other rayons   -- rayon IS NULL
exec spRepHumFormN1Header 'en', 2014, '','', 1344340000000, null, null

-- 2014  Azerbaijan
exec spRepHumFormN1Header 'en', 2014, '','', null, null, null

*/ 
 
create PROCEDURE [dbo].[spRepHumFormN1Header]
	@LangID			as varchar(36),
	@Year			as int, 
	@strStartMonth	as nvarchar(100) = null,
	@strEndMonth	as nvarchar(100) = null,
	@RegionID		as bigint = null,
	@RayonID		as bigint = null,
	@OrganizationID	as bigint = null,
	@SiteID			as bigint = null
	
as
BEGIN

	declare @idfSiteInfoOffice bigint
	declare @CountryID bigint
	declare @Address nvarchar(1000)

	declare @strParameters nvarchar(1000)
	declare @strOrganizationName  nvarchar(1000)
	declare @strTransportOrganizationName  nvarchar(1000)
	declare @strRegion  nvarchar(1000)
	declare @strRayon	nvarchar(1000)
	declare @strCountry nvarchar(1000)

	set @strStartMonth = case when @strStartMonth = '' then null else @strStartMonth END
	set @strEndMonth = case when @strEndMonth = '' then null else @strEndMonth END
  
  	select 
				@idfSiteInfoOffice = tstSite.idfOffice,
				@strOrganizationName = fnInstitution.[name]
	from		dbo.fnGisReference(@LangID,19000001) --'rftCountry'  
		inner join	gisCountry  
		on			dbo.fnGisReference.idfsReference = gisCountry.idfsCountry 
		join		tstCustomizationPackage tcpac 
		on			tcpac.idfsCountry =  gisCountry.idfsCountry
		inner join	tstSite   
		on			tstSite.idfCustomizationPackage = tcpac.idfCustomizationPackage  
		inner join	dbo.fnReference(@LangID, 19000085) --rftSiteType  
		on			tstSite.idfsSiteType = fnReference.idfsReference  
		inner join	dbo.fnInstitution(@LangID)   
		on			tstSite.idfOffice = fnInstitution.idfOffice  
		left join	tlbGeoLocationShared   
		on			fnInstitution.idfLocation = tlbGeoLocationShared.idfGeoLocationShared  
	where		tstSite.idfsSite = isnull(@SiteID, dbo.fnSiteID()) 
	
	select 
				@Address = dbo.fnAddressSharedString(@LangID, o.idfLocation)
	from		tlbOffice o
	where		@idfSiteInfoOffice = o.idfOffice

	set	@CountryID = 170000000

	select @strTransportOrganizationName =  i.[name]
	from tstSite   
		inner join	dbo.fnInstitution(@LangID) as i  
		on			tstSite.idfOffice = i.idfOffice  
	where		tstSite.idfsSite = @OrganizationID
	
	select @strRegion = [name] 
	from fnGisReference(@LangID, 19000003 /*rftRegion*/) 
	where idfsReference = @RegionID
		
	select @strRayon = [name] 
	from fnGisReference(@LangID, 19000002 /*rftRayon*/)  
	where idfsReference = @RayonID
		
	select @strCountry = [name] 
	from fnGisReference(@LangID, 19000001 /*rftCountry*/) 
	where idfsReference = @CountryID
	
	
	set @strParameters = 
		case 
			when isnull(@strStartMonth, N'') <> isnull(@strEndMonth, N'')
				then isnull(@strStartMonth + isnull(' - ' + @strEndMonth, '') +  ', ', '') /*+ cast(@Year as VARCHAR(4)) + CHAR(13) + CHAR(10)*/
				else isnull(@strStartMonth + ', ', '')			
		end + cast(@Year as VARCHAR(4)) + CHAR(13) + CHAR(10) +	
		case 
			when @OrganizationID is not null 
				then isnull(@strTransportOrganizationName, '') 
				else 
					case when @RegionID = 1344330000000 -- Baku
							then @strRegion + isnull(', ' + @strRayon, '')
						 when @RegionID = 1344340000000 -- other
							then isnull(@strRayon, @strRegion)
						  when @RegionID = 1344350000000 -- Nakhichevan AR
							then  isnull(@strRayon + ', ', '') + @strRegion 
						 else @strCountry
					end 
		end
		
		
	
	
		--isnull((select [name] from fnGisReference(@LangID, 19000002 /*rftRayon*/) where idfsReference = @RayonID),'') 
  --                     +
  --                     CASE WHEN @RayonID IS NOT null AND @RegionID IS NOT null AND @RegionID <> 1344340000000 -- Other rayons
  --                      THEN
  --                          ', '
  --                      ELSE ''
  --                     END
  --                     +
  --                     CASE WHEN @RegionID IS NOT null AND (@RayonID IS null OR @RegionID <> 1344340000000) -- Other rayons
  --                      THEN
  --                          isnull((select [name] from fnGisReference(@LangID, 19000003 /*rftRegion*/) where idfsReference = @RegionID),'') 
  --                      ELSE ''
  --                     end
  --                     +
  --                     CASE WHEN @OrganizationID is not null and @RegionID IS null AND @RayonID IS null 
  --                      THEN
  --                          isnull(@strTransportOrganizationName, '')
  --                      ELSE ''
  --                     end
                       
		--				+
  --                     CASE WHEN @RayonID IS null AND @RegionID IS null and @OrganizationID is null
  --                      THEN
  --                          isnull((select [name] from fnGisReference(@LangID, 19000001 /*rftCountry*/) where idfsReference = @CountryID),'') 
  --                      ELSE ''
  --                     END
                      
                       
					

    
	select
	    @strParameters as strParameters,
	    @strOrganizationName  as strOrganizationName,
	    @Address as strOrganizationAddress

END

