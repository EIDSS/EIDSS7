--=====================================================================================================
-- Name: USP_REF_REPORTDIAGNOSISGROUP_SET
-- Description:	Creates or updates a report diagnosis group
--
-- Author:		Ricky Moss
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/16/2018  Initial release
-- Ricky Moss		01/16/2019	Removed return code
-- Ricky Moss		02/10/2019	Checks to see when updating a report diagnosis group that the name does not exists in another reference and updates English value
--
-- exec USP_REF_REPORTDIAGNOSISGROUP_SET 55540680000292, 'Test Locally 28', 'Test Locally 28', NULL, 'en'
-- exec USP_REF_REPORTDIAGNOSISGROUP_SET NULL, 'Rabies Group', 'Rabies Group', NULL, 'en'
-- exec USP_REF_REPORTDIAGNOSISGROUP_SET 53352780000000, 'Rabies Group', 'Rabies Group', NULL, 'en'
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_REPORTDIAGNOSISGROUP_SET](
	@idfsReportDiagnosisGroup BIGINT = NULL,
	@strDefault NVARCHAR(MAX), 
	@strName NVARCHAR(MAX),  
	@strCode NVARCHAR(500),	
	@LangID NVARCHAR(50)
)
AS
BEGIN
DECLARE @SupressSelect TABLE
( 
	retrunCode INT,
	returnMessage VARCHAR(200)
)
DECLARE @returnMsg			NVARCHAR(MAX) = N'SUCCESS';
DECLARE @returnCode			BIGINT = 0;

	BEGIN TRY
		IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000130 AND trtBaseReference.intRowStatus = 0) AND @idfsReportDiagnosisGroup is NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000130 AND trtBaseReference.intRowStatus = 0) AND @idfsReportDiagnosisGroup IS NOT NULL)
		BEGIN
			SELECT @returnMsg = 'DOES EXIST'
			SELECT @idfsReportDiagnosisGroup = (SELECT idfsBaseReference from trtBaseReference where strDefault = @strName AND idfsReferenceType = 19000130)
		END
		ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsReportDiagnosisGroup AND intRowStatus = 0) AND EXISTS (SELECT idfsReportDiagnosisGroup from dbo.trtReportDiagnosisGroup WHERE idfsReportDiagnosisGroup  = @idfsReportDiagnosisGroup and intRowStatus = 0)
		BEGIN
			UPDATE trtReportDiagnosisGroup
				SET
					strCode = @strCode
				WHERE idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup

			UPDATE trtBaseReference
				SET
					strDefault = @strDefault
				WHERE idfsBaseReference = @idfsReportDiagnosisGroup

			UPDATE trtStringNameTranslation
				SET 
					strTextString = @strName
				WHERE idfsBaseReference = @idfsReportDiagnosisGroup AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
		END
		ELSE
		BEGIN			
			INSERT INTO @SupressSelect
			EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference', @idfsReportDiagnosisGroup OUTPUT

			EXEC USP_GBL_BaseReference_SET @idfsReportDiagnosisGroup, 19000130, @LangID, @strDefault, @strName, NULL, NULL, 0

			INSERT INTO trtReportDiagnosisGroup
			(idfsReportDiagnosisGroup, strCode) 
            VALUES  (@idfsReportDiagnosisGroup, @strCode)
			
		END
		SELECT @returnCode'ReturnCode', @returnMsg 'ReturnMessage' , @idfsReportDiagnosisGroup 'idfsReportDiagnosisGroup'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
