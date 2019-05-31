
--*************************************************************
-- Name 				: FN_GBL_ReferenceRepair
-- Description			: The FUNCTION returns all the reference values 
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- SELECT * FROM FN_GBL_ReferenceRepair('ru',19000040)
--*************************************************************
-- SELECT all reference values - with deleted values
CREATE FUNCTION[dbo].[FN_GBL_ReferenceRepair]
(
 @LangID	NVARCHAR(50), 
 @type		BIGINT
 )
RETURNS TABLE
AS

	RETURN(
			SELECT		b.idfsBaseReference as idfsReference, 
						IsNull(c.strTextString, b.strDefault) as [name],
						b.idfsReferenceType, 
						b.intHACode, 
						b.strDefault, 
						IsNull(c.strTextString, b.strDefault) as LongName,
						b.intOrder,
						b.intRowStatus

			FROM		dbo.trtBaseReference as b with(index=IX_trtBaseReference_RR)
			LEFT JOIN	dbo.trtStringNameTranslation as c with(index=IX_trtStringNameTranslation_BL)
			ON			b.idfsBaseReference = c.idfsBaseReference and c.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

			WHERE		b.idfsReferenceType = @type --and = 0 
		)



