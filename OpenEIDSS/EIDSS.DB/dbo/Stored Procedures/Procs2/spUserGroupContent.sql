﻿


CREATE PROCEDURE dbo.spUserGroupContent(@ID bigint = NULL, @LangID As nvarchar(50) = NULL)
AS

	select		--tlbEmployeeGroupMember.idfEmployeeGroupMember,
				UG.idfEmployee,
				UG.idfsEmployeeType,
				--UG.idfsSite,
				UG.strName,
				UG.strDescription
	from		tlbEmployeeGroupMember
	inner join	fn_UsersAndGroups_SelectList(@LangID) UG
	on			tlbEmployeeGroupMember.idfEmployee=UG.idfEmployee
	where		tlbEmployeeGroupMember.idfEmployeeGroup=@ID and 
				tlbEmployeeGroupMember.intRowStatus=0

/*
	SELECT 	
			EE.idfEmployee, 
			EE.idfsEmployee_Type, 
			EG.strName AS [name], 
			EG.strDescription AS [Description]
	FROM 	EmployeeGroup EG,
			Employee EE,
			Employee_Relationship ER
	WHERE EE.idfEmployee = EG.idfEmployee
	AND EG.idfEmployee = ER.idfRelated_Employee
	AND ER.idfParent_Employee = @ID
	--
	AND EE.intRowStatus = 0 
	AND ER.intRowStatus = 0 
	UNION 
	SELECT 	EE.idfEmployee, EE.idfsEmployee_Type, ISNULL(PE.strFirstName, '') + ' ' + ISNULL(PE.strSecondName, '') + ' ' + ISNULL(PE.strFamilyName, '')  AS [name], PE.strBarcode AS [Description]
	FROM 	Person PE,
			Employee EE,
			Employee_Relationship ER
	WHERE EE.idfEmployee = PE.idfEmployee
	AND ER.idfParent_Employee = @ID
	AND PE.idfEmployee = ER.idfRelated_Employee
	--
	AND EE.intRowStatus = 0 
	AND ER.intRowStatus = 0 
RETURN 0
*/
/*
exec spUserGroupContent @ID = '88BD3886-FB4A-4DA7-9C34-BB67B6DC0720'
*/



