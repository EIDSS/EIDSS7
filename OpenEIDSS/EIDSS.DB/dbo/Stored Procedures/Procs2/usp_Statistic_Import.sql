
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_Import:  V7 usp59
--                          purpose: insert or update statisic data parsed from csv format into table : tlbStatistic
/*
----testing code:JL: app will call it one by one?

*/
--=====================================================================================================

CREATE                  PROCEDURE [dbo].[usp_Statistic_Import](
                 @idfsStatisticDataType AS BIGINT --##PARAM @idfsStatisticDataType - statistic data type
                ,@strParameterValue AS NVARCHAR(200) --##PARAM @idfsMainBaseReference - statistic base reference
                ,@idfsStatisticAreaType AS BIGINT --##PARAM @idfsStatisticAreaType - statistic area type
                ,@idfsStatisticPeriodType AS BIGINT --##PARAM @idfsStatisticPeriodType - statistic period type
                ,@strCountry AS NVARCHAR(200) --##PARAM @idfsArea - statistic area
                ,@strRegion AS NVARCHAR(200) --##PARAM @idfsArea - statistic area
                ,@strRayon AS NVARCHAR(200) --##PARAM @idfsArea - statistic area
                ,@strSettlement AS NVARCHAR(200) --##PARAM @idfsArea - statistic area
                ,@datStatisticStartDate DATETIME --##PARAM @datStatisticStartDate - start date
                ,@datStatisticFinishDate DATETIME --##PARAM @datStatisticFinishDate - finish date 
				,@blnRelatedWithAgeGroup BIT
				,@strStatisticalAgeGroup AS NVARCHAR(200)
                ,@varValue SQL_VARIANT  --##PARAM @varValue - statistic content
)
AS
DECLARE @idfsCountry bigint
DECLARE @idfsRegion bigint
DECLARE @idfsRayon bigint
DECLARE @idfsSettlement bigint
DECLARE @idfsArea bigint
DECLARE @idfsMainBaseReference bigint
DECLARE @idfsStatisticalAgeGroup BIGINT

--Validate area names
SELECT @idfsCountry = idfsReference from dbo.fnGisReference('en',19000001) WHERE [name] = @strCountry IF(@idfsCountry IS NULL) 
        RETURN 1
IF(@idfsStatisticAreaType = 10089003 OR @idfsStatisticAreaType = 10089002 OR @idfsStatisticAreaType = 10089004) --REGION OR RAYON OR SETTLEMENT 
BEGIN
        SELECT @idfsRegion = idfsReference from dbo.fnGisReference('en',19000003) WHERE [name] = @strRegion
        IF(@idfsRegion IS NULL) 
                RETURN 2
END

IF(@idfsStatisticAreaType = 10089002 OR @idfsStatisticAreaType = 10089004) --RAYON OR SETTLEMENT 
BEGIN
        SELECT @idfsRayon = idfsReference from dbo.fnGisReference('en',19000002) WHERE [name] = @strRayon
        IF(@idfsRayon IS NULL) 
                RETURN 3
END


IF(@idfsStatisticAreaType = 10089004) --SETTLEMENT 
BEGIN
        SELECT @idfsSettlement = idfsReference from dbo.fnGisReference('en',19000004) WHERE [name] = @strSettlement
        IF(@idfsSettlement IS NULL) 
                RETURN 4
END

SELECT @idfsArea = CASE @idfsStatisticAreaType 
                                                WHEN 10089003 THEN @idfsRegion 
                                                WHEN 10089002 THEN @idfsRayon
                                                WHEN 10089004 THEN @idfsSettlement
                                                ELSE @idfsCountry END

if (ISNULL(@strParameterValue,N'')<>N'')
BEGIN
	DECLARE @idfsParameterType bigint 
	SELECT  
			@idfsParameterType = trtStatisticDataType.idfsReferenceType
	FROM 
			trtStatisticDataType
	LEFT JOIN 
			fnReference('en',19000090) ON--'rftStatisticDataType'
			fnReference.idfsReference = trtStatisticDataType.idfsStatisticDataType
	WHERE 
			trtStatisticDataType.intRowStatus = 0
			and fnReference.idfsReference = @idfsStatisticDataType

	SELECT @idfsMainBaseReference = idfsReference 
	FROM dbo.fnReference('en',@idfsParameterType) 
	WHERE [name] = @strParameterValue

	IF(@idfsMainBaseReference IS NULL) 
					RETURN 5
END
IF @blnRelatedWithAgeGroup=1
BEGIN
	SELECT @idfsStatisticalAgeGroup = idfsReference 
	FROM dbo.fnReference('en',19000145) --rftStatisticalAgeGroup
	WHERE [name] = @strStatisticalAgeGroup

	IF(@idfsStatisticalAgeGroup IS NULL) 
					RETURN 6
END
DECLARE @idfStatistic bigint
SELECT  @idfStatistic = idfStatistic 
FROM    tlbStatistic
WHERE
        idfsStatisticDataType = @idfsStatisticDataType
        and idfsStatisticPeriodType = @idfsStatisticPeriodType
        and datStatisticStartDate = @datStatisticStartDate
        and idfsStatisticAreaType = @idfsStatisticAreaType
        and idfsArea = @idfsArea
		and (@idfsStatisticalAgeGroup  IS NULL OR idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup)
        and (@idfsMainBaseReference  IS NULL OR idfsMainBaseReference= @idfsMainBaseReference)
        and intRowStatus = 0

----insert records
IF( @idfStatistic IS NULL)
	BEGIN
		exec usp_sysGetNewID @idfStatistic output
			INSERT INTO tlbStatistic
			(
				idfStatistic
			   ,idfsStatisticDataType
			   ,idfsMainBaseReference
			   ,idfsStatisticAreaType
			   ,idfsStatisticPeriodType
			   ,idfsStatisticalAgeGroup
			   ,idfsArea
			   ,datStatisticStartDate
			   ,datStatisticFinishDate
			   ,varValue
			)
		 VALUES
			(
				@idfStatistic
			   ,@idfsStatisticDataType
			   ,@idfsMainBaseReference
			   ,@idfsStatisticAreaType
			   ,@idfsStatisticPeriodType
			   ,@idfsStatisticalAgeGroup
			   ,@idfsArea
			   ,@datStatisticStartDate
			   ,@datStatisticFinishDate
			   ,@varValue
		   )
	END

ELSE 
	----update
	BEGIN
        UPDATE tlbStatistic
           SET varValue = @varValue
         WHERE  idfStatistic = @idfStatistic
            AND varValue <> @varValue
	END
RETURN 0

