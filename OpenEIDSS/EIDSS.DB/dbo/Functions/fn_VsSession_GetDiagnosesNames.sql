
CREATE FUNCTION [dbo].[fn_VsSession_GetDiagnosesNames]
(
	@idfVectorSurveillanceSession AS bigint--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
RETURNS nvarchar(1000)
AS
BEGIN
	declare @strDiagnoses nvarchar(1000)

	select @strDiagnoses = isnull(@strDiagnoses + '; ','') + ref_Diagnosis.[name]
	from (
		Select distinct Test.idfsDiagnosis
		From  dbo.tlbPensideTest Test
		Inner Join dbo.tlbMaterial Material On
		Material.idfMaterial = Test.idfMaterial
        and Test.intRowStatus = 0
        inner join trtPensideTestTypeToTestResult tr
        on
        Test.idfsPensideTestName = tr.idfsPensideTestName
        and Test.idfsPensideTestResult = tr.idfsPensideTestResult
        and Test.intRowStatus = 0
        and tr.intRowStatus = 0
        and tr.blnIndicative = 1
		Where Material.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

		union

		Select distinct Test.idfsDiagnosis
		From  dbo.tlbTesting Test
		Inner Join dbo.tlbMaterial Material On
		Material.idfMaterial = Test.idfMaterial
		Where Material.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

		union

		Select distinct Vssd.[idfsDiagnosis] 
		From  dbo.tlbVectorSurveillanceSessionSummary Vss
		Inner Join dbo.tlbVectorSurveillanceSessionSummaryDiagnosis Vssd On
		Vss.[idfsVSSessionSummary] = Vssd.[idfsVSSessionSummary]
		Where Vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession	  
	  ) as VectorSession
	  inner join dbo.fnReference(@LangID, 19000019) ref_Diagnosis
	  on ref_Diagnosis.idfsReference = VectorSession.idfsDiagnosis

	RETURN @strDiagnoses
END
