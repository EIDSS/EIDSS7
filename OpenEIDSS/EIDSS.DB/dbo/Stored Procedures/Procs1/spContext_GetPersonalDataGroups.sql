
CREATE PROCEDURE [dbo].[spContext_GetPersonalDataGroups]  
@idfCustomizationPackage bigint = null    
AS    
IF @idfCustomizationPackage IS NULL    
BEGIN    
	SELECT @idfCustomizationPackage = dbo.fnCustomizationPackage()
 --DECLARE @idfSite VARCHAR(50)    
    
 --SELECT     
 -- @idfSite = strValue    
 --FROM     
 -- tstLocalSiteOptions    
 --WHERE     
 -- strName = 'SiteID'    
    
 --SELECT     
 -- @idfCustomizationPackage = idfCustomizationPackage    
 --FROM    
 -- tstSite    
 --WHERE    
 -- idfsSite = CAST(@idfSite as bigint)     
END    
  
SELECT      
 mf.idfPersonalDataGroup,    
 strGroupName    
FROM     
 dbo.tstPersonalDataGroup mf    
JOIN dbo.tstPersonalDataGroupToCP ms    
 ON mf.idfPersonalDataGroup = ms.idfPersonalDataGroup 
 WHERE 
	ms.idfCustomizationPackage = @idfCustomizationPackage
  
  
