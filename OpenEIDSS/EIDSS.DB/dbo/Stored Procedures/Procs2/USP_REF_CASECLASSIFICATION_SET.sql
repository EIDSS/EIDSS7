
-- ============================================================================
-- Name: USP_REF_CASECLASSIFICATION_SET
-- Description:	Get the Case Classification for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss       10/02/2018 Initial release.
-- Ricky Moss		10/04/2018	Updated the update piece of the stored procedure
-- Ricky Moss		12/19/2018	Removed return codes and id variables and merge SET and DOESEXIST Stored procedures
-- Ricky Moss		01/02/2019	Added return codes
-- Ricky Moss		01/27/2019	Added case classification id value and english name already exists
-- Ricky Moss		02/10/2019	Checks to see when updating a case classification that the name does not exists in another reference and updates English value
--
-- exec USP_REF_CASECLASSIFICATION_SET 55540680000281, 'Test Locally 25', 'Test Locally 25', 1, 1, 'en', 6, 32
-- exec USP_REF_CASECLASSIFICATION_SET 55540680000138, 'Test for Debug', 'Test for Debug', 0, 1, 'en', 8, 96
-- ============================================================================

CREATE  PROCEDURE [dbo].[USP_REF_CASECLASSIFICATION_SET](
	@idfsCaseClassification BIGINT = NULL
	,@strDefault NVARCHAR(200)
	,@strName NVARCHAR(200)
	,@blnInitialHumanCaseClassification BIT		
	,@blnFinalHumanCaseClassification BIT		
	,@LangID NVARCHAR(50) = NULL
	,@intOrder INT
	,@intHACode INT
)
AS 
BEGIN
	Declare @SupressSelect table
	( 
		retrunCode int,
		returnMessage varchar(200)
		)
DECLARE @returnCode							INT = 0;
DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';
BEGIN TRY
		IF (EXISTS(SELECT idfsBaseReference from trtBaseReference where strDefault = @strDefault AND idfsReferenceType = 19000011) AND @idfsCaseClassification IS NULL) OR (@idfsCaseClassification IS NOT NULL AND EXISTS(SELECT idfsBaseReference FROM trtBaseReference where strDefault = @strDefault AND idfsReferenceType = 19000011 AND idfsBaseReference <> @idfsCaseClassification))
		BEGIN
			SELECT @idfsCaseClassification = (SELECT idfsBaseReference from trtBaseReference where strDefault = @strName AND idfsReferenceType = 19000011)
			SELECT @returnMsg = 'DOES EXIST'
		END
		ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsCaseClassification AND intRowStatus = 0) AND EXISTS (SELECT idfsCaseClassification FROM dbo.trtCaseClassification WHERE idfsCaseClassification = @idfsCaseClassification and intRowStatus = 0)
		BEGIN
			UPDATE dbo.[trtCaseClassification]
			SET 
				blnInitialHumanCaseClassification = @blnInitialHumanCaseClassification		
				,blnFinalHumanCaseClassification = @blnFinalHumanCaseClassification
			WHERE [idfsCaseClassification] = @idfsCaseClassification					

			UPDATE dbo.[trtBaseReference]
				SET
					strDefault = @strDefault,
					intHACode = @intHACode,
					intOrder = @intOrder
				WHERE idfsBaseReference = @idfsCaseClassification

			UPDATE dbo.[trtStringNameTranslation]
				SET
					strTextString = @strName
				WHERE idfsBaseReference = @idfsCaseClassification AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
		END
		ELSE
		BEGIN
		    INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsCaseClassification OUTPUT
				
			EXEC dbo.USP_GBL_BaseReference_SET @idfsCaseClassification, 19000011, @LangID, @strDefault, @strName, @intHACode, @intOrder, 0

			INSERT INTO [dbo].[trtCaseClassification]
			(
				idfsCaseClassification
				,blnInitialHumanCaseClassification
				,blnFinalHumanCaseClassification
				,intRowStatus
			)
			VALUES
			(
				@idfsCaseClassification, 
				@blnInitialHumanCaseClassification,
				@blnFinalHumanCaseClassification,
				0
			)
		END
			SELECT @returnCode as ReturnCode, @returnMsg as ReturnMessage, @idfsCaseClassification as idfsCaseClassification
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
