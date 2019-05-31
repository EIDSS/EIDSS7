
--##SUMMARY Selects lookup list of test results joint with test test types to which test result belongs.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 18.01.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:

EXEC spTestResult_SelectLookup 'en'

*/
CREATE   PROCEDURE dbo.spTestResult_SelectLookup
	@LangID As nvarchar(50)/*,
	@idfsTestName AS VARCHAR(36)*/
AS

SELECT
			trtTestTypeToTestResult.idfsTestName,
			trtTestTypeToTestResult.idfsTestResult idfsReference,
			Result.name,
			(Result.intRowStatus + trtTestTypeToTestResult.intRowStatus) as intRowStatus
from		trtTestTypeToTestResult
left join	fnReferenceRepair(@LangID,19000096) Result
on			Result.idfsReference=trtTestTypeToTestResult.idfsTestResult
--WHERE  		trtTestTypeToTestResult.intRowStatus=0


