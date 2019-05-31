-- =========================================================================================
-- NAME: USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_SET
-- DESCRIPTION: Creates a vector type to collection method relationship

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/04/2019	Initial Release
-- Ricky Moss		04/26/2019  Hi
--
-- exec USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_SET NULL, 6619360000000, 6703300000000
-- exec USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_SET NULL, 6619360000000, 6703240000000
-- =========================================================================================
ALTER PROCEDURE USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_SET
(
	@idfCollectionMethodForVectorType BIGINT = NULL,
	@idfsVectorType BIGINT,
	@idfsCollectionMethod BIGINT
)
AS

DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))

BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsVectorType = @idfsVectorType AND idfsCollectionMethod = @idfsCollectionMethod AND intRowStatus = 0) AND @idfCollectionMethodForVectorType IS NULL) OR (EXISTS(SELECT idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsVectorType = @idfsVectorType AND idfsCollectionMethod = @idfsCollectionMethod AND idfCollectionMethodForVectorType <> @idfCollectionMethodForVectorType AND intRowStatus = 0) AND @idfCollectionMethodForVectorType IS NOT NULL)
		BEGIN
			SELECT @returnCode = 1
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfCollectionMethodForVectorType = (SELECT idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsVectorType = @idfsVectorType AND idfsCollectionMethod = @idfsCollectionMethod AND intRowStatus = 0)
		END
		ELSE IF EXISTS(SELECT idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsVectorType = @idfsVectorType AND idfsCollectionMethod = @idfsCollectionMethod AND intRowStatus = 1)
		BEGIN
			UPDATE trtCollectionMethodForVectorType SET intRowStatus = 0 WHERE idfsVectorType = @idfsVectorType AND idfsCollectionMethod = @idfsCollectionMethod
			SELECT @idfCollectionMethodForVectorType = (SELECT idfCollectionMethodForVectorType FROM trtCollectionMethodForVectorType WHERE idfsVectorType = @idfsVectorType AND idfsCollectionMethod = @idfsCollectionMethod AND intRowStatus = 0)
		END
		ELSE
		BEGIN			
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtCollectionMethodforVectorType', @idfCollectionMethodForVectorType OUTPUT;

			INSERT INTO trtCollectionMethodForVectorType (idfCollectionMethodForVectorType, idfsVectorType, idfsCollectionMethod, intRowStatus) VALUES (@idfCollectionMethodForVectorType, @idfsVectorType, @idfsCollectionMethod, 0)
			INSERT INTO trtCollectionMethodForVectorTypeToCP (idfCollectionMethodForVectorType, idfCustomizationPackage) VALUES ( @idfCollectionMethodForVectorType, dbo.FN_GBL_CustomizationPackage_GET())
		END
	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfCollectionMethodForVectorType 'idfCollectionMethodForVectorType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END