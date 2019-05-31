
CREATE PROCEDURE [dbo].[spObjectAccess_SelectDetail]
(
	@LangID As nvarchar(50)
	,@idfEmployee bigint
)
AS
Begin
	--if @idfEmployee IS null create temp table with requiered structure and return it
	--this is needed to generate correct object
	if(@idfEmployee IS null)
	begin
		CREATE TABLE #tmp(
			idfObjectAccess bigint not null
			,FunctionName nvarchar(2000) null
			,idfsObjectOperation bigint null
			,ObjectOperationName nvarchar(2000) null
			,idfsObjectType bigint null
			,idfsObjectID bigint null
			,idfsSite bigint not null
			,strSiteID nvarchar(36) null
			,strSiteName nvarchar(200) null
			,idfEmployee bigint null
			,isAllow bit null
			,isDeny bit null
		)
	select * from #tmp
	return
	end
--return real data
SELECT
	y.idfObjectAccess
	, y.FunctionName
	, y.idfsObjectOperation
	, y.ObjectOperationName
	, y.idfsObjectType
	, y.idfsObjectID
	, y.idfsSite
	, y.strSiteID
	, y.strSiteName
	, @idfEmployee as [idfEmployee]
	, y.isAllow
	, y.isDeny
FROM (
	SELECT
		*
		,  ROW_NUMBER() OVER (PARTITION BY idfsObjectOperation, idfsObjectID, idfsSite ORDER BY x.idfEmployee DESC) rn
	FROM (
		Select
			idfObjectAccess
			,ObjectAccessNames.name as [FunctionName]
			,ObjectAccess.idfsObjectOperation
			,ObjectOperationNames.name as [ObjectOperationName]
			,ObjectAccess.idfsObjectType
			,idfsObjectID
			,[Site].idfsSite
			,[Site].strSiteID
			,[Site].strSiteName
			,ObjectAccess.idfActor as [idfEmployee]
			,Cast(case ObjectAccess.intPermission
				when 2 then 1 else 0
			End As Bit) as [isAllow]
			,Cast(case ObjectAccess.intPermission
				when 1 then 1 else 0
			end As Bit) as [isDeny]
		from dbo.[tstObjectAccess] ObjectAccess
		inner join dbo.fnReference(@LangID, 19000094) ObjectAccessNames On ObjectAccess.idfsObjectID = ObjectAccessNames.idfsReference
		inner join dbo.fnReference(@LangID, 19000059) ObjectOperationNames On ObjectAccess.idfsObjectOperation = ObjectOperationNames.idfsReference
		inner join dbo.tstSite [Site] On [Site].idfsSite = ObjectAccess.idfsOnSite
		
		JOIN trtObjectTypeToObjectOperation tottoo ON 
			tottoo.idfsObjectOperation = ObjectAccess.idfsObjectOperation
			AND tottoo.idfsObjectType = ObjectAccess.idfsObjectType
		
		where 
		ObjectAccess.intRowStatus = 0
		and (ObjectAccess.idfActor = @idfEmployee)
		and ObjectAccess.idfsOnSite = dbo.fnPermissionSite()
			
		UNION ALL	
			
		Select
			CAST(-ROW_NUMBER() OVER (ORDER BY ObjectAccessNames.name, ObjectOperationNames.name) as bigint) idfObjectAccess
			,ObjectAccessNames.name as [FunctionName]
			,ObjectAccess.idfsObjectOperation
			,ObjectOperationNames.name as [ObjectOperationName]
			,ObjectAccess.idfsObjectType
			,idfsObjectID
			,[Site].idfsSite
			,[Site].strSiteID
			,[Site].strSiteName
			,ObjectAccess.idfActor as [idfEmployee]
			,Cast(0 As Bit) as [isAllow]
			,Cast(0 As Bit) as [isDeny]
		from dbo.[tstObjectAccess] ObjectAccess
		inner join dbo.fnReference(@LangID, 19000094) ObjectAccessNames On ObjectAccess.idfsObjectID = ObjectAccessNames.idfsReference
		inner join dbo.fnReference(@LangID, 19000059) ObjectOperationNames On ObjectAccess.idfsObjectOperation = ObjectOperationNames.idfsReference
		inner join dbo.tstSite [Site] On [Site].idfsSite = ObjectAccess.idfsOnSite
		
		JOIN trtObjectTypeToObjectOperation tottoo ON 
			tottoo.idfsObjectOperation = ObjectAccess.idfsObjectOperation
			AND tottoo.idfsObjectType = ObjectAccess.idfsObjectType
		
		where 
			ObjectAccess.intRowStatus = 0
			and (ObjectAccess.idfActor = -1)	
			and ObjectAccess.idfsOnSite = dbo.fnPermissionSite()
	) x
) y
WHERE y.rn = 1
Order by [FunctionName], [ObjectOperationName]

end
