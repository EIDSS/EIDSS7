

/*
exec spObjectAccess 10094041,10060053,'en'
exec spObjectAccess null, null, 'en'
*/


CREATE   PROCEDURE [dbo].[spObjectAccess](
	@ID bigint = NULL,
	@ObjectType bigint = NULL,
	@LangID As nvarchar(50)
)
AS


--select permissions
	select		tstObjectAccess.idfObjectAccess,
				tstObjectAccess.idfsObjectOperation,
				tstObjectAccess.idfsObjectType,
				tstObjectAccess.idfsObjectID,
				tstObjectAccess.idfActor,
				tstObjectAccess.intPermission,
				tstObjectAccess.idfsOnSite
	from		tstObjectAccess
	where		tstObjectAccess.intRowStatus=0 and
				tstObjectAccess.idfsOnSite = dbo.fnPermissionSite() and
				tstObjectAccess.idfsObjectType=@ObjectType and
				(
					(@ID is null and tstObjectAccess.idfsObjectID is null) or
					tstObjectAccess.idfsObjectID=@ID
				)

--select actors

	select		Actors.idfActor,
				Actors.idfsOnSite,
				UG.strName,
				UG.EmployeeTypeName,
				--UG.strSiteID,
				UG.strDescription
	from
		(
		select		distinct 
					tstObjectAccess.idfActor,
					tstObjectAccess.idfsOnSite
		from		tstObjectAccess
		where		tstObjectAccess.intRowStatus=0 and
					tstObjectAccess.idfsOnSite = dbo.fnPermissionSite() and
					tstObjectAccess.idfsObjectType=@ObjectType and
					(
					(@ID is null and tstObjectAccess.idfsObjectID is null) or
					tstObjectAccess.idfsObjectID=@ID
					)
		union
		select	-1,
				tstSite.idfsSite
		from	tstSite
		where	tstSite.idfsSite = dbo.fnPermissionSite()

		)Actors
	inner join	fn_UsersAndGroups_SelectList(@LangID) UG
	on			Actors.idfActor=UG.idfEmployee

	select		Operation.idfsObjectOperation,
				Names.name
	from		trtObjectTypeToObjectOperation Operation
	inner join	fnReference(@LangID,19000059) Names--rftObjectOperation
	on			Names.idfsReference=Operation.idfsObjectOperation
	where		Operation.idfsObjectType=@ObjectType


