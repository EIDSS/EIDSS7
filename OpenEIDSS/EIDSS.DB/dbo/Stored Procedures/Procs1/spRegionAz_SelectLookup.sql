


/*
exec spRegionAz_SelectLookup 'en'
exec spRegionAz_SelectLookup 'en' , 170000000
exec spRegionAz_SelectLookup 'en' , 170000000, 1344340000000
*/

create          PROCEDURE dbo.spRegionAz_SelectLookup
	@LangID As nvarchar(50),
	@CountryID as bigint = NULL,
	@ID as bigint = NULL
as


	declare		
		@idfsRegionBaku bigint,
		@idfsRegionOtherRayons bigint,
		@idfsRegionNakhichevanAR bigint

 	--1344330000000 --Baku
	select @idfsRegionBaku = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Baku'

	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'


	--1344350000000 --Nakhichevan AR
	select @idfsRegionNakhichevanAR = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Nakhichevan AR'

 	--Transport CHE
 	declare @TransportCHE bigint
 
 	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
 	

	select	
		ra.idfsRegion, 
		ra.strRegionName, 
		ra.strRegionCode, 
		ra.idfsCountry, 
		ra.intRowStatus,
		case ra.idfsRegion
		  when @idfsRegionBaku --Baku
		  then 1
		  
		  when @idfsRegionOtherRayons --Other rayons
		  then 2
		  
		  when @idfsRegionNakhichevanAR --Nakhichevan AR
		  then 3
		  
		  when @TransportCHE --TransportCHE
		  then 4
		  else 0
		 end as intOrder
	from	vwRegionAggr ra
	where	
		ra.idfsCountry = isnull(@CountryID, ra.idfsCountry)
		and (ra.idfsRegion = @ID or @ID is null)
		and exists (select distinct * 
						from tstSite s 
							inner join tstCustomizationPackage cp
							on cp.idfCustomizationPackage = s.idfCustomizationPackage
						where cp.idfsCountry = ra.idfsCountry )
		and idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	order by 
		case ra.idfsRegion
		  when @idfsRegionBaku --Baku
		  then 1
		  
		  when @idfsRegionOtherRayons --Other rayons
		  then 2
		  
		  when @idfsRegionNakhichevanAR --Nakhichevan AR
		  then 3
		  
		  when @TransportCHE --TransportCHE
		  then 4
		  else 0
		 end,
		 ra.strRegionName

	


