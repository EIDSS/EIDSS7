-- =========================================================================================
-- NAME: USP_CONF_DISEASEPENSIDETESTMATRIX_DEL
-- DESCRIPTION: Deactivates a disease to penside test relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		02/26/2019	Initial Release
--
-- exec USP_CONF_DISEASEPENSIDETESTMATRIX_DEL 6706310000045
-- =========================================================================================
CREATE PROCEDURE USP_CONF_DISEASEPENSIDETESTMATRIX_DEL
(
	@idfPensideTestforDisease BIGINT
)
AS
BEGIN
	DECLARE @returnCode			INT				= 0 
	DECLARE	@returnMsg			NVARCHAR(max)	= 'SUCCESS' 
	BEGIN TRY
		UPDATE trtPensideTestForDisease SET intRowStatus = 1 where idfPensideTestForDisease = @idfPensideTestforDisease
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
