
-- the return value of this function  depends on the value that is set by using SET DATEFIRST

CREATE    function fnWeekDatediff (@StartDate datetime, @EndDate datetime)
returns int
as
begin

declare @SDate datetime
declare @EDate datetime
declare @sgn int

if @StartDate > @EndDate
begin
	set @sgn = -1
	set @SDate = @EndDate
	set @EDate = @StartDate
end
else
begin
	set @sgn = 1
	set @SDate = @StartDate
	set @EDate = @EndDate
end

-- move to the last "first week day"
set @SDate = dateadd(day, 1 - DATEPART(dw, @SDate) , @SDate)
set @EDate = dateadd(day, 1 - DATEPART(dw, @EDate) , @EDate)
return @sgn * datediff(wk, @SDate, @EDate)
end










