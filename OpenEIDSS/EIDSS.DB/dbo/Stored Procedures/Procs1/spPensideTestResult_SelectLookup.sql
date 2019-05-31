

--##SUMMARY Selects the list of penside test results in relation with Penside test Type.
--##SUMMARY The special PensideTestType = 0 can be used for retieving full Penside tests results list.
--##SUMMARY It is assumed that returned recorrd set will be filters in client appliction by the Penside test Type to receive test results for specific test Type.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
EXEC spPensideTestResult_SelectLookup 'en'
*/

CREATE   PROCEDURE dbo.spPensideTestResult_SelectLookup
	@LangID As nvarchar(50)--##PARAM @LangID - language ID
AS
DECLARE @tmp Table
(
	idfRowNumber bigint  IDENTITY(1,1) not null PRIMARY KEY ,
	idfsPensideTestName bigint,
	idfsReference bigint,
	[name] nvarchar(200),
	intOrder int,
	intRowStatus int
)

insert into @tmp(
	idfsReference,
	[name],
	idfsPensideTestName,
	intOrder,
	intRowStatus
	)	
(SELECT 	
	idfsReference,
	[name],
	0 AS idfsPensideTestName,
	intOrder,
	intRowStatus
FROM dbo.fnReferenceRepair(@LangID, 19000105/*rftPensideTestResult*/)

UNION 

SELECT 	
	idfsReference,
	[name],
	trtPensideTestTypeToTestResult.idfsPensideTestName,
	intOrder,
	(dbo.fnReferenceRepair.intRowStatus + trtPensideTestTypeToTestResult.intRowStatus) as intRowStatus
FROM dbo.fnReferenceRepair(@LangID,19000105/*rftPensideTestResult*/)
INNER JOIN trtPensideTestTypeToTestResult ON 
	trtPensideTestTypeToTestResult.idfsPensideTestResult = dbo.fnReferenceRepair.idfsReference
--WHERE 
--	trtPensideTestTypeToTestResult.intRowStatus = 0 
)
SELECT 
	idfRowNumber,
	idfsReference,
	[name],
	idfsPensideTestName,
	intRowStatus	
FROM @tmp
ORDER BY intOrder, [name]






