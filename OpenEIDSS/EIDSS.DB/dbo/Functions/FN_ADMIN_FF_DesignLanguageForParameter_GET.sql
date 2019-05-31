

-- ================================================================================================
-- Name: FN_ADMIN_FF_DesignLanguageForParameter_GET
-- Description: Retrieves the Design language for the Parameter as a Function result in BigInt. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
Create function [dbo].[FN_ADMIN_FF_DesignLanguageForParameter_GET]
(
	@LangID Nvarchar(50)
	,@idfsParameter Bigint
	,@idfsFormTemplate Bigint	
)
RETURNS Bigint
AS
BEGIN
	--
	DECLARE @Result Bigint
	
	SET @Result = dbo.FN_GBL_LanguageCode_GET(@LangID);  

	IF (@idfsFormTemplate Is Null) 
	BEGIN	
		IF NOT EXISTS(SELECT TOP 1 1 
						FROM dbo.ffParameterDesignOption 
						WHERE [idfsParameter] =  @idfsParameter 
						AND idfsLanguage = @Result 
						AND idfsFormTemplate Is Null 
						AND intRowStatus = 0) 
			SET @Result = dbo.FN_GBL_LanguageCode_GET('en');
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT TOP 1 1 
						FROM dbo.ffParameterDesignOption 
						WHERE [idfsParameter] =  @idfsParameter 
						AND idfsLanguage = @Result 
						AND idfsFormTemplate = @idfsFormTemplate 
						AND intRowStatus = 0) 
			SET @Result = dbo.FN_GBL_LanguageCode_GET('en');
	END	
	
	RETURN	@Result;
END
