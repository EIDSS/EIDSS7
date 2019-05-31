-- ============================================================================
-- Name: USP_REF_MEASUREREFERENCE_GETList
-- Description:	Get the measure references for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		02/12/2018 Initial release.
--
-- exec USP_REF_BASEREFERENCE_GETList 19000146, 'en'
-- exec USP_REF_BASEREFERENCE_GETList 19000087, 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_BASEREFERENCE_GETList]
	@idfsReferenceType	BIGINT,
	@LangID				NVARCHAR(50)
AS
BEGIN	
	BEGIN TRY
		
		SELECT 
			br.[idfsBaseReference], 
			br.[idfsReferenceType], 
			br.[strDefault], 
			brs.name AS strName,
			br.[intHACode], 
			dbo.FN_GBL_HACode_ToCSV(@LangID,br.[intHACode]) AS strHACode,			
			dbo.FN_GBL_HACodeNames_ToCSV(@LangID,br.[intHACode]) AS strHACodeNames,
			br.[intOrder]
		FROM  dbo.trtBaseReference br
		JOIN dbo.FN_GBL_ReferenceRepair(@LangID, @idfsReferenceType) brS
		ON br.idfsBaseReference = brs.idfsReference 
		WHERE br.[idfsReferenceType] = @idfsReferenceType AND br.intRowStatus = 0 AND brs.intRowStatus = 0
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END