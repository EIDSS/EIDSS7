﻿







-- select dbo.fnAlphaNumeric(10000,4), dbo.fnAlphaNumeric(193456,4), dbo.fnAlphaNumeric(1008,4)
CREATE  function fnAlphaNumeric(@number bigint, @digitsCount int = 4)
returns nvarchar(100)
as
begin
declare @res nvarchar(100), @i int, @n int, @maxDigitalNumber int, @mod int
set @i = 0
set @maxDigitalNumber=CAST (REPLICATE('9',@digitsCount) as int)

if @number<=@maxDigitalNumber
begin
	set @res = cast(@number as NVARCHAR)
	set @res = REPLICATE('0',@digitsCount-LEN(@res))+@res
	return @res
end

set @number = @number - (@maxDigitalNumber+1)
set @res = ''
set @i = 0
while @number>=0
begin
	IF @number<26
	BEGIN
		SET @mod=@number%26
		SET @res= char(ascii('A') + @mod) +@res
		SET @number = -1
	END
	ELSE
	BEGIN
		SET @mod=(@number -26)%36
		SET @number=(@number - 26)/36
		SET @res=CASE WHEN @mod>=0 and @mod<=9 THEN char(ascii('0')+@mod) ELSE char(ascii('A') + @mod -10) END+@res
	END
end
set @res = REPLICATE('0',@digitsCount-LEN(@res))+@res
return @res

end








