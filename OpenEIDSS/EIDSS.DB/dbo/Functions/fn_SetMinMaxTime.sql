﻿

--##SUMMARY Returns minimum or maximum datetime that belong to given day.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 03.12.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
select [dbo].[fn_SetMinMaxTime] ('12/03/2009 12:01:43', 0)
select [dbo].[fn_SetMinMaxTime] ('12/03/2009 12:01:43', 1)

*/


CREATE              Function	[dbo].[fn_SetMinMaxTime](@InputDate as datetime, @MaxTime as bit) 
returns datetime
as
begin
	declare @time as varchar(10)
  
	if (@MaxTime = 0)
		set @time = ' 00:00:00'
	else
		set @time = ' 23:59:59'

	return convert(
					datetime, 
					str(Year(@InputDate)) + '-' + 
					str(Month(@InputDate)) + '-' + 
					str(Day(@InputDate)) + @time,
					20)
end




