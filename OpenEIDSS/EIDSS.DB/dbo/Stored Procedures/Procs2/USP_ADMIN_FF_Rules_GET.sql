
-- ================================================================================================
-- Name: USP_ADMIN_FF_Rules_GET
-- Description: Returns the list of rules for hte template.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Rules_GET]
(
	@LangID NVARCHAR(50) = NULL	
	,@idfsFormTemplate BIGINT = NULL
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
	
		SELECT [idfsRule]
			   ,[idfsFormTemplate]
			   ,[idfsRuleMessage]
			   ,R.[idfsRuleFunction] AS [idfsRuleFunction]
			   ,RF.intNumberOfParameters
			   ,[idfsCheckPoint]
			   ,CASE WHEN [idfsCheckPoint] = 10028001
					 THEN 'onload'
					 WHEN [idfsCheckPoint] = 10028002 
					 THEN 'onsave'
					 WHEN [idfsCheckPoint] = 10028003
					 THEN 'onvaluechanged'
					 END AS [idfsCheckPointDescr]
				,NULL AS [intRowStatus]
				,R.[rowguid]
				,B1.[strDefault] AS [DefaultName]
				,ISNULL(SNT1.[strTextString], B1.[strDefault]) AS [NationalName]
				,B2.[strDefault] AS [MessageText]		
				,ISNULL(SNT2.[strTextString], B2.[strDefault]) AS [MessageNationalText]
				,@LangID AS [langid]
				,[blnNot]
		FROM [dbo].[ffRule] R
		INNER JOIN dbo.trtBaseReference B1 
		ON B1.[idfsBaseReference] = R.[idfsRule]
		   AND B1.[intRowStatus] = 0
		INNER JOIN dbo.ffRuleFunction RF
		ON R.idfsRuleFunction = RF.idfsRuleFunction
		LEFT JOIN dbo.trtBaseReference B2 
		ON B2.[idfsBaseReference] = R.[idfsRuleMessage]
		   AND B2.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT1 
		ON SNT1.[idfsBaseReference] = R.[idfsRule]
		   AND SNT1.[idfsLanguage] = @langid_int
		   AND SNT1.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT2
		ON SNT2.[idfsBaseReference] = R.[idfsRuleMessage]
		   AND SNT2.[idfsLanguage] = @langid_int
		   AND SNT2.[intRowStatus] = 0
		WHERE (R.[idfsFormTemplate] = @idfsFormTemplate OR @idfsFormTemplate IS NULL)
			  AND R.[intRowStatus] = 0
   
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END


