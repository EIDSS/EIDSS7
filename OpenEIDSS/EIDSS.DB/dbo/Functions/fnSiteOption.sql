






CREATE     function [dbo].[fnSiteOption](
	@OptionName nvarchar(200),
	@DefValue nvarchar(200) = N''
	)
returns nvarchar(200)
as
begin

declare @Val as nvarchar(200)
	
select TOP 1 @Val = strValue 
from	tstLocalSiteOptions
where	strName = @OptionName
	
return IsNull(@Val, @DefValue)

end





