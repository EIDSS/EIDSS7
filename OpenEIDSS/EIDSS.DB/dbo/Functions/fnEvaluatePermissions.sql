

/*
	select * from fnEvaluatePermissions(1)
*/

CREATE FUNCTION dbo.fnEvaluatePermissions
(	
	@idfEmployee bigint
)
RETURNS TABLE 
AS
RETURN 
(
select		trtSystemFunction.idfsSystemFunction,
			trtBaseReference.strBaseReferenceCode,
			trtObjectTypeToObjectOperation.idfsObjectOperation,
			COALESCE(
						nullif(min(isnull(InstanceUser.intPermission,999)),999),
						nullif(min(isnull(InstanceDefault.intPermission,999)),999),
						nullif(min(isnull(TypeUser.intPermission,999)),999),
						nullif(min(isnull(TypeDefault.intPermission,999)),999),
						2
					) as intPermission
from		trtSystemFunction
inner join	trtBaseReference
on			trtBaseReference.idfsBaseReference=trtSystemFunction.idfsSystemFunction
inner join	trtObjectTypeToObjectOperation
on			trtSystemFunction.idfsObjectType=trtObjectTypeToObjectOperation.idfsObjectType
--user rights on instance
left join
(
			select		tstObjectAccess.idfsObjectID,
						tstObjectAccess.idfsObjectOperation,
						tstObjectAccess.intPermission
			from		tstObjectAccess
			inner join	fn_ObjectActorRelations(@idfEmployee) Groups
			on			tstObjectAccess.idfActor=Groups.idfEmployee and
						tstObjectAccess.intRowStatus=0 and
						tstObjectAccess.intPermission in (1,2) and 
						tstObjectAccess.idfsOnSite=dbo.fnPermissionSite()
)InstanceUser
on			trtSystemFunction.idfsSystemFunction=InstanceUser.idfsObjectID and
			trtObjectTypeToObjectOperation.idfsObjectOperation=InstanceUser.idfsObjectOperation
--default rights on instance
left join
(
			select		tstObjectAccess.idfsObjectID,
						tstObjectAccess.idfsObjectOperation,
						tstObjectAccess.intPermission
			from		tstObjectAccess
			where		tstObjectAccess.idfActor=-1 and
						tstObjectAccess.intRowStatus=0 and 
						tstObjectAccess.idfsOnSite=dbo.fnPermissionSite()
)InstanceDefault
on			trtSystemFunction.idfsSystemFunction=InstanceDefault.idfsObjectID and
			trtObjectTypeToObjectOperation.idfsObjectOperation=InstanceDefault.idfsObjectOperation
--user rights on Type
left join
(
			select		tstObjectAccess.idfsObjectOperation,
						tstObjectAccess.idfsObjectType,
						tstObjectAccess.intPermission
			from		tstObjectAccess
			inner join	fn_ObjectActorRelations(@idfEmployee) Groups
			on			tstObjectAccess.idfActor=Groups.idfEmployee and
						tstObjectAccess.intRowStatus=0 and
						tstObjectAccess.idfsObjectID is null and 
						tstObjectAccess.idfsOnSite=dbo.fnPermissionSite()

)TypeUser
on			trtSystemFunction.idfsObjectType=TypeUser.idfsObjectType and
			trtObjectTypeToObjectOperation.idfsObjectOperation=TypeUser.idfsObjectOperation
--default rights on Type
left join
(
			select		tstObjectAccess.idfsObjectOperation,
						tstObjectAccess.idfsObjectType,
						tstObjectAccess.intPermission
			from		tstObjectAccess
			WHERE		tstObjectAccess.idfActor=-1 and
						tstObjectAccess.intRowStatus=0 and
						tstObjectAccess.idfsObjectID is null and 
						tstObjectAccess.idfsOnSite=dbo.fnPermissionSite()
)TypeDefault
on			trtSystemFunction.idfsObjectType=TypeDefault.idfsObjectType and
			trtObjectTypeToObjectOperation.idfsObjectOperation=TypeDefault.idfsObjectOperation

where		trtBaseReference.intRowStatus=0
	AND trtSystemFunction.intRowStatus = 0

group by	trtSystemFunction.idfsSystemFunction,
			trtBaseReference.strBaseReferenceCode,
			trtObjectTypeToObjectOperation.idfsObjectOperation
)

