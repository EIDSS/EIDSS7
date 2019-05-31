

--##SUMMARY 

--##REMARKS 
--##REMARKS Create date: 

--##RETURNS Doesn't use



/*


*/




CREATE  PROCEDURE [dbo].[spVsSessionSummary_SelectDetail](
	@idfVectorSurveillanceSession AS bigint--##PARAM @idfVectorSurveillanceSession - session ID
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
begin	
	SELECT 
	 Vss.[idfsVSSessionSummary]
      ,Vss.[idfVectorSurveillanceSession]
      ,Vss.[strVSSessionSummaryID] -- RecordID
      ,Vss.[idfGeoLocation]
      ,Vss.[datCollectionDateTime]
      ,Vst.idfsVectorType
      ,VectorType.name As [strVectorType]
      ,Vss.[idfsVectorSubType]
      ,VectorSubType.name As [strVectorSubType]
      ,Vss.[idfsSex]
      ,Sex.name As [strSex]	
      ,Vss.[intQuantity]
      ,Vss.[intRowStatus]	  
	FROM dbo.tlbVectorSurveillanceSessionSummary Vss
	Inner Join dbo.trtVectorSubType Vst On Vss.idfsVectorSubType = Vst.idfsVectorSubType And Vst.intRowStatus = 0
	Inner Join dbo.fnReference(@LangID,19000140) VectorType On	VectorType.idfsReference = Vst.idfsVectorType
	Inner Join dbo.fnReference(@LangID,19000141) VectorSubType On VectorSubType.idfsReference = Vss.idfsVectorSubType
	Left Join	dbo.fnReference(@LangID,19000007) Sex On	Sex.idfsReference = Vss.idfsSex
	WHERE
		Vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		and Vss.intRowStatus = 0
end
