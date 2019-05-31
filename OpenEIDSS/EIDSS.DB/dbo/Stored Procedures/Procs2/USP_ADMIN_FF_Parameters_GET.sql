
-- ================================================================================================
-- Name: USP_ADMIN_FF_Parameters_GET
-- Description: Gets list of the Parameters.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru   11/28/2018 Initial release for new API.
-- ================================================================================================
/*
exec dbo.spFFGetParameters 'en', null, 10034012
exec dbo.spFFGetParameters 'en', null, 10034023
exec dbo.spFFGetParameters 'en', null, 10034024
exec dbo.spFFGetParameters 'en', null, 10034021
exec dbo.spFFGetParameters 'en', null, 10034022
exec EIDSS_version6_actual.dbo.spFFGetParameters 'en', null, 10034022
*/
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Parameters_GET]
(
	@LangID NVARCHAR(50) = NULL
	,@idfsSection BIGINT = NULL
	,@idfsFormType BIGINT = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL) SET @LangID = 'en';
	
	DECLARE
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY
	
		SET @langid_int = dbo.fnGetLanguageCode(@LangID);	

		SELECT P.[idfsParameter]
			   ,P.[idfsSection] -- null
			   ,P.[idfsFormType] 
			   ,FPRO.[intScheme] -- 0
			   ,P.[idfsParameterType] -- string const
			   ,ISNULL(FR1.[name],FR1.[strDefault]) AS [ParameterTypeName]  --   
			   ,P.[idfsEditor] --,P.[intControlType] -- text box
			   ,P.[idfsParameterCaption] -- null
			   ,P.[intOrder] -- intorder from stub
			   ,ISNULL(P.[strNote], '') AS [strNote] -- null
			   ,ISNULL(P.[intHACode], -1) AS [intHACode] -- null
			   ,FPRO.[intLabelSize] -- 0
			   ,FPRO.[intTop] -- 0
			   ,FPRO.[intLeft]-- 0
			   ,FPRO.[intWidth] -- to column new field
			   ,FPRO.[intHeight] -- 0
			   ,FPRO.[idfsFormTemplate] -- null    
			   ,P.[intRowStatus] --0
			   ,ISNULL(B2.[strDefault], '') AS [DefaultName]
			   ,ISNULL(B1.[strDefault], '') AS [DefaultLongName]
			   ,ISNULL(SNT2.[strTextString], B2.[strDefault]) AS [NationalName]
			   ,ISNULL(SNT1.[strTextString], B1.[strDefault]) AS [NationalLongName]
			   ,@LangID As [langid]
			   ,1 AS [IsRealParameter]
		FROM [dbo].[ffParameter] P
		INNER JOIN dbo.trtBaseReference B1
		ON B1.[idfsBaseReference] = P.[idfsParameter]
		   AND B1.[intRowStatus] = 0
		INNER JOIN dbo.ffParameterDesignOption FPRO
		ON P.[idfsParameter] = FPRO.[idfsParameter]
		   AND FPRO.idfsLanguage = dbo.FN_ADMIN_FF_DesignLanguageForParameter_GET(@LangID, P.[idfsParameter], NULL)
		   AND FPRO.[intRowStatus] = 0
		LEFT JOIN dbo.trtBaseReference B2
		ON B2.[idfsBaseReference] = P.[idfsParameterCaption]
		   AND B2.[intRowStatus] = 0
		LEFT JOIN dbo.FN_GBL_Reference_List_GET(@LangID, 19000071 /*'rftParameterType'*/) FR1
		ON FR1.[idfsReference] = P.[idfsParameterType]
		LEFT JOIN dbo.trtStringNameTranslation SNT1
		ON (SNT1.[idfsBaseReference] = P.[idfsParameter]
			AND SNT1.[idfsLanguage] = @langid_int)
		   AND SNT1.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT2
		ON (SNT2.[idfsBaseReference] = P.[idfsParameterCaption]
			AND SNT2.[idfsLanguage] = @langid_int)
		   AND SNT2.[intRowStatus] = 0
		WHERE (P.idfsSection = @idfsSection OR @idfsSection IS NULL)
			  AND (P.idfsFormType = @idfsFormType OR @idfsFormType IS NULL)
			  AND (FPRO.idfsFormTemplate IS NULL)	
			  AND (P.intRowStatus = 0)
	
		UNION ALL

		SELECT mc.idfsMatrixColumn AS idfsParameter
			   ,NULL AS idfsSection -- null
			   ,mt.idfsFormType	AS idfsFormType 
			   ,0 AS intScheme -- 0
			   ,mc.idfsParameterType AS idfsParameterType -- string const
			   ,ref_pt.[name] AS ParameterTypeName     
			   ,mc.idfsEditor AS idfsEditor -- text box
			   ,NULL AS idfsParameterCaption -- null
			   ,mc.intColumnOrder AS intOrder -- intorder from stub
			   ,NULL AS strNote -- null
			   ,0 AS intHACode -- null
			   ,0 AS intLabelSize -- 0
			   ,0 AS intTop -- 0
			   ,0 AS intLeft -- 0
			   ,mc.intWidth	AS intWidth -- 
			   ,0 AS intHeight -- 0
			   ,NULL AS idfsFormTemplate -- null    
			   ,0 AS intRowStatus --0
			   ,ISNULL(ref_mc.strDefault, '') AS DefaultName
			   ,ISNULL(ref_mc.strDefault	, '') AS DefaultLongName
			   ,ISNULL(ref_mc.[name], '') AS NationalName
			   ,ISNULL(ref_mc.[name], '') AS NationalLongName
			   ,@LangID	AS [langid]
			   ,0 AS [IsRealParameter]
		FROM trtMatrixColumn mc
		INNER JOIN trtMatrixType mt
		ON mt.idfsMatrixType = mc.idfsMatrixType
		   AND mt.intRowStatus = 0
		LEFT JOIN dbo.fnReference(@LangID, 19000071 /*rftParameterType*/) ref_pt 
		ON ref_pt.[idfsReference] = mc.idfsParameterType
		LEFT JOIN dbo.fnReference(@LangID, 19000152 /*rftMatrixColumn*/) ref_mc
		ON ref_mc.[idfsReference] = mc.idfsMatrixColumn		
		WHERE mc.intRowStatus = 0	
			  AND mt.idfsFormType = @idfsFormType
			  AND @idfsSection IS NULL
		ORDER BY [NationalName], P.[intOrder]-- 21, 9 
		
		--COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		--IF @@TRANCOUNT > 0 
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

