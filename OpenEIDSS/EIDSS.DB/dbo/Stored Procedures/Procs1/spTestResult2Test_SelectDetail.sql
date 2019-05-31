



--##SUMMARY Selects data for Test->TestResult matrix form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.11.2009

--##RETURNS Doesn't use


/*
exec spTestResult2Test_SelectDetail 'en'
*/


CREATE          PROCEDURE dbo.spTestResult2Test_SelectDetail(
	@LangID as NVARCHAR(50)
	)
AS
--0 virtual record for test lookup binging
SELECT cast(0 as bigint) as idfsReference

--1 test results related with test types
SELECT  
	idfsTestName,
	idfsTestResult,
	TestResult.[name] AS TestResultName,
	blnIndicative,
	0 as TestKind --laboratory test
FROM 	trtTestTypeToTestResult
INNER JOIN dbo.fnReference(@LangID, 19000096) TestResult ON --'rftTestResult'
	idfsTestResult= TestResult.idfsReference
WHERE
	intRowStatus = 0

UNION

SELECT  
	idfsPensideTestName as idfsTestName,
	idfsPensideTestResult as idfsTestResult,
	TestResult.[name] AS TestResultName,
	blnIndicative,
	1 as TestKind -- penside test
FROM 	trtPensideTestTypeToTestResult
INNER JOIN dbo.fnReference(@LangID, 19000105) TestResult ON --'rftPensideTestResult'
	idfsPensideTestResult= TestResult.idfsReference
WHERE
	intRowStatus = 0





