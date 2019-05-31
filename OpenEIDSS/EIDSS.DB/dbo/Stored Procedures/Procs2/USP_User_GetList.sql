-- =============================================
-- Author:		Steven L. Verner
-- Create date: 05.16.2019
-- Description:	Retrieves the list of tstUserTable users given either a idfUserID, 
-- idfPerson or if null the entire list of system users.
-- =============================================
CREATE PROCEDURE USP_User_GetList 
	-- Add the parameters for the stored procedure here
	@idfUserID bigint = null, 
	@idfPersonID bigint = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select distinct
		 p.idfPerson
		,u.idfUserID
		,p.idfInstitution
		,p.strFirstName
		,p.strFamilyName
		,Case when u.idfPerson is not null then 1 else 0 end as HasUserRecord
		,Case when au.idfUserID is not null then 1 else 0 end as HasASPNetUserRecord
		,Case when e.idfEmployee is not null then 1 else 0 end as HasEmployeeRecord
		,u.strAccountName [EIDSS Account Name]
		,au.UserName 
		,g.idfEmployeeGroup
		,g.strName Role
	from tlbPerson p
	left join tlbEmployee e on e.idfEmployee = p.idfPerson
	left join tstusertable u on u.idfPerson = p.idfperson 
	left join tlbEmployeeGroupMember gm on gm.idfEmployee = e.idfEmployee 
	left join tlbEmployeeGroup g on g.idfEmployeeGroup = gm.idfEmployeeGroup
	left join AspNetUsers au on au.idfUserID = u.idfUserID
	where g.idfEmployeeGroup < 0 
	and ( u.idfUserID = iif( @idfUserID is not null, @idfUserID, u.idfUserID ))
	and ( p.idfPerson = iif( @idfPersonID is not null, @idfPersonID, p.idfPerson ))
	order by p.strFirstName
END
GO
