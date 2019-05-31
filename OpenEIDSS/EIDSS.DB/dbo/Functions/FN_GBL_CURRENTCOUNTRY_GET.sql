
--*************************************************************
-- Name 				: FN_GBL_CURRENTCOUNTRY_GET
-- Description			: Returns country code 
--						
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- 
--*************************************************************

CREATE FUNCTION [dbo].[FN_GBL_CURRENTCOUNTRY_GET]()

RETURNS BIGINT

AS

BEGIN

	DECLARE @idfsCountry BIGINT

	SELECT		
		@idfsCountry = tcp1.idfsCountry
	FROM		
		tstSite ts
		JOIN tstCustomizationPackage tcp1 ON
			tcp1.idfCustomizationPackage = ts.idfCustomizationPackage
	WHERE		
		ts.idfsSite = dbo.fnSiteID()

	RETURN @idfsCountry

END