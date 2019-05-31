--=====================================================================================================
-- Name: USP_REF_VECTORTYPEREFERENCE_DEL
-- Description:	Removes vector type from active list of vector types
--							
-- Author: Ricky Moss.
-- Revision History:
-- Name             Date		Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/09/26	Initial Release
-- Ricky Moss		12/13/2018	Removed return code
-- 
-- Test Code:
-- exec USP_REF_VECTORTYPEREFERENCE_DEL 55615180000050, 0
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_VECTORTYPEREFERENCE_DEL]
(
	@idfsVectorType BIGINT,
	@deleteAnyway BIT = 0
)
AS
BEGIN
	DECLARE @returnCode					INT = 0 
	DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	BEGIN TRY
	 IF	(NOT EXISTS(select idfCollectionMethodForVectorType from trtCollectionMethodForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) AND
		NOT	EXISTS(select idfPensideTestTypeForVectorType from trtPensideTestTypeForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) AND 			
		NOT	EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) AND
		NOT	EXISTS(select idfsVectorSubType from trtVectorSubType where idfsVectorType = @idfsVectorType and intRowStatus = 0)) OR @deleteAnyway = 1
		BEGIN
		UPDATE trtVectorType SET intRowStatus = 1 
			WHERE idfsVectorType = @idfsVectorType 
			and intRowStatus = 0

		UPDATE trtBaseReference SET intRowStatus = 1 
			WHERE idfsBaseReference = @idfsVectorType 
			AND intRowStatus = 0

		UPDATE trtStringNameTranslation SET intRowStatus = 1
			WHERE idfsBaseReference = @idfsVectorType
		END
	ELSE IF	EXISTS(select idfCollectionMethodForVectorType from trtCollectionMethodForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) OR
			EXISTS(select idfPensideTestTypeForVectorType from trtPensideTestTypeForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) OR 			
			EXISTS(select idfSampleTypeForVectorType from trtSampleTypeForVectorType where idfsVectorType = @idfsVectorType and intRowStatus = 0) OR
			EXISTS(select idfsVectorSubType from trtVectorSubType where idfsVectorType = @idfsVectorType and intRowStatus = 0) 
			BEGIN
				SELECT @returnCode = -1
				SELECT @returnMsg = 'IN USE'
			END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage';
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END