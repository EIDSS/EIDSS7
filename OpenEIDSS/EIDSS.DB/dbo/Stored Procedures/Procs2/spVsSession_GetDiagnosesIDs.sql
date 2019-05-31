
--##REMARKS Date: 15.08.2013
--##REMARKS Updated: 

/*
exec spVsSession_GetDiagnosesIDs 12677890000000
*/
CREATE PROCEDURE [dbo].[spVsSession_GetDiagnosesIDs]
(
	@idfVectorSurveillanceSession AS bigint--##PARAM @idfVectorSurveillanceSession - AS session ID
)
AS

BEGIN 
SET NOCOUNT ON;
		select idfsDiagnosis
		From  dbo.fnVsSessionDiagnosis() d
		Where d.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
END
