
----------------------------------------------------------------------------
-- Name 				: FN_GBL_CustomizationPackage_GET
-- Description			: Get the id for the current Customizatino Package
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards and 
--                              changed name FN_GBL_CustomizationPackage_GET
--
-- Testing code:
-- SELECT dbo.FN_GBL_CustomizationPackage_GET()
----------------------------------------------------------------------------
----------------------------------------------------------------------------

CREATE FUNCTION [dbo].[FN_GBL_CustomizationPackage_GET]
(
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @idfsCustomizationPackage BIGINT
	
	SELECT	@idfsCustomizationPackage = CAST(strValue as BIGINT)
	FROM	tstGlobalSiteOptions o
	WHERE	o.strName = 'CustomizationPackage'

	IF @idfsCustomizationPackage IS NULL			
		SELECT	@idfsCustomizationPackage = ts.idfCustomizationPackage
		FROM	tstLocalSiteOptions tlso
		JOIN	tstSite ts ON ts.idfsSite = CAST(tlso.strValue as BIGINT)
		WHERE	tlso.strName = 'SiteID'

	RETURN @idfsCustomizationPackage
END


