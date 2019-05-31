

--##SUMMARY Selects data for MeasureReferenceDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 4.12.2009

--##RETURNS Doesn't use

/*
Example of procedure call:

EXEC spMeasureReference_SelectDetail 'en'

*/





CREATE     PROCEDURE [dbo].[spMeasureReference_SelectDetail] 
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
	  ,IsNull(trtProphilacticAction.strActionCode, trtSanitaryAction.strActionCode) as strActionCode 
FROM trtBaseReference
INNER JOIN trtReferenceType ON 
	trtReferenceType.idfsReferenceType = trtBaseReference.idfsReferenceType
left join	trtStringNameTranslation ON	
	trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference 
	and trtStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
LEFT JOIN	trtProphilacticAction ON
	trtProphilacticAction.idfsProphilacticAction = trtBaseReference.idfsBaseReference
LEFT JOIN	trtSanitaryAction ON
	trtSanitaryAction.idfsSanitaryAction = trtBaseReference.idfsBaseReference 

WHERE 
	(trtReferenceType.idfsReferenceType =19000074 --rftProphilacticActionList
	OR trtReferenceType.idfsReferenceType =19000079) --rftSanitaryActionList
	and trtBaseReference.intRowStatus = 0
	and trtReferenceType.intRowStatus = 0
ORDER BY 
	trtBaseReference.intOrder
	,trtBaseReference.strDefault
	,[name]

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
	trtReferenceType.idfsReferenceType =19000074 --rftProphilacticActionList
	OR trtReferenceType.idfsReferenceType =19000079 --rftSanitaryActionList

order by 
	strReferenceTypeName


--2 - HACodesList
EXEC spHACode_SelectCheckList @LangID


--3 --master ReferenceType
SELECT 
	CAST (-1 as bigint) idfsReferenceType 


