

--##SUMMARY Selects data for SpeciesTypeReferenceDetail form

--##REMARKS Author: Vdovin
--##REMARKS Create date: 29.09.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

EXEC spSpeciesTypeReference_SelectDetail 'en'

*/





CREATE     PROCEDURE [dbo].[spSpeciesTypeReference_SelectDetail] 
	@LangID  nvarchar(50) --##PARAM @LangID - language ID
AS
-- 0 BaseReference
SELECT trtBaseReference.idfsBaseReference
      ,trtBaseReference.idfsReferenceType
      ,trtBaseReference.strBaseReferenceCode
      ,ISNULL(trtStringNameTranslation.strTextString, trtBaseReference.strDefault) AS [name]
	  ,trtBaseReference.strDefault
      ,trtBaseReference.intHACode
      ,trtBaseReference.intOrder
	  ,trtSpeciesType.strCode
	  ,trtSpeciesType.intRowStatus
FROM trtBaseReference
INNER JOIN trtReferenceType ON 
	trtReferenceType.idfsReferenceType = trtBaseReference.idfsReferenceType
left join	trtStringNameTranslation ON	
	trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference 
	and trtStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
LEFT JOIN	trtSpeciesType ON
	trtSpeciesType.idfsSpeciesType = trtBaseReference.idfsBaseReference
WHERE 
	trtReferenceType.idfsReferenceType =19000086 --rftSpeciesList
	AND trtBaseReference.intRowStatus = 0
ORDER BY 
	trtBaseReference.intOrder
	,trtBaseReference.strDefault
	,[name]

/*
-- 1 ReferenceType
SELECT 
	trtReferenceType.idfsReferenceType 
	,dbo.fnReference.name as strReferenceTypeName
	,trtReferenceType.intStandard
	,CAST (NULL as bigint) idfsCurrentReferenceType 
FROM dbo.fnReference(@LangID, 19000076)
INNER JOIN trtReferenceType ON
	trtReferenceType.idfsReferenceType = dbo.fnReference.idfsReference 
WHERE 
	trtReferenceType.idfsReferenceType =19000086 --rftSpeciesList

order by 
	strReferenceTypeName
*/

--2 - HACodesList
EXEC spHACode_SelectCheckList @LangID

/*
--3 --master ReferenceType
SELECT 
	CAST (19000086 as bigint) idfsReferenceType 
*/

