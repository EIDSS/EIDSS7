
--*************************************************************
-- Name 				: USP_ADMIN_STAT_GetList
-- Description			: ISatistical Data List
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
-- execute USP_ADMIN_STAT_GetList 'en'
--*************************************************************

CREATE  PROCEDURE	[dbo].[USP_ADMIN_STAT_GetList]
(
  @LangID						NVARCHAR(50)--##PARAM @LangID - language ID
 ,@idfsStatisticalDataType		BIGINT = NULL
 ,@idfsArea						BIGINT = NULL
 ,@datStatisticStartDateFrom	DATETIME = NULL
 ,@datStatisticStartDateTo		DATETIME = NULL
)

AS

DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0 
DECLARE @SearchValue	SQL_VARIANT					-- fnsysSplitList returns "value" as SQL_VARIANT.
DECLARE @StartLoop		BIT = 0

BEGIN	

	BEGIN TRY  	

		DECLARE @sql		NVARCHAR(MAX)
				,@paramlist	NVARCHAR(4000)
				,@nl		CHAR(2) = CHAR(13) + CHAR(10)
	
		SELECT @sql = 	' SELECT * 
						  FROM   FN_ADMIN_STAT_GetList(@LangID) 				
						  WHERE  1 = 1' + @nl

		IF ISNULL(@idfsStatisticalDataType, 0) <> 0
			SELECT @sql += ' AND idfsStatisticDataType = @idfsStatisticalDataType' + @nl

		IF ISNULL(@idfsArea, 0) <> 0
			SELECT @sql += ' AND idfsArea = @idfsArea' + @nl

		IF ((@datStatisticStartDateFrom IS NOT NULL) AND (@datStatisticStartDateTo IS NOT NULL))
			SELECT @sql += ' AND datStatisticStartDate BETWEEN @datStatisticStartDateFrom AND @datStatisticStartDateTo' + @nl
		ELSE IF @datStatisticStartDateFrom IS NOT NULL
			SELECT @sql += ' AND datStatisticStartDate >= @datStatisticStartDateFrom' + @nl
		ELSE IF @datStatisticStartDateTo IS NOT NULL
			SELECT @sql += ' AND datStatisticStartDate <= @datStatisticStartDateTo' + @nl

		SELECT @paramlist = ' @LangID						NVARCHAR(50)
							 ,@idfsStatisticalDataType		BIGINT
							 ,@idfsArea						BIGINT
							 ,@datStatisticStartDateFrom	DATETIME
							 ,@datStatisticStartDateTo		DATETIME'

		--PRINT @sql
		--RETURN

		EXEC SP_EXECUTESQL	 @sql
							 ,@paramlist
							 ,@LangID
							 ,@idfsStatisticalDataType	
							 ,@idfsArea					
							 ,@datStatisticStartDateFrom	
							 ,@datStatisticStartDateTo

		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()
			SET @returnCode  = ERROR_NUMBER()	
			SELECT @returnCode, @returnMsg
		END

	END CATCH;
END


