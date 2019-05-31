-- ============================================================================
-- Name: USP_REF_SPECIESTYPE_SET
-- Description:	Adds or updates a species type reference
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss       10/02/2018	Initial release.
-- Ricky Moss		10/04/2018	Updated the update piece of the stored procedure
-- Ricky Moss		12/13/2018	Removed the return codes and reference id
-- Lamont Mitchell	01/02/2019	Aliased Columns in Final Output
-- Ricky Moss		01/02/2019	Replace fnGetLanguageCode with FN_GBL_LanguageCode_GET function
-- Ricky Moss		02/10/2019	Checks to see when updating a species type that the name does not exists in another reference and updates English value
-- 
-- exec USP_REF_SPECIESTYPE_SET null, 'Aardvark', 'Aardvark', '', 32, 1, 'en'
-- exec USP_REF_SPECIESTYPE_SET 837790000000, 'Buffalo', 'Buffalo', '', 32, 0, 'en'
-- exec USP_REF_SPECIESTYPE_SET null, 'Buffalo', 'Buffalo', '', 32, 1, 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_SPECIESTYPE_SET] 
(
	@idfsSpeciesType BIGINT = NULL,
	@strDefault VARCHAR(200),
	@strName  NVARCHAR(200),
	@strCode NVARCHAR(50),
	@intHACode INT,
	@intOrder INT,
	@LangID  NVARCHAR(50)
)
AS
BEGIN 
	Declare @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
	)
 DECLARE
@returnMsg			NVARCHAR(max) = N'SUCCESS',
@returnCode			BIGINT = 0 
	BEGIN TRY
		IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000086 AND trtBaseReference.intRowStatus = 0) AND @idfsSpeciesType is NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000086 AND trtBaseReference.intRowStatus = 0) AND @idfsSpeciesType IS NOT NULL)
		BEGIN
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfsSpeciesType = (SELECT idfsBaseReference from trtBaseReference where strDefault = @strName AND idfsReferenceType = 19000086)
		END
		ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsSpeciesType AND intRowStatus = 0) AND EXISTS (SELECT idfsSpeciesType FROM dbo.trtSpeciesType WHERE idfsSpeciesType  = @idfsSpeciesType and intRowStatus = 0)
		BEGIN
			UPDATE trtSpeciesType
				SET strCode = @strCode
				WHERE idfsSpeciesType = @idfsSpeciesType

			UPDATE dbo.[trtBaseReference]
				SET
					strDefault = @strDefault,
					intHACode = @intHACode,
					intOrder = @intOrder
				WHERE idfsBaseReference = @idfsSpeciesType

			UPDATE dbo.[trtStringNameTranslation]
				SET 
					strTextString = @strName
				WHERE idfsBaseReference = @idfsSpeciesType AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)

		END
		ELSE
		BEGIN			
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsSpeciesType OUTPUT

			EXEC dbo.USP_GBL_BaseReference_SET @idfsSpeciesType, 19000086, @LangID, @strDefault, @strName, @intHACode, @intOrder, 0

			INSERT INTO trtSpeciesType
				(idfsSpeciesType, strCode) 
				VALUES  (@idfsSpeciesType, @strCode)
		END
		
		SELECT @returnMsg 'ReturnMessage', @returnCode 'ReturnCode', @idfsSpeciesType 'idfSpeciesType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END