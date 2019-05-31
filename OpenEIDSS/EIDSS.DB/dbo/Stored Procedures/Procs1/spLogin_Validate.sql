



--##SUMMARY Checks if user with requested login exists on specific site.

--##REMARKS Author: Zurin M.
--##REMARKS Upadte date: 19.01.2010

--##RETURNS count of users with passed account name (except checked user)


/*
--Example of procedure call:
DECLARE @idfUserID bigint
DECLARE @strAccountName nvarchar(200)


EXECUTE spLogin_Validate 
   @idfUserID
  ,@strAccountName


*/



CREATE            PROCEDURE [dbo].[spLogin_Validate]( 
	@idfUserID		AS BIGINT,			--##PARAM @idfUserID - ID of user related with requested login
	@strAccountName	AS NVARCHAR(200)	--##PARAM @strAccountName - user login
)
AS


SELECT 
	COUNT(tstUserTable.idfUserID)
FROM 
	tstUserTable 
INNER JOIN tlbPerson On
	tstUserTable.idfPerson = tlbPerson.idfPerson
INNER JOIN tlbEmployee On
	tlbPerson.idfPerson = tlbEmployee.idfEmployee
	and tlbEmployee.intRowStatus = 0
LEFT JOIN tstUserTable ut_id
	INNER JOIN tlbPerson p_id On
		ut_id.idfPerson = p_id.idfPerson
	INNER JOIN tlbEmployee e_id On
		p_id.idfPerson = e_id.idfEmployee
		and e_id.intRowStatus = 0
On	ut_id.idfUserID = @idfUserID
	and ut_id.intRowStatus = 0
	and ut_id.strAccountName = @strAccountName
WHERE 
	tstUserTable.strAccountName=@strAccountName
	AND tstUserTable.intRowStatus = 0
	AND tstUserTable.idfUserID<>isnull(@idfUserID, -100)

RETURN 0



