
--=====================================================================================================
-- Author:		Original Author Unknown
-- Description:	Returns three (3) result sets.
--
-- 1) List of laboratory sample types available with details
-- 2) results of the stored procedure usp_HACode_GetCheckList.
-- 3) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Philip Shaffer	2018/09/24 Created for EIDSS 7.0 based on 6.1 procedure spSampleTypeReference_SelectDetail.
--
-- 
-- Test Code:
-- declare @LangID nvarchar(50) = N'en';
-- exec USP_REF_SampleType_GetDetail @LangID with recompile;
-- 
--=====================================================================================================

CREATE PROCEDURE [dbo].[USP_REF_SampleType_GetDetail]
( 
	@LangID  NVARCHAR(50) -- language ID
)
AS
BEGIN

SET NOCOUNT ON;

DECLARE
@returnMsg			NVARCHAR(max) = N'Success',
@returnCode			BIGINT = 0;

DECLARE
@LanguageCodeEn		BIGINT = dbo.fnGetLanguageCode(N'en'),		-- English
@LanguageCodeNl		BIGINT = dbo.fnGetLanguageCode(@LangID);	-- National

BEGIN TRY

	-- 0 BaseReference
	SELECT 
		st.[idfsSampleType],
		stbr.[idfsReferenceType],
		COALESCE(stsntDnEn.[strTextString], stbr.[strDefault]) as [strDisplaySampleTypeNameEnglish],
		stsntDnNl.[strTextString] as [strDisplaySampleTypeNameNational],
		st.[strSampleCode],
		stbr.[intHACode],
		dbo.FN_GBL_HACode_ToCSV(@LangID, stbr.[intHACode]) as [strHACodeCSV],
		dbo.FN_GBL_HACodeNames_ToCSV(@LangID, stbr.[intHACode]) as [strHACodeNamesCSV],
		stbr.[intOrder],
		stbr.[blnSystem],
		st.[intRowStatus]
	
	FROM dbo.[trtSampleType] as st  -- Sample Type
	
	INNER JOIN dbo.[trtBaseReference] as stbr -- Sample Type base reference
		ON st.[idfsSampleType] = stbr.[idfsBaseReference]
	
	LEFT OUTER JOIN dbo.[trtStringNameTranslation] as stsntDnEn -- Sample Type Display Name English 
		ON stbr.[idfsBaseReference] = stsntDnEn.[idfsBaseReference] 
		and stsntDnEn.[idfsLanguage] = @LanguageCodeEn
	
	LEFT OUTER JOIN dbo.[trtStringNameTranslation] as stsntDnNl -- Sample Type Display Name National 
		ON stbr.[idfsBaseReference] = stsntDnNl.[idfsBaseReference] 
		and stsntDnNl.[idfsLanguage] = @LanguageCodeNl
	
	WHERE 
		stbr.[idfsReferenceType] = 19000087 -- type "Sample Type"
		and st.[intRowStatus] = 0
	
	ORDER BY 
		stbr.[intOrder] asc,
		[strDisplaySampleTypeNameEnglish];

	/*
	-- 1 ReferenceType
	SELECT 
		trtReferenceType.idfsReferenceType 
		,dbo.fnReference.name as strReferenceTypeName
		,trtReferenceType.intStandard
		,CAST (NULL as bigint) idfsCurrentReferenceType 
	FROM dbo.fnReference(@LangID, 19000076)
	INNER JOIN trtReferenceType ON
		trtReferenceType.idfsReferenceType = dbo.fnReference.idfsReference 
	WHERE 
		trtReferenceType.idfsReferenceType =19000087 --rftSpecimenType

	order by 
		strReferenceTypeName
	*/

	--2 - HACodesList
	EXEC usp_HACode_GetCheckList @LangID;

	/*
	--3 --master ReferenceType
	SELECT 
		CAST (19000087 as bigint) idfsReferenceType 
	*/

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
