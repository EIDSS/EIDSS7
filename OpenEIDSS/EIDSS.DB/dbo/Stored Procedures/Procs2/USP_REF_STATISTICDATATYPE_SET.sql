
-- ============================================================================
-- Name: USP_REF_STATISTICDATATYPE_SET
-- Description:	Creates or updates a statistical data type.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
--	Ricky Moss      09/28/2018	Initial release.
--	Ricky Moss		12/13/2018	Removed the return code and reference id variables
--	Ricky Moss		12/20/2018	Merged SET AND DOESEXIST stored procedures
--	Ricky Moss		02/11/2019	Checks to see when updating a statistical data type that the name does not exists in another reference
--
-- exec USP_REF_STATISTICDATATYPE_SET NULL, 'Test Locally', 'Test Locally', 19000043, 10091005, 10089002, 1, 'en'
-- exec USP_REF_STATISTICDATATYPE_SET 39850000000, 'Population', 'Population', 19000043, 10091005, 10089001, 1, 'en'
-- ============================================================================

CREATE PROCEDURE [dbo].[USP_REF_STATISTICDATATYPE_SET] 
(
	@idfsStatisticDataType AS BIGINT = NULL,
	@strDefault AS NVARCHAR(200),
	@strName AS NVARCHAR(200),
	@idfsReferenceType AS BIGINT,
	@idfsStatisticPeriodType AS BIGINT,
	@idfsStatisticAreaType AS BIGINT = NULL,
	@blnRelatedWithAgeGroup AS BIT,
	@LangID AS NVARCHAR (50)
)
AS
BEGIN
DECLARE @returnMsg			NVARCHAR(max) = N'SUCCESS';
DECLARE @returnCode			BIGINT = 0;

Declare @SupressSelect table
( 
	retrunCode int,
	returnMessage varchar(200)
)
	BEGIN TRY
	IF (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference LEFT JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000090 AND trtBaseReference.intRowStatus = 0) AND @idfsStatisticDataType IS NULL) OR (EXISTS(SELECT trtBaseReference.idfsBaseReference FROM trtBaseReference JOIN trtStringNameTranslation ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference WHERE (strDefault = @strDefault OR strTextString = @strName) AND idfsReferenceType = 19000090 AND trtBaseReference.intRowStatus = 0) AND @idfsStatisticDataType IS NOT NULL)
	BEGIN
		SELECT @idfsStatisticDataType = (SELECT idfsBaseReference FROM trtBaseReference WHERE strDefault = @strName AND idfsReferenceType = 19000090)
		SELECT @returnMsg = 'DOES EXIST'
	END
	ELSE IF EXISTS (SELECT idfsBaseReference FROM dbo.trtBaseReference WHERE idfsBaseReference = @idfsStatisticDataType AND intRowStatus = 0) AND EXISTS (SELECT idfsStatisticDataType FROM dbo.trtStatisticDataType WHERE idfsStatisticDataType  = @idfsStatisticDataType and intRowStatus = 0)
	BEGIN
		UPDATE dbo.[trtStatisticDataType]
			SET
				idfsReferenceType = @idfsReferenceType
				,idfsStatisticAreaType = @idfsStatisticAreaType
				,idfsStatisticPeriodType = @idfsStatisticPeriodType
				,blnRelatedWithAgeGroup = @blnRelatedWithAgeGroup
			WHERE idfsStatisticDataType = @idfsStatisticDataType

		UPDATE dbo.[trtBaseReference]
			SET
				strDefault = @strDefault
			WHERE idfsBaseReference = @idfsStatisticDataType

		UPDATE dbo.[trtStringNameTranslation]
			SET 
				strTextString = @strName
			WHERE idfsBaseReference = @idfsStatisticDataType AND idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
	END
	 ELSE
	 BEGIN	 
		INSERT INTO @SupressSelect
		EXEC USP_GBL_NEXTKEYID_GET 'trtBaseReference',  @idfsStatisticDataType OUTPUT

		EXEC dbo.USP_GBL_BaseReference_SET @idfsStatisticDataType, 19000090, @LangID, @strDefault, @strName, 226, 0, 1

		INSERT INTO trtStatisticDataType (idfsStatisticDataType, idfsReferenceType, idfsStatisticAreaType, idfsStatisticPeriodType, blnRelatedWithAgeGroup, intRowStatus)
				VALUES (@idfsStatisticDataType, @idfsReferenceType, @idfsStatisticAreaType, @idfsStatisticPeriodType, @blnRelatedWithAgeGroup, 0)
	 END
	 Select @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' , @idfsStatisticDataType 'idfsStatisticDataType'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END

