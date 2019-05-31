
CREATE FUNCTION [dbo].[FN_VCTS_VSSESSION_DIAGNOSESIDS_GET]
(
	@idfVectorSurveillanceSession	AS BIGINT,
	@LangID							AS NVARCHAR(50)
)
RETURNS								NVARCHAR(1000)
AS
BEGIN
	DECLARE @strDiagnosesIDs		NVARCHAR(1000);

	SELECT @strDiagnosesIDs = ISNULL(@strDiagnosesIDs + ';', '') + CAST(vs.idfsDiagnosis AS NVARCHAR(50))
	FROM (
			SELECT DISTINCT			t.idfsDiagnosis
			FROM					dbo.tlbPensideTest t
			INNER JOIN				dbo.tlbMaterial m 
			ON						m.idfMaterial = t.idfMaterial
			AND						t.intRowStatus = 0
			INNER JOIN				dbo.trtPensideTestTypeToTestResult tr 
			ON						t.idfsPensideTestName = tr.idfsPensideTestName
			AND						t.idfsPensideTestResult = tr.idfsPensideTestResult
			AND						t.intRowStatus = 0
			AND						tr.intRowStatus = 0
			AND						tr.blnIndicative = 1
			WHERE					m.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

		UNION

			SELECT DISTINCT			t.idfsDiagnosis
			FROM					dbo.tlbTesting t
			INNER JOIN				dbo.tlbMaterial m 
			ON						m.idfMaterial = t.idfMaterial
			WHERE					m.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

		UNION

			SELECT DISTINCT			vssd.idfsDiagnosis
			FROM					dbo.tlbVectorSurveillanceSessionSummary vss
			INNER JOIN				dbo.tlbVectorSurveillanceSessionSummaryDiagnosis vssd 
			ON						vss.idfsVSSessionSummary = vssd.idfsVSSessionSummary
			WHERE					vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
	  ) AS vs;

	RETURN							@strDiagnosesIDs;
END
