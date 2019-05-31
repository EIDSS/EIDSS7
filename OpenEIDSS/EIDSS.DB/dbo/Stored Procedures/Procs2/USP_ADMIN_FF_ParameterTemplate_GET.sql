
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTemplate_GET
-- Description:	Return list of Parameter Templates
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
/*
exec dbo.spFFGetParameterTemplate null, null, 'en'
*/
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTemplate_GET]
(	
	@idfsParameter BIGINT = NULL
	,@idfsFormTemplate BIGINT = NULL
	,@LangID NVARCHAR(50) = NULL
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
		SET @langid_int = dbo.fnGetLanguageCode(@LangID);	
	
		SELECT PT.[idfsParameter]
			   ,P.[idfsSection]
			   ,P.[idfsFormType]
			   ,P.[intHACode]
			   ,PT.[idfsFormTemplate]
			   ,PT.[idfsEditMode]
			   ,P.[idfsEditor]
			   ,P.[idfsParameterType]
			   ,PDO.[intLeft]
			   ,PDO.[intTop]
			   ,PDO.[intWidth]
			   ,PDO.[intHeight]
			   ,PDO.[intScheme]
			   ,PDO.[intLabelSize]
			   ,PDO.[intOrder]
			   ,ISNULL(B.[strDefault], '') AS [DefaultName]
			   ,ISNULL(B1.[strDefault], '') AS [DefaultLongName]
			   ,ISNULL(SNT.[strTextString], B.[strDefault]) AS [NationalName]
			   ,ISNULL(SNT1.[strTextString], B1.[strDefault]) AS [NationalLongName]
			   ,@LangID AS [langid]
			   ,ISNULL(PT.blnFreeze,0) AS [blnFreeze]	  
			   ,CAST(CASE WHEN dbo.FN_ADMIN_FF_DesignLanguageForParameter_GET(@LangID, PT.[idfsParameter], @idfsFormTemplate) = @langid_int
						  THEN 1
						  ELSE 0
						  END AS BIT) AS [blnIsRealStruct] 
			   ,P.idfsParameterCaption	
		FROM [dbo].[ffParameterForTemplate] PT
		INNER JOIN dbo.ffParameterDesignOption PDO
		ON PT.idfsParameter = PDO.idfsParameter
		   AND PT.idfsFormTemplate = PDO.idfsFormTemplate
		   AND PDO.idfsLanguage = dbo.fnFFGetDesignLanguageForParameter(@LangID, PT.[idfsParameter], @idfsFormTemplate)
		   AND PDO.[intRowStatus] = 0
		INNER JOIN dbo.ffParameter P
		ON PT.idfsParameter = P.idfsParameter
		   AND P.[intRowStatus] = 0
		INNER JOIN dbo.trtBaseReference B 
		ON B.[idfsBaseReference] = P.idfsParameterCaption
		   AND B.[intRowStatus] = 0
		INNER JOIN dbo.trtBaseReference B1
		ON B1.[idfsBaseReference] = P.[idfsParameter]
		   AND B1.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT
		ON SNT.[idfsBaseReference] = P.idfsParameterCaption
		   AND SNT.idfsLanguage = @langid_int
		   AND SNT.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT1
		ON (SNT1.[idfsBaseReference] = P.[idfsParameter]
			AND SNT1.[idfsLanguage] = @langid_int)
		   AND SNT1.[intRowStatus] = 0
		WHERE (PT.[idfsFormTemplate] = @idfsFormTemplate
			   OR @idfsFormTemplate IS NULL)
			  AND (PT.[idfsParameter] = @idfsParameter
				   OR @idfsParameter IS NULL)
			  AND PT.intRowStatus = 0	
		ORDER BY PDO.[intOrder]

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

