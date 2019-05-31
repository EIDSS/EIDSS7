



--##SUMMARY Deletes organization record.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:
DECLARE @idfOffice BIGINT
EXEC spOrganization_Delete @idfOffice
*/

CREATE     PROCEDURE dbo.spOrganization_Delete( 
	@idfOffice AS bigint
)
AS
DECLARE @NameID bigint
DECLARE @AbbrID bigint
declare @AddressID bigint

SELECT 
	@NameID = idfsOfficeName,
	@AbbrID = idfsOfficeAbbreviation,
	@AddressID = idfLocation
FROM 
	tlbOffice 
WHERE 
	idfOffice=@idfOffice

DELETE FROM dbo.tlbOffice
WHERE idfOffice = @idfOffice

delete dbo.tlbGeoLocationShared
where idfGeoLocationShared = @AddressID


exec dbo.spsysBaseReference_Delete @NameID
exec dbo.spsysBaseReference_Delete @AbbrID


