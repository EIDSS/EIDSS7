
--##SUMMARY Deletes Monitoring Session object.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.06.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use

/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spASSession_Delete 
	@ID

*/


CREATE proc	[dbo].[spASSession_Delete]
	@ID AS BIGINT --#PARAM @ID - session ID
as
DECLARE @idfFarm bigint

DELETE FROM  dbo.tlbMonitoringSessionToDiagnosis WHERE idfMonitoringSession = @ID
DECLARE crFarm Cursor FOR
	SELECT tlbFarm.idfFarm FROM tlbFarm
	  left join tlbVetCase	             
	    on tlbVetCase.idfFarm = tlbFarm.idfFarm
			AND tlbVetCase.intRowStatus = 0
	WHERE
		tlbFarm.idfMonitoringSession = @ID
		and  tlbVetCase.idfVetCase IS NULL
		and tlbFarm.intRowStatus = 0

OPEN crFarm
FETCH NEXT FROM crFarm into @idfFarm

WHILE @@FETCH_STATUS = 0 
BEGIN
	EXEC spFarm_Delete @idfFarm
	FETCH NEXT FROM crFarm INTO  @idfFarm
END 

CLOSE crFarm
DEALLOCATE crFarm

DECLARE @idfFarm_del TABLE (idfFarm bigint)
INSERT into @idfFarm_del(idfFarm)
SELECT idfFarm from tlbMonitoringSessionSummary where idfMonitoringSession = @ID

DELETE tlbMonitoringSessionSummaryDiagnosis
FROM tlbMonitoringSessionSummaryDiagnosis
INNER JOIN tlbMonitoringSessionSummary
ON tlbMonitoringSessionSummary.idfMonitoringSessionSummary = tlbMonitoringSessionSummaryDiagnosis.idfMonitoringSessionSummary
WHERE 
	tlbMonitoringSessionSummary.idfMonitoringSession = @ID

DELETE tlbMonitoringSessionSummarySample
FROM tlbMonitoringSessionSummarySample
INNER JOIN tlbMonitoringSessionSummary
ON tlbMonitoringSessionSummary.idfMonitoringSessionSummary = tlbMonitoringSessionSummarySample.idfMonitoringSessionSummary
WHERE 
	tlbMonitoringSessionSummary.idfMonitoringSession = @ID

DELETE FROM tlbMonitoringSessionSummary
WHERE 
	idfMonitoringSession = @ID

DELETE FROM tlbMonitoringSessionAction
WHERE 
	idfMonitoringSession = @ID

DELETE FROM tlbMonitoringSessionToDiagnosis
WHERE 
	idfMonitoringSession = @ID

DELETE FROM  dbo.tflMonitoringSessionFiltered WHERE idfMonitoringSession = @ID
DELETE FROM  dbo.tlbMonitoringSession WHERE idfMonitoringSession = @ID

DECLARE crFarm_Summary Cursor FOR
	SELECT idfFarm FROM @idfFarm_del
OPEN crFarm_Summary
FETCH NEXT FROM crFarm_Summary into @idfFarm

WHILE @@FETCH_STATUS = 0 
BEGIN
	EXEC spFarm_Delete @idfFarm
	FETCH NEXT FROM crFarm_Summary INTO  @idfFarm
END --crAnimal cursor end
CLOSE crFarm_Summary
DEALLOCATE crFarm_Summary

