-- ============================================================================
-- Name: USP_REF_SPECIESTYPEREFERENCE_SET
-- Description:	Get the Case Classification for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss       10/02/2018 Initial release.
-- Ricky Moss		10/04/2018	Updated the update piece of the stored procedure
-- exec USP_REF_SPECIESTYPEREFERENCE_SET null, 'Test', 'Test', '', 32, 1, 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_SPECIESTYPEREFERENCE_SET] 
	@idfsSpeciesType BIGINT = NULL,
	@strDefault VARCHAR(200),
	@strName  NVARCHAR(200),
	@strCode NVARCHAR(50),
	@intHACode INT,
	@intOrder INT,
	@LangID  NVARCHAR(50)
AS


DECLARE @returnMsg			NVARCHAR(max) = N'Success';
DECLARE @returnCode			BIGINT = 0;
Declare @idfsReferenceType	BIGINT
Declare @SupressSelect table
( 
retrunCode int,
returnMessage varchar(200)
)
BEGIN 

	SET NOCOUNT ON
	BEGIN TRY
		IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsSpeciesType AND intRowStatus = 0) AND EXISTS (SELECT idfsSpeciesType from dbo.trtSpeciesType WHERE idfsSpeciesType  = @idfsSpeciesType and intRowStatus = 0)
		BEGIN
				UPDATE trtSpeciesType
					SET strCode = @strCode
					WHERE idfsSpeciesType = @idfsSpeciesType
				UPDATE dbo.[trtBaseReference]
					SET
						intHACode = @intHACode,
						intOrder = @intOrder
					where idfsBaseReference = @idfsSpeciesType

				update dbo.[trtStringNameTranslation]
					set 
						strTextString = @strName
					where idfsBaseReference = @idfsSpeciesType AND idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		END
		ELSE
		BEGIN			
			Select @idfsReferenceType = (Select idfsReferenceType from trtReferenceType WHERE strReferenceTypeName = 'Species List')
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsSpeciesType OUTPUT	
			Exec dbo.USP_GBL_BaseReference_SET @idfsSpeciesType, @idfsReferenceType, @LangID, @strDefault, @strName, @intHACode, @intOrder, 0

			INSERT INTO trtSpeciesType
			(idfsSpeciesType, strCode) 
            VALUES  (@idfsSpeciesType, @strCode)
		END
		Select @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' , @idfsSpeciesType 'idfsSpeciesType'
	END TRY
	BEGIN CATCH
			Throw;
	END CATCH
END
