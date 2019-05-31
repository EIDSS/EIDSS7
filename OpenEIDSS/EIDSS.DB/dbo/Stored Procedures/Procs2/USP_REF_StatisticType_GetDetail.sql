
--=====================================================================================================
-- Author:		Original Author Unknown
-- Description:	Returns two (2) result sets.
--
-- 1) Selects detail data for statistic types
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Philip Shaffer	2018/09/26 Created for EIDSS 7.0 based on 6.1 procedure spStatisticType_SelectDetail.
--
-- 
-- Test Code:
-- declare @LangID nvarchar(50) = N'en';
-- exec USP_REF_StatisticType_GetDetail @LangID with recompile;
-- 
--=====================================================================================================

CREATE PROCEDURE [dbo].[USP_REF_StatisticType_GetDetail]
(
	@LangID		NVARCHAR(50)
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE
@returnMsg			NVARCHAR(max) = N'Success',
@returnCode			BIGINT = 0;

DECLARE
@LanguageCodeEn		BIGINT = dbo.fnGetLanguageCode(N'en'),   -- Language code english
@LanguageCodeNl		BIGINT = dbo.fnGetLanguageCode(@LangID); -- Language code national

BEGIN TRY


	SELECT
		ROW_NUMBER() OVER (ORDER BY br.[intOrder] asc, COALESCE(sntDnEn.[strTextString], br.[strDefault]) asc) as [intRowNumber], 
		sdt.[idfsStatisticDataType] as [idfsBaseReference],
		sdt.[idfsReferenceType],
		COALESCE(sntDnEn.[strTextString], br.[strDefault]) as [strDisplayNameEnglish],
		sntDnNl.[strTextString] as [strDisplayNameNational],
		CAST(N'<parameter type info needed here>' as NVARCHAR(50)) as [strParameterTypeInfo], -- parameter type info needed per use case SAUC49
		COALESCE(sdt.[blnRelatedWithAgeGroup], 0) as [blnStatisticalAgeGroup],  -- statistical age group info needed per use case SAUC49
		sdt.[idfsStatisticPeriodType],
		COALESCE(sntPtEn.[strTextString], brPt.[strDefault]) as [strDisplayPeriodTypeEnglish],
		sntPtNl.[strTextString] as [strDisplayPeriodTypeNational], 
		sdt.[idfsStatisticAreaType],
		COALESCE(sntAtEn.[strTextString], brAt.[strDefault]) as [strDisplayAreaTypeEnglish],
		sntAtNl.[strTextString] as [strDisplayAreaTypeNational], 
		br.[blnSystem],
		br.[intRowStatus]

	FROM [trtStatisticDataType] as sdt -- Statistic Data Type

	INNER JOIN [trtBaseReference] as br	-- Statistic Data Type base reference
		ON sdt.idfsStatisticDataType = br.idfsBaseReference

	LEFT OUTER JOIN [trtStringNameTranslation] as sntDnEn -- Display Name English
		ON br.idfsBaseReference = sntDnEn.idfsBaseReference
		AND sntDnEn.idfsLanguage = @LanguageCodeEn

	LEFT OUTER JOIN [trtStringNameTranslation] as sntDnNl -- Display Name National
		ON br.idfsBaseReference = sntDnNl.idfsBaseReference
		AND sntDnNl.idfsLanguage = @LanguageCodeNl

	LEFT OUTER JOIN [trtBaseReference] as brPt -- Period Type base reference
		ON sdt.[idfsStatisticPeriodType] = brPt.[idfsBaseReference]

	LEFT OUTER JOIN [trtStringNameTranslation] as sntPtEn -- Period Type English
		ON sdt.[idfsStatisticPeriodType] = sntPtEn.[idfsBaseReference]
		AND sntPtEn.[idfsLanguage] = @LanguageCodeEn 

	LEFT OUTER JOIN [trtStringNameTranslation] as sntPtNl -- Period Type National
		ON sdt.[idfsStatisticPeriodType] = sntPtNl.[idfsBaseReference]
		AND sntPtNl.[idfsLanguage] = @LanguageCodeEn 

	LEFT OUTER JOIN [trtBaseReference] as brAt -- Area Type base reference
		ON sdt.[idfsStatisticAreaType] = brAt.[idfsBaseReference]

	LEFT OUTER JOIN [trtStringNameTranslation] as sntAtEn -- Area Type English
		ON sdt.[idfsStatisticAreaType] = sntAtEn.[idfsBaseReference]
		AND sntAtEn.[idfsLanguage] = @LanguageCodeEn 

	LEFT OUTER JOIN [trtStringNameTranslation] as sntAtNl -- Period Type National
		ON sdt.[idfsStatisticAreaType] = sntAtNl.[idfsBaseReference]
		AND sntAtNl.[idfsLanguage] = @LanguageCodeEn 

	WHERE
		sdt.[intRowStatus] = 0

	ORDER BY
		br.[intOrder] asc,
		[strDisplayNameEnglish]
	;


	SELECT @returnCode, @returnMsg;
END TRY

BEGIN CATCH
	SET @returnCode = ERROR_NUMBER();
	SET @returnMsg = N'ErrorNumber: ' + CONVERT(NVARCHAR, ERROR_NUMBER()) 
					+ N' ErrorSeverity: ' + CONVERT(NVARCHAR, ERROR_SEVERITY())
					+ N' ErrorState: ' + CONVERT(NVARCHAR, ERROR_STATE())
					+ N' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), N'')
					+ N' ErrorLine: ' +  CONVERT(NVARCHAR, ISNULL(ERROR_LINE(), N''))
					+ N' ErrorMessage: ' + ERROR_MESSAGE();

	SELECT @returnCode, @returnMsg;
END CATCH

END
