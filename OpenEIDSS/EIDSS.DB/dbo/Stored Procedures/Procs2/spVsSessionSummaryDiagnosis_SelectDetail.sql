
CREATE  PROCEDURE [dbo].[spVsSessionSummaryDiagnosis_SelectDetail](
	@idfsVSSessionSummary AS bigint--##PARAM @idfVectorSurveillanceSession - session ID
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
begin
	Select 
	  Vssd.[idfsVSSessionSummaryDiagnosis]
      ,Vssd.[idfsVSSessionSummary]
      ,Vssd.[idfsDiagnosis]     
      ,D.name As [strDiagnosis]
      ,Vssd.[intPositiveQuantity]
      ,Vssd.[intRowStatus]
	FROM dbo.tlbVectorSurveillanceSessionSummaryDiagnosis Vssd
	Inner Join dbo.fnReference(@LangID, 19000019) D On Vssd.[idfsDiagnosis] = D.idfsReference 
	Where Vssd.idfsVSSessionSummary  = @idfsVSSessionSummary
	And Vssd.intRowStatus = 0	  	
end
