----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: FN_GBL_AlphNumeric_GET
-- Description			: Get AlphaNumeric value - copied 6.1 code to V7
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
--
-- Testing code:
--
-- select dbo.FN_GBL_AlphNumeric_GET(10000,4), dbo.FN_GBL_AlphNumeric_GET(193456,4), dbo.FN_GBL_AlphNumeric_GET(1008,4)
----------------------------------------------------------------------------
----------------------------------------------------------------------------

CREATE  FUNCTION [dbo].[FN_GBL_AlphNumeric_GET](@number BIGINT, @digitsCount INT = 4)
RETURNS NVARCHAR(100)
AS

BEGIN
  DECLARE @res NVARCHAR(100), @i INT, @n INT, @maxDigitalNumber INT, @mod INT
  SET @i = 0
  SET @maxDigitalNumber=CAST (REPLICATE('9',@digitsCount) AS INT)

  IF @number<=@maxDigitalNumber
  BEGIN
	  SET @res = CAST(@number AS NVARCHAR)
	  SET @res = REPLICATE('0',@digitsCount-LEN(@res))+@res
	  RETURN @res
  END

  SET @number = @number - (@maxDigitalNumber+1)
  SET @res = ''
  SET @i = 0
  WHILE @number>=0
  BEGIN
  	IF @number<26
    BEGIN
	  SET @mod=@number%26
	  SET @res= CHAR(ASCII('A') + @mod) +@res
	  SET @number = -1
	END
	
	ELSE
	BEGIN
	  SET @mod=(@number -26)%36
	  SET @number=(@number - 26)/36
	  SET @res=CASE WHEN @mod>=0 and @mod<=9 THEN CHAR(ASCII('0')+@mod) ELSE CHAR(ASCII('A') + @mod -10) END + @res
	END
  END
  SET @res = REPLICATE('0',@digitsCount-LEN(@res))+@res
  RETURN @res

END

