-- ============================================================================
-- Name: USP_REF_AGEGROUP_CANDEL
-- Description:	Check to see 
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss     10/26/2018	Initial release.

-- exec USP_REF_MEASUREREFEFENCE_DEL 952180000000, 19000074, 0
-- exec USP_REF_MEASUREREFEFENCE_DEL 952250000000, 19000079, 1
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_MEASUREREFEFENCE_DEL]
(
	@idfsAction BIGINT,
	@idfsMeasureList BIGINT,
	@deleteAnyway BIT
)
AS
	DECLARE @returnMsg			VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode			BIGINT = 0;
BEGIN
	BEGIN TRY
		IF @idfsMeasureList = 19000074
			BEGIN
			IF NOT EXISTS(SELECT idfAggrProphylacticActionMTX FROM tlbAggrProphylacticActionMTX where idfsProphilacticAction = @idfsAction)	OR @deleteAnyway = 1	
			BEGIN
				UPDATE trtProphilacticAction
					SET intRowStatus=1
					WHERE idfsProphilacticAction = @idfsAction
					AND intRowStatus = 0

				UPDATE trtBaseReference
					SET intRowStatus = 1
					WHERE idfsBaseReference = @idfsAction
					AND intRowStatus = 0

				UPDATE trtStringNameTranslation
					SET intRowStatus = 1
					WHERE idfsBaseReference = @idfsAction
					AND intRowStatus = 0
			END
			ELSE IF EXISTS(SELECT idfAggrProphylacticActionMTX FROM tlbAggrProphylacticActionMTX where idfsProphilacticAction = @idfsAction)
			BEGIN
				SELECT @returnCode = -1
				SELECT @returnMsg = 'IN USE'
			END
		END
		ELSE
		BEGIN
		IF NOT EXISTS(SELECT idfAggrSanitaryActionMTX  from tlbAggrSanitaryActionMTX where idfsSanitaryAction = @idfsAction) OR @deleteAnyway = 1
			BEGIN
				UPDATE trtSanitaryAction
					SET intRowStatus = 1
					WHERE idfsSanitaryAction = @idfsAction
					AND intRowStatus = 0

				UPDATE trtBaseReference
					SET intRowStatus = 1
					WHERE idfsBaseReference = @idfsAction
					AND intRowStatus = 0

				UPDATE trtStringNameTranslation
					SET intRowStatus = 1
					WHERE idfsBaseReference = @idfsAction
					AND intRowStatus = 0
			END
			ELSE IF EXISTS(SELECT idfAggrSanitaryActionMTX  from tlbAggrSanitaryActionMTX where idfsSanitaryAction = @idfsAction)
			BEGIN
				SELECT @returnCode = -1
				SELECT @returnMsg = 'IN USE'
			END
		END
		SELECT @returnCode AS ReturnCode, @returnMsg AS ReturnMessage;
	END TRY
	BEGIN CATCH		
	 THROW;
	END CATCH
END
