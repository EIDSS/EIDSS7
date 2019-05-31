


--##SUMMARY Returns table with system aggregate settings
--##SUMMARY that defines minimal adninistrative unit and period Type for different aggregate cases types.
--##SUMMARY If NULL is passed as input aggregate case Type, settings for this Type only is selected.
--##SUMMARY In other case all settings are selected.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 01.12.2009

--##RETURNS Doesn't use



/*
--Example of function call:
DECLARE @idfsAggrCaseType bigint
SET  @idfsAggrCaseType = 10102001
SELECT * FROM fnAggregateSettings(@idfsAggrCaseType)

*/

CREATE          function fnAggregateSettings(
	@idfsAggrCaseType bigint --##PARAM @idfsAggrCaseType - aggregate case Type
)
returns table
as
return(

SELECT fnReference.idfsReference as idfsAggrCaseType
      ,tcp1.idfCustomizationPackage
	  ,tcp1.idfsCountry
      ,ISNULL(tstAggrSetting.idfsStatisticAreaType,10089004/*Settlement*/) AS idfsStatisticAreaType 
      ,ISNULL(tstAggrSetting.idfsStatisticPeriodType,10091002/*Day*/) AS idfsStatisticPeriodType
--      ,tstAggrSetting.strValue
  FROM fnReference('en',19000102 /*Aggregate case Type*/) 
LEFT OUTER JOIN tstAggrSetting ON
	fnReference.idfsReference = tstAggrSetting.idfsAggrCaseType
	and tstAggrSetting.idfCustomizationPackage = dbo.fnCustomizationPackage()
INNER JOIN tstCustomizationPackage tcp1 ON
	tcp1.idfCustomizationPackage = dbo.fnCustomizationPackage()
WHERE 
	(@idfsAggrCaseType IS NULL OR fnReference.idfsReference = @idfsAggrCaseType)
)











