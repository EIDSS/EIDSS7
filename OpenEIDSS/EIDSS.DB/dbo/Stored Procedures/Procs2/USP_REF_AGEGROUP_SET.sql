-- ============================================================================
-- Name: USP_REF_AGEGROUP_SET
-- Description:	Get the Case Classification for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		09/25/2018	Initial release.
-- Ricky Moss		12/19/2018	Remove the return codes
-- Ricky Moss		01/02/2019	Add the return codes and replaced dbo.FN_GBL_LanguageCode_GET(@LangID)
-- Ricky Moss		01/03/2019	returnMessage param returns 'ALREADY EXISTS' if new Age Group already exists
-- Ricky Moss		02/10/2019	Checks to see when updating a age group that the name does not exists in another reference
--
-- exec USP_REF_AGEGROUP_SET 55540680000151, 'Test Again for Developers Meeting 3', 'Test Again for Developers Meeting 3', 0, 0, 10042003, 'en', 100
-- ============================================================================
CREATE  PROCEDURE [dbo].[USP_REF_AGEGROUP_SET](
     @idfsAgeGroup       BIGINT = NULL,
	 @strDefault NVARCHAR (200)
	,@strName NVARCHAR (200)
	,@intLowerBoundary INT
	,@intUpperBoundary INT
	,@idfsAgeType BIGINT	
	,@LangID NVARCHAR(50) = NULL
	,@intOrder INT
)
AS 
BEGIN


DECLARE @returnCode			INT				= 0 
DECLARE	@returnMsg			NVARCHAR(max)	= 'SUCCESS' 
Declare @SupressSelect table
( 
	retrunCode int,
	returnMessage varchar(200)
)
BEGIN TRY
	IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000146 AND trtBaseReference.intRowStatus = 0) AND @idfsAgeGroup is NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000146 AND trtBaseReference.intRowStatus = 0) AND @idfsAgeGroup IS NOT NULL)
	BEGIN
		SELECT @idfsAgeGroup = (SELECT idfsBaseReference from trtBaseReference WHERE strDefault = @strDefault AND idfsReferenceType = 19000146)
		SELECT @returnMsg = 'DOES EXIST'
	END
	ELSE IF (EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsAgeGroup AND intRowStatus = 0) 
		AND EXISTS (SELECT idfsDiagnosisAgeGroup FROM dbo.trtDiagnosisAgeGroup WHERE idfsDiagnosisAgeGroup = @idfsAgeGroup and intRowStatus = 0))
			BEGIN
				UPDATE dbo.[trtDiagnosisAgeGroup]
				SET 
					intLowerBoundary = @intLowerBoundary	
					,intUpperBoundary = @intUpperBoundary
					,idfsAgeType = @idfsAgeType
				WHERE [idfsDiagnosisAgeGroup] = @idfsAgeGroup					

				UPDATE dbo.[trtBaseReference]
					SET
						strDefault = @strDefault,
						intOrder = @intOrder
					WHERE idfsBaseReference = @idfsAgeGroup

				UPDATE dbo.[trtStringNameTranslation]
					SET 
						strTextString = @strName
					WHERE idfsBaseReference = @idfsAgeGroup AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
			END
	ELSE
		BEGIN
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference',  @idfsAgeGroup OUTPUT;

			--INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_BaseReference_SET @idfsAgeGroup, 19000146, @LangID, @strDefault, @strName, 2, @intOrder, 0;

			INSERT INTO dbo.trtDiagnosisAgeGroup
				(
				 [idfsDiagnosisAgeGroup]
				,[intLowerBoundary]
				,[intUpperBoundary]
				,[idfsAgeType]
				,[intRowStatus]
				)
			VALUES
				(
				@idfsAgeGroup, 
				@intLowerBoundary, 
				@intUpperBoundary, 
				@idfsAgeType,
				0
				)
		END

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfsAgeGroup 'idfsAgeGroup'
END TRY
BEGIN CATCH
	THROW;
END CATCH
END
