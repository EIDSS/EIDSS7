
CREATE PROCEDURE [dbo].[spCustomReportRowsMaster_SelectDetail]

AS
	SELECT ISNULL(CAST(-1 as bigint),0) AS idfsSummaryReportType
	,ISNULL(CAST(-1 as bigint),0) AS idfsDiagnosisOrReportDiagnosisGroup	
RETURN 0
