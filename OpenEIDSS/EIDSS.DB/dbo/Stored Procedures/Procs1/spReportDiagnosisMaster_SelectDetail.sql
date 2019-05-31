
CREATE PROCEDURE [dbo].[spReportDiagnosisMaster_SelectDetail]

AS
	SELECT ISNULL(CAST(-1 as bigint),0) AS idfsSummaryReportType
	,ISNULL(CAST(-1 as bigint),0) AS idfsReportDiagnosisGroup
	,ISNULL(CAST(-1 as bigint),0) AS idfsDiagnosis
RETURN 0
