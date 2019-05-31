
CREATE FUNCTION [dbo].[fnIsWebAccess]()
RETURNS bit
AS
BEGIN
 declare @webAccess bit      
 if exists(select * from tstLocalSiteOptions where strName='WebSiteMode' and strValue is not null)      
	RETURN 1       
 RETURN 0      
END
