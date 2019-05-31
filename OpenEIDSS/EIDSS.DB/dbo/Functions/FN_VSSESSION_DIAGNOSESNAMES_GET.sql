
CREATE FUNCTION [dbo].[FN_VSSESSION_DIAGNOSESNAMES_GET]
(
	@idfVectorSurveillanceSession AS BIGINT--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID AS NVARCHAR(50)--##PARAM @LangID - language ID
)
RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @strDiagnoses NVARCHAR(1000)

	SELECT @strDiagnoses = isnull(@strDiagnoses + '; ','') + ref_Diagnosis.[name]
	FROM (
			SELECT 
			DISTINCT	Test.idfsDiagnosis
			FROM		dbo.tlbPensideTest Test
			INNER JOIN	dbo.tlbMaterial Material ON
						Material.idfMaterial = Test.idfMaterial
			AND			Test.intRowStatus = 0
			INNER JOIN	trtPensideTestTypeToTestResult tr ON
						Test.idfsPensideTestName = tr.idfsPensideTestName
			AND			Test.idfsPensideTestResult = tr.idfsPensideTestResult
			AND			Test.intRowStatus = 0
			AND			tr.intRowStatus = 0
			AND			tr.blnIndicative = 1
			WHERE		Material.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

		UNION

			SELECT 
			DISTINCT	Test.idfsDiagnosis
			FROM		dbo.tlbTesting Test
			INNER JOIN	dbo.tlbMaterial Material ON
						Material.idfMaterial = Test.idfMaterial
			WHERE		Material.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

		UNION

			SELECT 
			DISTINCT	Vssd.[idfsDiagnosis] 
			FROM		dbo.tlbVectorSurveillanceSessionSummary Vss
			INNER JOIN	dbo.tlbVectorSurveillanceSessionSummaryDiagnosis Vssd ON
						Vss.[idfsVSSessionSummary] = Vssd.[idfsVSSessionSummary]
			WHERE		Vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession	  
	  ) AS VectorSession
	INNER JOIN dbo.fnReference(@LangID, 19000019) ref_Diagnosis	ON 
				ref_Diagnosis.idfsReference = VectorSession.idfsDiagnosis

	RETURN @strDiagnoses
END
