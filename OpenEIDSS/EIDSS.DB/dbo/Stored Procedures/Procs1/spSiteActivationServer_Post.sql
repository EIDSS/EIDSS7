





--##SUMMARY Posts data from SiteActivationServerDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.02.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @idfsSite bigint
DECLARE @strSiteID nvarchar(200)
DECLARE @strSiteName nvarchar(200)
DECLARE @idfsSiteType bigint
DECLARE @idfsCountry bigint
DECLARE @idfOffice bigint


EXECUTE spSiteActivationServer_Post
   @idfsSite
  ,@strSiteID
  ,@strSiteName
  ,@idfsSiteType
  ,@idfsCountry
  ,@idfOffice

*/


CREATE          PROCEDURE dbo.spSiteActivationServer_Post (
	@idfsSite AS BIGINT,--##PARAM @idfsSite  - site ID
	@strSiteID AS NVARCHAR(200),--##PARAM @strSiteID - string representaion of site ID in EIDSS 2.0 format
	@strSiteName AS NVARCHAR(200),--##PARAM @strSiteName - site name
	@strServerName AS NVARCHAR(200),--##PARAM @strServerName - site server name
	@idfsSiteType AS BIGINT,--##PARAM @idfsSiteType - site Type
	@idfCustomizationPackage AS BIGINT,--##PARAM @idfCustomizationPackage - site Customization Package
	@idfOffice AS BIGINT --##PARAM @idfOffice - site organization
)

AS

--Currently sites can't be created/deleted from client application,
--so we process only data updating here.
UPDATE tstSite
   SET 
       idfsSiteType = @idfsSiteType
      ,idfCustomizationPackage = @idfCustomizationPackage
      ,idfOffice = @idfOffice
      ,strSiteName = @strSiteName
      ,strServerName = @strServerName
      --,strHASCsiteID = @strHASCsiteID
      ,strSiteID = @strSiteID
 WHERE idfsSite = @idfsSite




