
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/10/2017
-- Last modified by:		Joan Li
-- Description:				4/10/2017: Created baseed on V6 spLoginUserInternal: resume @flag input paramter 
--							branching out with new login and old login method
/*
----testing code:

DECLARE	@return_value int,
		@Result int,
		@UserID bigint
EXEC	@return_value = [dbo].[usp_LoginUserInternal]
		@UserName = N'admin',
		@Password = 0x12456,
		@indContextN = N'N',
		@Result = @Result OUTPUT,
		@UserID = @UserID OUTPUT

SELECT	@Result as N'@Result',
		@UserID as N'@UserID'
SELECT	'Return Value' = @return_value
GO
*/
--=====================================================================================================      
/************************************************************      
* spLoginUserInternal.proc      
************************************************************/   
      
--##SUMMARY Performs login to the system.      
--##SUMMARY Login uses @UserName, @Password      
--##SUMMARY Password encoded using Challenge value returned by spLoginChallenge      
--##SUMMARY After successfull login current connection context is assotiated with @ClientID and user defined by login.      
      
--##REMARKS Author: Kletkin      
--##REMARKS Create date: 31.05.2010      
      
--##RETURNS @Result parameter returns the extended error code      
--##RETURNS   0 - No errors      
--##RETURNS   2 - User with such login/password is not found      
--##RETURNS   6 - Login is locked after 3 unsuccessfull login attempt.   
--##RETURNS   7 - User account is disabled.   
    
      
--@Flags 1-skip expiration check      
      
/*      
--Example of procedure call:      
*/      
      
CREATE PROCEDURE [dbo].[usp_LoginUserInternal]      
 @UserName as nvarchar(200),--##PARAM @UserName - user login      
 @Password as varbinary(max),--##PARAM @Password - user password      
 @Flags as int=null,
 @indContextN as varchar(10),      
 @Result as int output,      
 @UserID as bigint output      
AS      
BEGIN      
      
 declare @context nvarchar(100) 
	IF @indContextN is null 
		print 'login with new methond doing nothing.'
	ELSE
		set @context=dbo.fnGetContext()      
     
 declare @localSite bigint      
		select @localSite=strValue      
		from tstLocalSiteOptions       
		where strName='SiteID'      
 
 declare @challenge varbinary(max)     
 	IF  @indContextN is null 
		print 'login with new methond doing nothing.'
	ELSE 
		select @challenge=binChallenge      
		from tstLocalConnectionContext      
		where strConnectionContext=@context      
      
 Declare @error2 Nvarchar(255), @error6 Nvarchar(255) , @error7 Nvarchar(255)    
		Select @error2 = 'User with such login/password is not found',      
		@error6 = 'Login is locked',  @error7 = 'Login is disabled';    
		  
    IF  @indContextN is null 
		print 'login with new methond doing nothing.'
	ELSE 
		BEGIN 
		 if @challenge is null      
			Begin       
				exec usp_LogSecurityEvent @UserID,10110000,0, @error2    
				set @Result=2      
				return      
			end      
      END
 --declare @timestamp as datetime  ---BVCode    
 --set @timestamp=DATEADD(minute,-30,GETDATE())   ---BVCode    
      
 --declare @user bigint      
 declare @storedPassword varbinary(max)      
 declare @tryCount int      
 declare @person bigint      
 declare @userSite bigint      
 declare @firstName nvarchar(200)      
 declare @secondName nvarchar(200)      
 declare @familyName nvarchar(200)      
 declare @institution bigint      
 declare @tryDate datetime      
 declare @passwordSet datetime      
 --declare @webAccess bit---BVCode 
 declare  @Organization as nvarchar(200)
 declare @UserDisabled bit
 declare @strOptions as nvarchar(max)
--SELECT @webAccess = dbo.fnIsWebAccess() ---BVCode       
     
SELECT       
-- DISTINCT      
 @UserID=tstUserTable.idfUserID,       
 @userSite=tstSite.idfsSite,      
 @storedPassword=tstUserTable.binPassword,      
 --@tryCount=Logins.TryCount,      
 @tryCount=COALESCE(tstUserTableLocal.intTry,tstUserTable.intTry, 0),      
 @tryDate=ISNULL(tstUserTableLocal.datTryDate, tstUserTable.datTryDate),      
 @strOptions=ISNULL(tstUserTableLocal.strOptions, ''),
 @passwordSet=tstUserTable.datPasswordSet,      
 @person=tlbPerson.idfPerson,      
 @firstName=tlbPerson.strFirstName,      
 @secondName=tlbPerson.strSecondName,      
 @familyName=tlbPerson.strFamilyName,      
 @institution=tlbOffice.idfOffice,  
 @Organization = isnull(OfficeAbbreviation.name, OfficeAbbreviation.strDefault),
 @UserDisabled = tstUserTable.blnDisabled
 
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
LEFT JOIN dbo.fnReference('en',19000045) as OfficeAbbreviation       
ON   OfficeAbbreviation.idfsReference = tlbOffice.idfsOfficeAbbreviation      
LEFT JOIN tstUserTableLocal    
ON tstUserTable.idfUserID = tstUserTableLocal.idfUserID    
WHERE  strAccountName=@UserName      
   AND tstUserTable.intRowStatus = 0      
ORDER BY tstSite.idfsSite      
      
if @UserID is null or @storedPassword is null      
Begin      
 exec usp_LogSecurityEvent @UserID,10110000,0, @error2      
 set @Result=2      
 return      
end      
      
declare @lockInterval int      
declare @lockTreshold int      
      
select @lockInterval=intAccountLockTimeout from dbo.fnPolicyValue()      
select @lockTreshold=intAccountTryCount from dbo.fnPolicyValue()       
      
--is account locked      
if @tryCount>=@lockTreshold and (DATEDIFF(s, @tryDate, getutcdate())/60)<@lockInterval      
begin      
 exec usp_LogSecurityEvent @UserID,10110000,0, @error6      
 set @Result=6      
 return      
end      

--is account disabled      
if @UserDisabled = 1      
begin      
 exec usp_LogSecurityEvent @UserID,10110000,0, @error7      
 set @Result=7      
 return      
end      
      
declare @total varbinary(100)      
      
exec usp_CalculatePasswordHash @storedPassword,@challenge,@total output      
      
if @total<>@Password      
begin      
 if @tryCount>=@lockTreshold   
 set @tryCount = 1  
 else  
 set @tryCount = @tryCount + 1  
   
 if exists (select 1 from tstUserTableLocal where idfUserID = @UserID)    
  update tstUserTableLocal      
  set  intTry=@tryCount,      
    datTryDate=getutcdate()      
  where idfUserID=@UserID      
 else    
 insert tstUserTableLocal (idfUserID, intTry, datTryDate)    
 values (@userID, @tryCount+1, getutcdate())    
     
 exec usp_LogSecurityEvent @UserID,10110000,0, @error2      
 set @Result= 2      
 return      
end      
    
      
--is password expired      JL: need to confirm: now @flag is use to detect expired 
if (isnull(@Flags,0) & 1)=0      
begin      
 declare @passwordAge int      
 select @passwordAge=intPasswordAge from dbo.fnPolicyValue()      
      
 if datediff(d,isnull(@passwordSet,'2000-01-01T00:00:00'),getutcdate())>=@passwordAge      
 begin      
  --exec usp_LogSecurityEvent @UserID,1,0    --BV code  
  set @Result=9      
  return      
 end      
end      
      
---------actual site calculation      
--if @webAccess<>1      
--begin      
-- set @userSite=@localSite       
--end      
set @userSite=isnull(@userSite,@localSite)      
---------actual site calculation      
DECLARE @blnDiagnosisDenied  bit
DECLARE @blnSiteDenied  bit
if exists	(	select	* from tstObjectAccess oa_diag_user_deny
				inner join trtDiagnosis d 
					on d.idfsDiagnosis = oa_diag_user_deny.idfsObjectID
				where
					oa_diag_user_deny.intPermission = 1						-- deny
					and oa_diag_user_deny.idfActor = @person
					and oa_diag_user_deny.idfsObjectOperation = 10059003	-- Read
					and oa_diag_user_deny.idfsOnSite = dbo.fnPermissionSite()
					and oa_diag_user_deny.intRowStatus = 0
			)
	set @blnDiagnosisDenied = 1
else
	set @blnDiagnosisDenied = 0

if exists	(	select	* from tstObjectAccess oa_diag_user_deny
				inner join trtDiagnosis d 
					on d.idfsDiagnosis = oa_diag_user_deny.idfsObjectID
				where
					oa_diag_user_deny.intPermission = 1						-- deny
					and oa_diag_user_deny.idfActor = @person
					and oa_diag_user_deny.idfsObjectOperation = 10059003	-- Read
					and oa_diag_user_deny.idfsOnSite = dbo.fnPermissionSite()
					and oa_diag_user_deny.intRowStatus = 0
			)
	or
	exists	(
					select		*
					from		tstObjectAccess oa_diag_group_deny
					inner join	tlbEmployeeGroupMember egm_diag_group_deny
					on			egm_diag_group_deny.idfEmployee = @person
								and egm_diag_group_deny.intRowStatus = 0
								and oa_diag_group_deny.idfActor = egm_diag_group_deny.idfEmployeeGroup
					inner join	tlbEmployee eg_diag_group_deny
					on			eg_diag_group_deny.idfEmployee = egm_diag_group_deny.idfEmployeeGroup
								and eg_diag_group_deny.intRowStatus = 0
					inner join trtDiagnosis d 
						on d.idfsDiagnosis = oa_diag_group_deny.idfsObjectID
					where		oa_diag_group_deny.intPermission = 1					-- deny
								and oa_diag_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_diag_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_diag_group_deny.intRowStatus = 0
			)
	set @blnDiagnosisDenied = 1
else
	set @blnDiagnosisDenied = 0


if exists	(
					select		*
					from		tstObjectAccess oa_site_user_deny
					inner join	tstSite s
					on			s.idfsSite = oa_site_user_deny.idfsObjectID
								and s.intRowStatus = 0
					where		oa_site_user_deny.intPermission = 1						-- deny
								and oa_site_user_deny.idfActor = @person
								and oa_site_user_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_user_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_user_deny.intRowStatus = 0
						)
		or exists	(
					select		*
					from		tstObjectAccess oa_site_group_deny
					inner join	tlbEmployeeGroupMember egm_site_group_deny
					on			egm_site_group_deny.idfEmployee = @person
								and oa_site_group_deny.idfActor = egm_site_group_deny.idfEmployeeGroup
								and egm_site_group_deny.intRowStatus = 0
					inner join	tlbEmployee eg_site_group_deny
					on			eg_site_group_deny.idfEmployee = egm_site_group_deny.idfEmployeeGroup
								and eg_site_group_deny.intRowStatus = 0
					inner join	tstSite s
					on			s.idfsSite = oa_site_group_deny.idfsObjectID
								and s.intRowStatus = 0
					where		oa_site_group_deny.intPermission = 1					-- deny
								and oa_site_group_deny.idfsObjectOperation = 10059003	-- Read
								and oa_site_group_deny.idfsOnSite = dbo.fnPermissionSite()
								and oa_site_group_deny.intRowStatus = 0
						)
 	set @blnSiteDenied = 1
else
	set @blnSiteDenied = 0

     IF @indContextN is NULL
		print 'new login method and doing nothing'
	ELSE
		exec usp_SetLoginContext @UserID, @userSite, @blnDiagnosisDenied, @blnSiteDenied 
      
 if exists (select 1 from tstUserTableLocal where idfUserID = @UserID)    
  update tstUserTableLocal      
  set  intTry=null,    
    datTryDate=getutcdate()      
  where idfUserID=@UserID      
 else    
	insert tstUserTableLocal (idfUserID, intTry, datTryDate)    
	values (@userID, null, getutcdate())    
     
exec usp_LogSecurityEvent @UserID,10110000,1      
      
set @Result=0      
select       
  @UserID as 'idfUserID',      
  @person as 'idfPerson',      
  @firstName as 'strFirstName',      
  @secondName as 'strSecondName',      
  @familyName as 'strFamilyName',      
  @institution as 'idfInstitution',  
  @UserName as 'strUserName',
  @Organization as 'strLoginOrganization',
  @strOptions as 'strOptions',
  @userSite as 'idfsSite'
      
return      
      
END 

