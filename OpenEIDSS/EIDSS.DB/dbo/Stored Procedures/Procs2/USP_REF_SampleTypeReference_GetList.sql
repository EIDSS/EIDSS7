
--=====================================================================================================
-- Author:		Original Author Unknown
-- Description:	Returns a list of active sample type references
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/10/24	Initial Reference
-- Ricky Moss		12/13/2018	Removed return code and usp_HACode_GetCheckList Store procedure
-- 
-- Test Code:
-- exec USP_REF_SAMPLETYPEREFERENCE_GETList 'en';
-- 
--=====================================================================================================

CREATE PROCEDURE [dbo].[USP_REF_SampleTypeReference_GetList]
( 
	@LangID  NVARCHAR(50) -- language ID
)
AS
BEGIN
BEGIN TRY
	SELECT 
		st.[idfsSampleType],
		stbr.strDefault,
		stbr.name,
		st.[strSampleCode],
		stbr.[intHACode],
		dbo.FN_GBL_HACode_ToCSV(@LangID, stbr.[intHACode]) as [strHACode],
		dbo.FN_GBL_HACodeNames_ToCSV(@LangID, stbr.[intHACode]) as [strHACodeNames],
		stbr.[intOrder]
	
	FROM dbo.[trtSampleType] as st  -- Sample Type	
	INNER JOIN dbo.FN_GBL_ReferenceRepair(@LangId, 19000087)  as stbr -- Sample Type base reference
		ON st.[idfsSampleType] = stbr.[idfsReference]
	WHERE st.[intRowStatus] = 0	
	ORDER BY 
		stbr.[intOrder],[strDefault];

	--2 - HACodesList
	--EXEC usp_HACode_GetCheckList @LangID;

END TRY

BEGIN CATCH
	THROW;
END CATCH

END
