-- ============================================================================
-- Name: USP_REF_VectorSubType_SET
-- Description:	CREATES OR UPDATES VECTOR SUB TYPES.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/18/2018	Initial release.
-- LAMONT Mitchell	01/03/2019	Aliased Return Columns and Supressed Selects from Stored Procs
-- Ricky Moss		01/17/2019	Merged with USP_REF_VECTORSUBTYPE_DOESEXIST
-- Ricky Moss		01/24/2019  Added vector type exist clause to verify if vector sub type exists
-- Ricky Moss		02/11/2019 Checks to see when updating a vector sub type that the name does not exists in another reference
--
-- exec USP_REF_VectorSubType_SET NULL, 6619330000000, 'Test Again', 'Test Again', NULL, 100000, 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_VectorSubType_SET]
	@idfsVectorSubType BIGINT = NULL,
	@idfsVectorType BIGINT,
	@strName NVARCHAR(200),
	@strDefault VARCHAR(200),
	@strCode VARCHAR(50),
	@intOrder INT,
	@LangID  NVARCHAR(50)
AS
DECLARE
@returnMsg			NVARCHAR(max) = 'SUCCESS',
@returnCode			BIGINT = 0
	DECLARE @SupressSelect TABLE
	( 
		retrunCode INT,
		returnMessage VARCHAR(200)
	)
BEGIN
	BEGIN TRY
		IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference LEFT JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference JOIN trtVectorSubType ON trtBaseReference.idfsBaseReference = trtVectorSubType.idfsVectorType WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000141 AND idfsVectorType = @idfsVectorType AND trtBaseReference.intRowStatus = 0) AND @idfsVectorSubType IS NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference JOIN trtVectorSubType ON trtBaseReference.idfsBaseReference = trtVectorSubType.idfsVectorType WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000141 AND idfsVectorType = @idfsVectorType AND trtBaseReference.intRowStatus = 0) AND @idfsVectorSubType IS NOT NULL)
		BEGIN
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfsVectorSubType =(SELECT idfsBaseReference from trtBaseReference where strDefault = @strDefault AND idfsReferenceType = 19000141)
		END
		ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsVectorSubType AND intRowStatus = 0) AND EXISTS (SELECT idfsVectorSubType from dbo.trtVectorSubType WHERE idfsVectorSubType  = @idfsVectorSubType and intRowStatus = 0)
		BEGIN
				UPDATE dbo.trtVectorSubType
					SET
						idfsVectorType = @idfsVectorType,
						strCode = @strCode
					WHERE idfsVectorSubType = idfsVectorSubType and idfsVectorType = @idfsVectorType
		
				UPDATE dbo.[trtBaseReference]
					SET
						strDefault = @strDefault,
						intOrder = @intOrder
					WHERE idfsBaseReference = @idfsVectorSubType

				UPDATE dbo.[trtStringNameTranslation]
					SET 
						strTextString = @strName
					WHERE idfsBaseReference = @idfsVectorSubType AND idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		END
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsVectorSubType OUTPUT

			EXEC USP_GBL_BaseReference_SET @idfsVectorSubType, 19000141, @LangID, @strDefault, @strName, 128, @intOrder, 0

			INSERT INTO trtVectorSubType (idfsVectorSubType, idfsVectorType, strCode, intRowStatus)
			VALUES(@idfsVectorSubType, @idfsVectorType, @strCode, 0)
		END
		
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfsVectorSubType 'idfsVectorSubType'
	END TRY
	BEGIN CATCH	
		THROW;
	END CATCH
END
