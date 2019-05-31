


--##SUMMARY Selects lookup list of hospitals for syndromic surveillance table.

--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 

--##RETURNS Doesn't use


/*
--Example of procedure call:
exec spRepSyndromicHospitalSelectLookup 'en'

*/

create      PROCEDURE dbo.spRepSyndromicHospitalSelectLookup
	@LangID As nvarchar(50) --##PARAM @LangID - language ID

as
	declare @CountryID bigint
	
	SELECT		@CountryID = tcpac.idfsCountry
	FROM tstCustomizationPackage tcpac
	JOIN tstSite s ON
		s.idfCustomizationPackage = tcpac.idfCustomizationPackage
	JOIN tstLocalSiteOptions lso ON
		lso.strName = N'SiteID'
		AND lso.strValue = CAST(s.idfsSite AS NVARCHAR(200))
 				
 				
	select
		ss.idfsSite AS idfInstitution
		,[name]
		, fir.intRowStatus
  
	from tlbBasicSyndromicSurveillance ss
	join dbo.fnInstitutionRepair(@LangID) fir	
		on fir.idfOffice = ss.idfHospital
	order by fir.name



