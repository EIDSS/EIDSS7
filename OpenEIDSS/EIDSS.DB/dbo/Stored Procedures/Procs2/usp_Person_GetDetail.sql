

--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/19/2017
-- Last modified by:		Joan Li
-- Description:				04/19/2017: Created based on V6 spPerson_SelectDetail : rename for V7
--                          04/26/2017: change name to : usp_Person_GetDetail
--                          Input: personid, languageid; Output: person list, group list
--                          07/03/2017: JL open user blockeded code
-- Testing code:
/*
----testing code:
DECLARE @idfPerson BIGINT 
exec usp_Person_GetDetail @idfPerson, 'en'
*/

--====================================================================================================
--##SUMMARY Selects data for PersonDetail form.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.12.2009
--##RETURNS Doesn't use
CREATE        PROCEDURE [dbo].[usp_Person_GetDetail]

( 

	@idfPerson AS BIGINT  --##PARAM @idfPerson - person ID

	,@LangID NVARCHAR(50) --##PARAM @LangID - language ID

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



--1, User Table jl:BV blocked 4/19/2017 reopen 7/3/2017 based on discussion 

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
 

-- Groups
SELECT		
	EG.idfEmployeeGroup,
	EG.idfsEmployeeGroupName,
	E.idfEmployee,
	ISNULL(GroupName.name,EG.strName) AS strName,
	EG.strDescription
FROM		dbo.tlbEmployeeGroup EG

INNER JOIN	dbo.tlbEmployeeGroupMember EM ON	EM.idfEmployeeGroup=EG.idfEmployeeGroup

INNER JOIN	dbo.tlbEmployee E ON E.idfEmployee=EM.idfEmployee

LEFT JOIN fnReference(@LangID, 19000022) GroupName ON GroupName.idfsReference = EG.idfsEmployeeGroupName

WHERE		

E.intRowStatus=0 

AND EG.idfEmployeeGroup<>-1 

AND EG.intRowStatus=0

AND EM.intRowStatus = 0

AND E.idfEmployee = @idfPerson



