
CREATE PROCEDURE [dbo].[spLoginByTicket]
	@strTicket nvarchar(100),
	@intExpirationInterval int = 10,
	@Result as int output
AS
	DECLARE @UserID as bigint 
	BEGIN TRAN
	SELECT @UserID = idfUserID
	FROM tstUserTicket
	WHERE strTicket = @strTicket
		and DATEDIFF(s, datExpirationDate , GETDATE()) <= @intExpirationInterval
	IF(@@ROWCOUNT > 0 and @UserID IS NOT NULL)
		SET @Result = 0
	ELSE 
		SET @Result = 2      
	
	DELETE FROM tstUserTicket
	WHERE strTicket = @strTicket

	--DELETE FROM tstUserTicket
	--WHERE DATEDIFF(s, datExpirationDate , GETDATE()) > @intExpirationInterval

	COMMIT TRAN
	DECLARE @person bigint      
	DECLARE @userSite bigint      
	DECLARE @firstName nvarchar(200)      
	DECLARE @secondName nvarchar(200)      
	DECLARE @familyName nvarchar(200)      
	DECLARE @institution bigint      
	DECLARE @Organization as nvarchar(200)  
	DECLARE @UserName as nvarchar(200)
	declare @strOptions as nvarchar(max)
	SELECT       
	-- DISTINCT      
	 @UserID=tstUserTable.idfUserID,       
	 @userSite=tstSite.idfsSite,      
	 @person=tlbPerson.idfPerson,      
	 @strOptions=ISNULL(tstUserTableLocal.strOptions, ''),
	 @firstName=tlbPerson.strFirstName,      
	 @secondName=tlbPerson.strSecondName,      
	 @familyName=tlbPerson.strFamilyName,      
	 @institution=tlbOffice.idfOffice,
	 @UserName  = strAccountName,
	 @Organization  = isnull(OfficeAbbreviation.name, OfficeAbbreviation.strDefault)       
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
		where tstUserTable.idfUserID = @UserID
	
      
	declare @localSite bigint      
	select @localSite=strValue      
	from tstLocalSiteOptions       
	where strName='SiteID'
	      
	---------actual site calculation      
	--declare @webAccess bit
	--SELECT @webAccess = dbo.fnIsWebAccess()       

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
    
	exec spSetLoginContext @UserID, @userSite, @blnDiagnosisDenied, @blnSiteDenied

	SELECT       
	  @UserID as 'idfUserID',      
	  @person as 'idfPerson',      
	  @firstName as 'strFirstName',      
	  @secondName as 'strSecondName',      
	  @familyName as 'strFamilyName',      
	  @institution as 'idfInstitution',  
	  @UserName as 'strUserName',
	  @Organization as 'strLoginOrganization',
	  @strOptions as 'strOptions'
RETURN 0

