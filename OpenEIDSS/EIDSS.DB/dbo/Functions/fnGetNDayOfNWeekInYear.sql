
--##SUMMARY getting N day of the N week of the N year

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 24.02.2014

--##RETURNS date


/*
declare 
	@WeekDay int,
	@Year int,
	@Week int
	
	set @Year = 2014
	set @Week = 1
	set @WeekDay = 4
	
	select dbo.fnGetNDayOfNWeekInYear(@WeekDay, @Year, @Week)
*/	

create function dbo.fnGetNDayOfNWeekInYear
(
	@WeekDay int,
	@Year int,
	@Week int
)
returns date
as 
begin
	if @WeekDay < 1 or @WeekDay > 7 return null
	  
	declare @FirstDayOfYear date
	declare @SDate date

	set @SDate = cast(@year as varchar) + '0101'

	-- get first january in the year of 4-th week day
	set @FirstDayOfYear = dateadd(day, 1 - day(@SDate), @SDate)
	set @FirstDayOfYear = dateadd(month, 1 - month(@SDate), @FirstDayOfYear)

	--print 'FirstDayOfYear:'
	--print @FirstDayOfYear

	set @SDate = dateadd(day, 4 - DATEPART(dw, @FirstDayOfYear) , @FirstDayOfYear)
	--print '4-th week day of first week in the year:'
	--print @SDate

	set @SDate = dateadd(week, @week-1, @FirstDayOfYear)
	--print 'add @week:'
	--print @SDate

	--print '1th week day'
	--set @SDate = dateadd(day, 1 - DATEPART(dw, @SDate), @SDate)
	--print @SDate

	--print '7th week day'
	--set @SDate = dateadd(day, 7 - DATEPART(dw, @SDate), @SDate)
	--print @SDate

	set @SDate = dateadd(day, @WeekDay - DATEPART(dw, @SDate), @SDate)
	
	return @SDate
end
