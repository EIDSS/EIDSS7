

--##SUMMARY Select data for Antibiotic Resistance.
--##REMARKS Author: 
--##REMARKS Create date: 25.09.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec spRepLabAssignmentDiagnosticAZSendToLookup 'ru', 'HWEB00160095'
exec spRepLabAssignmentDiagnosticAZSendToLookup 'ru', 'HWEB00160001'
exec spRepLabAssignmentDiagnosticAZSendToLookup 'ru', '123'
*/

create  Procedure [dbo].[spRepLabAssignmentDiagnosticAZSendToLookup]
	(
		@LangID	as nvarchar(10), 
		@CaseID	as varchar(36)
	)
AS	

declare @ReportTable table 
(
	idfsReference bigint primary key not null, 
	strName nvarchar(200)
)

/*
input parameters: language, case id

output: organization  id, organization abbreviations

o If case was not found it should returns (-2, null) 
o If case was found, and it does not contain any registered sample meeting criteria of General filtration rules, it should returns (-1, null)
o If case was found, and there is at least one sample meeting criteria of General filtration rules registered in the case, 
then all unique non-blank abbreviations of organizations taken from Send to Organization attribute of all samples meeting criteria 
of General filtration rules shall be returned with their ids


*/

if not exists (select * from tlbHumanCase thc where thc.strCaseID = @CaseID)
begin
	-- -2 means that case does not exist
	insert into @ReportTable values (-2, null)
end
else	
if not exists (
	select		*
	from	tlbMaterial m
		inner join tlbHumanCase thc
		on thc.idfHumanCase = m.idfHumanCase
		and thc.intRowStatus = 0
	where	m.intRowStatus = 0
			and m.idfsSampleType <> 10320001 /*Unknown*/
			and m.idfParentMaterial is null /*it is initially collected sample*/
			and thc.strCaseID = @CaseID
)	
begin
	-- -1 means that case exists, but does not contain registered samples
	insert into @ReportTable values (-1, null) 
end
else
if exists (
	select		*
	from	tlbMaterial m
		inner join tlbHumanCase thc
		on thc.idfHumanCase = m.idfHumanCase
		and thc.intRowStatus = 0
		
		inner join fnInstitutionRepair(@LangID) i_sent_to
		on i_sent_to.idfOffice = m.idfSendToOffice
	where	m.intRowStatus = 0
			and m.idfsSampleType <> 10320001 /*Unknown*/
			and m.idfParentMaterial is null /*it is initially collected sample*/
			and thc.strCaseID = @CaseID
)
begin
	--	o If case was found, and there is at least one sample meeting criteria of General filtration rules registered in the case, 
	--then all unique non-blank abbreviations of organizations taken from Send to Organization attribute of all samples meeting criteria 
	--of General filtration rules shall be returned with their ids
	insert into @ReportTable (idfsReference, strName)
	select	distinct m.idfSendToOffice, i_sent_to.name
	from	tlbMaterial m
		inner join tlbHumanCase thc
		on thc.idfHumanCase = m.idfHumanCase
		and thc.intRowStatus = 0
		
		inner join fnInstitutionRepair(@LangID) i_sent_to
		on i_sent_to.idfOffice = m.idfSendToOffice
	where	m.intRowStatus = 0
			and m.idfsSampleType <> 10320001 /*Unknown*/
			and m.idfParentMaterial is null /*it is initially collected sample*/
			and thc.strCaseID = @CaseID
end	



select *
from @ReportTable


