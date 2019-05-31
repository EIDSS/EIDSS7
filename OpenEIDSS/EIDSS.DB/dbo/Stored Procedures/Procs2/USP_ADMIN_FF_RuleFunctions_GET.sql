
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleFunctions_GET
-- Description: Returns the list of Rule Function
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleFunctions_GET]
(	
	@count INT = NULL
	,@LangID NVARCHAR(50) = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;	
	
	IF (@count = -1)
		SET @count = NULL;
	IF (@LangID IS NULL)
		SET @LangID = 'en';
	
	DECLARE 
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)    
	
	BEGIN TRY
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
	
		SELECT [idfsRuleFunction]	
			   ,[strMask]
			   ,ISNULL(SNT.strTextString, [strMask]) AS [strMaskNational]
			   ,[intNumberOfParameters]
			   ,0 AS [intRowStatus]
		FROM dbo.ffRuleFunction RF
		INNER JOIN dbo.trtStringNameTranslation SNT
		ON RF.idfsRuleFunction = SNT.idfsBaseReference
		   AND SNT.idfsLanguage = @langid_int
		WHERE ([intNumberOfParameters] = @count OR @count IS NULL)
			  AND SNT.[intRowStatus] = 0

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

