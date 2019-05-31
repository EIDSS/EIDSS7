
CREATE FUNCTION [dbo].[fnVsSessionDiagnosis]
(
)
RETURNS TABLE
AS
RETURN
    select distinct mi.idfVectorSurveillanceSession, ti.idfsDiagnosis 
	from tlbTesting ti
    inner join dbo.tlbMaterial mi
    on	ti.idfMaterial = mi.idfMaterial
		and mi.intRowStatus = 0
		and ti.intRowStatus = 0
    UNION
    select distinct mi1.idfVectorSurveillanceSession, pt.idfsDiagnosis 
	from tlbPensideTest pt
    inner join dbo.tlbMaterial mi1
    on	pt.idfMaterial = mi1.idfMaterial
		and mi1.intRowStatus = 0
		and pt.intRowStatus = 0
    inner join trtPensideTestTypeToTestResult tr
    on	pt.idfsPensideTestName = tr.idfsPensideTestName
		and pt.idfsPensideTestResult = tr.idfsPensideTestResult
		and pt.intRowStatus = 0
		and tr.intRowStatus = 0
		and tr.blnIndicative = 1
    UNION
    select distinct Vss.idfVectorSurveillanceSession, Vssd.[idfsDiagnosis]
    from  dbo.tlbVectorSurveillanceSessionSummary Vss
    inner Join dbo.tlbVectorSurveillanceSessionSummaryDiagnosis Vssd 
	On	Vss.[idfsVSSessionSummary] = Vssd.[idfsVSSessionSummary]
		and Vssd.intRowStatus = 0


