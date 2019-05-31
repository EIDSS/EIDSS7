-- ==========================================================================================
-- Name:		EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_DEL
-- Description:	Removes vector type to sample type matrix a vector type sample type id
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		04/01/2019	Initial Release
--
-- EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_DEL 6706830000003, 1
-- ==========================================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPESAMPLETYPEMATRIX_DEL
(
	@idfSampleTypeForVectorType BIGINT,
	@deleteAnyway BIT
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		UPDATE trtSampleTypeForVectorType SET intRowStatus = 1 WHERE idfSampleTypeForVectorType = @idfSampleTypeForVectorType
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END