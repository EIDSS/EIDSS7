



--##SUMMARY Returns list of farms that are notrelated with cases (root farms).

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.11.2009

--##REMARKS UPDATED BY: Shatilova T.
--##REMARKS Date: 27.12.2011

--##RETURNS Returns list of farms that are notrelated with cases (root farms).



/*
select * from fn_Farm_SelectList ('en')
*/


CREATE     Function [dbo].[fn_Farm_SelectList](
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns table 
as
return
SELECT  
	idfFarmActual AS idfFarm, 
	strContactPhone, 
	strInternationalName, 
	strNationalName, 
	strFarmCode,
	idfsOwnershipStructure,
	idfsLivestockProductionType,
	tlbGeoLocationShared.idfsCountry,
	tlbGeoLocationShared.idfsRegion,
	tlbGeoLocationShared.idfsRayon,
	tlbGeoLocationShared.idfsSettlement,
	tr.strDefault as strAddressDefaultString,
	tlbHumanActual.strLastName,
	tlbHumanActual.strFirstName,
	tlbHumanActual.strSecondName,
	dbo.fnConcatFullName(tlbHumanActual.strLastName,tlbHumanActual.strFirstName,tlbHumanActual.strSecondName) as strOwnerName,
	Region.[name] as strRegion,  
	Rayon.[name] as strRayon,  
	Settlement.[name] as strSettlement,
	CAST (intHACode as bigint) as intHACode,
 	CASE WHEN (intHACode & 96) = 96 THEN Avian.strTextString + N', '+ Livestock.strTextString
		 WHEN (intHACode & 32) = 32 THEN Livestock.strTextString
		 WHEN (intHACode & 64) = 64 THEN Avian.strTextString
		 ELSE N'' END as strFarmType
FROM tlbFarmActual  
LEFT JOIN tlbHumanActual ON  
 tlbHumanActual.idfHumanActual = tlbFarmActual.idfHumanActual  
LEFT JOIN tlbGeoLocationShared ON  
 tlbGeoLocationShared.idfGeoLocationShared = tlbFarmActual.idfFarmAddress  
LEFT JOIN dbo.fnGeoLocationSharedTranslation(@LangID) tr  
 on tlbGeoLocationShared.idfGeoLocationShared = tr.idfGeoLocationShared  
LEFT JOIN dbo.fnGisReference(@LangID,19000003) Region  
  on Region.idfsReference = tlbGeoLocationShared.idfsRegion  
 LEFT JOIN dbo.fnGisReference(@LangID,19000002) Rayon  
  on Rayon.idfsReference = tlbGeoLocationShared.idfsRayon  
 LEFT  JOIN dbo.fnGisReference(@LangID,19000004) Settlement  
  on Settlement.idfsReference = tlbGeoLocationShared.idfsSettlement  
 LEFT JOIN trtStringNameTranslation Livestock
	on Livestock.idfsBaseReference = 10040007 
	AND Livestock.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
 LEFT JOIN trtStringNameTranslation Avian
	on Avian.idfsBaseReference = 10040003 
	AND Avian.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
WHERE tlbFarmActual.intRowStatus = 0  
