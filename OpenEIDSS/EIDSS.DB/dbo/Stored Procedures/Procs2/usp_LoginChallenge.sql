
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/12/2017
-- Last modified by:		Joan Li
-- Description:				Created based on V6 spLoginChallenge: rename for V7
-- Testing code:
/*
----testing code:
declare @challenge varbinary(max)
exec usp_LoginChallenge @challenge output
select @challenge
*/

--=====================================================================================================
--##SUMMARY Return security authority generated value.
--##SUMMARY This value should be used by client to mix pasword with this Challenge value
--##REMARKS Author: Kletkin
--##REMARKS Create date: 31.05.2010
--##RETURNS Should be always succeeded

CREATE PROCEDURE [dbo].[usp_LoginChallenge]
	@challenge varbinary(max) output
AS
BEGIN
	declare @context nvarchar(50)

	set @context=dbo.fnGetContext()

	if @context is null return
	delete	
	from	tstLocalConnectionContext
	where	datLastUsed<dateadd(d,-30,getutcdate())
	set @challenge=NewID()--0x6AB7F7794389E3479F9714FE83F67854--
	update	tstLocalConnectionContext
	set		binChallenge=@challenge,
			idfUserID=null,
			idfsSite=null
	where	strConnectionContext=@context
	if @@ROWCOUNT=0
	begin
		insert into tstLocalConnectionContext(strConnectionContext,binChallenge,datLastUsed)
		values(@context,@challenge,getutcdate())
	end
END




