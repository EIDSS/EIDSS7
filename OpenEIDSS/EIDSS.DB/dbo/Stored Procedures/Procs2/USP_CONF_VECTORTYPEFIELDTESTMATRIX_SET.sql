-- ==========================================================================================
-- Name:		EXEC USP_CONF_VECTORTYPEFIELDTESTMATRIX_SET
-- Description:	Creates vector type to field test matrix
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		04/02/2019	Initial Release
--
-- EXEC USP_CONF_VECTORTYPEFIELDTESTMATRIX_SET NULL, 6619310000000, 6619120000000
-- EXEC USP_CONF_VECTORTYPEFIELDTESTMATRIX_SET NULL, 6619350000000, 6619280000000
-- ==========================================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPEFIELDTESTMATRIX_SET
(
	@idfPensideTestTypeForVectorType BIGINT = NULL, 
	@idfsVectorType BIGINT,
	@idfsPensideTestName BIGINT
)
AS
	DECLARE @returnCode					INT = 0  
	DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT idfPensideTestTypeForVectorType FROM trtPensideTestTypeForVectorType WHERE idfsPensideTestName = @idfsPensideTestName AND idfsVectorType = @idfsVectorType AND intRowStatus = 0) AND @idfPensideTestTypeForVectorType IS NULL
		BEGIN
			SELECT @returnCode = 1
			SELECT @idfPensideTestTypeForVectorType = (SELECT idfPensideTestTypeForVectorType from trtPensideTestTypeForVectorType where idfsPensideTestName = @idfsPensideTestName AND idfsVectorType = @idfsVectorType AND intRowStatus = 0)
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF EXISTS(SELECT idfPensideTestTypeForVectorType from trtPensideTestTypeForVectorType where idfsPensideTestName = @idfsPensideTestName AND idfsVectorType = @idfsVectorType AND intRowStatus = 1) AND @idfPensideTestTypeForVectorType IS NULL
		BEGIN
			UPDATE trtPensideTestTypeForVectorType SET intRowStatus = 0 WHERE idfsPensideTestName = @idfsPensideTestName AND idfsVectorType = @idfsVectorType
		END
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtPensideTestTypeForVectorType', @idfPensideTestTypeForVectorType OUTPUT;

			INSERT INTO trtPensideTestTypeForVectorType (idfPensideTestTypeForVectorType, idfsVectorType, idfsPensideTestName, intRowStatus) VALUES (@idfPensideTestTypeForVectorType, @idfsVectorType, @idfsPensideTestName, 0)
			INSERT INTO trtPensideTestTypeForVectorTypeToCP(idfPensideTestTypeForVectorType, idfCustomizationPackage) VALUES (@idfPensideTestTypeForVectorType, dbo.FN_GBL_CustomizationPackage_GET())
		END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfPensideTestTypeForVectorType 'idfPensideTestTypeForVectorType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END