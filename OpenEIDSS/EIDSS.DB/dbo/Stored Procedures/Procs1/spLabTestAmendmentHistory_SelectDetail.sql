
--##SUMMARY Selects data for test amendment history

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.12.2011

--##RETURNS Doesn't use

/*
Example of procedure call:
Declare @idfTesting bigint
SET @idfTesting=1
EXECUTE spLabTestAmendmentHistory_SelectDetail @idfTesting,'en'

*/
create PROCEDURE [dbo].[spLabTestAmendmentHistory_SelectDetail]
	@idfTesting as bigint,
	@LangID as nvarchar(50)
AS
-- Amendment history	
select 
	amh.idfTestAmendmentHistory,
	amh.datAmendmentDate,
	dbo.fnConcatFullName(pen.strFamilyName, pen.strSecondName, pen.strFirstName) as strName,
	AmendByOffice.name as strOffice,
	OldTestResult.name as strOldTestResult,
	NewTestResult.name as strNewTestResult,
	amh.idfsOldTestResult,
	amh.idfsNewTestResult,
	amh.strOldNote,
	amh.strNewNote,
	amh.strReason,
	amh.idfTesting,
	amh.idfAmendByOffice,
	amh.idfAmendByPerson
from 
	dbo.tlbTestAmendmentHistory amh
left join	tlbOffice ofc
	on			amh.idfAmendByOffice = ofc.idfOffice
left join	tlbPerson pen
	on			amh.idfAmendByPerson = pen.idfPerson
left join		dbo.fnReference(@LangID,19000045) AmendByOffice
	ON			AmendByOffice.idfsReference = ofc.idfsOfficeAbbreviation	
left join		dbo.fnReference(@LangID,19000096) OldTestResult
	ON			OldTestResult.idfsReference = amh.idfsOldTestResult	
left join		dbo.fnReference(@LangID,19000096) NewTestResult
	ON			NewTestResult.idfsReference = amh.idfsNewTestResult	
where
	amh.intRowStatus=0
	and amh.idfTesting = @idfTesting

