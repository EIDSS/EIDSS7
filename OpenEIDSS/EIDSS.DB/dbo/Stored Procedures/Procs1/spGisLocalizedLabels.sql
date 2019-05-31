



--##SUMMARY Select localized labels for GIS objects
--##SUMMARY Used by map for rendering localized labels
--##RETURNS Table with GIS reference ID and localized field 'name'

--##REMARKS Author: Nikulin E.
--##REMARKS Create date: 24.06.2010


/*
	Dependences
		Tables:
			dbo.gisBaseReference
			dbo.gisStringNameTranslation
		Functions:
			dbo.fnGetLanguageCode
*/

/*
--Example of procedure call:
DECLARE @LangID NVARCHAR(50)
DECLARE @type BIGINT

SET @LangID = 'ru'	 	
SET @type = 19000001 --rftCountry

EXECUTE spGisLocalizedLabels
   @LangID
  ,@type
*/

CREATE PROCEDURE [dbo].[spGisLocalizedLabels]
	@LangID  NVARCHAR(50),	--##PARAM @LangID - Language ID
	@type BIGINT			--##PARAM @type - GIS reference Type
AS
			SELECT
			b.idfsGISBaseReference AS [Id], 
				IsNull(c.strTextString, b.strDefault) AS [name]
			FROM
			dbo.gisBaseReference AS b WITH(NOLOCK)
			LEFT JOIN dbo.gisStringNameTranslation AS c WITH(NOLOCK)
			ON b.idfsGISBaseReference=c.idfsGISBaseReference and idfsLanguage=dbo.fnGetLanguageCode(@LangID)
				AND c.intRowStatus = 0
			WHERE b.idfsGISReferenceType=@type
				AND b.intRowStatus = 0

