
/*
SELECT dbo.fnCustomizationPackage()
*/
CREATE FUNCTION [dbo].[fnCustomizationPackage]
(
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @idfsCustomizationPackage BIGINT
	SELECT		
		@idfsCustomizationPackage = CAST(strValue as BIGINT)
	FROM tstGlobalSiteOptions o
	WHERE o.strName = 'CustomizationPackage'
	IF @idfsCustomizationPackage IS NULL			
		SELECT
			@idfsCustomizationPackage = ts.idfCustomizationPackage
		FROM tstLocalSiteOptions tlso
		JOIN tstSite ts ON
			ts.idfsSite = CAST(tlso.strValue as BIGINT)
		WHERE tlso.strName = 'SiteID'
	RETURN @idfsCustomizationPackage
END

