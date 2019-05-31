
/*******************************************************
NAME						: USP_GBL_SITE_GETDetail		


Description					: Returns Information about a Site based on the userid and Site Id

Author						: Lamont Mitchell

Revision History
		
			Name							Date								Change Detail
			Lamont Mitchell					11/20/2018							Initial Created
				Lamont Mitchell				02/04/2019							Had to Fix Return results someone modified this proc.
			Asim Karim						04/04/2019							Modified proc to return Region, Rayon & Settlement from OfficeID
*******************************************************/
CREATE PROCEDURE [dbo].[USP_GBL_SITE_GETDetail]
	@idfsSite							INT,
	@UserId								BIGINT
AS
BEGIN
	
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
		
		SELECT distinct
			 s.[idfsSite]
			,s.[idfsSiteType]
			,s.[idfCustomizationPackage]
			,cp.[strCustomizationPackageName]
			,s.[idfOffice]
			,s.[strSiteName]
			,s.[strHASCsiteID]
			,s.[strSiteID]
			,s.[idfsParentSite]
			,s.[strMaintenanceFlag]
			,lcp.[idfsLanguage]
			,lcp.[idfCustomizationPackage]
			,lcp.[rowguid]
			,ut.[idfUserID]
			,ut.[idfPerson]
			,ut.[idfsSite]
			,ut.[PreferredLanguageID]
			,br.[idfsReferenceType]
			,br.[strBaseReferenceCode]
			,br.[strDefault]
			,br.[intHACode]
			,g.[idfsCountry]
			,g.[idfsRegion]
			,g.[idfsRayon]
			,g.[idfsSettlement]
		FROM [dbo].[tstSite] s
			JOIN [dbo].[tstCustomizationPackage] cp
				ON cp.idfCustomizationPackage = s.idfCustomizationPackage 
			JOIN  [dbo].[trtLanguageToCP] lcp
				ON lcp.idfCustomizationPackage = cp.idfCustomizationPackage
			JOIN [dbo].[tstUserTable] ut
				ON ut.PreferredLanguageID = lcp.idfsLanguage and ut.idfUserID = @UserId
			JOIN [dbo].[trtBaseReference] br
				ON br.idfsBaseReference = ut.PreferredLanguageID
			JOIN [dbo].[tlbOffice] o 
				ON s.idfOffice = o.idfOffice
			JOIN [dbo].[tlbGeoLocationShared] g 
				ON o.idfLocation = g.idfGeoLocationShared
			LEFT JOIN	trtStringNameTranslation snt 
				ON br.idfsBaseReference = snt.idfsBaseReference and snt.idfsLanguage = dbo.fnGetLanguageCode(br.strBaseReferenceCode)
		WHERE s.[idfsSite] = @idfsSite
	

	END TRY
	BEGIN CATCH
		Throw;
		
	END CATCH
END
--EXEC [dbo].[USP_GBL_SITE_GETDetail] 1101,1
