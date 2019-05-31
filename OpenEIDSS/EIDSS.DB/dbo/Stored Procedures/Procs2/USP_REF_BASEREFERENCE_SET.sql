-- ============================================================================
-- Name: USP_REF_BASEREFERENCE_SET
-- Description:	Creates or saves a base reference
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		02/10/2018	Initial release.
-- Ricky Moss		02/19/2018	Updated the portion of the query to see if there reference currently exists
--
-- exec USP_REF_BASEREFERENCE_SET NULL, 190000087 'en', 'Test', 'Test', 98, 0, 1
-- exec USP_REF_BASEREFERENCE_SET 55540680000318, 19000128, 'en', 'Test in Local Env', 'Test in Local Env 2', 34, 1, 0
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_BASEREFERENCE_SET] 
	@idfsBaseReference			BIGINT = NULL , 
	@idfsReferenceType			BIGINT, 
	@LangID						NVARCHAR(50), 
	@strDefault					VARCHAR(200), -- Default reference name, used if there is no reference translation
	@strName					NVARCHAR(200), -- Reference name in the language defined by @LangID
	@HACode						INT = NULL, -- Bit mask for reference using
	@Order						INT = NULL -- Reference record order for sorting
AS
BEGIN
	DECLARE @returnMsg					VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode					BIGINT = 0;
	Declare @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
	BEGIN TRY
		IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = @idfsReferenceType AND trtBaseReference.intRowStatus = 0) AND @idfsBaseReference IS NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference WHERE strDefault = @strDefault AND idfsReferenceType = @idfsReferenceType AND idfsBaseReference <> @idfsBaseReference AND intRowStatus = 0) AND EXISTS(SELECT idfsBaseReference FROM trtStringNameTranslation WHERE strTextString = @strName AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)) AND @idfsBaseReference IS NOT NULL)
		BEGIN
			SELECT @idfsBaseReference = (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE strDefault = @strDefault AND idfsReferenceType = @idfsReferenceType AND intRowStatus = 0)
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsBaseReference AND intRowStatus = 0)
		BEGIN
			UPDATE						dbo.trtBaseReference
			SET
										idfsReferenceType = @idfsReferenceType, 
										strDefault = @strDefault,
										intHACode = ISNULL(@HACode, intHACode),
										intOrder = ISNULL(@Order, intOrder)
			WHERE						idfsBaseReference = @idfsBaseReference;

			UPDATE						dbo.trtStringNameTranslation
			SET							strTextString = @strName
			WHERE						idfsBaseReference = @idfsBaseReference
		END
		ELSE
		BEGIN
		    INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsBaseReference OUTPUT;

			INSERT INTO					dbo.trtBaseReference
			(
										idfsBaseReference, 
										idfsReferenceType, 
										intHACode, 
										strDefault,
										intOrder
			)
  			VALUES
			(
										@idfsBaseReference, 
										@idfsReferenceType, 
										@HACode, 
										@strDefault, 
										@Order
			);
			DECLARE @idfCustomizationPackage BIGINT;
			SELECT @idfCustomizationPackage = dbo.FN_GBL_CustomizationPackage_GET();
		
			IF @idfCustomizationPackage IS NOT NULL AND @idfCustomizationPackage <> 51577300000000 --The USA
			BEGIN
				EXEC					dbo.USP_GBL_BaseReferenceToCP_SET @idfsBaseReference, @idfCustomizationPackage;
			END
		END
    
		IF (@LangID = N'en')
		BEGIN
			IF EXISTS(SELECT idfsBaseReference FROM dbo.trtStringNameTranslation WHERE idfsBaseReference=@idfsBaseReference AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(N'en'))
				EXEC					dbo.USSP_GBL_StringTranslation_SET @idfsBaseReference, @LangID, @strDefault, @strName;
		END
		ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC						dbo.USSP_GBL_StringTranslation_SET @idfsBaseReference, @LangID, @strDefault, @strName;
		END

		SELECT							@returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfsBaseReference 'idfsBaseReference';
	END TRY  
	BEGIN CATCH 
	THROW;
	END CATCH;
END