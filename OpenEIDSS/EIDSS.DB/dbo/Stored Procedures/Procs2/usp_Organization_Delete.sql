






--##SUMMARY Deletes organization record.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

-- renamed to usp_ from sp by MCW on 5/1/2017

/*
--Example of procedure call:
DECLARE @idfOffice BIGINT
EXEC usp_Organization_Delete @idfOffice
*/

CREATE     PROCEDURE [dbo].[usp_Organization_Delete]( 
	@idfOffice AS bigint
)
AS
BEGIN
DECLARE @NameID bigint
DECLARE @AbbrID bigint
declare @AddressID bigint
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN TRY
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

-- changed name to call usp_ instead of sp by MCW
exec dbo.usp_sysBaseReference_Delete @NameID
exec dbo.usp_sysBaseReference_Delete @AbbrID

SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
END TRY
BEGIN CATCH
THROW;
END CATCH 
END



