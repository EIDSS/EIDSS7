
/************************************************************      
* spSetLoginContext  
************************************************************/      
      
--##SUMMARY Stores login information into tstLocalConnectionContext table for current context      
--##SUMMARY Called internally by spLoginByTicket and by spLoginUserInternal procedures      
      
--##REMARKS Author: Zurin      
--##REMARKS Create date: 01.04.2015      
CREATE PROCEDURE spSetLoginContext
	@UserID as bigint 
	,@userSite bigint 
	,@blnDiagnosisDenied  bit
	,@blnSiteDenied  bit
AS
	declare @context nvarchar(100)      
	set @context=dbo.fnGetContext()      
	if isnull(@context,N'') <> N''
	begin  
		if Exists(select * from tstLocalConnectionContext where strConnectionContext=@context)
			update tstLocalConnectionContext      
			set  idfUserID=@UserID,      
			  idfsSite=@userSite,      
			  datLastUsed=getutcdate(),
			  blnDiagnosisDenied =  @blnDiagnosisDenied,
			  blnSiteDenied = @blnSiteDenied
			where strConnectionContext=@context      
		else
			insert into tstLocalConnectionContext(
				strConnectionContext,
				idfUserID,
				idfsSite,
				datLastUsed,
				blnDiagnosisDenied,
				blnSiteDenied
				)
			values(
				@context,
				@UserID,
				@userSite,
				getutcdate(),
				@blnDiagnosisDenied,
				@blnSiteDenied
				)
	end


RETURN 0

