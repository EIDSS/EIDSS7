
CREATE  PROCEDURE [dbo].[spUserLocked_TimeElapsed]
 @Organization NVARCHAR(200),--##PARAM @Organization - organization abbreviation  
 @UserName NVARCHAR(200)--##PARAM @UserName - user login   
AS
DECLARE @Result int, @LockDateTime DATETIME

declare @lockInterval int  
declare @lockTreshold int  
  
select @lockInterval=intAccountLockTimeout from dbo.fnPolicyValue()  
select @lockTreshold=intAccountTryCount from dbo.fnPolicyValue()  

SELECT   
	@LockDateTime = loc.datTryDate
FROM  tstUserTable
INNER JOIN tstUserTableLocal loc
	on tstUserTable.idfUserID = loc.idfUserID
INNER JOIN tlbPerson  
On   tlbPerson.idfPerson = tstUserTable.idfPerson  
   and tlbPerson.intRowStatus = 0  
INNER JOIN tlbOffice  
ON   tlbOffice.idfOffice = tlbPerson.idfInstitution  
   and tlbOffice.intRowStatus = 0  
INNER JOIN dbo.fnReference('en',19000045) as OfficeAbbreviation   
	ON   OfficeAbbreviation.idfsReference = tlbOffice.idfsOfficeAbbreviation  
 WHERE  strAccountName=@UserName  
   AND isnull(OfficeAbbreviation.name, OfficeAbbreviation.strDefault) = @Organization     
   AND tstUserTable.intRowStatus = 0  
AND loc.intTry >= @lockTreshold
ORDER By loc.datTryDate

DECLARE @interval INT
SET @interval =  DATEDIFF(s, @LockDateTime, getutcdate()) 

 
SET @Result = @lockInterval - @interval / 60  
  
SELECT @Result  


