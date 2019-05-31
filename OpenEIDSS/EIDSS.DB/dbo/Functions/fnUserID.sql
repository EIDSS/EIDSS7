

/*

*/

CREATE  function [dbo].[fnUserID]()
returns bigint
as
begin

declare @user bigint
select @user = idfUserID 
from tstLocalConnectionContext
where strConnectionContext = dbo.fnGetContext()

if @user is null
begin
	select @user = idfUserID from tstUserTable 
	where strAccountName = suser_sname()
	and idfsSite = dbo.fnSiteID()
end

return @user
end


