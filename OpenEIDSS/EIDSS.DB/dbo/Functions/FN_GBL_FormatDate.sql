

/*
Author: Maheshwar D Deo
Description: Formats a date to a specific format.
Parameters:
     @DateField = A value or field of datatype datetime or a value or field that can be explicitly converted to 
                  a datetime datatype.
     @FormatAs varchar(40) = Format codes using the characters described below
       
     MMMM or DDDD = the full name for the day or month
     MMM or DDD = the first 3 letters of the month or day
     MM or DD = the two digit code signifying the month or day
     M1 or D1 = the month or day value without a preceding zero
     YYYY = a four digit year
     YY = a two digit year
     
     All other characters will not be replaced such as / - . * # a b z x % and will show
     up in the date in the same relative position that they appear in the format
     parameter.
     
     Examples
     select dbo.FN_GBL_FormatDate('9/21/2001','dddd, mmmm d1, yyyy') --> Friday, September 21, 2001
     select dbo.FN_GBL_FormatDate('9/21/2001','mm/dd/yyyy') --> 09/21/2001
     select dbo.FN_GBL_FormatDate('9/21/2001','mm-dd-yyyy') --> 09/21/2001
     select dbo.FN_GBL_FormatDate('9/21/2001','yyyymmdd') --> 20010921
     select dbo.FN_GBL_FormatDate('9/5/2001','m1/d1/yy') --> 9/5/01
     select dbo.FN_GBL_FormatDate('9/21/2001','mmm-yyyy') --> Sep-2001
*/

CREATE FUNCTION [dbo].[FN_GBL_FormatDate]
(
	@DateField	DATETIME,		--Date value to be formatted
	@FormatAs 	VARCHAR(40)    	--Format for date value
)
Returns VARCHAR(40)

AS

BEGIN

     -- Insert the Month
     -- ~~~~~~~~~~~~~~~~
     SET @FormatAs = REPLACE(@FormatAs,'MMMM',DATENAME(MONTH,@DateField))
     SET @FormatAs = REPLACE(@FormatAs,'MMM',CONVERT(CHAR(3),DATENAME(MONTH,@DateField)))
     SET @FormatAs = REPLACE(@FormatAs,'MM',RIGHT(CONVERT(CHAR(4),@DateField,12),2))
     SET @FormatAs = REPLACE(@FormatAs,'M1',CONVERT(VARCHAR(2),CONVERT(INT,RIGHT(CONVERT(CHAR(4),@DateField,12),2))))

     -- Insert the Day
     -- ~~~~~~~~~~~~~~
     SET @FormatAs = REPLACE(@FormatAs,'DDDD',DATENAME(WEEKDAY,@DateField))
     set @FormatAs = REPLACE(@FormatAs,'DDD',CONVERT(CHAR(3),DATENAME(WEEKDAY,@DateField)))
     SET @FormatAs = REPLACE(@FormatAs,'DD',RIGHT(CONVERT(CHAR(6),@DateField,12),2))
     SET @FormatAs = REPLACE(@FormatAs,'D1',CONVERT(VARCHAR(2),CONVERT(INT,right(CONVERT(CHAR(6),@DateField,12),2))))

     -- Insert the Year
     -- ~~~~~~~~~~~~~~~
     SET @FormatAs = REPLACE(@FormatAs,'YYYY',CONVERT(CHAR(4),@DateField,112))
     SET @FormatAs = REPLACE(@FormatAs,'YY',CONVERT(CHAR(2),@DateField,12))

     -- Return the function's value
     -- ~~~~~~~~~~~~~~~~~~~~~~~~~~~  
     RETURN @FormatAs
END

