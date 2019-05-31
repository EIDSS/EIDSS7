
-- ================================================================================================
-- Name: USP_ADMIN_FF_Sections_GET
-- Description: Returns list of sections
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Sections_GET]
(
	@LangID NVARCHAR(50) = NULL 
	,@idfsFormType BIGINT = NULL
	,@idfsSection BIGINT = NULL
	,@idfsParentSection BIGINT = NULL		
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE
		@langid_int BIGINT, 
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY
	
		IF (@LangID IS NULL)
			SET @LangID = 'en';
	
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
	
		SELECT S.[idfsSection]
			   ,S.[idfsParentSection]
			   ,S.[idfsFormType]     
			   ,S.[rowguid]
			   ,S.[intRowStatus]
			   ,B.[strDefault] AS [DefaultName]	
			   ,ISNULL(SNT.[strTextString], B.[strDefault]) AS [NationalName]	 
			   ,CASE WHEN COUNT(P.[idfsParameter]) > 0
				THEN 1
				ELSE 0
				END AS [HasParameters]
			   ,CASE WHEN COUNT(S2.[idfsSection]) > 0
				THEN 1
				ELSE 0
				END AS [HasNestedSections]	
			   ,S.blnGrid
			   ,S.blnFixedRowSet
			   ,S.intOrder
			   ,@LangID AS [langid]
			   ,S.idfsMatrixType
		FROM [dbo].[ffSection] S
		INNER JOIN dbo.trtBaseReference B
		ON B.[idfsBaseReference] = S.[idfsSection]
		   AND B.[intRowStatus] = 0  
		LEFT JOIN dbo.ffParameter P
		ON P.idfsSection = S.[idfsSection]
		   AND P.[intRowStatus] = 0
		LEFT JOIN dbo.ffSection S2
		ON S.[idfsSection] = S2.[idfsParentSection]
		   AND S2.[intRowStatus] = 0
		LEFT JOIN dbo.trtStringNameTranslation SNT
		ON SNT.[idfsBaseReference] = S.[idfsSection]
		   AND SNT.idfsLanguage = @langid_int
		   AND SNT.[intRowStatus] = 0
		WHERE ((S.idfsFormType = @idfsFormType )
			   OR (@idfsFormType IS NULL))
			  AND ((S.idfsSection = @idfsSection)
				   OR (@idfsSection IS NULL))
			  AND ((S.idfsParentSection = @idfsParentSection)
				   OR (@idfsParentSection IS NULL))
			  AND S.[intRowStatus] = 0
		GROUP BY S.[idfsSection]
				 ,S.[idfsParentSection]
				 ,S.[idfsFormType]     
				 ,S.[rowguid]
				 ,S.[intRowStatus]
				 ,B.[strDefault]
				 ,SNT.[strTextString]	  
				 ,S.blnGrid
				 ,S.blnFixedRowSet
				 ,S.intOrder
				 ,S.idfsMatrixType
		ORDER BY [NationalName], S.[intOrder]

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
