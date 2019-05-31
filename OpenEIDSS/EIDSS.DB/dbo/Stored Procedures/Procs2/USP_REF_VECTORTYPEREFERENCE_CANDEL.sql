--=====================================================================================================
-- Author:		Ricky Moss.
-- Description:	Returns two (2) result sets.
--
-- 1) Removes vector type from active list of vector types
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/09/26 Initial Release
--
-- 
-- Test Code:
-- exec USP_REF_VECTORTYPEREFERENCE_CANDEL 6619360000000
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_VECTORTYPEREFERENCE_CANDEL]
@idfsVectorType BIGINT
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
				Declare @exists bit
		IF	EXISTS(select idfCollectionMethodForVectorType from trtCollectionMethodForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) OR
			EXISTS(select idfPensideTestTypeForVectorType from trtPensideTestTypeForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) OR 			
			EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) OR
			EXISTS(select idfsVectorSubType from trtVectorSubType where idfsVectorType = @idfsVectorType and intRowStatus = 0) 
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
