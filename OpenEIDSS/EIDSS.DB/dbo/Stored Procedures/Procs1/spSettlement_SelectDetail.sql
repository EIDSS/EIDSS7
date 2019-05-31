


--##SUMMARY Selects data for SettlementDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.11.2009

--##RETURNS Doesn't use
/*
--Example of a call of procedure:
DECLARE @idfsSettlement bigint
DECLARE @LangID varchar(50)
EXECUTE spSettlement_SelectDetail
   @idfsSettlement
  ,@LangID

EXECUTE spSettlement_SelectDetail
   NULL
  ,'en'

*/


CREATE     PROCEDURE dbo.spSettlement_SelectDetail(
	@idfsSettlement AS VARCHAR(36), --##PARAM @idfsSettlement - settlement ID
	@LangID as NVARCHAR(50) --##PARAM @LangID - language ID
)
AS
SELECT  
	idfsSettlement,
	dblLongitude, 
	dblLatitude, 
	idfsSettlementType, 
	idfsRayon, 
	idfsCountry, 
	idfsRegion,
	strSettlementCode,
	natSettlement.[name] as strNationalName,
	enSettlement.[name] as strEnglishName,
	blnIsCustomSettlement,
	gisSettlement.intElevation
FROM 
	gisSettlement
LEFT JOIN 
	fnGisReference(@LangID,19000004) as natSettlement --'rftSettlement'
on	natSettlement.idfsReference = idfsSettlement
LEFT JOIN 
	fnGisReference('en',19000004) as enSettlement --'rftSettlement'
on	enSettlement.idfsReference = idfsSettlement
WHERE
	idfsSettlement = @idfsSettlement 




