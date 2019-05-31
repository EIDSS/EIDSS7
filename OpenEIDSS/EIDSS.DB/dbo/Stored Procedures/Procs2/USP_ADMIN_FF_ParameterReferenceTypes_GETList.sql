
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterReferenceTypes_GETList
-- Description: List of Parameter Reference Types
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterReferenceTypes_GETList] 
(
	@LangID NVARCHAR(50) = NULL	
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL)
		SET @LangID = 'en';

	DECLARE
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)

	BEGIN TRY
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);

		SELECT RT.idfsReferenceType
			   ,BR.strDefault AS [DefaultName]
			   ,ISNULL(SNT.strTextString, BR.strDefault) AS [NationalName]
			   ,@LangID AS [langid]	
		FROM dbo.trtReferenceType RT 
		INNER JOIN dbo.trtBaseReference BR
		ON RT.idfsReferenceType = BR.idfsBaseReference
		INNER JOIN dbo.trtStringNameTranslation SNT
		ON SNT.idfsBaseReference = RT.idfsReferenceType
		   AND SNT.intRowStatus = 0
		   AND SNT.idfsLanguage = @langid_int
	--Where ((RT.intStandard & 1 > 0)  Or (BR.idfsBaseReference In (19000079, 19000074)))
	--			And RT.intRowStatus = 0
		WHERE RT.intRowStatus = 0
		ORDER BY [NationalName]
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
