


--##SUMMARY Selects data for PersonDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.12.2009

--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @idfPerson BIGINT 
exec spPerson_SelectDetail @idfPerson, 'en'

*/


CREATE        PROCEDURE dbo.spPerson_SelectDetail
( 
	@idfPerson AS BIGINT  --##PARAM @idfPerson - person ID
	,@LangID nvarchar(50) --##PARAM @LangID - language ID

)
	
AS
SELECT idfPerson
      ,idfsStaffPosition
      ,idfInstitution
      ,idfDepartment
      ,strFamilyName
      ,strFirstName
      ,strSecondName
      ,strContactPhone
      ,strBarcode
	  ,tlbEmployee.idfsSite
  FROM tlbPerson
INNER JOIN 
	tlbEmployee ON
	tlbPerson.idfPerson=tlbEmployee.idfEmployee
WHERE 
	tlbEmployee.idfEmployee=@idfPerson
	AND tlbEmployee.intRowStatus=0 
	AND tlbEmployee.idfsEmployeeType=10023002 --Person 

--1, User Table
/*
Select	 
		UT.idfUserID
		,UT.idfPerson
		,UT.idfsSite
		,UT.strAccountName
		,S.strSiteID
		,S.strSiteName
		,S.idfsSiteType
		,ISNULL(Rf.name, Rf.strDefault) AS strSiteType
From dbo.tstUserTable UT
Inner Join dbo.tstSite S On S.idfsSite = UT.idfsSite And S.intRowStatus = 0
Inner Join dbo.fnReference(@LangID, 19000085/*Site Type*/) Rf On S.idfsSiteType = Rf.idfsReference
WHERE
	UT.idfPerson=@idfPerson
	And UT.intRowStatus=0
*/ 

-- Groups
select		
	EG.idfEmployeeGroup,
	EG.idfsEmployeeGroupName,
	E.idfEmployee,
	ISNULL(GroupName.name,EG.strName) as strName,
	EG.strDescription
from		dbo.tlbEmployeeGroup EG
inner join	dbo.tlbEmployeeGroupMember EM on	EM.idfEmployeeGroup=EG.idfEmployeeGroup
inner join	dbo.tlbEmployee E on E.idfEmployee=EM.idfEmployee
left Join fnReference(@LangID, 19000022) GroupName on GroupName.idfsReference = EG.idfsEmployeeGroupName
where		
E.intRowStatus=0 
And EG.idfEmployeeGroup<>-1 
And EG.intRowStatus=0
And EM.intRowStatus = 0
And E.idfEmployee = @idfPerson

