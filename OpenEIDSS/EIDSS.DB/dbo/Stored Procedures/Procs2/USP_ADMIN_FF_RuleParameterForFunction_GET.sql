
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleParameterForFunction_GET
-- Description: Returns the List of RUles for parameter
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleParameterForFunction_GET]
(		
	@LangID NVARCHAR(50) = NULL
	,@idfRule BIGINT
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	IF (@LangID IS NULL)
		SET @LangID = 'en';
	
	DECLARE
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY

		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);	
	
		SELECT 
			PF.[idfParameterForFunction]
			,PF.[idfsParameter]
			,PF.[idfsFormTemplate]
			,PF.[idfsRule]
			,PF.[intOrder]
			,PF.[rowguid]
			,P.[idfsParameterType]
			,B.[strDefault] AS [DefaultName]
			,ISNULL(SNT.[strTextString], B.[strDefault]) AS [NationalName]
		FROM [dbo].[ffParameterForFunction] PF
		INNER JOIN [dbo].[ffParameter] P
		ON PF.idfsParameter = P.idfsParameter
		   AND P.[intRowStatus] = 0
		LEFT JOIN dbo.trtBaseReference B
		ON B.[idfsBaseReference] = P.[idfsParameterCaption]
		   AND B.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT
		ON (SNT.[idfsBaseReference] = P.[idfsParameterCaption]
			AND SNT.[idfsLanguage] = @langid_int)
		   AND SNT.[intRowStatus] = 0
		WHERE PF.[idfsRule] = @idfRule AND PF.[intRowStatus] = 0   

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END


