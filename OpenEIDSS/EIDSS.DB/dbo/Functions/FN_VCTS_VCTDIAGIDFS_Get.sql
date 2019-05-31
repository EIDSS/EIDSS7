
--*************************************************************
-- Name 				: FN_VCTS_VCTDIAGIDFS_Get
-- Description			: Vector Surveillance Session - Diagnosis Names
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- 
--*************************************************************

CREATE FUNCTION [dbo].[FN_VCTS_VCTDIAGIDFS_Get]
(
	@idfVectorSurveillanceSession	AS BIGINT		--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID						AS NVARCHAR(50)	--##PARAM @LangID - language ID
)
RETURNS NVARCHAR(1000)
AS
BEGIN
	DECLARE @strDiagnosesIDFS NVARCHAR(1000)

	SELECT 	@strDiagnosesIDFS = ISNULL(@strDiagnosesIDFS + '; ','') + CONVERT(NVARCHAR(MAX), idfsDiagnosis)
	FROM 
		(
				SELECT 
				DISTINCT	idfsDiagnosis
				FROM		dbo.tlbPensideTest
				INNER JOIN	dbo.tlbMaterial ON
							tlbMaterial.idfMaterial = tlbPensideTest.idfMaterial AND tlbPensideTest.intRowStatus = 0
				INNER JOIN	trtPensideTestTypeToTestResult ON
							tlbPensideTest.idfsPensideTestName = trtPensideTestTypeToTestResult.idfsPensideTestName
							AND tlbPensideTest.idfsPensideTestResult = trtPensideTestTypeToTestResult.idfsPensideTestResult
							AND tlbPensideTest.intRowStatus = 0	AND trtPensideTestTypeToTestResult.intRowStatus = 0
							AND trtPensideTestTypeToTestResult.blnIndicative = 1
				WHERE		tlbMaterial.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

			UNION

				SELECT 
				DISTINCT 	tlbTesting.idfsDiagnosis
				FROM  		dbo.tlbTesting
				INNER JOIN	dbo.tlbMaterial ON
							tlbMaterial.idfMaterial = tlbTesting.idfMaterial
				WHERE		tlbMaterial.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

			UNION

				SELECT 
				DISTINCT 	tlbVectorSurveillanceSessionSummaryDiagnosis.[idfsDiagnosis] 
				FROM  		dbo.tlbVectorSurveillanceSessionSummary
				INNER JOIN	dbo.tlbVectorSurveillanceSessionSummaryDiagnosis ON
							tlbVectorSurveillanceSessionSummary.[idfsVSSessionSummary] = tlbVectorSurveillanceSessionSummaryDiagnosis.[idfsVSSessionSummary]
				WHERE 		tlbVectorSurveillanceSessionSummary.idfVectorSurveillanceSession = @idfVectorSurveillanceSession	  
		) AS VectorSession

	INNER JOIN 	dbo.fnReference(@LangID, 19000019) ref_Diagnosis ON 
				ref_Diagnosis.idfsReference = VectorSession.idfsDiagnosis

	RETURN @strDiagnosesIDFS
END
