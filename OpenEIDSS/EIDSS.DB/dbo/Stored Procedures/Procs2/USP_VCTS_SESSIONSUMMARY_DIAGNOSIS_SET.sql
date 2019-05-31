--**********************/***************************************
-- Name 				: USP_VCTS_SESSIONSUMMARY_DIAGNOSIS_SET
-- Description			: Set the Vector Sessions Summary and Diagnosis
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--   Harold Pryor 5/17/2018  Updated to properly insert data  
--   Harold Pryor  6/12/2018   Updated to replace parameters with @lucSummaryCollection prefix to @lucAggregateCollection
--   Harold Pryor  8/30/2018   Removed @lucAggregateCollection parameters 
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCTS_SESSIONSUMMARY_DIAGNOSIS_SET] 
(
     @idfsVSSessionSummary						BIGINT OUTPUT 
	 ,@idfDiagnosisVectorSurveillanceSession	BIGINT 
     ,@strVSSessionSummaryID					NVARCHAR(200) OUTPUT 
	 ,@DiagnosisidfGeoLocation					BIGINT  		 
	 ,@datSummaryCollectionDateTime				DATETIME = NULL
	 ,@SummaryInfoSpecies						BIGINT
	 ,@SummaryInfoSex							BIGINT = NULL
	 ,@PoolsVectors								BIGINT = NULL
	 ,@Diagnosis								tlbVectorDiagnosisGetListSPType READONLY
)
AS
DECLARE @returnCode	INT = 0 
DECLARE	@returnMsg	NVARCHAR(max) = 'SUCCESS' 

DECLARE @idfsVSSessionSummaryDiagnosis	BIGINT 
DECLARE	@idfsDiagnosis					BIGINT
DECLARE	@intPositiveQuantity			BIGINT

DECLARE										@DiagnosisTemp dbo.tlbVectorDiagnosisGetListSPType;
INSERT INTO									@DiagnosisTemp SELECT * FROM @Diagnosis;

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION			

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

		WHILE EXISTS (SELECT * FROM @DiagnosisTemp)
				BEGIN
					SELECT TOP 1				@idfsVSSessionSummaryDiagnosis = idfsVSSessionSummaryDiagnosis,
												@idfsDiagnosis = idfsDiagnosis, 
												@intPositiveQuantity = intPositiveQuantity
					FROM						@DiagnosisTemp;
								
					BEGIN
						IF LEFT(ISNULL(@strVSSessionSummaryID, '(new'),4) = '(new'
						BEGIN
						   set @idfsVSSessionSummaryDiagnosis = null
						END
						EXEC					dbo.USSP_VCTS_SESSIONSUMMARYDIAGNOSIS_SET
												@idfsVSSessionSummaryDiagnosis OUTPUT,
												@idfsVSSessionSummary,
												@idfsDiagnosis,
												@intPositiveQuantity			
					END							

					 DELETE TOP (1) FROM @DiagnosisTemp
				END;


		IF @@TRANCOUNT > 0 AND @returnCode = 0
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
