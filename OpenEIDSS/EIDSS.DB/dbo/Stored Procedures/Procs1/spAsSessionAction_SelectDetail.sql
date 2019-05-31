



--##SUMMARY Selects monitoring session action records related with specific session.
--##SUMMARY Called by ASSessionAction panel.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 20.08.2010

--##REMARKS Update: Zolotareva N.
--##REMARKS Update date: 14.12.2011
--##REMARKS Added user name of person, who entered the record


--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfCase bigint

EXECUTE spAsSessionAction_SelectDetail
   @idfCase

EXECUTE spAsSessionAction_SelectDetail
   NULL
*/

CREATE    Proc	spAsSessionAction_SelectDetail
	@idfMonitoringSession bigint --##PARAM @idfMonitoringSession - session ID for which actions are retrieved
As
SELECT idfMonitoringSessionAction
      ,idfMonitoringSession
      ,idfPersonEnteredBy
      ,idfsMonitoringSessionActionType
      ,idfsMonitoringSessionActionStatus
      ,datActionDate
      ,strComments
	  ,dbo.fnConcatFullName(p.strFamilyName,p.strFirstName, p.strSecondName)  as strPersonEnteredBy      
  FROM tlbMonitoringSessionAction  a 
  INNER JOIN tlbPerson p
	on a.idfPersonEnteredBy = p.idfPerson
WHERE  
 idfMonitoringSession = @idfMonitoringSession  
 and a.intRowStatus = 0  


