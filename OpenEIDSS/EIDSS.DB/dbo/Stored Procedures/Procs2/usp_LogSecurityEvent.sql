

--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/10/2017
-- Last modified by:		Joan Li
-- Description:				4/10/2017: Change SP name for V7
/*
----testing code:

DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_LogSecurityEvent]
		@idfUserID = 123456789,
		@idfsAction = 987654321,
		@success = 1,
		@strErrorText = N'NUL',
		@strDescription = N'NULL',
		@idfObjectID = 0,
		@idfsProcessType = 10130000
SELECT	'Return Value' = @return_value
GO
*/
--=====================================================================================================
CREATE PROCEDURE [dbo].[usp_LogSecurityEvent]
(
	@idfUserID Bigint = Null
	,@idfsAction bigint
	,@success bit--success	
	,@strErrorText As Nvarchar(200) = Null
	,@strDescription As Nvarchar(200) = Null
	,@idfObjectID as bigint =0
	,@idfsProcessType as bigint = 10130000--eidss
)
AS
Begin
/*	
	Declare @typeID Bigint
	
	Set @typeID = case @type when 1 then 10110000
						when 0 then 10110001 
						when 2 then 10110005 
						end
*/
	declare @ID bigint
	exec usp_sysGetNewID @ID out

	insert into dbo.tstSecurityAudit(
		idfSecurityAudit
		,idfsAction
		,idfsResult
		,idfUserID
		,datActionDate
		,idfsProcessType
		,idfAffectedObjectType
		,idfObjectID
		,strErrorText
		,strProcessID
		,strDescription
	)
	values
	(
		@ID
		,@idfsAction--@typeID
		,case @success when 1 then 10120000 else 10120001 end
		,@idfUserID
		,GetUtcDate()
		,@idfsProcessType
		,0
		,@idfObjectID
		,@strErrorText
		,dbo.fnGetContext()
		,@strDescription
	)
END



