

--*************************************************************
-- Name 				: USP_VCTS_SESSIONSUMMARY_DEL
-- Description			: 
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  5/22/2018  Initial Creation
--
-- Testing code:
--*************************************************************

 
CREATE PROCEDURE [dbo].[USP_VCTS_SESSIONSUMMARY_DEL]
(	 
	@idfsVSSessionSummary		   BIGINT
)
AS

DECLARE @returnCode INT = 0;
DECLARE @returnMsg  NVARCHAR(max) = 'SUCCESS'

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION			
			
			BEGIN
				update dbo.tlbVectorSurveillanceSessionSummary
				SET		intRowStatus = 1
				WHERE	idfsVSSessionSummary  = @idfsVSSessionSummary

				update dbo.tlbVectorSurveillanceSessionSummaryDiagnosis
				SET		intRowStatus = 1
				WHERE	idfsVSSessionSummary in (select idfsVSSessionSummary from dbo.tlbVectorSurveillanceSessionSummary where idfsVSSessionSummary  = @idfsVSSessionSummary)

		   END
  				
			IF @@TRANCOUNT > 0 
			COMMIT;

		  SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
		BEGIN 
			IF @@TRANCOUNT  > 0 
				ROLLBACK

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @returnCode, @returnMsg
		END

	END CATCH
END 


