
----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: FN_GBL_SiteOption_Get
-- Description			: Get Next Number - copied 6.1 code to V7
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
--
-- Testing code:
-- 
-- select FN_GBL_SiteOption_Get('SiteID', N'')
--
----------------------------------------------------------------------------
----------------------------------------------------------------------------
CREATE FUNCTION [dbo].[FN_GBL_SiteOption_Get]
(
	@OptionName NVARCHAR(200),
	@DefValue	NVARCHAR(200) = N''
)
RETURNS NVARCHAR(200)
AS
BEGIN

  DECLARE @Val AS NVARCHAR(200)
	
  SELECT TOP 1 @Val = strValue 
  FROM	tstLocalSiteOptions
  WHERE	strName = @OptionName
	
  RETURN ISNULL(@Val, @DefValue)

END

