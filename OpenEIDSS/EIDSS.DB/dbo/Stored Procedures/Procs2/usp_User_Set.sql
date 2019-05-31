
--=====================================================================================================
-- Created by:				Joan Li
-- Description:				04/19/2017: Created based on V6 spUser_Post :  V7 USP 10
--                          Input: 5 parameters related to user id, person id, site id an so on; Output: N/A 
--                          04/26/2017: insert,update and delete data from table tstUserTable
--                          06/15/2017: change action parameter
--                          06/21/2017: JL: need to wait for team deside adding new column to hold data change info
-- Testing code:
/*
----testing code:
EXECUTE usp_User_Set 'D',3448500000000, NULL,NULL,NULL
EXECUTE usp_User_Set 'I',55464340000000, 55464330000000,1176,'backend unittest'
EXECUTE usp_User_Set 'U',55464340000000, 55464330000000,1176,'backend unittest by JL'
select * from tstUserTable where idfuserid in(3448500000000,3448480000000,55464340000000)
*/

--=====================================================================================================

CREATE        PROCEDURE [dbo].[usp_User_Set]

( 

		 @Action Varchar(2)  --##PARAM @Action - set action,  I - add record, D - delete record, U - modify record
		,@idfUserID as bigint --##PARAM @idfUserID - user ID
		,@idfPerson as bigint  --##PARAM @idfPerson - person ID
		,@idfsSite bigint --##PARAM @idfsSite - site where user can login to system
		,@strAccountName  as nvarchar(200) --##PARAM @strAccountName - user login
		--,@blbPassword as varbinary(max)=null--##PARAM @strPassword - user password   ----BV Block code
)

AS
IF upper(@Action) = 'I' --insert

	BEGIN
		INSERT INTO tstUserTable
			   (
				idfUserID
				,idfPerson
				,idfsSite
				,strAccountName
				,binPassword
				,datPasswordSet
			   )
		 VALUES
			   (
				@idfUserID
				,@idfPerson
				,ISNULL(@idfsSite,dbo.fnSiteID())
				,@strAccountName
				--,isnull(@blbPassword,NewID())--@strPassword   ----BV Block code
				,NewID()
				,getdate()
			   )
	END
ELSE IF upper(@Action)='U' --Update

	BEGIN
		UPDATE tstUserTable --login form allows changing of user login and password only
		   SET 
				strAccountName = @strAccountName
				--,blbPassword = isnull(@blbPassword,blbPassword)  ----BV Block code
		 WHERE 	idfUserID=@idfUserID
	END

ELSE IF upper(@Action)='D' --DELETE
	BEGIN
		DELETE FROM tstUserTable
		WHERE 	idfUserID=@idfUserID
	END

	




