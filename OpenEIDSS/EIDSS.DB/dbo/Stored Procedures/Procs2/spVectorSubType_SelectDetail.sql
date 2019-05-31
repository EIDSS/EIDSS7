
--##SUMMARY Selects list of vector subtypes for editing in VectorSubTypeDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 12.01.2012

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

EXEC spVectorSubType_SelectDetail 'en'
*/


CREATE PROCEDURE [dbo].[spVectorSubType_SelectDetail]
	@LangID  NVARCHAR(50)--##PARAM @LangID - language ID 

AS
select	trtVectorSubType.idfsVectorSubType, 
		trtVectorSubType.idfsVectorType,
		fnReference.[name] AS strTranslatedName,
		fnReference.strDefault as strDefaultName,
		trtVectorSubType.strCode,
		fnReference.intOrder,
		fnReference.idfsReferenceType
from dbo.trtVectorSubType
inner join fnReference(@LangID, 19000141/*Vector sub type*/)
	on trtVectorSubType.idfsVectorSubType = fnReference.idfsReference
where 
	trtVectorSubType.intRowStatus = 0


RETURN 0
