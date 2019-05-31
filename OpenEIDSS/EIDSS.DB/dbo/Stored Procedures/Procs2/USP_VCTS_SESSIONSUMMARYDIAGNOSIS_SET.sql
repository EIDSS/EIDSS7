--*************************************************************
-- Name 				: USP_VCTS_SESSIONSUMMARYDIAGNOSIS_SET
-- Description			: Vector Sessions Summary Diagnosis Insert & Update
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[USP_VCTS_SESSIONSUMMARYDIAGNOSIS_SET]
(
     @idfsVSSessionSummaryDiagnosis BIGINT OUTPUT,
	 @idfsVSSessionSummary BIGINT,
	 @idfsDiagnosis BIGINT,
	 @intPositiveQuantity BIGINT
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (	SELECT idfsVSSessionSummaryDiagnosis FROM [dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
						WHERE idfsVSSessionSummaryDiagnosis = @idfsVSSessionSummaryDiagnosis
						)
			BEGIN
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbVectorSurveillanceSessionSummaryDiagnosis', @idfsVSSessionSummaryDiagnosis OUTPUT
	
				INSERT 
				INTO	[dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
						(
							[idfsVSSessionSummaryDiagnosis]
						   ,[idfsVSSessionSummary]
						   ,[idfsDiagnosis]
						   ,[intPositiveQuantity]
						)
				VALUES
						(
							@idfsVSSessionSummaryDiagnosis
							,@idfsVSSessionSummary
							,@idfsDiagnosis 
							,@intPositiveQuantity
						)
			END
		ELSE 
			BEGIN
				UPDATE	[dbo].[tlbVectorSurveillanceSessionSummaryDiagnosis]
				SET 	[idfsVSSessionSummary] = @idfsVSSessionSummary
						,[idfsDiagnosis] = @idfsDiagnosis
						,[intPositiveQuantity] = @intPositiveQuantity    
				WHERE 	[idfsVSSessionSummaryDiagnosis] = @idfsVSSessionSummaryDiagnosis
			END

		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
			IF @@Trancount = 1 
				ROLLBACK
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg = 
			   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			   + ' ErrorMessage: '+ ERROR_MESSAGE()
			   ----select @LogErrMsg

			  SELECT @returnCode, @returnMsg

	END CATCH
END
