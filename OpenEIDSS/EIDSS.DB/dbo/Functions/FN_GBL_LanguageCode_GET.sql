----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: FN_GBL_LanguageCode_GET
-- Description			: Function to return Language code
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards and 
--                              renamed to FN_GBL_LanguageCode_GET
--
-- Testing code:
--
-- select * from FN_GBL_LanguageCode_GET('en','rftCountry')

CREATE FUNCTION [dbo].[FN_GBL_LanguageCode_GET](@LangID  NVARCHAR(50))
RETURNS BIGINT
AS
BEGIN
  DECLARE @LanguageCode bigint
  SET @LanguageCode = 
  CASE @LangID 
     WHEN N'az-L'		THEN 10049001
	 WHEN N'ru'			THEN 10049006
	 WHEN N'ka'			THEN 10049004
	 WHEN N'kk'			THEN 10049005
	 WHEN N'uz-C'		THEN 10049007
	 WHEN N'uz-L'		THEN 10049008
	 WHEN N'uk'			THEN 10049009
	 WHEN N'CISID-AZ'	THEN 10049002
	 WHEN N'hy'			THEN 10049010
	 WHEN N'ar'			THEN 10049011
	 WHEN N'vi'			THEN 10049012
	 WHEN N'lo'			THEN 10049013
	 WHEN N'th'			THEN 10049014
	 ELSE 10049003 END
  RETURN @LanguageCode
END



