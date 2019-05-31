
--*************************************************************
-- Name 				: FN_GBL_ConcatFullName
-- Description			: Concatinate name parts to full name
--						
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- DECLARE @FullName nvarchar(100)
-- SELECT @FullName = [dbo].[FN_GBL_ConcatFullName]( N'Doe', N'John', N'nomiddle')
-- Select @FullName
--*************************************************************

CREATE FUNCTION [dbo].[FN_GBL_ConcatFullName]
(
	@LastName	NVARCHAR(50), 
	@FirstName	NVARCHAR(50), 
	@SecondName NVARCHAR(50)
)

RETURNS NVARCHAR(400)

AS
	BEGIN
		RETURN ISNULL(@LastName, N'') + ISNULL(' ' + @FirstName, '') + ISNULL(' ' +@SecondName, '')
	END