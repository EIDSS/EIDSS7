
-- ================================================================================================
-- Name: FN_ADMIN_DesignLanguageForLabel_GET
-- Description: Returns the Design Language for the label
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- Kishore Kodru	1/11/2019  Updated old references. 
-- ================================================================================================
Create function dbo.FN_ADMIN_FF_DesignLanguageForLabel_GET
(
	@LangID Nvarchar(50)
	,@idfDecorElement Bigint
)
RETURNS BIGINT
AS
BEGIN

	--
	DECLARE @Result Bigint
	SET @Result = dbo.FN_GBL_LanguageCode_GET(@LangID);  
	
	IF NOT EXISTS(SELECT TOP 1 1 
					FROM dbo.ffDecorElement 
					WHERE [idfDecorElement] =  @idfDecorElement 
					AND idfsLanguage = @Result 
					AND intRowStatus = 0) 
			SET @Result = dbo.FN_GBL_LanguageCode_GET('en');
		
	RETURN	@Result;
END


