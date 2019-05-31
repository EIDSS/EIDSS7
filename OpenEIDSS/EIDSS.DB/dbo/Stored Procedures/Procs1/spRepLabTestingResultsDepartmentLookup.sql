

--##SUMMARY Select data for Antibiotic Resistance.
--##REMARKS Author: 
--##REMARKS Create date: 25.09.2014

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec [spRepLabTestingResultsDepartmentLookup] 'az-l', N'SAZQA000120174'
exec [spRepLabTestingResultsDepartmentLookup] 'ru', N'S120853'
exec [spRepLabTestingResultsDepartmentLookup] 'ru', N'1234'

select *
from tlbMaterial tm
		inner join tstSite ts
		on ts.idfsSite = tm.idfsCurrentSite
		inner join tlbOffice to1
		on to1.idfOffice = ts.idfOffice
		inner join tlbDepartment td
		on td.idfOrganization = to1.idfOffice
where
idfHumanCase is not null

 tm.strBarcode = N'SAZTO002110001'
	
	
*/

create  Procedure [dbo].[spRepLabTestingResultsDepartmentLookup]
	(
		@LangID	as nvarchar(10), 
		@SampleID	as varchar(36)
	)
AS	

declare @ReportTable table 
(
	idfsReference bigint primary key not null, 
	strName nvarchar(200)
)

--o If sample was not found it should returns (-2, null) 
--o If appropriate sample was found, and the laboratory (EIDSS site), where it is located, 
--		does not contain any department, it should returns (-1, null)
--o If appropriate sample was found, and the laboratory (EIDSS site), where it is located, 
--		contains at least one department, 
--		then names of all departments of this laboratory  shall be returned with their ids

if not exists (select * from tlbMaterial tm where tm.strBarcode = @SampleID)
begin
	insert into @ReportTable values (-2, null)
end
else
if not exists (
	select * 
	from tlbMaterial tm
		inner join tstSite ts
		on ts.idfsSite = tm.idfsCurrentSite
		inner join tlbOffice to1
		on to1.idfOffice = ts.idfOffice
		inner join tlbDepartment td
		on td.idfOrganization = to1.idfOffice
	where tm.strBarcode = @SampleID
)	
begin
	insert into @ReportTable values (-1, null) 
end
else 	
if exists (
	select * 
	from tlbMaterial tm
		inner join tstSite ts
		on ts.idfsSite = tm.idfsCurrentSite
		inner join tlbOffice to1
		on to1.idfOffice = ts.idfOffice
		inner join tlbDepartment td
		on td.idfOrganization = to1.idfOffice
	where tm.strBarcode = @SampleID
)	
begin
	insert into @ReportTable(idfsReference, strName)
	select td.idfDepartment, frr.name
	from tlbDepartment td
		inner join dbo.fnReferenceRepair(@LangID, 19000164) frr
		on td.idfsDepartmentName = frr.idfsReference
		inner join tlbOffice to1
		on td.idfOrganization = to1.idfOffice
		inner join tstSite ts
		on to1.idfOffice = ts.idfOffice
		inner join tlbMaterial tm
		on ts.idfsSite = tm.idfsCurrentSite
	where tm.strBarcode = @SampleID
	
	
end








select *
from @ReportTable


