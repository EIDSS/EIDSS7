--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/10/2017
-- Last modified by:		Joan Li
-- Description:				4/10/2017:change name for V7
/*
----testing code:

DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_SetLoginContext]
		@UserID = 1234567,
		@userSite = 2,
		@blnDiagnosisDenied =1,
		@blnSiteDenied =0
SELECT	'Return Value' = @return_value
GO
*/
--=====================================================================================================
/************************************************************      
* spSetLoginContext  
************************************************************/      
      
--##SUMMARY Stores login information into tstLocalConnectionContext table for current context      
--##SUMMARY Called internally by spLoginByTicket and by spLoginUserInternal procedures      
      
--##REMARKS Author: Zurin      
--##REMARKS Create date: 01.04.2015      
CREATE PROCEDURE [dbo].[usp_SetLoginContext]
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


