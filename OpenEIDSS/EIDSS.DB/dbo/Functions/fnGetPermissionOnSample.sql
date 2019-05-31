

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011


CREATE FUNCTION [dbo].[fnGetPermissionOnSample](
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
	idfMaterial
	, CASE
		WHEN m_vetcase <= m_humcase THEN m_vetcase
		ELSE m_humcase
	END intPermission
FROM (
	SELECT
		tm.idfMaterial
		, MIN(CASE 
				WHEN ot1.idfsStatus = 10107003 
					THEN ISNULL(VetCase.intPermission, 2)
				ELSE 2
			END) m_vetcase
		, MIN(CASE 
				WHEN ot2.idfsStatus = 10107003 
					THEN ISNULL(HumanCase.intPermission, 2)
				ELSE 2
			END) m_humcase
	FROM dbo.tlbMaterial tm
	LEFT JOIN fnGetPermissionOnVetCase(@ObjectOperation, @Employee) VetCase ON
		VetCase.idfVetCase = tm.idfVetCase
	LEFT JOIN dbo.trtObjectTypeToObjectType ot1 ON
		ot1.idfsRelatedObjectType = 10060009
		AND ot1.idfsParentObjectType = 10060013
	LEFT JOIN fnGetPermissionOnHumanCase(@ObjectOperation, @Employee) HumanCase ON
		HumanCase.idfHumanCase = tm.idfHumanCase
	LEFT JOIN dbo.trtObjectTypeToObjectType ot2 ON
		ot2.idfsRelatedObjectType = 10060009
		AND ot2.idfsParentObjectType = 10060006	
	WHERE tm.intRowStatus = 0
	GROUP BY tm.idfMaterial
) sampl



