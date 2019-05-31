

CREATE FUNCTION [dbo].[fnGetPermissionOnOutbreak](
	@ObjectOperation BIGINT
	, @Employee BIGINT
)
RETURNS TABLE 
AS
RETURN
/* test
DECLARE @ObjectOperation BIGINT
DECLARE @Employee BIGINT

SET @Employee = 3
*/



SELECT
	to1.idfOutbreak
	, MIN(CASE 
			WHEN ot1.idfsStatus = 10107003 
				THEN ISNULL(Diagnosis.intPermission, 2)
			ELSE 2
		END) intPermission
FROM tlbOutbreak to1
--rights on diagnosis
LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS Diagnosis ON
	Diagnosis.idfsDiagnosis = to1.idfsDiagnosisOrDiagnosisGroup
LEFT JOIN dbo.trtObjectTypeToObjectType ot1 ON
	ot1.idfsRelatedObjectType = 10060014
	AND ot1.idfsParentObjectType = 10060001
GROUP BY to1.idfOutbreak



