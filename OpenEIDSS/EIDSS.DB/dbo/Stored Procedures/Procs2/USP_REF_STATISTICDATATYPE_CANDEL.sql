--=====================================================================================================
-- Author:		Ricky Moss.
-- Description:	Returns two (2) result sets.
--
-- 1) Checks to see if the species is being referred to as foreign key
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/10/22 Initial Release
--
-- 
-- Test Code:
-- exec USP_REF_STATISTICDATATYPE_CANDEL 39850000000
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_STATISTICDATATYPE_CANDEL]
	@idfsStatisticDataType bigint
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
		Declare @exists bit
		IF	EXISTS(select idfsStatisticDataType from tlbStatistic where idfsStatisticDataType = @idfsStatisticDataType and intRowStatus = 0)
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
