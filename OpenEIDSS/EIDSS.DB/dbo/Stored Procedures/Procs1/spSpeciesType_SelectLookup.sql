
--##SUMMARY

--##REMARKS Author:
--##REMARKS Create date:

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  dbo.spSpeciesType_SelectLookup 'en', 32
*/


CREATE PROCEDURE [dbo].[spSpeciesType_SelectLookup] (
	@LangID AS NVARCHAR(50), --##PARAM @LangID - language ID
	@HACode AS INT = NULL  --##PARAM @HACode - bit mask that defines Area where species type are used (LiveStock or avian)
)
AS

	SELECT 
		sl.idfsReference
		, sl.name
		, sl.intHACode
		, sl.intOrder
		, sl.intRowStatus
	FROM dbo.fnReferenceRepair(@LangID, 19000086 /*Species List*/) sl
	JOIN trtSpeciesType tst ON
		tst.idfsSpeciesType = sl.idfsReference
	WHERE @HACode = 0 
		OR @HACode IS NULL 
		OR sl.intHACode IS NULL 
		OR sl.intHACode & @HACode > 0
	ORDER BY sl.intOrder
		, sl.name  
