-- ============================================================================
-- Name: USP_REF_VectorSubType_DEL
-- Description:	Remove an active Vector Sub Type.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/18/2018 Initial release.
-- exec USP_REF_VectorSubType_DEL 6619330000000, 0
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_VectorSubType_DEL]
(
	@idfsVectorSubType BIGINT,
	@deleteAnyway BIT = 0
)AS
 	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
BEGIN
 BEGIN TRY
	IF NOT EXISTS(SELECT idfVectorSurveillanceSession FROM tlbVectorSurveillanceSessionSummary WHERE idfsVectorSubType = @idfsVectorSubType and intRowStatus = 0) OR @deleteAnyway = 1
	BEGIN
	UPDATE trtVectorSubType SET intRowStatus = 1 
		WHERE idfsVectorSubType = @idfsVectorSubType 
		and intRowStatus = 0

	UPDATE trtBaseReference SET intRowStatus = 1 
		WHERE idfsBaseReference = @idfsVectorSubType
		AND intRowStatus = 0

	UPDATE trtStringNameTranslation SET intRowStatus = 1
		WHERE idfsBaseReference = @idfsVectorSubType
	END
	ELSE IF	EXISTS(select idfVectorSurveillanceSession from tlbVectorSurveillanceSessionSummary where idfsVectorSubType = @idfsVectorSubType and intRowStatus = 0) 
	BEGIN
		SELECT @returnMsg = 'IN USE'
		SELECT @returnCode = -1
	END
			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
END TRY
BEGIN CATCH
	THROW;
END CATCH
end
