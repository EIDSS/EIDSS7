
--=====================================================================================================
-- Name: USP_REF_VECTORTYPEREFERENCE_GETList
-- Description:	Returns a list of active vector types
--
-- Author:		Philip Shaffer
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Philip Shaffer	2018/09/26 Initial release
-- Ricky Moss		2018/10/01 Modified USP_REF_VECTORTYPEREFERENCE from EIDSS 7.0
-- Ricky Moss		2019/01/11 Remove return codes
-- Ricky Moss		2019/01/28 Removed deprecated stored procedures
-- Test Code:
-- exec USP_REF_VECTORTYPEREFERENCE_GETList 'ar';
-- 
--=====================================================================================================


CREATE PROCEDURE [dbo].[USP_REF_VECTORTYPEREFERENCE_GETList]
(		
	@LangID  NVARCHAR(50)
)
AS
BEGIN
BEGIN TRY

	SELECT
		vt.idfsVectorType,
		br.strDefault as strDefault,
		br.[name] as strName,	
		vt.[strCode],
		vt.[bitCollectionByPool],
		br.[intOrder],
		vt.[intRowStatus]
	
	FROM dbo.[trtVectorType] as vt -- Vector Type
	INNER JOIN FN_GBL_Reference_GETList(@LangID, 19000140) AS br
	ON vt.idfsVectorType = br.idfsReference AND vt.intRowStatus = 0
	
	ORDER BY
		br.[intOrder] asc,
		br.strDefault;
END TRY
BEGIN CATCH
	THROW;
END CATCH

END
