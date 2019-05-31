

-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Create address string from geo information
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.12.2009

--##RETURNS String with address

/*
--Example of a call of function:
select dbo.fnAddressStringDenyRigths ('ru', 12171490000000, 0)
*/

create function [dbo].[fnAddressStringDenyRigths]
	(
		@LangID nvarchar(50), 
		@GeoLocation bigint,
		@IsSettlement bit
	)
returns nvarchar(1000)
as
	begin
	declare @Country nvarchar(200)
	declare @Region nvarchar(200)
	declare @Rayon nvarchar(200)
	declare @Settlement nvarchar(200)
	DECLARE @blnForeignAddress	bit

	select		@Country	= IsNull(rfCountry.[name], ''),
				@Region		= IsNull(rfRegion.[name], ''),
				@Rayon		= IsNull(rfRayon.[name], ''),
				@Settlement = IsNull(rfSettlement.[name], ''),
				@blnForeignAddress = ISNULL(tLocation.blnForeignAddress, 0)

	from
	(  
					dbo.tlbGeoLocation tLocation
		 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/) rfCountry 
				on	rfCountry.idfsReference = tLocation.idfsCountry
		 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfRegion 
				on	rfRegion.idfsReference = tLocation.idfsRegion
		 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfRayon 
				on	rfRayon.idfsReference = tLocation.idfsRayon
		 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfSettlement
				on	rfSettlement.idfsReference = tLocation.idfsSettlement
	)
	 where	tLocation.idfGeoLocation = @GeoLocation
	   and  tLocation.intRowStatus = 0
	   
	   
	if (@IsSettlement = 1) 
	set @Settlement = ''

	return	dbo.fnCreateAddressString(
						@Country,
						@Region,
						@Rayon,
						'',
						'',
						@Settlement,
						'*',
						'',
						'',
						'',
						@blnForeignAddress,
						'*')

	end

