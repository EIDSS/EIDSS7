
--=====================================================================================================
-- Name: USP_REF_VectorSubType_GETList
-- Description:	Returns a list of active vector subtypes
-- 
-- Author:		Ricky Moss
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/19/2018	Initial Release
-- Ricky Moss		01/17/2019	Remove return code
--
-- Test Code:
-- exec USP_REF_VectorSubType_GETList 'ar', 6619360000000;
-- exec USP_REF_VectorSubType_GETList 'en', 6619340000000;
--=====================================================================================================

CREATE PROCEDURE [dbo].[USP_REF_VectorSubType_GETList]
(
	@LangID  NVARCHAR(50), -- language ID
	@idfsVectorType BIGINT
)
AS
BEGIN
BEGIN TRY
	SELECT
		vst.[idfsVectorSubType], 
		vst.[idfsVectorType],
		vstbr.idfsReferenceType as idfsVectorSubTypeReferenceType,
		vtbr.[name] as [VectorType],
		vstbr.[strDefault] as [strDefault],
		vstbr.[name] as [strName],
		vst.[strCode],
		vstbr.intOrder

	FROM dbo.[trtVectorSubType] as vst -- Vector Sub Type (aka Vector Species Type)
	INNER JOIN dbo.FN_GBL_Reference_GETList(@LangID, 19000141) vstbr
	ON vst.idfsVectorSubType = vstbr.idfsReference
	INNER JOIN dbo.FN_GBL_Reference_GETList(@LangID, 19000140) vtbr
	ON vst.idfsVectorType = vtbr.idfsReference
	WHERE 
		vst.[intRowStatus] = 0
		AND vst.idfsVectorType = @idfsVectorType
	ORDER BY
		vstbr.[intOrder] asc,
		vstbr.[strDefault] asc;
END TRY
BEGIN CATCH
	THROW;
END CATCH

END
