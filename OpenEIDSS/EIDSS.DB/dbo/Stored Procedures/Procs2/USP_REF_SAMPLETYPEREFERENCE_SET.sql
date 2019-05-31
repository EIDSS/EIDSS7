-- ============================================================================
-- Name: USP_SAMPLETYPEREFERENCE_SET
-- Description:	Add and Update a sample type
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date		Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/01/2018	Initial release.
-- Ricky Moss		12/13/2018	Removed return code
-- Ricky Moss		01/02/2019	Replaced fnGetLanguageCode with FN_GBL_LanguageCode_GET function
-- Ricky Moss		02/10/2019	Checks to see when updating a sample type that the name does not exists in another reference and updates English value
--
-- exec USP_REF_SAMPLETYPEREFERENCE_SET NULL, 'Test Again for Local', 'Test Again for Local', '100.0',  224, 0, 'en'
-- exec USP_SAMPLETYPEREFERENCE_SET 55615180000028, 'Test Again', 'Test Again', '99.0', 98, 0, 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_SAMPLETYPEREFERENCE_SET]
(
	@idfsSampleType BIGINT  = NULL,
	@strDefault VARCHAR(200),
	@strName  NVARCHAR(200),
	@strSampleCode NVARCHAR(50),
	@intHACode INT,
	@intOrder INT,
	@LangID  NVARCHAR(50)
)
AS
BEGIN
DECLARE @returnMsg			NVARCHAR(max) = N'Success';
DECLARE @returnCode			BIGINT = 0;
Declare @SupressSelect table
( 
retrunCode int,
returnMessage varchar(200)
)
	BEGIN TRY
	IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000087 AND trtBaseReference.intRowStatus = 0) AND @idfsSampleType is NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000087 AND trtBaseReference.intRowStatus = 0) AND @idfsSampleType IS NOT NULL)
	BEGIN
		SELECT @returnMsg = 'DOES EXIST';
		SELECT @idfsSampleType = (SELECT idfsBaseReference from trtBaseReference where strDefault = @strName AND idfsReferenceType = 19000087)
	END
	ELSE IF EXISTS(SELECT idfsBaseReference FROM trtBaseReference WHERE idfsBaseReference = @idfsSampleType) and exists(SELECT idfsSampleType FROM trtSampleType WHERE idfsSampleType = @idfsSampleType)
	BEGIN		
		UPDATE trtSampleType
			SET 
				strSampleCode = @strSampleCode
			WHERE idfsSampleType = @idfsSampleType

		UPDATE dbo.[trtBaseReference]
			SET
				strDefault = @strDefault,
				intOrder = @intOrder,
				intHACode = @intHACode
			WHERE idfsBaseReference = @idfsSampleType

		UPDATE dbo.[trtStringNameTranslation]
			SET 
				strTextString = @strName
			WHERE idfsBaseReference = @idfsSampleType AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
	END
	ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsSampleType OUTPUT
			EXEC USP_GBL_BaseReference_SET @idfsSampleType, 19000087, @LangID, @strDefault, @strName, @intHACode, @intOrder, 0
		
			INSERT INTO trtSampleType
				(idfsSampleType, strSampleCode, intRowStatus) 
				VALUES  (@idfsSampleType, @strSampleCode, 0)
		END
		
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' , @idfsSampleType 'idfsSampleType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END



