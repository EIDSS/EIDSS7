
--##SUMMARY Selects data for AS session summary diagnosis

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
EXEC spASSessionSummaryDiagnosis_SelectDetail 2, 'en'
*/

CREATE PROCEDURE [dbo].[spASSessionSummaryDiagnosis_SelectDetail]
	@idfMonitoringSessionSummary bigint
	,@LangID nvarchar(50)
AS

  
--1 diagnosis detail
--for each  summary record contains checked list of all session diagnosis
SELECT	DISTINCT (CAST(diagnosis.idfsDiagnosis AS  VARCHAR) + '.' + CAST(@idfMonitoringSessionSummary AS  VARCHAR)) AS id
		,diagnosis.idfsDiagnosis
		,diagnosis.name
		,@idfMonitoringSessionSummary AS idfMonitoringSessionSummary
		,ISNULL(sd.blnChecked,0) AS  blnChecked
FROM tlbMonitoringSessionToDiagnosis d
INNER JOIN fnDiagnosisRepair(@LangID, 32, 10020001) diagnosis ON--standard Livestock
	d.idfsDiagnosis = diagnosis.idfsDiagnosis
LEFT JOIN(
	tlbMonitoringSessionSummaryDiagnosis sd
	INNER JOIN tlbMonitoringSessionSummary s ON
		sd.idfMonitoringSessionSummary = s.idfMonitoringSessionSummary
	) ON
	d.idfsDiagnosis = sd.idfsDiagnosis
	AND s.idfMonitoringSessionSummary = @idfMonitoringSessionSummary

WHERE
	(diagnosis.intRowStatus = 0 OR diagnosis.idfsDiagnosis = d.idfsDiagnosis)
	AND d.intRowStatus = 0	
	AND @idfMonitoringSessionSummary>0

 

RETURN 0
