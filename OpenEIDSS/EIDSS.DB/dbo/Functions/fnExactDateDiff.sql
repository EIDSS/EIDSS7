
--##SUMMARY Returns the difference between specified Start Date and End Date in specified units (1 - years, 2 - months, 3 - days).
--##SUMMARY If units are not specified or incorrect, the function returns the difference between days in Years units.
--##SUMMARY If at least of one start or end dates is not specified, the function returns -1000000.

--##REMARKS Author: Olga Mirnaya.
--##REMARKS Create date: 18.08.2015

--##RETURNS Returns int value


/*
--Example of function call:
SELECT dbo.fnExactDateDiff(1, '20120915', '20100101')
SELECT dbo.fnExactDateDiff(1, '20090915', '20100101')
SELECT dbo.fnExactDateDiff(2, '20091001', '20100101')
SELECT dbo.fnExactDateDiff(2, '20091215', '20100101')

*/

CREATE    function fnExactDateDiff
		(	@DateUnit int,			--##PARAM @DateUnit unit for calulating difference between dates
			@StartDate datetime,	--##PARAM @StartDate start date for calulating difference between dates
			@EndDate datetime		--##PARAM @DateUnit end date for calulating difference between dates
		)
returns int
as
begin

	declare	@diff	int
	if	@StartDate is null or @EndDate is null
		set	@diff = -1000000
	else begin

		declare	@ChangeDateValue datetime
		declare	@StartEndDatesSgn	int = 1
		
		if	@StartDate > @EndDate
		begin
			set	@StartEndDatesSgn = -1

			set	@ChangeDateValue = @EndDate
			set	@EndDate = @StartDate
			set	@StartDate = @ChangeDateValue
		end

		declare	@ddStart int = day(@StartDate)
		declare	@mmStart int = month(@StartDate)
        declare @yyyyStart int = year(@StartDate)

		declare	@ddEnd int = day(@EndDate)
		declare	@mmEnd int = month(@EndDate)
        declare @yyyyEnd int = year(@EndDate)

		declare	@ChangeIntValue int


        if (@ddEnd <= 0) or (@ddStart <= 0) or (@mmEnd <= 0) or (@mmStart <= 0) or (@yyyyEnd <= 0) or (@yyyyStart <= 0)
			set	@diff = -1000000
		else begin
			set	@diff = -1000000

            declare	@sgnY int = 1
            declare	@sgnM int = 1
            declare	@sgnD int = 1

            if (@yyyyEnd < @yyyyStart)
            begin
                set	@sgnY = @sgnY * (-1)
				
				set	@ChangeIntValue = @yyyyEnd
				set	@yyyyEnd = @yyyyStart
				set	@yyyyStart = @ChangeIntValue
            end
            else if (@yyyyEnd = @yyyyStart)
            begin
                set	@sgnY = 0
            end

            if (@mmEnd < @mmStart)
            begin
                set	@sgnM = @sgnM * (-1)
				
				set	@ChangeIntValue = @mmEnd
				set	@mmEnd = @mmStart
				set	@mmStart = @ChangeIntValue
            end
            else if (@mmEnd = @mmStart)
            begin
                set	@sgnM = 0
            end

            if (@ddEnd < @ddStart) 
            begin
                set	@sgnD = @sgnD * (-1)
				
				--set	@ChangeIntValue = @ddEnd
				--set	@ddEnd = @ddStart
				--set	@ddStart = @ChangeIntValue
            end
            else if (@ddEnd = @ddStart)
            begin
                set	@sgnD = 0
            end
            
            declare @sgnYM int = @sgnY + (1 - @sgnY * @sgnY) * @sgnM

			set	@diff = @StartEndDatesSgn *
				case	@DateUnit
					when	1	-- Years
						then	@sgnY * (@yyyyEnd - @yyyyStart + @sgnM * @sgnM * (cast(((@sgnM * @sgnY - 1) / 2) as int)) 
									 + (1 - @sgnM * @sgnM) * @sgnD * @sgnD * (cast(((@sgnD * @sgnY - 1) / 2) as int)))
                    when	2	-- Months
						then	@sgnY * (@yyyyEnd - @yyyyStart) * 12 + @sgnM * (@mmEnd - @mmStart) + 
									@sgnYM * @sgnD * @sgnD * (cast(((@sgnD * @sgnYM - 1) / 2) as int))
                    when	3	-- Days
						then	datediff(dd, @StartDate, @EndDate)
					else	-- Incorrect (Years)
							@sgnY * (@yyyyEnd - @yyyyStart + @sgnM * @sgnM * (cast(((@sgnM * @sgnY - 1) / 2) as int)) 
								 + (1 - @sgnM * @sgnM) * @sgnD * @sgnD * (cast(((@sgnD * @sgnY - 1) / 2) as int)))
				end
		end
	end

    return @diff

end










