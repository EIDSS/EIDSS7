

--##SUMMARY Returns the result of adding specified numbers of years, months and days to specified initial date.
--##SUMMARY If all units are not specified or equal to 0 (if needed) or incorrect, function returns null.
--##SUMMARY If initial date is not specified, function returns null.
--##SUMMARY If result of adding time periods to initial date is out of range, function returns null.


--##REMARKS Author: Olga Mirnaya.
--##REMARKS Create date: 18.08.2015

--##RETURNS Returns int value


/*
--Example of function call:
SELECT dbo.fnAddDMYToDate('20120915', 17, 1, -2, 1)

*/

CREATE    function [dbo].[fnAddDMYToDate]
		(	  @Date			datetime	--##PARAM @Date	Initial date to add years, months, and days
			, @D			int			--##PARAM @D number of days (-31 <= @D <= 31) to add to initial date
			, @M			int			--##PARAM @M number of months (-11 <= @M <= 11) to add to initial date
			, @Y			int			--##PARAM @Y number of years to add to initial date
			, @NullForZeros	bit = 1		--##PARAM @NullForZeros indicator whether Null values shall be return for @Y = @M = @D = 0 or null
		)
returns datetime
as
begin

	declare	@resD	datetime
	
	set @Y = isnull(@Y, 0)
	set @M = isnull(@M, 0)
	set @D = isnull(@D, 0)
	
	if	(@Date is null)
		or	(	@NullForZeros = 1
				and @Y = 0 and @M = 0 and @D = 0
			)
		or	(@M > 11) or (@M < -11) or (@D > 31) or (@D < -31)
		or	not(YEAR(@Date) + @Y between 1800 and 9800)
		set	@resD = null
	else
	begin
		set	@resD = dateadd(Day, @D, dateadd(Month, @M, dateadd(Year, @Y, @Date)))
--		set	@resD = dateadd(Month, @M, @resD)
--		set	@resD = dateadd(Day, @D, @resD)
	end

    return @resD

end











