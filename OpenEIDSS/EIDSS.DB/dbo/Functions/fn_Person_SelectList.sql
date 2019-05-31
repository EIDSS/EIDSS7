




--##SUMMARY Selects list of employees for PersonList form

--##REMARKS Author: Zurin M.
--##REMARKS Update date: 19.01.2010

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

SELECT * FROM fn_Person_SelectList('en')
*/


CREATE    FUNCTION fn_Person_SelectList(
	@LangID AS NVARCHAR(50) --##PARAM @LangID - language ID
)
RETURNS TABLE 
AS
RETURN

SELECT		tlbPerson.idfPerson AS idfEmployee, 
			tlbPerson.strFirstName,
			tlbPerson.strSecondName,
			tlbPerson.strFamilyName,
			Organization.[name] AS Organization,
			Organization.FullName AS OrganizationFullName,
			Organization.strOrganizationID,
			tlbPerson.idfInstitution,
			Position.[name] AS strRankName,
			Position.idfsReference AS idfRankName

FROM	tlbPerson
INNER JOIN	tlbEmployee
	ON		tlbEmployee.idfEmployee = tlbPerson.idfPerson
			AND tlbEmployee.intRowStatus = 0		
LEFT JOIN fnReferenceRepair(@LangID, 19000073 /*rftPosition*/) Position	
	ON		tlbPerson.idfsStaffPosition = Position.idfsReference
LEFT JOIN	fnInstitution(@LangID) AS Organization
	ON		Organization.idfOffice = tlbPerson.idfInstitution

WHERE ISNULL(tlbPerson.strFirstName, '') <> ''
	OR ISNULL(tlbPerson.strSecondName, '') <> ''
	OR ISNULL(tlbPerson.strFamilyName, '') <> ''


