-- ============================================================================
-- Name: USP_REF_BASEREFERENCE_DEL
-- Description:	Removes a base reference
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		02/10/2019	Initial release.
-- Ricky Moss		02/12/2019	Returns values.
--
-- exec USP_REF_BASEREFERENCE_DEL 55540680000289
-- ============================================================================
CREATE PROCEDURE dbo.[USP_REF_BASEREFERENCE_DEL]
(
	@idfsBaseReference BIGINT
)
AS
DECLARE @returnMsg			NVARCHAR(MAX) = 'SUCCESS',
@returnCode			BIGINT = 0
BEGIN
	BEGIN TRY
		UPDATE trtBaseReference 
		SET intRowStatus = 1
		WHERE idfsBaseReference = @idfsBaseReference

		UPDATE trtStringNameTranslation
		SET intRowStatus = 1
		WHERE idfsBaseReference = @idfsBaseReference

		SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END