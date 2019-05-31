
--##SUMMARY Select data for Test Amendment History.
--##REMARKS Author: 
--##REMARKS Create date: 23.04.2014


--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec dbo.spRepLimTestResultsAmendmentHistory @LangID=N'en',@ObjID=75380000870
 
exec dbo.spRepLimTestResultsAmendmentHistory @LangID=N'en',@ObjID=76430000870
*/

create  Procedure [dbo].[spRepLimTestResultsAmendmentHistory]
    (
		@LangID as nvarchar(10),
        @ObjID	as bigint
    )
as

-- TODO: implement select fields. Check existing fields
--- see https://repos.btrp.net/BTRP/Project_Documents/10x-Business Analysis/21 Reports and Paper Forms/Templates v 6/Tests/TestResultReport - to be (with deleted parts).rtf 
	select  
				OldTestResult.name		as strFirstTestResult,
				amh.datAmendmentDate	as datAmendmentDate,
				dbo.fnConcatFullName(pen.strFamilyName, pen.strSecondName, pen.strFirstName)		as strAmendedByPerson,
				AmendByOffice.name		as strAmendedByOrganization,
				NewTestResult.name		as strNewTestResult,
				amh.strReason			as strReasonOfAmended,
				amh.strNewNote			as srtNewCommentary	,
				amh.strOldNote			as srtOldCommentary		
	from		tlbTesting	as t
		inner join  tlbTestAmendmentHistory as amh
		on		t.idfTesting = amh.idfTesting
		left join	tlbOffice ofc
		on		amh.idfAmendByOffice = ofc.idfOffice
		left join	tlbPerson pen
		on		amh.idfAmendByPerson = pen.idfPerson
		left join	dbo.fnReference(@LangID,19000045) AmendByOffice
		on		AmendByOffice.idfsReference = ofc.idfsOfficeAbbreviation	
		left join	dbo.fnReference(@LangID,19000096) OldTestResult
		on		OldTestResult.idfsReference = amh.idfsOldTestResult	
		left join	dbo.fnReference(@LangID,19000096) NewTestResult
		on		NewTestResult.idfsReference = amh.idfsNewTestResult				
	where	t.idfTesting = @ObjID
			and	t.intRowStatus=0
			

