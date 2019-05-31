

/*
select * from fn_ObjectActorRelations(70980000000)
*/

create  function dbo.fn_ObjectActorRelations
(
	@idfEmployee	bigint
)
returns @res table (idfEmployee bigint primary key)
as
begin

--if @ActorID is null 
--set @ActorID = dbo.fnPersonID()

if @idfEmployee is null 
return

insert into @res(idfEmployee)
values (@idfEmployee)

while @@rowcount > 0
	insert into @res(idfEmployee)
	select		tlbEmployeeGroupMember.idfEmployeeGroup
	from		tlbEmployeeGroupMember
	inner join	@res as total
	on			total.idfEmployee = tlbEmployeeGroupMember.idfEmployee
	left join	@res as exclude
	on			exclude.idfEmployee = tlbEmployeeGroupMember.idfEmployeeGroup
	where		exclude.idfEmployee is null and 
				tlbEmployeeGroupMember.intRowStatus = 0

return 
end







