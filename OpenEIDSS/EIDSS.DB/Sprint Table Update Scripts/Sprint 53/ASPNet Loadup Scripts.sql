insert into aspNetRoles( id, idfEmployeeGroup, Name )
select trim(Lower(Newid())), idfEmployeeGroup,  strName 
from tlbEmployeeGroup 
where idfEmployeeGroup < 0
order by strname



