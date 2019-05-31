
----------------------------------------------------------------------------
-- Name 				: FN_GBL_Reference_GETList
-- Description			: Returns reference data and translation of language
--                        code passed
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
--
--
-- Testing code:-- SELECT * FROM dbo.FN_GBL_Reference_GETList('ru',19000040)
----------------------------------------------------------------------------
----------------------------------------------------------------------------

CREATE FUNCTION [dbo].[FN_GBL_Reference_GETList](@LangID  NVARCHAR(50), @type BIGINT)
RETURNS TABLE
AS

RETURN(
		SELECT
					b.idfsBaseReference AS idfsReference, 
					ISNULL(c.strTextString, b.strDefault) AS name,
					b.idfsReferenceType, 
					b.intHACode, 
					b.strDefault, 
					c.strTextString,
					ISNULL(c.strTextString, b.strDefault) AS LongName,
					b.intOrder

		FROM		dbo.trtBASeReference AS b with(index=IX_trtBASeReference_RR)
		LEFT JOIN	dbo.trtStringNameTranslatiON AS c WITH(INDEX=IX_trtStringNameTranslation_BL)
		ON			b.idfsBASeReference = c.idfsBASeReference AND c.idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)

		WHERE		b.idfsReferenceType = @type and b.intRowStatus = 0 
	)



