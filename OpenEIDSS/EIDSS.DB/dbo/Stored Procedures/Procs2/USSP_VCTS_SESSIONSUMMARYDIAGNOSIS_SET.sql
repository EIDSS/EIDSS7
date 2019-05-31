
--*************************************************************
-- Name 				: USSP_VCTS_SESSIONSUMMARYDIAGNOSIS_SET
-- Description			: Vector Sessions Summary Diagnosis Insert & Update
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[USSP_VCTS_SESSIONSUMMARYDIAGNOSIS_SET]
(
     @idfsVSSessionSummaryDiagnosis BIGINT OUTPUT,
	 @idfsVSSessionSummary BIGINT,
	 @idfsDiagnosis BIGINT,
	 @intPositiveQuantity BIGINT
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(MAX) = 'SUCCESS' 
BEGIN
	BEGIN TRY

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

		SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
		THROW;

		SELECT @returnCode, @returnMsg

	END CATCH
END
