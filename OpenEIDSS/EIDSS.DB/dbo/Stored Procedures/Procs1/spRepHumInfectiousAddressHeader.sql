

--##SUMMARY This procedure returns Header for Human Disease Intermediate reports

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumInfectiousAddressHeader 'en', 37020000000, 3260000000

*/ 
 
CREATE PROCEDURE [dbo].[spRepHumInfectiousAddressHeader]
	@LangID			as varchar(36),
	@RegionID		as bigint = null,
	@RayonID		as bigint = null
AS
BEGIN
	DECLARE @CountryID BIGINT
	SELECT		@CountryID = tcp1.idfsCountry
	FROM tstCustomizationPackage tcp1
	JOIN tstSite s ON
		s.idfCustomizationPackage = tcp1.idfCustomizationPackage
	INNER JOIN	tstLocalSiteOptions lso
	ON			lso.strName = N'SiteID'
	AND			lso.strValue = cast(s.idfsSite as nvarchar(20))

	SELECT   
		ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000001 /*rftCountry*/) WHERE idfsReference = @CountryID),'') +
		CASE WHEN @RegionID IS NOT NULL
			THEN ', '
			ELSE ''
		END +
		ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000003 /*rftRegion*/) WHERE idfsReference = @RegionID),'')+
		CASE WHEN @RayonID IS NOT NULL
			THEN ', '
			ELSE ''
		END +
		ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000002 /*rftRayon*/) WHERE idfsReference = @RayonID),'')
	AS strLocation		
END

