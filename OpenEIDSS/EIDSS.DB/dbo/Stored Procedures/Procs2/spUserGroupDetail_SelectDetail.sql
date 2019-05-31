
CREATE PROCEDURE dbo.spUserGroupDetail_SelectDetail
(
	@idfEmployeeGroup bigint
	,@LangID nvarchar(50) = N'en'
)
AS
Begin
	select	EmployeeGroup.idfEmployeeGroup
			,EmployeeGroup.idfsEmployeeGroupName
			,EmployeeGroup.strName as [strGroupName]
			,GroupName.name as [strNationalGroupName]			
			,EmployeeGroup.idfsSite
			,[Site].strSiteID
			,EmployeeGroup.strDescription
	from	dbo.tlbEmployeeGroup EmployeeGroup
	left join	fnReference(@LangID, 19000022) GroupName on	GroupName.idfsReference = EmployeeGroup.idfsEmployeeGroupName
	Inner Join dbo.tstSite [Site] On [Site].idfsSite = EmployeeGroup.idfsSite
	where	EmployeeGroup.idfEmployeeGroup=@idfEmployeeGroup
End
