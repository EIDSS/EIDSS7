

/*
select * from fnVectorList('en')
*/

--##SUMMARY Returns the list of vectors with main vector attributes.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.12.2011

--##RETURNS Doesn't use

CREATE FUNCTION [dbo].fnVectorList
(	
	@LangID nvarchar(20)
)
RETURNS TABLE 
AS
RETURN 

SELECT		
	idfVector,
	strVectorID,
	idfsVectorType,
	idfsVectorSubType,
	vectorType.[name] as strVectorTypeName,
	vectorSubType.[name] as strVectorSubTypeName,
	ISNULL(vectorType.[name],N'') + ISNULL(N'/'+vectorSubType.[name], N'') + ISNULL(N', '+ strVectorID, N'') As strVectorCode
FROM tlbVector
LEFT JOIN	fnReferenceRepair(@LangID,19000140) vectorType ON			--Vector type
	vectorType.idfsReference=tlbVector.idfsVectorType
LEFT JOIN	fnReferenceRepair(@LangID,19000141) vectorSubType ON			--Vector sub type
	vectorSubType.idfsReference=tlbVector.idfsVectorSubType
WHERE		tlbVector.intRowStatus = 0


