



--##SUMMARY Selects data for OrganizationDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfOffice bigint

EXECUTE spOrganization_SelectDetail 
	@idfOffice,
	'en'

EXECUTE spOrganization_SelectDetail 
	NULL,
	'en'
*/


create      PROCEDURE dbo.spOrganization_SelectDetail 
	@idfOffice AS BIGINT, --##PARAM @idfOffice - organization ID
	@LangID As nvarchar(50) --##PARAM @LangID - language ID
AS
--0 Organization
SELECT  
	idfOffice, 
	EnglishName, 
	EnglishFullName, 
	[name], 
	FullName, 
	strContactPhone, 
	idfLocation,
	intHACode,
	strOrganizationID,
	intOrder
FROM 
	dbo.fnInstitution(@LangID) 
WHERE 
	idfOffice=@idfOffice

--1 Departments
SELECT  idfDepartment, @idfOffice as idfOrganization, DefaultName, [name] 
FROM 
	dbo.fnDepartment(@LangID) 
WHERE 
	idfInstitution=@idfOffice


--2 Persons
SELECT idfPerson
      ,idfsStaffPosition
      ,idfInstitution
      ,idfDepartment
      ,strFamilyName
      ,strFirstName
      ,strSecondName
      ,strContactPhone
      ,strBarcode
	  ,tlbEmployee.idfsSite
  FROM tlbPerson
INNER JOIN 
	tlbEmployee ON
	tlbPerson.idfPerson=tlbEmployee.idfEmployee
WHERE 
	tlbPerson.idfInstitution=@idfOffice
	AND tlbEmployee.intRowStatus=0 
	AND tlbEmployee.idfsEmployeeType=10023002 --Person 



