





CREATE   Proc spPerson_Delete
		@idfPerson bigint
As
-- StaffPosition
delete from tstObjectAccess WHERE idfActor = @idfPerson
delete from tlbEmployeeGroupMember where idfEmployee = @idfPerson
delete from tlbPerson WHERE idfPerson = @idfPerson
delete from tlbEmployee WHERE idfEmployee = @idfPerson








