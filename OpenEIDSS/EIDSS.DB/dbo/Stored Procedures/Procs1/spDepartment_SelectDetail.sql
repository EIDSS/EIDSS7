



--##SUMMARY Selects data for DepartmentDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfDepartment bigint

EXECUTE spDepartment_SelectDetail 
	@idfDepartment,
	'en'

EXECUTE spDepartment_SelectDetail 
	NULL,
	'en'
*/



CREATE     procedure dbo.spDepartment_SelectDetail 
	@idfDepartment as nvarchar(50), --##PARAM @idfDepartment - Department ID
	@LangID as nvarchar(50)  --##PARAM @LangID - language ID
as

SELECT  idfDepartment, idfInstitution as idfOrganization, DefaultName, [name] 
FROM 
	dbo.fnDepartment(@LangID) 
WHERE 
	idfDepartment=@idfDepartment



