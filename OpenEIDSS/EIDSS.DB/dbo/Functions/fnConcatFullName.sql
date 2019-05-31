
--=========================================================================
--Checked by: Joan Li 
--Checked on: 6/19/2017
--Note: checked for V7 USP66: usp_HumanCase_GetDetail call this function
/*
----Example of function call:
DECLARE @FullName nvarchar(100)
SELECT @FullName = [dbo].[fnConcatFullName]( N'Doe', N'John', N'nomiddle')
Select @FullName
*/
--=========================================================================
CREATE FUNCTION [dbo].[fnConcatFullName]
(
	@LastName nvarchar(50), 
	@FirstName nvarchar(50), 
	@SecondName nvarchar(50)
)
RETURNS NVARCHAR(400)
AS
	BEGIN
	 RETURN IsNull(@LastName, N'') + IsNull(' ' + @FirstName, '') + IsNull(' ' +@SecondName, '')
	END

