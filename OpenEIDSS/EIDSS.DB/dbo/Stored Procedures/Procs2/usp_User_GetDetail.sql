
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		5/8/2017
-- Last modified by:		Joan Li
-- Description:				5/9/2017: Sprint task Request 39: input USERID
/*
----testing code:
USE [EIDSS7]

DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_User_GetDetail]
		@UserID = 55423500000000
----SELECT	'Return Value' = @return_value
*/
--=====================================================================================================   
CREATE PROCEDURE [dbo].[usp_User_GetDetail]    
(
	-- Add the parameters for the stored procedure here
	 @UserID as bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		declare @l_userid bigint
		IF @UserID is null
			RAISERROR (15600,-1,-1, 'usp_User_GetDetail'); 
		ELSE
			BEGIN
				Select @l_userid=@UserID
  ----  -- Insert statements for procedure here
			print '@l_userid: '+ convert(varchar,@l_userid)
		
			SELECT       
			-- DISTINCT      
			 tstUserTable.idfUserID,       
			 tstSite.idfsSite,      
			 tstUserTable.binPassword,          
			 COALESCE(tstUserTableLocal.intTry,tstUserTable.intTry, 0) as tryCount,      
			 ISNULL(tstUserTableLocal.datTryDate, tstUserTable.datTryDate) as tryDate,      
			 ISNULL(tstUserTableLocal.strOptions, '') as strOptions,
			 tstUserTable.datPasswordSet as passwordSet,      
			 tlbPerson.idfPerson as person,      
			 tlbPerson.strFirstName as firstName,      
			 tlbPerson.strSecondName as secondName,      
			 tlbPerson.strFamilyName as familyName,      
			 tlbOffice.idfOffice as institution,  
			 isnull(OfficeAbbreviation.name, OfficeAbbreviation.strDefault) as Organization,
			 tstUserTable.blnDisabled as  UserDisabled
			----,strAccountName


			FROM  tstUserTable       
			INNER JOIN tlbPerson      
			On   tstUserTable.idfPerson = tlbPerson.idfPerson      
			INNER JOIN tlbEmployee      
			On   tlbEmployee.idfEmployee = tlbPerson.idfPerson      
			   and tlbEmployee.intRowStatus = 0      
			INNER JOIN tlbOffice      
			ON   tlbOffice.idfOffice = tlbPerson.idfInstitution      
			   and tlbOffice.intRowStatus = 0      
			LEFT JOIN tstSite      
			ON   tstSite.idfOffice=tlbPerson.idfInstitution and      
			   tstSite.intRowStatus=0      
			INNER JOIN dbo.fnReference('en',19000045) as OfficeAbbreviation       
			ON   OfficeAbbreviation.idfsReference = tlbOffice.idfsOfficeAbbreviation      
			LEFT JOIN tstUserTableLocal    
			ON tstUserTable.idfUserID = tstUserTableLocal.idfUserID    
			WHERE tstUserTable.idfUserID=@l_userid  
			   AND 	   tstUserTable.intRowStatus = 0      
			ORDER BY tstSite.idfsSite     

		END
 
END
