--**********************/***************************************
-- Name 				: USP_VCTS_SESSIONSUMMARY_SET
-- Description			: Set the Vector Sessions Summary
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  6/12/2018   Updated to replace parameters with @lucSummaryCollection prefix to @lucAggregateCollection
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCTS_SESSIONSUMMARY_SET]
(
     @idfsVSSessionSummary						BIGINT OUTPUT 
	 ,@idfDiagnosisVectorSurveillanceSession	BIGINT 
     ,@strVSSessionSummaryID					NVARCHAR(200) OUTPUT 
	 ,@DiagnosisidfGeoLocation					BIGINT
  	 ,@lucAggregateCollectionidfsResidentType							BIGINT	= NULL
	 ,@lucAggregateCollectionidfsGroundType							BIGINT = NULL
	 ,@lucAggregateCollectionidfsGeolocationType						BIGINT = 10036001
	 ,@lucAggregateCollectionidfsCountry								BIGINT = NULL
	 ,@lucAggregateCollectionidfsRegion								BIGINT = NULL
	 ,@lucAggregateCollectionidfsRayon								BIGINT = NULL
	 ,@lucAggregateCollectionidfsSettlement							BIGINT = NULL
	 ,@lucAggregateCollectionstrApartment								NVARCHAR(200) = NULL
	 ,@lucAggregateCollectionstrBuilding								NVARCHAR(200) = NULL
	 ,@lucAggregateCollectionstrStreetName							NVARCHAR(200) = NULL
	 ,@lucAggregateCollectionstrHouse									NVARCHAR(200) = NULL
	 ,@lucAggregateCollectionstrPostCode								NVARCHAR(200) = NULL
	 ,@lucAggregateCollectionstrDescription							NVARCHAR(200) = NULL
	 ,@lucAggregateCollectiondblDistance								FLOAT = NULL
     ,@lucAggregateCollectionstrLatitude								FLOAT = NULL
     ,@lucAggregateCollectionstrLongitude								FLOAT = NULL
	 ,@lucAggregateCollectiondblAccuracy								FLOAT = NULL
	 ,@lucAggregateCollectiondblAlignment								FLOAT = NULL
	 ,@blnForeignAddress						BIT = 0
	 ,@strForeignAddress						NVARCHAR(200) = NULL
	 ,@blnGeoLocationShared						BIT = 0
	 ,@datSummaryCollectionDateTime				DATETIME = NULL
	 ,@SummaryInfoSpecies						BIGINT
	 ,@SummaryInfoSex							BIGINT = NULL
	 ,@PoolsVectors								BIGINT = NULL
)
AS
DECLARE @returnCode	INT = 0 
DECLARE	@returnMsg	NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			-- Create GeoLocation
			EXEC dbo.USP_GBL_ADDRESS_SET 	@DiagnosisidfGeoLocation OUTPUT,
											@lucAggregateCollectionidfsResidentType,
											@lucAggregateCollectionidfsGroundType,
											@lucAggregateCollectionidfsGeolocationType,
											@lucAggregateCollectionidfsCountry,
											@lucAggregateCollectionidfsRegion,
											@lucAggregateCollectionidfsRayon,
											@lucAggregateCollectionidfsSettlement,
											@lucAggregateCollectionstrApartment,
											@lucAggregateCollectionstrBuilding,
											@lucAggregateCollectionstrStreetName,
											@lucAggregateCollectionstrHouse,
											@lucAggregateCollectionstrPostCode,
											@lucAggregateCollectionstrDescription,
											@lucAggregateCollectiondblDistance,
											@lucAggregateCollectionstrLatitude,
											@lucAggregateCollectionstrLongitude,
											@lucAggregateCollectiondblAccuracy,
											@lucAggregateCollectiondblAlignment,
											@blnForeignAddress,
											@strForeignAddress,
											@blnGeoLocationShared,
											@returnCode,
											@returnMsg


			IF NOT EXISTS (SELECT * FROM dbo.tlbVectorSurveillanceSessionSummary  WHERE idfsVSSessionSummary = @idfsVSSessionSummary)
				BEGIN
					IF ISNULL(@idfsVSSessionSummary,-1)<0
						BEGIN
							EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbVectorSurveillanceSessionSummary', @idfsVSSessionSummary OUTPUT
						END
					IF LEFT(ISNULL(@strVSSessionSummaryID, '(new'),4) = '(new'
					BEGIN
						EXEC dbo.USP_GBL_NextNumber_GET 10057031, @strVSSessionSummaryID OUTPUT , NULL --N'AS Session'
					END
					INSERT 
					INTO [dbo].[tlbVectorSurveillanceSessionSummary]
						 (	
							[idfsVSSessionSummary]
							,[idfVectorSurveillanceSession]
							,[strVSSessionSummaryID]
							,[idfGeoLocation]
							,[datCollectionDATETIME]
							,[idfsVectorSubType]
							,[idfsSex]
							,[intQuantity]
						)
					VALUES
					   (	
							@idfsVSSessionSummary
							,@idfDiagnosisVectorSurveillanceSession
							,@strVSSessionSummaryID
							,@DiagnosisidfGeoLocation
							,@datSummaryCollectionDateTime
							,@SummaryInfoSpecies
							,@SummaryInfoSex
							,@PoolsVectors
						)
				END
			ELSE 
				BEGIN
					UPDATE	[dbo].[tlbVectorSurveillanceSessionSummary]
					   SET 	[idfVectorSurveillanceSession] = @idfDiagnosisVectorSurveillanceSession
							,[strVSSessionSummaryID] = @strVSSessionSummaryID
							,[idfGeoLocation] = @DiagnosisidfGeoLocation
							,[datCollectionDATETIME] = @datSummaryCollectionDateTime
							,[idfsVectorSubType] = @SummaryInfoSpecies
							,[idfsSex] = @SummaryInfoSex
							,[intQuantity] = @PoolsVectors      
					WHERE	idfsVSSessionSummary = @idfsVSSessionSummary
				END

		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode, @returnMsg , @idfsVSSessionSummary

	END TRY

	BEGIN CATCH
			IF @@Trancount > 0
				ROLLBACK

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
			'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			+ ' ErrorState: ' + convert(varchar,ERROR_STATE())
			+ ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()
			----SELECT @LogErrMsg

			SELECT @returnCode, @returnMsg , @idfsVSSessionSummary

	END CATCH
END
