
-- the return value of this function  depends on the value that is set by using SET DATEFIRST

CREATE    function fnWeekDatepart (@Date dateTime)
returns int
as
begin

declare @SDate datetime

-- move to the 4-th day in current week
set @SDate = dateadd(day, 4 - DATEPART(dw, @Date) , @Date)

-- get first january in the year of 4-th week day
declare @FirstDayOfYear datetime
set @FirstDayOfYear = dateadd(day, 1 - day(@SDate), @SDate)
set @FirstDayOfYear = dateadd(month, 1 - month(@SDate), @FirstDayOfYear)

-- return the number of 4-th days in the year
return 1 + datediff(day, @FirstDayOfYear, @SDate)/7
end

