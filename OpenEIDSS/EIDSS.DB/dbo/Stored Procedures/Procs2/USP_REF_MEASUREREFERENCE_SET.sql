-- ============================================================================
-- Name: USP_REF_MEASUREREFERENCE_SET
-- Description:	Get the measure list references for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/22/2018 Initial release.
-- Ricky Moss		01/18/2019 Remove return codes;
--
-- exec USP_REF_MEASUREREFERENCE_SET NULL, 19000074, 'Test', 'Test', '', 0, 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_MEASUREREFERENCE_SET]
 	@idfsBaseReference BIGINT = NULL,
	@idfsReferenceType BIGINT,
	@strDefault VARCHAR(200),
	@strName  NVARCHAR(200),
	@strActionCode NVARCHAR(200),
	@intOrder INT,
	@LangID  NVARCHAR(50)
 AS
 DECLARE @SupressSelect table
( 
	retrunCode INT,
	returnMessage VARCHAR(200)
)
 DECLARE
@returnMsg			NVARCHAR(max) = N'SUCCESS',
@returnCode			BIGINT = 0

 BEGIN
	BEGIN TRY
		IF EXISTS(SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strDefault and idfsReferenceType in (19000074, 19000079))
		BEGIN
			IF @idfsReferenceType = 19000074
			BEGIN
				IF (EXISTS(SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strDefault and idfsReferenceType = 19000074) AND @idfsBaseReference IS NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000074 AND trtBaseReference.idfsBaseReference <> @idfsBaseReference AND trtBaseReference.intRowStatus=0) AND @idfsBaseReference IS NOT NULL)
				BEGIN
					SELECT @returnMsg = 'DOES EXIST'
					SELECT @idfsBaseReference = (SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strDefault and idfsReferenceType = 19000074)
				END
			END
			ELSE
			BEGIN
			IF (EXISTS(SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strDefault and idfsReferenceType = 19000079) AND @idfsBaseReference IS NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000079 AND trtBaseReference.idfsBaseReference <> @idfsBaseReference AND trtBaseReference.intRowStatus=0) AND @idfsBaseReference IS NOT NULL)
				BEGIN
					SELECT @returnMsg = 'DOES EXIST'
					SELECT @idfsBaseReference = (SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strDefault and idfsReferenceType = 19000079)
				END
			END
		END
		ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsBaseReference AND intRowStatus = 0)
		BEGIN
			IF @idfsReferenceType = 19000074
					BEGIN
						UPDATE trtProphilacticAction
							SET strActionCode = @strActionCode
							WHERE  idfsProphilacticAction = @idfsBaseReference				
					END
				ELSE
					BEGIN
						UPDATE trtSanitaryAction
							SET strActionCode = @strActionCode
							WHERE  idfsSanitaryAction = @idfsBaseReference
					END
			UPDATE dbo.[trtBaseReference]
				SET
					strDefault = @strDefault,
					intOrder = @intOrder
				WHERE idfsBaseReference = @idfsBaseReference

			UPDATE dbo.[trtStringNameTranslation]
				SET 
					strTextString = @strName
				WHERE idfsBaseReference = @idfsBaseReference AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
		END
		ELSE
		BEGIN			
		
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsBaseReference OUTPUT
			Exec USP_GBL_BaseReference_SET @idfsBaseReference, @idfsReferenceType, @LangID, @strDefault, @strName, 32, @intOrder, 0
			IF @idfsReferenceType = 19000074
				BEGIN
					INSERT INTO trtProphilacticAction
					(idfsProphilacticAction, strActionCode, intRowStatus) 
					VALUES  (@idfsBaseReference, @strActionCode, 0)
					
				END
			ELSE
				BEGIN
					INSERT INTO trtSanitaryAction
					(idfsSanitaryAction, strActionCode, intRowStatus) 
					VALUES  (@idfsBaseReference, @strActionCode, 0)					
				END
		END
				SELECT	@returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfsBaseReference 'idfsBaseReference';
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
 END
