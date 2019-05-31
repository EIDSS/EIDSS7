
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE FUNCTION [dbo].[fnGetPermissionOnVetCase](
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
	idfVetCase
	, CASE
		WHEN m_diag <= m_site AND m_diag <= m_out THEN m_diag
		WHEN m_site <= m_diag AND m_site <= m_out THEN m_site
		ELSE m_out
	END intPermission
FROM (
	SELECT
		tvc.idfVetCase
		, MIN(CASE
				WHEN ISNULL(ot1.idfsStatus, -1) <> 10107003 
					OR (
							ISNULL(FinalDiagnosis.intPermission, 0) = 2
							OR ISNULL(TentativeDiagnosis.intPermission, 0) = 2
							OR ISNULL(TentativeDiagnosis1.intPermission, 0) = 2
							OR ISNULL(TentativeDiagnosis2.intPermission, 0) = 2
							OR COALESCE(FinalDiagnosis.intPermission
										, TentativeDiagnosis.intPermission
										, TentativeDiagnosis1.intPermission
										, TentativeDiagnosis2.intPermission
										, 0) = 0
						)
					THEN 2
				ELSE 1
			END) m_diag
		, MIN(CASE 
				WHEN ISNULL(ot2.idfsStatus, -1) = 10107003 
					THEN ISNULL(Site.intPermission, 2)
				ELSE 2
			END) m_site
		, MIN(CASE 
				WHEN ISNULL(ot3.idfsStatus, -1) = 10107003 
					THEN ISNULL(Outbreak.intPermission, 2)
				ELSE 2
			END) m_out
	FROM tlbVetCase tvc
	--rights on diagnosis
/*	LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS Diagnosis ON
		Diagnosis.idfsDiagnosis = tvc.idfsShowDiagnosis*/
	LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS FinalDiagnosis ON
		FinalDiagnosis.idfsDiagnosis = tvc.idfsFinalDiagnosis
	LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS TentativeDiagnosis ON
		FinalDiagnosis.idfsDiagnosis = tvc.idfsTentativeDiagnosis
	LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS TentativeDiagnosis1 ON
		TentativeDiagnosis1.idfsDiagnosis = tvc.idfsTentativeDiagnosis1
	LEFT JOIN dbo.fnGetPermissionOnDiagnosis(@ObjectOperation, @Employee) AS TentativeDiagnosis2 ON
		TentativeDiagnosis2.idfsDiagnosis = tvc.idfsTentativeDiagnosis2
	LEFT JOIN dbo.trtObjectTypeToObjectType ot1 ON
		ot1.idfsRelatedObjectType = 10060013
		AND ot1.idfsParentObjectType = 10060001
	--rights on site
	LEFT JOIN dbo.fnGetPermissionOnSite(@ObjectOperation, @Employee) AS [Site] ON
		Site.idfsSite = tvc.idfsSite
	LEFT JOIN dbo.trtObjectTypeToObjectType ot2 ON
		ot2.idfsRelatedObjectType = 10060013
		AND ot2.idfsParentObjectType = 10060011
	--rights on Outbreak
	LEFT JOIN dbo.fnGetPermissionOnOutbreak(@ObjectOperation, @Employee) AS [Outbreak] ON
		Outbreak.idfOutbreak = tvc.idfOutbreak
	LEFT JOIN dbo.trtObjectTypeToObjectType ot3 ON
		ot3.idfsRelatedObjectType = 10060013
		AND ot3.idfsParentObjectType = 10060014
	WHERE tvc.intRowStatus = 0
	GROUP BY tvc.idfVetCase
) vc



