----------------------------------------------------------------------------
----------------------------------------------------------------------------
-- Name 				: USSP_ADMIN_BASEREF_DEL
-- Description			: Insert/Update Base Reference Data
--          
-- Author               : Mark Wilson
-- 
-- Revision History
-- Name				Date		Change Detail
-- Mark Wilson    10-Nov-2017   Convert EIDSS 6 to EIDSS 7 standards and 
--                              added table name to USP_GBL_NEWID_GET call
--
-- Stephen Long		05/03/2018	Added return code and try catch block.
--
-- Testing code:
----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USSP_ADMIN_BASEREF_DEL] 
(
	@idfsBasereference					BIGINT
)
AS
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;

	BEGIN TRY
		BEGIN
			DELETE
			FROM	dbo.trtStringNameTranslation
			WHERE	idfsBaseReference = @idfsBasereference
		END

		BEGIN
			DELETE
			FROM	dbo.trtBaseReference
			WHERE	idfsBaseReference = @idfsBasereference
		END

		SELECT						@returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		THROW;

		SELECT						@returnCode, @returnMsg;
	END CATCH;
END

