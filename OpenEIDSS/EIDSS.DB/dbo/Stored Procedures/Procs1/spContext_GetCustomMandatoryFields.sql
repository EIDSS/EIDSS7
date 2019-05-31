
CREATE PROCEDURE spContext_GetCustomMandatoryFields
@idfCustomizationPackage bigint = null
AS

IF @idfCustomizationPackage IS NULL
BEGIN
	SELECT @idfCustomizationPackage = dbo.fnCustomizationPackage()
	--DECLARE @idfSite VARCHAR(50)

	--SELECT 
	--	@idfSite = strValue
	--FROM 
	--	tstLocalSiteOptions
	--WHERE 
	--	strName = 'SiteID'

	--SELECT 
	--	@idfCustomizationPackage = idfCustomizationPackage
	--FROM
	--	tstSite
	--WHERE
	--	idfsSite = CAST(@idfSite as bigint)	
END
	
SELECT  
	mf.idfMandatoryField,
	strFieldAlias
FROM 
	dbo.tstMandatoryFields mf
JOIN dbo.tstMandatoryFieldsToCP ms
	ON mf.idfMandatoryField = ms.idfMandatoryField
WHERE 
	ms.idfCustomizationPackage = @idfCustomizationPackage
	

