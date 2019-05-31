-- ============================================================================
-- Name: USP_REF_VectorSubType_DEL
-- Description:	Remove an active Vector Sub Type.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/18/2018 Initial release.
-- exec USP_REF_VectorSubType_CANDEL 6619330000000
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_VectorSubType_CANDEL]
(
	@idfsVectorSubType bigint
)as

 	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;

BEGIN
	BEGIN TRY
		Declare @exists bit
		IF	EXISTS(select idfVectorSurveillanceSession from tlbVectorSurveillanceSessionSummary where idfsVectorSubType = @idfsVectorSubType and intRowStatus = 0)
			BEGIN
				Select @exists = 1

				Select @exists as CurrentlyInUse
			END
			ELSE
			BEGIN
				Select @exists = 0

				Select @exists as CurrentlyInUse

			END
		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
			BEGIN
			SET							@returnCode = ERROR_NUMBER();
			SET							@returnMsg = 
										'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
										+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
										+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
										+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
										+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
										+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT						@returnCode, @returnMsg;
		END
	END CATCH
END
