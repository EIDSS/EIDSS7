
--=====================================================================================================
-- Author:		Zhdanova A.
-- Description:	Returns two (2) result sets.
--
-- 1) Selects vector type reference detail data for reference editor
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Zhdanova A.		2011/09/12 Initial creation for 6.1 or earlier
-- Philip Shaffer	2018/09/26 Modified for EIDSS 7.0 and renamed from spVectorTypeReference_SelectDetail
--
-- 
-- Test Code:
-- declare @LangID nvarchar(50) = N'en';
-- exec USP_REF_VectorTypeReference_GetDetail @LangID with recompile;
-- 
--=====================================================================================================


CREATE PROCEDURE [dbo].[USP_REF_VectorTypeReference_GetDetail]
(		
	@LangID  NVARCHAR(50) -- Language ID
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
		vtbr.[idfsBaseReference],
		vtbr.[idfsReferenceType],
		COALESCE(sntDnEn.[strTextString], vtbr.[strDefault]) as [strDisplayNameEnglish],
		sntDnNl.[strTextString] as [strDisplayNameNational],	
		vt.[strCode],
		vt.[bitCollectionByPool],
		vtbr.[intOrder],
		vt.[intRowStatus]
	
	FROM dbo.[trtVectorType] as vt -- Vector Type

	INNER JOIN dbo.[trtBaseReference] as vtbr	 -- Vector Type base reference
		ON vt.[idfsVectorType] = vtbr.[idfsBaseReference]

	LEFT OUTER JOIN dbo.[trtStringNameTranslation] as sntDnEn -- Vector Type Display Name English
		ON vtbr.[idfsBaseReference] = sntDnEn.[idfsBaseReference]
		AND sntDnEn.[idfsLanguage] = @LanguageCodeEn
	
	LEFT OUTER JOIN dbo.[trtStringNameTranslation] as sntDnNl -- Vector Type Display Name National
		ON vtbr.[idfsBaseReference] = sntDnNl.[idfsBaseReference]
		AND sntDnNl.[idfsLanguage] = @LanguageCodeNl
	
	WHERE
		vtbr.[idfsReferenceType] = 19000140 -- type code/name "rftVectorType", "Vector type" 
		AND vt.[intRowStatus] = 0
	
	ORDER BY
		vtbr.[intOrder] asc,
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
