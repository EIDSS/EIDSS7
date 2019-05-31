
CREATE PROCEDURE [dbo].[spUserGroupMember_SelectDetail]
(
	@idfEmployeeGroup bigint
	,@LangID nvarchar(50) = N'en'
)
AS
Begin
	Select	Employee.idfEmployee	
			,Employee.idfsEmployeeType
			,EmployeeGroupMember.idfEmployeeGroup
			,Actor.name as [EmployeeTypeName]
			,IsNull(ISNULL(GroupName.name,EmployeeGroup.strName),dbo.fnConcatFullName(Person.strFamilyName,Person.strFirstName,Person.strSecondName))as [strName]
			,Office.idfsOfficeAbbreviation
			,OfficeName.name as [OrganizationName]
			,EmployeeGroup.strDescription
	from dbo.tlbEmployee Employee
	Inner Join dbo.tlbEmployeeGroupMember EmployeeGroupMember On EmployeeGroupMember.idfEmployee = Employee.idfEmployee
	left join dbo.tlbPerson Person on Employee.idfEmployee = Person.idfPerson
	left join dbo.tlbEmployeeGroup EmployeeGroup on	Employee.idfEmployee = EmployeeGroup.idfEmployeeGroup 
	--rftEmployeeType
	left join dbo.fnReference(@LangID,19000023) Actor on Actor.idfsReference=Employee.idfsEmployeeType
	-- translated group name
	left join dbo.fnReference(@LangID, 19000022) GroupName on GroupName.idfsReference = EmployeeGroup.idfsEmployeeGroupName
	left join dbo.tlbOffice Office On Person.idfInstitution = Office.idfOffice
	left join dbo.fnReference(@LangID, 19000045) OfficeName on Office.idfsOfficeAbbreviation = OfficeName.idfsReference

	where Employee.intRowStatus=0 
	and Employee.idfsEmployeeType in (10023001,10023002) -- user or group
	and EmployeeGroupMember.intRowStatus=0 
	and EmployeeGroupMember.idfEmployeeGroup = @idfEmployeeGroup

end
