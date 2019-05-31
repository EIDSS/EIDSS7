

--##SUMMARY This procedure returns geo information related with current site.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 02.02.2011

--##RETURNS Don't use  

/*
--Example of a call of procedure:

exec spRepSelectLocation 'ru', 1

exec spRepSelectLocation 'ru', 1, 869

select *
 	from dbo.fnGisReferenceRepair('en', 19000020) frr

select *
 	from dbo.fnGisReferenceRepair('en', 19000021) frr
*/ 
 
create PROCEDURE [dbo].[spRepSelectLocation]
	@LangID varchar(36),
	@IsCHE bit = 0,
	@SiteID bigint = null
AS
BEGIN

	if @SiteID	is null
	set @SiteID = dbo.fnSiteID()
	
	if @IsCHE = 1 and exists (select * from dbo.fnGisReferenceRepair('en', 19000021) where idfsReference = @SiteID)
		select		
				tcp1.idfsCountry,
				CHERegion.idfsReference as idfsRegion, 
				CHERayon.idfsReference	as idfsRayon, 
				null					as idfsSettlement, 
				country.[name]			as strCountry,
				CHERegion.[name]		as strRegion,
				CHERayon.[name]			as strRayon,
				null					as strSettlement
		from 		tstSite					as st
			join dbo.fnGisReferenceRepair('en', 19000020) CHERegion
			on 1=1
			join dbo.fnGisReferenceRepair('en', 19000021) CHERayon
			on st.idfsSite = CHERayon.idfsReference
			join tstCustomizationPackage tcp1
			on tcp1.idfCustomizationPackage = st.idfCustomizationPackage
			left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/)as  country 
			on	country.idfsReference = tcp1.idfsCountry
		where		st.idfsSite = @SiteID
	else
 		select		loc.idfsCountry,
					loc.idfsRegion, 
					loc.idfsRayon, 
					loc.idfsSettlement, 
					country.[name]	as strCountry,
					region.[name]		as strRegion,
					rayon.[name]		as strRayon,
					settlement.[name]	as strSettlement
		from 		tstSite					as st
		 left join	dbo.fnInstitution(@LangID) as	inst
				on	st.idfOffice = inst.idfOffice
		 left join	dbo.tlbGeoLocationShared			as loc
				on	inst.idfLocation = loc.idfGeoLocationShared
 		 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/)as  country 
				on	country.idfsReference = loc.idfsCountry
		 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/) as  region 
				on	region.idfsReference = loc.idfsRegion
		 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)  as rayon 
				on	rayon.idfsReference = loc.idfsRayon
		 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) as settlement
				on	settlement.idfsReference = loc.idfsSettlement
		where		st.idfsSite = @SiteID
END

