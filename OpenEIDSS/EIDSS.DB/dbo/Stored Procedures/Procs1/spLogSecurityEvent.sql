

CREATE PROCEDURE [dbo].[spLogSecurityEvent]
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
	exec spsysGetNewID @ID out

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


