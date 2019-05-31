

CREATE function [dbo].[fnCurrentCustomization]()

-- 20170622   rkirksey Migrate over to EIDSS 7
RETURNS BIGINT
AS
BEGIN
	DECLARE @idfsCustomization BIGINT
	SELECT		@idfsCustomization = ts.idfCustomizationPackage
	FROM		tstSite ts
	WHERE		ts.idfsSite = dbo.fnSiteID()
	RETURN @idfsCustomization
END

