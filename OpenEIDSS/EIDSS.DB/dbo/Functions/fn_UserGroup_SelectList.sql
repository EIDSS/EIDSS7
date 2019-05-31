



/*
select * from dbo.fn_UserGroup_SelectList('ru')
*/




CREATE  function dbo.fn_UserGroup_SelectList(@LangID as nvarchar(50))
returns table 
as
return
	select		tlbEmployeeGroup.idfEmployeeGroup,
				tlbEmployeeGroup.idfsEmployeeGroupName,				
				ISNULL(GroupName.name,tlbEmployeeGroup.strName) as strName,
				tlbEmployeeGroup.strDescription
	from		tlbEmployeeGroup
	inner join	tlbEmployee
	on			tlbEmployee.idfEmployee=tlbEmployeeGroup.idfEmployeeGroup
	left join	fnReferenceRepair(@LangID, 19000022) GroupName -- translated group name
	on			GroupName.idfsReference = tlbEmployeeGroup.idfsEmployeeGroupName
	where		tlbEmployee.intRowStatus=0 and
				tlbEmployeeGroup.idfEmployeeGroup<>-1
				
/*
	select	TOP 100 PERCENT
				EE.idfEmployee, 
				EE.idfsEmployee_Type, 
				EG.strName as [name], 
				EG.strDescription as [Description]

	from		EmployeeGroup EG,
				Employee EE
	where		EE.idfEmployee = EG.idfEmployee
				--
				and EE.idfEmployee <> '{DEFA0000-0000-0000-0000-000000000000}'
				and IsNull(EE.intRowStatus, 0) = 0
 
	order by	EG.strName
*/


