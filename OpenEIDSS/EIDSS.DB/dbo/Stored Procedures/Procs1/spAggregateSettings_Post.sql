


--##SUMMARY Posts AggregateSettings data

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 01.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @idfsAggrCaseType bigint
DECLARE @idfCustomizationPackage bigint
DECLARE @idfsStatisticAreaType bigint
DECLARE @idfsStatisticPeriodType bigint

EXECUTE spAggregateSettings_Post
   @idfsAggrCaseType
  ,@idfCustomizationPackage
  ,@idfsStatisticAreaType
  ,@idfsStatisticPeriodType
*/


CREATE       procedure dbo.spAggregateSettings_Post
			 @idfsAggrCaseType		bigint --##PARAM @idfsAggrCaseType - aggregate case Type
			,@idfCustomizationPackage			bigint --##PARAM @idfsCountry - country ID for posted settings
			,@idfsStatisticAreaType	bigint --##PARAM @idfsStatisticAreaType - statistic Area Type
			,@idfsStatisticPeriodType bigint --##PARAM @idfsStatisticPeriodType - statistic period Type
as
IF EXISTS(SELECT * FROM tstAggrSetting WHERE idfsAggrCaseType=@idfsAggrCaseType AND idfCustomizationPackage = @idfCustomizationPackage)
	UPDATE tstAggrSetting
	   SET 
		   idfsStatisticAreaType = @idfsStatisticAreaType
		  ,idfsStatisticPeriodType = @idfsStatisticPeriodType
	 WHERE  idfsAggrCaseType=@idfsAggrCaseType AND idfCustomizationPackage = @idfCustomizationPackage
ELSE
	INSERT INTO tstAggrSetting
           (
			idfsAggrCaseType
           ,idfCustomizationPackage
           ,idfsStatisticAreaType
           ,idfsStatisticPeriodType
			)
     VALUES
           (
			@idfsAggrCaseType
           ,@idfCustomizationPackage
           ,@idfsStatisticAreaType
           ,@idfsStatisticPeriodType
			)


