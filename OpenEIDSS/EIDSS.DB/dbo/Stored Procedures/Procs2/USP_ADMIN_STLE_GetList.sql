
--*************************************************************
-- Name 				: USP_ADMIN_STLE_GetList
-- Description			: Get Settlement details
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--EXECUTE USP_ADMIN_STLE_GetList 'en'
--*************************************************************

CREATE  PROCEDURE [dbo].[USP_ADMIN_STLE_GetList] 

(
	 @LangID				NVARCHAR(50) --##PARAM @LangID - language ID
	,@idfsSettlement		BIGINT = NULL
	,@idfsSettlementType	BIGINT = NULL
	,@DefaultName           NVARCHAR(100) = NULL 
	,@strNationalName		NVARCHAR(100) = NULL
	,@idfsRegion			BIGINT = NULL
	,@idfsRayon				BIGINT = NULL
	,@LatMin				FLOAT = NULL
	,@LatMax				FLOAT = NULL
	,@LngMin				FLOAT = NULL
	,@LngMax				FLOAT = NULL
	,@EleMin				FLOAT = NULL
	,@EleMax				FLOAT = NULL
)

AS 

DECLARE @returnCode					INT = 0
DECLARE	@returnMsg					NVARCHAR(MAX) = 'SUCCESS' 

BEGIN

	BEGIN TRY  	

		DECLARE @sql		NVARCHAR(MAX)
				,@paramlist	NVARCHAR(4000)
				,@nl		CHAR(2) = CHAR(13) + CHAR(10)

		SELECT @sql = '	SELECT * 
						FROM	dbo.FN_ADMIN_STLE_GetList(@LangID)
						WHERE	1 = 1 
						' + @nl

			IF ISNULL(@idfsSettlement, 0) <> 0
				SELECT @sql += ' AND idfsSettlement = @idfsSettlement' + @nl

			IF ISNULL(@idfsSettlementType, 0) <> 0
				SELECT @sql += ' AND idfsSettlementType = @idfsSettlementType' + @nl

			IF TRIM(ISNULL(@DefaultName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('SettlementDefaultName', @DefaultName) + @nl

			IF TRIM(ISNULL(@strNationalName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('SettlementNationalName', @strNationalName) + @nl

			IF ISNULL(@idfsRegion, 0) <> 0
				SELECT @sql += ' AND idfsSettlementType = @idfsRegion' + @nl

			IF ISNULL(@idfsRayon, 0) <> 0
				SELECT @sql += ' AND idfsRayon = @idfsRayon' + @nl

			IF ISNULL(@LatMin, 0) <> 0
				SELECT @sql += ' AND dblLatitude >= @LatMin' + @nl

			IF ISNULL(@LatMax, 0) <> 0
				SELECT @sql += ' AND dblLatitude <= @LatMax' + @nl

			IF ISNULL(@LngMin, 0) <> 0
				SELECT @sql += ' AND dblLongitude >= @LngMin' + @nl

			IF ISNULL(@LatMax, 0) <> 0
				SELECT @sql += ' AND dblLongitude <= @LngMax' + @nl

			IF ISNULL(@EleMin, 0) <> 0
				SELECT @sql += ' AND intElevation >= @EleMin' + @nl

			IF ISNULL(@EleMax, 0) <> 0
				SELECT @sql += ' AND intElevation <= @EleMax' + @nl

		SELECT @paramlist = '@LangID				AS NVARCHAR(50)
							,@idfsSettlement		BIGINT
							,@idfsSettlementType	BIGINT
							,@DefaultName           NVARCHAR(100) 
							,@strNationalName		NVARCHAR(100)
							,@idfsRegion			BIGINT
							,@idfsRayon				BIGINT
							,@LatMin				FLOAT
							,@LatMax				FLOAT
							,@LngMin				FLOAT
							,@LngMax				FLOAT
							,@EleMin				FLOAT
							,@EleMax				FLOAT
							'

		--PRINT @sql
		--RETURN

		EXEC SP_EXECUTESQL	@sql
							,@paramlist
							,@LangID
							,@idfsSettlement		
							,@idfsSettlementType	
							,@DefaultName           
							,@strNationalName		
							,@idfsRegion			
							,@idfsRayon				
							,@LatMin				
							,@LatMax				
							,@LngMin				
							,@LngMax				
							,@EleMin				
							,@EleMax				

		SELECT @returnCode, @returnMsg;

	END TRY

	BEGIN CATCH
		IF @@Trancount = 1 
			ROLLBACK
			SET @returnCode = ERROR_NUMBER();
			SET @returnMsg = 
		   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
		   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
		   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
		   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
		   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
		   + ' ErrorMessage: '+ ERROR_MESSAGE();

		  SELECT @returnCode, @returnMsg;
	END CATCH

END


