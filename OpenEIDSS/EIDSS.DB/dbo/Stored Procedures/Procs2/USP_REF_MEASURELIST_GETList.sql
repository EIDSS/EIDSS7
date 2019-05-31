-- ============================================================================
-- Name: USP_REF_MEASURELIST_GETList
-- Description:	Get the measure list references for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/22/2018 Initial release.
-- Ricky Moss		01/18/2019 Remove return codes;
--
-- exec USP_REF_MEASURELIST_GETList 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_MEASURELIST_GETList]
(
 @LangID nvarchar(50)
)
 AS
 BEGIN
 BEGIN TRY
		SELECT 
			trtReferenceType.idfsReferenceType 
			,mr.[name] as strReferenceTypeName
			,trtReferenceType.intStandard
			,CAST (NULL as bigint) idfsCurrentReferenceType 
		FROM dbo.FN_GBL_Reference_GETList(@LangID, 19000076) mr
		INNER JOIN trtReferenceType ON
			trtReferenceType.idfsReferenceType = mr.idfsReference 
		WHERE 
			trtReferenceType.idfsReferenceType = 19000074
			OR trtReferenceType.idfsReferenceType = 19000079
		ORDER BY 
		strReferenceTypeName
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
 END
