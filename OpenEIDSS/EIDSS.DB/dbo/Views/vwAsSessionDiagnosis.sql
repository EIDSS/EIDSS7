

--##SUMMARY Selects the translated list of diagnosis for AS session for each language registered in the system

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 31.07.2013

--##RETURNS Doesn't use

/*
--Example of view call:

SELECT * FROM  dbo.vwAsSessionDiagnosis
*/
CREATE VIEW [dbo].[vwAsSessionDiagnosis]
AS 
SELECT     TOP (100) PERCENT 
tSTD1.idfMonitoringSession,
l1.idfsBaseReference as idfsLanguage, 
CONVERT	(   
	nvarchar(500),
	STUFF	(	(SELECT N'' + diagnosis.x FROM
				(
				SELECT 
					tSTD.idfMonitoringSession,
					c.idfsLanguage,
					(N', ' + ISNULL(c.strTextString, b.strDefault)) as x
					, (row_number () over (partition by c.idfsLanguage, N', ' +  ISNULL(c.strTextString,b.strDefault) order by tSTD.intOrder, N', ' +  ISNULL(c.strTextString,b.strDefault))) as rn
				FROM         dbo.tlbMonitoringSessionToDiagnosis AS tSTD 
				INNER JOIN	dbo.trtDiagnosis AS d 
					ON tSTD.idfsDiagnosis = d.idfsDiagnosis 
				INNER JOIN	dbo.trtBaseReference AS b WITH (INDEX = IX_trtBaseReference_RR) 
					ON d.idfsDiagnosis = b.idfsBaseReference
                LEFT OUTER JOIN dbo.trtBaseReference AS l  WITH (INDEX = IX_trtBaseReference_RR) 
					ON l.idfsReferenceType = 19000049  --langauges
                LEFT OUTER JOIN dbo.trtStringNameTranslation AS c WITH (INDEX = IX_trtStringNameTranslation_BL) 
					ON b.idfsBaseReference = c.idfsBaseReference AND l.idfsBaseReference = c.idfsLanguage
				WHERE tSTD1.idfMonitoringSession = tSTD.idfMonitoringSession and l.idfsBaseReference = l1.idfsBaseReference 
				) diagnosis
				WHERE diagnosis.rn = 1
				FOR XML PATH('') 
				), 1, 2, ''
			)
		) 
 AS name 
FROM         dbo.tlbMonitoringSessionToDiagnosis AS tSTD1 
             LEFT OUTER JOIN dbo.trtBaseReference AS l1  WITH (INDEX = IX_trtBaseReference_RR) 
             ON l1.idfsReferenceType = 19000049 --langauges
                      
WHERE     (tSTD1.intRowStatus = 0)
GROUP by idfMonitoringSession,
l1.idfsBaseReference


