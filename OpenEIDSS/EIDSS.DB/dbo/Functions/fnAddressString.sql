

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
select dbo.fnAddressString ('ru', 1)
*/

create function [dbo].[fnAddressString]
	(
		@LangID nvarchar(50), 
		@GeoLocation bigint
	)
returns nvarchar(1000)
as
	begin
	declare @Country nvarchar(200)
	declare @Region nvarchar(200)
	declare @Rayon nvarchar(200)
	declare @PostCode nvarchar(200)
	declare @SettlementType nvarchar(200)
	declare @Settlement nvarchar(200)
	declare @Street nvarchar(200)
	declare @House nvarchar(200)
	declare @Bilding nvarchar(200)
	declare @Appartment nvarchar(200)
	DECLARE @blnForeignAddress	bit
	DECLARE @strForeignAddress	nvarchar(200)

	select		@Country	= IsNull(rfCountry.[name], ''),
				@Region		= IsNull(rfRegion.[name], ''),
				@Rayon		= IsNull(rfRayon.[name], ''),
				@PostCode	= IsNull(tLocation.strPostCode, ''),
				@SettlementType = IsNull(rfSettlementType.[name], ''),
				@Settlement = IsNull(rfSettlement.[name], ''),
				@Street		= IsNull(tLocation.strStreetName, ''),
				@House		= IsNull(tLocation.strHouse, ''),
				@Bilding	= IsNull(tLocation.strBuilding, ''),
				@Appartment = IsNull(tLocation.strApartment, ''),
				@blnForeignAddress = ISNULL(tLocation.blnForeignAddress, 0),
				@strForeignAddress =  ISNULL(tLocation.strForeignAddress,N'')

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
	left join	
	(
					gisSettlement 
		inner join  fnGisReference(@LangID, 19000005 /*'rftSettlementType'*/) rfSettlementType 
				on	rfSettlementType.idfsReference = gisSettlement.idfsSettlementType
	)	
		on	gisSettlement.idfsSettlement = tLocation.idfsSettlement
	 where	tLocation.idfGeoLocation = @GeoLocation
	   and  tLocation.intRowStatus = 0

	return	dbo.fnCreateAddressString(
						@Country,
						@Region,
						@Rayon,
						@PostCode,
						@SettlementType,
						@Settlement,
						@Street,
						@House,
						@Bilding,
						@Appartment,
						@blnForeignAddress,
						@strForeignAddress)

	end

