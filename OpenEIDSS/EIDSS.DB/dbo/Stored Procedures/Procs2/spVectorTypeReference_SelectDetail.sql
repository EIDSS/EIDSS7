

--##SUMMARY Select list of Vector Types for Editor.

--##REMARKS Author: Zhdanova A.
--##REMARKS Update date: 12.09.2011

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
execute	spVectorTypeReference_SelectDetail 'ru'
*/



CREATE procedure	[dbo].[spVectorTypeReference_SelectDetail]
(		
	@LangID  nvarchar(50) --##PARAM @LangID - language ID
)
as

select	fnReference.idfsReference AS idfsBaseReference, 
		fnReference.[name] AS strTranslatedName,
		fnReference.strDefault as strDefaultName,
		trtVectorType.strCode,
		trtVectorType.bitCollectionByPool,
		fnReference.intOrder,
		fnReference.idfsReferenceType,
		trtVectorType.intRowStatus
from dbo.trtVectorType
inner join fnReference(@LangID, 19000140/*Vector type*/)
	on trtVectorType.idfsVectorType = fnReference.idfsReference
where 
	trtVectorType.intRowStatus = 0
	

