
--##SUMMARY This procedure 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetNameOfInvestigationOrMeasureSelectLookup 'en'

*/ 
 
CREATE PROCEDURE [dbo].[spRepVetNameOfInvestigationOrMeasureSelectLookup]
	@LangID AS VARCHAR(36)
AS
BEGIN
	
	SELECT
		idfsReference
		, strName
		, ROW_NUMBER() OVER (ORDER BY a, intOrder, strName) AS intOrder
	FROM (
		SELECT 
			idfsReference 
			, [name] as strName
			, intOrder
			, 1 a
		FROM fnReference(@LangID, 19000021 /*Diagnostic Investigation List*/)
		UNION ALL
		SELECT 
			idfsReference 
			, [name] as strName
			, intOrder
			, 2
		FROM fnReference(@LangID, 19000074 /*Prophylactic Measure List*/)
	) x

END
