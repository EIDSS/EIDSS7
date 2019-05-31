
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_Post:  V7 usp54
--                          purpose: save records in tlbStatistic
--                          06/15/2017: change action parameter
-- Lamont Mitchell			1/2/19 Added ReturnCode and ReturnMessage and changed @idfStatistic from output parameter added it to the Select output
/*
----testing code:
DECLARE @idfStatistic BIGINT
EXECUTE USP_ADMIN_STAT_SET 'd',10736140000000--10736130000000
select * from tlbStatistic
*/
--=====================================================================================================

CREATE PROCEDURE [dbo].[USP_ADMIN_STAT_SET]
	(
	 @idfStatistic						BIGINT = NULL	,	--##PARAM @idfStatistic - statistic record ID
	 @idfsStatisticDataType				BIGINT		= NULL,	--##PARAM @idfsStatisticDataType - statistic data Type
	 @idfsMainBaseReference				BIGINT		= NULL,	--##PARAM @idfsMainBaseReference - statistic base reference
 	 @idfsStatisticAreaType				BIGINT		= NULL,	--##PARAM @idfsStatisticAreaType - statistic Area Type
	 @idfsStatisticPeriodType			BIGINT		= NULL,	--##PARAM @idfsStatisticPeriodType - statistic period Type
	 @LocationUserControlidfsCountry	BIGINT		= NULL,	--##PARAM @idfsArea - statistic Area
	 @LocationUserControlidfsRegion		BIGINT		= NULL,	--##PARAM @idfsArea - statistic Area
	 @LocationUserControlidfsRayon 		BIGINT		= NULL,	--##PARAM @idfsArea - statistic Area
	 @datStatisticStartDate				DATETIME	= NULL,	--##PARAM @datStatisticStartDate - start date
	 @datStatisticFinishDate			DATETIME	= NULL,	--##PARAM @datStatisticFinishDate - finish date 
	 @varValue							SQL_VARIANT = NULL,	--##PARAM @varValue - statistic content
	 @idfsStatisticalAgeGroup			BIGINT		= NULL,
	 @idfsParameterName					BIGINT		= NULL
	)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
Declare @SupressSelect table
( 
	retrunCode int,
	returnMessage varchar(200)
)
BEGIN

	BEGIN TRY  	

		BEGIN TRANSACTION

			IF NOT EXISTS (SELECT * FROM dbo.tlbStatistic WHERE  idfStatistic = @idfStatistic) 

				BEGIN
					INSERT INTO @SupressSelect
					EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbStatistic', @idfStatistic OUTPUT

					INSERT INTO tlbStatistic
						(
							idfStatistic,
							idfsStatisticDataType,
							idfsMainBaseReference,
							idfsStatisticAreaType,
							idfsStatisticPeriodType,
							idfsArea,
							datStatisticStartDate,
							datStatisticFinishDate,
							varValue,
							idfsStatisticalAgeGroup
						)
					VALUES
						(
							@idfStatistic,
							@idfsStatisticDataType,
							@idfsMainBaseReference,
						    @idfsStatisticAreaType,
							@idfsStatisticPeriodType,
							CASE ISNULL(@LocationUserControlidfsRayon , '') 
							WHEN '' THEN
								CASE ISNULL(@LocationUserControlidfsRegion, '') 
								WHEN '' THEN
										@LocationUserControlidfsCountry 
								ELSE 
										@LocationUserControlidfsRegion 
								END 
							ELSE 
								@LocationUserControlidfsRayon  
							END,
						   @datStatisticStartDate,
						   @datStatisticFinishDate,
						   CAST(@varValue AS INT),
						   @idfsStatisticalAgeGroup
						)
				END

			ELSE 
				UPDATE	tlbStatistic
				SET		idfsStatisticDataType = @idfsStatisticDataType,
						idfsMainBaseReference = @idfsMainBaseReference,
						idfsStatisticAreaType = @idfsStatisticAreaType,
						idfsStatisticPeriodType = @idfsStatisticPeriodType,
						idfsArea = CASE ISNULL(@LocationUserControlidfsRayon , '') 
									WHEN '' THEN 
										CASE ISNULL(@LocationUserControlidfsRegion, '') 
											WHEN '' THEN 
												@LocationUserControlidfsCountry 
											ELSE 
												@LocationUserControlidfsRegion 
										END 
									ELSE 
										@LocationUserControlidfsRayon  
									END,
						datStatisticStartDate = @datStatisticStartDate,
						datStatisticFinishDate = @datStatisticFinishDate,
						varValue = CAST(@varValue AS INT),
						idfsStatisticalAgeGroup = @idfsStatisticalAgeGroup
				 WHERE 	idfStatistic = @idfStatistic

		-- Commit the transaction
		IF @@TRANCOUNT > 0
			COMMIT  
		
		Select @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' , @idfStatistic 'idfStatistic'
	END TRY  

	BEGIN CATCH  

		-- Execute error retrieval routine. 
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK


			END;
			Throw;		
	END CATCH; 
END


