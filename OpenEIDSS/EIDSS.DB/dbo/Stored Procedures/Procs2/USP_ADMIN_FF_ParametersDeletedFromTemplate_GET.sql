
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParametersDeletedFromTemplate_GET
-- Description: Retrieves the list of Parameters deleted from template 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParametersDeletedFromTemplate_GET]
(	
	@idfObservation BIGINT
	,@LangID NVARCHAR(50)
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE
		@idfsFormTemplate BIGINT,
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY
	
		SELECT @idfsFormTemplate = idfsFormTemplate
		FROM dbo.tlbObservation
		WHERE idfObservation = @idfObservation
	
		IF (@LangID IS NULL)
			SET @LangID = 'en';
	
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
	
		SELECT DISTINCT AP.idfsParameter
						,O.idfsFormTemplate
						,AP.idfObservation
						,B2.[strDefault] AS [DefaultName]
						,B1.[strDefault] AS [DefaultLongName]
						,ISNULL(SNT2.[strTextString], B2.[strDefault]) AS [NationalName]
						,ISNULL(SNT1.[strTextString], B1.[strDefault]) AS [NationalLongName]
						,P.idfsParameterType
						,P.intHACode
						,P.idfsEditor
						,PDO.intLeft
						,PDO.intTop
						,PDO.intWidth
						,PDO.intHeight
						,PDO.intLabelSize
						,PDO.intScheme
						,PDO.intOrder
						,@LangID As [langid]
						,P.idfsFormType
		FROM dbo.tlbActivityParameters AP 
		LEFT JOIN dbo.ffParameterForTemplate PT
		ON PT.idfsParameter = AP.idfsParameter
		   AND PT.idfsFormTemplate = @idfsFormTemplate
		   AND PT.intRowStatus = 0
		INNER JOIN dbo.tlbObservation O
		ON AP.idfObservation = O.idfObservation
		   AND O.intRowStatus = 0
		INNER JOIN dbo.ffParameter P
		ON P.idfsParameter = AP.idfsParameter
		   AND P.intRowStatus = 0
		INNER JOIN dbo.ffParameterDesignOption PDO
		ON (AP.idfsParameter = PDO.idfsParameter)
		   AND (PDO.idfsFormTemplate IS NULL)
		   AND (PDO.idfsLanguage = dbo.FN_ADMIN_FF_DesignLanguageForParameter_GET(@LangID, PT.[idfsParameter], @idfsFormTemplate)) 
		   AND (PDO.intRowStatus = 0)
		INNER JOIN dbo.trtBaseReference B1
		ON B1.[idfsBaseReference] = P.[idfsParameter]
		   AND B1.[intRowStatus] = 0
		LEFT JOIN dbo.trtBaseReference B2
		ON B2.[idfsBaseReference] = P.[idfsParameterCaption]
		   AND B2.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT1
		ON (SNT1.[idfsBaseReference] = P.[idfsParameter]
			AND SNT1.[idfsLanguage] = @langid_int)
		   AND SNT1.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT2
		ON (SNT2.[idfsBaseReference] = P.[idfsParameterCaption]
			AND SNT2.[idfsLanguage] = @langid_int)
		   AND SNT2.[intRowStatus] = 0
		WHERE AP.intRowStatus = 0
			  AND PT.idfsParameter IS NULL
			  AND (AP.idfObservation = @idfObservation)

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

