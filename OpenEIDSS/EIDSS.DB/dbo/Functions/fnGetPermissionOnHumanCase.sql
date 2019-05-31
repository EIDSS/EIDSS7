
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013


CREATE FUNCTION [dbo].[fnGetPermissionOnHumanCase](
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
	idfHumanCase
	, CASE
		WHEN m_diag <= m_site AND m_diag <= m_out THEN m_diag
		WHEN m_out <= m_site AND m_out <= m_diag THEN m_out
		ELSE m_site
	END intPermission
FROM (
	SELECT
		thc.idfHumanCase
		, MIN(CASE 
				WHEN ot2.idfsStatus = 10107003 
					THEN ISNULL(Diagnosis.intPermission, 2)
				ELSE 2
			END) m_diag
		, MIN(CASE 
				WHEN ot3.idfsStatus = 10107003 
					THEN ISNULL(Site.intPermission, 2)
				ELSE 2
			END) m_site
		, MIN(CASE 
				WHEN ot4.idfsStatus = 10107003 
					THEN ISNULL(Site.intPermission, 2)
				ELSE 2
			END) m_out
	FROM tlbHumanCase thc
	--rights on diagnosis
	LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS Diagnosis ON
		Diagnosis.idfsDiagnosis = ISNULL(thc.idfsFinalDiagnosis, thc.idfsTentativeDiagnosis)
	LEFT JOIN dbo.trtObjectTypeToObjectType ot2 ON
		ot2.idfsRelatedObjectType = 10060006
		AND ot2.idfsParentObjectType = 10060001
	--rights on site
	LEFT JOIN dbo.fnGetPermissionOnSite(@ObjectOperation, @Employee) AS [Site] ON
		Site.idfsSite = thc.idfsSite
	LEFT JOIN dbo.trtObjectTypeToObjectType ot3 ON
		ot3.idfsRelatedObjectType = 10060006
		AND ot3.idfsParentObjectType = 10060011
	--rights on Outbreak
	LEFT JOIN dbo.fnGetPermissionOnOutbreak(@ObjectOperation, @Employee) AS [Outbreak] ON
		Outbreak.idfOutbreak = thc.idfOutbreak
	LEFT JOIN dbo.trtObjectTypeToObjectType ot4 ON
		ot4.idfsRelatedObjectType = 10060006
		AND ot4.idfsParentObjectType = 10060014
	WHERE thc.intRowStatus = 0
	GROUP BY thc.idfHumanCase
) hc



