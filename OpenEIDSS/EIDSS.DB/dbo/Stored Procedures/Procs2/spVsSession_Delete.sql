



--##SUMMARY Deletes VS Session object.
--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 18.07.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spVsSession_Delete 
	@ID

*/




CREATE proc	[dbo].[spVsSession_Delete]
	@ID AS BIGINT --#PARAM @ID - session ID
as
--store location for deleting
declare @idfLocation bigint
select @idfLocation = idfLocation from tlbVectorSurveillanceSession
where idfVectorSurveillanceSession = @ID

--delete vectors with all samples/tests
DECLARE @idfVector bigint
DECLARE crVSS Cursor FOR
	select idfVector from dbo.tlbVector
	WHERE
		tlbVector.idfVectorSurveillanceSession = @ID
		and tlbVector.intRowStatus = 0

OPEN crVSS
FETCH NEXT FROM crVSS into @idfVector

WHILE @@FETCH_STATUS = 0 
BEGIN
	EXEC spVector_Delete @idfVector
	FETCH NEXT FROM crVSS INTO  @idfVector
END 

CLOSE crVSS
DEALLOCATE crVSS

--Delete vs summary records
delete tlbVectorSurveillanceSessionSummaryDiagnosis
from tlbVectorSurveillanceSessionSummaryDiagnosis sd
inner join tlbVectorSurveillanceSessionSummary s
on sd.idfsVSSessionSummary = s.idfsVSSessionSummary
inner join tlbVectorSurveillanceSession vs 
on vs.idfVectorSurveillanceSession = s.idfVectorSurveillanceSession

where vs.idfVectorSurveillanceSession = @ID
delete tlbVectorSurveillanceSessionSummary
from tlbVectorSurveillanceSessionSummary s
inner join tlbVectorSurveillanceSession vs 
on vs.idfVectorSurveillanceSession = s.idfVectorSurveillanceSession
where vs.idfVectorSurveillanceSession = @ID



--Delete vs itself
delete tflVectorSurveillanceSessionFiltered
from tflVectorSurveillanceSessionFiltered fvs
inner join tlbVectorSurveillanceSession vs 
on vs.idfVectorSurveillanceSession = fvs.idfVectorSurveillanceSession
where vs.idfVectorSurveillanceSession = @ID

DELETE FROM  dbo.tlbVectorSurveillanceSession WHERE idfVectorSurveillanceSession = @ID

--delete  vs location record
exec spGeoLocation_Delete @idfLocation
