--*************************************************************
-- Name 				: FN_GBL_ISWEBACCESS
-- Description			: List All Vector Surveillance Session data
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
--SELECT * FROM FN_GBL_ISWEBACCESS()
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_ISWEBACCESS]()
RETURNS BIT
AS
BEGIN
	 DECLARE @webAccess BIT      
	 IF EXISTS(SELECT * FROM tstLocalSiteOptions WHERE strName='WebSiteMode' AND strValue IS NOT NULL)      
		RETURN 1       
	 RETURN 0      
END
