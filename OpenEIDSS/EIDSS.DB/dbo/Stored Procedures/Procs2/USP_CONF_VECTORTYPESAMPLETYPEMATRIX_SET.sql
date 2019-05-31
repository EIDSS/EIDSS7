-- ==========================================================================================
-- Name:		EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_SET
-- Description:	Creates vector type to sample type matrix a sample type id and vector type id
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		04/01/2019	Initial Release
--
-- EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_SET NULL, 6619310000000, 6618550000000
-- EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_SET NULL, 6619350000000, 6618550000000
-- ==========================================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPESAMPLETYPEMATRIX_SET
(
	@idfSampleTypeForVectorType BIGINT = NULL, 
	@idfsVectorType BIGINT,
	@idfsSampleType BIGINT
)
AS
	DECLARE @returnCode					INT = 0  
	DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
		IF EXISTS(SELECT idfSampleTypeforVectorType FROM trtSampleTypeForVectorType WHERE idfsSampleType = @idfsSampleType AND idfsVectorType = @idfsVectorType AND intRowStatus = 0) AND @idfSampleTypeForVectorType IS NULL
		BEGIN
			SELECT @returnCode = 1
			SELECT @idfSampleTypeForVectorType = (SELECT idfSampleTypeforVectorType from trtSampleTypeForVectorType where idfsSampleType = @idfsSampleType AND idfsVectorType = @idfsVectorType AND intRowStatus = 0)
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF EXISTS(SELECT idfSampleTypeforVectorType from trtSampleTypeForVectorType where idfsSampleType = @idfsSampleType AND idfsVectorType = @idfsVectorType AND intRowStatus = 1) AND @idfSampleTypeForVectorType IS NULL
		BEGIN
			UPDATE trtSampleTypeForVectorType SET intRowStatus = 0 WHERE idfsSampleType = @idfsSampleType AND idfsVectorType = @idfsVectorType
		END
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtSampleTypeForVectorType', @idfSampleTypeForVectorType OUTPUT;

			INSERT INTO trtSampleTypeForVectorType (idfSampleTypeForVectorType, idfsVectorType, idfsSampleType, intRowStatus) VALUES (@idfSampleTypeForVectorType, @idfsVectorType, @idfsSampleType, 0)
			INSERT INTO trtSampleTypeForVectorTypeToCP(idfSampleTypeForVectorType, idfCustomizationPackage) VALUES (@idfSampleTypeForVectorType, dbo.FN_GBL_CustomizationPackage_GET())
		END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfSampleTypeForVectorType 'idfSampleTypeForVectorType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END