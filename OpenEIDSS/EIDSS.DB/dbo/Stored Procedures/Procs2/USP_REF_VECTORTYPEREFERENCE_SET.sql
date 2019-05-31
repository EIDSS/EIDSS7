-- ============================================================================
-- Name: USP_VECTORTYPEREFERENCE_SET
-- Description:	CREATES OR UPDATES VECTOR TYPES.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/11/2018 Initial release.
-- Lamont Mitchell	01/03/2019 Aliased Returned Columns and Supressed Stored Procs
-- Ricky Moss		01/11/2019 Merged USP_VECTORTYPEREFERENCE_DOESEXIST AND USP_VECTORTYPEREFERENCE_SET stored procedures
-- Ricky Moss		02/11/2019 Checks to see when updating a vector type that the name does not exists in another reference
--
-- exec USP_REF_VECTORTYPEREFERENCE_SET NULL, 'Test 8', 'Test 8', '', 0, 0, 'en'
-- exec USP_REF_VECTORTYPEREFERENCE_SET 55615180000044, 'Test the first time', 'Test the first time', '', 1, 0, 'en'
--
-- ============================================================================

CREATE PROCEDURE [dbo].[USP_REF_VECTORTYPEREFERENCE_SET] 
	@idfsVectorType BIGINT = NULL,
	@strDefault VARCHAR(200),
	@strName NVARCHAR(200),
	@strCode  NVARCHAR(200),
	@bitCollectionByPool BIT,
	@intOrder INT,
	@LangID  NVARCHAR(50)
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
SET NOCOUNT ON;

DECLARE @SupressSelect TABLE
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
BEGIN TRY
	IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference LEFT JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000140 AND trtBaseReference.intRowStatus = 0) AND @idfsVectorType IS NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000140 AND trtBaseReference.intRowStatus = 0) AND @idfsVectorType IS NOT NULL)
	BEGIN
		SELECT @idfsVectorType = (SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strName AND idfsReferenceType = 19000140)
		SELECT @returnMsg = 'DOES EXIST'
	END
	ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsVectorType AND intRowStatus = 0) AND EXISTS (SELECT idfsVectorType FROM dbo.trtVectorType WHERE idfsVectorType = @idfsVectorType and intRowStatus = 0)
	BEGIN
				UPDATE dbo.trtVectorType
				SET 
						strCode = @strCode
						,bitCollectionByPool = @bitCollectionByPool
                WHERE	idfsVectorType = @idfsVectorType

				UPDATE dbo.[trtBaseReference]
					SET
						intOrder = @intOrder
					WHERE idfsBaseReference = @idfsVectorType

				UPDATE dbo.[trtStringNameTranslation]
					SET 
						strTextString = @strName
					WHERE idfsBaseReference = @idfsVectorType AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)

	END
	ELSE
	BEGIN	
		INSERT INTO @SupressSelect	
		EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsVectorType OUTPUT

		EXEC dbo.USP_GBL_BaseReference_SET 
				@idfsVectorType,
				19000140,
				@LangID,
				@strDefault,
				@strName,
				128,
				@intOrder

				INSERT INTO dbo.trtVectorType
				(	
					idfsVectorType
					,strCode
					,bitCollectionByPool
					,intRowStatus
				) 
                VALUES  
				(
					@idfsVectorType
					,@strCode
					,ISNULL(@bitCollectionByPool,0)
					,0
				)
		
	END

	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' ,@idfsVectorType 'idfsVectorType'
END TRY
BEGIN CATCH
		THROW;
END CATCH
END





