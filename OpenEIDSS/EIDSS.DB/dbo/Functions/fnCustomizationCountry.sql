
/*
SELECT dbo.fnCustomizationCountry()
*/
CREATE FUNCTION [dbo].[fnCustomizationCountry]
(
)
RETURNS BIGINT
AS
BEGIN
	DECLARE @idfsCountry BIGINT
		
	SELECT
		@idfsCountry = tcp1.idfsCountry
	FROM tstCustomizationPackage tcp1
	WHERE tcp1.idfCustomizationPackage = dbo.fnCustomizationPackage()
	
	RETURN @idfsCountry
END

