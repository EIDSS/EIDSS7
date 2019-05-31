--*************************************************************
-- Name 				: [FN_GBL_GIS_Reference]
-- Description			: The FUNCTION returns GIS reference details for given type and language
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- SELECT * FROM FN_GBL_GIS_Reference('ru',19000001)
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_GIS_Reference]
(
 @LangID	NVARCHAR(50), 
 @type		BIGINT
)
RETURNS TABLE
AS
	RETURN(

			SELECT
						b.idfsGISBaseReference AS idfsReference, 
						IsNull(c.strTextString, b.strDefault) AS [name],
						b.idfsGISReferenceType, 
						b.strDefault, 
						IsNull(c.strTextString, b.strDefault) AS LongName,
						b.intOrder

			FROM		dbo.gisBaseReference AS b 
			LEFT JOIN	dbo.gisStringNameTranslation AS c 
			ON			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
			AND			c.intRowStatus = 0

			WHERE		b.idfsGISReferenceType = @type
			AND			b.intRowStatus = 0
		)











