



--##SUMMARY Selects case log records related with specific case.
--##SUMMARY Called by CaseLog panel.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfCase bigint

EXECUTE spVetCaseLog_SelectDetail
   @idfCase

EXECUTE spVetCaseLog_SelectDetail
   NULL
*/

Create    Proc	spVetCaseLog_SelectDetail
	@idfCase bigint --##PARAM @idfCase - case ID for which case log is retrieved
As

SELECT idfVetCaseLog
      ,idfsCaseLogStatus
      ,idfPerson
      ,datCaseLogDate
      ,strActionRequired
      ,strNote
      ,idfVetCase
  FROM tlbVetCaseLog
WHERE
	idfVetCase = @idfCase
	and intRowStatus = 0


