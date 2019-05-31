﻿

--##SUMMARY Returns the correct operator in the string form.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.04.2010

--##RETURNS Function returns the correct operator in the string form.


/*
--Example of a call of function:
declare @strOperator		nvarchar(200)
declare @intOperatorType	int
declare @blnUseNot			bit

select	dbo.fnAsGetSearchOperator
		(	@strOperator,
			@intOperatorType,
			@blnUseNot
		)

*/


create	function	fnAsGetSearchOperator
(
	@strOperator		nvarchar(200),	--##PARAM @strOperator The name of the operator Type (Unary or Binary)
	@intOperatorType	int,			--##PARAM @intOperatorType The number from the Operator Type enum for specified operator
	@blnUseNot			bit				--##PARAM @blnUseNot The parameter that determines whether to use NOT for specified operator
)
returns varchar(20)
as
begin

declare @Operator varchar(20)
set @Operator = ''

declare @Not	bit
set	@Not = IsNull(@blnUseNot, 0)

if (@strOperator = 'Binary')
begin
	if	((@intOperatorType = 0) and (@Not = 0))
		or ((@intOperatorType = 1) and (@Not = 1))
		set	@Operator = '='
	else if	((@intOperatorType = 1) and (@Not = 0))
			or ((@intOperatorType = 0) and (@Not = 1))
		set @Operator = '<>'
	else if	((@intOperatorType = 2) and (@Not = 0))
			or ((@intOperatorType = 4) and (@Not = 1))
		set @Operator = '>'
	else if	((@intOperatorType = 3) and (@Not = 0))
			or ((@intOperatorType = 5) and (@Not = 1))
		set @Operator = '<'
	else if	((@intOperatorType = 4) and (@Not = 0))
			or ((@intOperatorType = 2) and (@Not = 1))
		set @Operator = '<='
	else if	((@intOperatorType = 5) and (@Not = 0))
			or ((@intOperatorType = 3) and (@Not = 1))
		set @Operator = '>='
	else if	(@intOperatorType = 6) and (@Not = 0)
		set @Operator = 'like'
	else if	(@intOperatorType = 6) and (@Not = 1)
		set @Operator = 'not like'
end
else if (@strOperator = 'Unary')
begin
	if (@intOperatorType = 4) and (@Not = 0)
		set	@Operator = 'is null'
	else if	(@intOperatorType = 4) and (@Not = 1)
		set @Operator = 'is not null'
else if (@strOperator = 'OutlookInterval')
	if (@intOperatorType = 23) and (@Not = 0)	-- Is Interval Beyond This Year
		set	@Operator = ''
	else if	(@intOperatorType = 23) and (@Not = 1) -- Is Interval Not Beyond This Year
		set @Operator = ''
	
	else if (@intOperatorType = 24) and (@Not = 0)	-- Is Interval Later This Year
		set	@Operator = ''
	else if	(@intOperatorType = 24) and (@Not = 1) -- Is Interval Earlier Or Beyond This Year
		set @Operator = ''
	
	else if (@intOperatorType = 25) and (@Not = 0)	-- Is Interval Later This Month
		set	@Operator = ''
	else if	(@intOperatorType = 25) and (@Not = 1) -- Is Interval Earlier Or Beyond This Month
		set @Operator = ''

	else if (@intOperatorType = 26) and (@Not = 0)	-- Is Interval Next Week
		set	@Operator = ''
	else if	(@intOperatorType = 26) and (@Not = 1) -- Is Interval Not Next Week
		set @Operator = ''

	else if (@intOperatorType = 27) and (@Not = 0)	-- Is Interval Later This Week
		set	@Operator = ''
	else if	(@intOperatorType = 27) and (@Not = 1) -- Is Interval Earlier Or Beyond This Week
		set @Operator = ''

	else if (@intOperatorType = 28) and (@Not = 0)	-- Is Interval Tomorrow
		set	@Operator = ''
	else if	(@intOperatorType = 28) and (@Not = 1) -- Is Interval Not Tomorrow
		set @Operator = ''

	else if (@intOperatorType = 29) and (@Not = 0)	-- Is Interval Today
		set	@Operator = ''
	else if	(@intOperatorType = 29) and (@Not = 1) -- Is Interval Not Today
		set @Operator = ''

	else if (@intOperatorType = 30) and (@Not = 0)	-- Is Interval Yesterday
		set	@Operator = ''
	else if	(@intOperatorType = 30) and (@Not = 1) -- Is Interval Not Yesterday
		set @Operator = ''

	else if (@intOperatorType = 31) and (@Not = 0)	-- Is Interval Earlier This Week
		set	@Operator = ''
	else if	(@intOperatorType = 31) and (@Not = 1) -- Is Interval Later Or Beyond This Week
		set @Operator = ''

	else if (@intOperatorType = 32) and (@Not = 0)	-- Is Interval Last Week
		set	@Operator = ''
	else if	(@intOperatorType = 32) and (@Not = 1) -- Is Interval Not Last Week
		set @Operator = ''

	else if (@intOperatorType = 33) and (@Not = 0)	-- Is Interval Earlier This Month
		set	@Operator = ''
	else if	(@intOperatorType = 33) and (@Not = 1) -- Is Interval Later Or Beyond This Month
		set @Operator = ''

	else if (@intOperatorType = 34) and (@Not = 0)	-- Is Interval Earlier This Year
		set	@Operator = ''
	else if	(@intOperatorType = 34) and (@Not = 1) -- Is Interval Later Or Beyond This Year
		set @Operator = ''

	else if (@intOperatorType = 35) and (@Not = 0)	-- Is Interval Prior This Year
		set	@Operator = ''
	else if	(@intOperatorType = 35) and (@Not = 1) -- Is Interval Later Or Beyond This Year
		set @Operator = ''
	
end

return @Operator
end



