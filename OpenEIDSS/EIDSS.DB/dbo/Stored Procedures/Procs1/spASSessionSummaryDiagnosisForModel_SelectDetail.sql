
--##SUMMARY Selects data for AS session summary diagnosis

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
EXEC spASSessionSummaryDiagnosisForModel_SelectDetail 2, 'en'
*/

CREATE PROCEDURE [dbo].[spASSessionSummaryDiagnosisForModel_SelectDetail]
	@idfMonitoringSessionSummary bigint
	,@LangID nvarchar(50)
AS

--1 diagnosis detail
SELECT	diagnosis.idfsDiagnosis
		,diagnosis.name
		,@idfMonitoringSessionSummary AS idfMonitoringSessionSummary
		,CAST(ISNULL(sd.blnChecked, 0) AS BIT)	AS  blnChecked
FROM fnDiagnosisRepair(@LangID, 32, 10020001) diagnosis --standard Livestock
LEFT JOIN  (
	tlbMonitoringSessionSummaryDiagnosis sd	
	INNER  JOIN tlbMonitoringSessionSummary s ON 
	sd.idfMonitoringSessionSummary = s.idfMonitoringSessionSummary
	)ON 
	sd.idfsDiagnosis = diagnosis.idfsDiagnosis
	AND (s.idfMonitoringSessionSummary = @idfMonitoringSessionSummary)
WHERE		
	(diagnosis.intRowStatus = 0 OR diagnosis.idfsDiagnosis = sd.idfsDiagnosis)
	AND @idfMonitoringSessionSummary>0
ORDER BY diagnosis.name

RETURN 0
