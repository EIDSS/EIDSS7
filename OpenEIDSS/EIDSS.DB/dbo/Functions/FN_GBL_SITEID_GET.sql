
/*
--*************************************************************
-- Name 				: FN_GBL_SITEID_GET
-- Description			: Funtion to return userid 
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- 
--*************************************************************
*/
CREATE FUNCTION [dbo].[FN_GBL_SITEID_GET]()
RETURNS BIGINT
AS
BEGIN
	DECLARE @ret BIGINT
	SELECT		@ret=ISNULL(tstLocalConnectionContext.idfsSite,CAST(tstLocalSiteOptions.strValue as BIGINT))
	FROM		tstLocalSiteOptions
	LEFT JOIN	tstLocalConnectionContext ON			
				tstLocalConnectionContext.strConnectionContext=dbo.fnGetContext()
	WHERE		tstLocalSiteOptions.strName='SiteID'

	RETURN @ret
END
