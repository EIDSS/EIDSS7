

/*
exec spObjectTypeTree 'en'
*/

CREATE PROCEDURE dbo.spObjectTypeTree(
@LangID  nvarchar(50)
)
AS

SELECT     
		ObjectTypeToObjectType.idfsParentObjectType,
		ObjectTypeToObjectType.idfsRelatedObjectType,
		ObjectTypeToObjectType.idfsStatus,
		parent.[name] AS ParentName, 
		child.[name] AS ChildName
FROM         
		trtObjectTypeToObjectType ObjectTypeToObjectType
INNER JOIN
		fnReference(@LangID, 19000060 /*'rftObjectType'*/) parent
ON		ObjectTypeToObjectType.idfsParentObjectType = parent.idfsReference
INNER JOIN
		fnReference(@LangID, 19000060 /*'rftObjectType'*/) child
ON		ObjectTypeToObjectType.idfsRelatedObjectType = child.idfsReference
INNER JOIN
		trtBaseReference
ON		trtBaseReference.idfsBaseReference=ObjectTypeToObjectType.idfsStatus AND
		trtBaseReference.idfsReferenceType=19000109 AND
		trtBaseReference.intRowStatus=0

--BEGIN relation values
/*
SELECT
		idfsReference,name
FROM
		fnReference(@LangID,19000109)
*/
--WHERE
--		idfsReference in ('brrObjectTypeYES','brrObjectTypeNO')
--END relation values


