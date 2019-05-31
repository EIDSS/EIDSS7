
/*
--=====================================================================
-- LASt modified date:		10/21/2017
-- LASt modified by:		Mandar Kulkarni
-- Description:				Function to get details from GIS Base reference table for 
--							for provided language code AND reference type
-- Testing code:
-- SELECT * from fnGisReference('en',19000001)
*/
CREATE FUNCTION [dbo].[FN_GBL_LKUP_GISBaseReference_GetList]
(
 @LangID				NVARCHAR(50), 
 @GISReferenceType		BIGINT
)
RETURNS TABLE
AS
	RETURN
		(
			SELECT	b.idfsGISBaseReference as idfsReference, 
					ISNULL(c.strTextString, b.strDefault) as [name],
					b.idfsGISReferenceType, 
					b.strDefault, 
					ISNULL(c.strTextString, b.strDefault) as LongName,
					b.intOrder
			FROM		dbo.gisBaseReference as b 
			LEFT JOIN	dbo.gisStringNameTranslation as c 
			ON			b.idfsGISBaseReference = c.idfsGISBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			AND			c.intRowStatus = 0
			WHERE		b.idfsGISReferenceType = @GISReferenceType
			AND			b.intRowStatus = 0
		)
