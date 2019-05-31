

--##SUMMARY Selects data for Vector Surveillance Session form

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 20.07.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @id bigint
SET @id=706800000000
EXECUTE spVsSession_SelectDetail 	@id,'en'

*/




CREATE         PROCEDURE [dbo].[spVsSession_SelectDetail](
	@idfVectorSurveillanceSession AS bigint--##PARAM @idfVectorSurveillanceSession - AS session ID
	,@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
begin
	-- 0- Session
	SELECT 
	  VsSession.idfVectorSurveillanceSession, 
	  VsSession.strSessionID, 
	  VsSession.strFieldSessionID, 
	  VsSession.idfsVectorSurveillanceStatus, 
	  VsSession.datStartDate, 
	  VsSession.datCloseDate, 
	  VsSession.idfLocation, 
	  VsSession.idfOutbreak, 
	  VsSession.strDescription, 
	  VsSession.idfsSite,
	  Outbreak.strOutbreakID,
	  VsSession.intCollectionEffort,
	  VsSession.datModificationForArchiveDate
	  FROM dbo.tlbVectorSurveillanceSession VsSession
	  Left Join dbo.tlbOutbreak Outbreak On VsSession.idfOutbreak = Outbreak.idfOutbreak And Outbreak.intRowStatus = 0
	WHERE
		VsSession.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		and VsSession.intRowStatus = 0

    -- TODO нужно ли это? 
	--1 Diagnosis

	SELECT 
		  d.idfVectorSurveillanceSession,
		  d.idfsDiagnosis,
		  R.strDefault As [DefaultName],
		  R.name As [NationalName]
		  FROM dbo.fnVsSessionDiagnosis() d
		  Inner Join dbo.fnReference(@LangID, 19000019) R On d.idfsDiagnosis = R.idfsReference  
	WHERE
			d.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		
end
