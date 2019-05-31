
-- ================================================================================================
-- Name: USP_ADMIN_FF_FormTypes_GET
-- Description:	Return list of Form Types
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.

-- Sample Test
-- exec [dbo].[spFFGetFormTypes]
-- select * from dbo.fnReference('en', 19000034 /*'rftFFType'*/)
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_FormTypes_GET]
(
	@LangID NVARCHAR(50) = NULL
	,@idfsFormType BIGINT = NULL	 	
)	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE 
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY

		IF (@LangID IS NULL)
			SET @LangID = 'en';
		
		SELECT fr.[idfsReference] AS [idfsFormType]		
			   ,fr.[name] AS [Name]
			   ,fr.[LongName]
			   ,ISNULL((SELECT TOP 1 
						CASE WHEN (P.[idfsParameter] IS NOT NULL)
						THEN 1
						ELSE 0
						END 
						FROM dbo.ffParameter P 
						WHERE (P.[idfsFormType] = fr.[idfsReference])
							  AND (P.[idfsSection] IS NULL)
							  AND P.[intRowStatus] = 0), 0) AS [HasParameters]
				,ISNULL((SELECT TOP 1 
						 CASE WHEN (S.[idfsSection] IS NOT NULL)
						 THEN 1 
						 ELSE 0
						 END 
						 FROM dbo.ffSection S
						 WHERE S.[idfsFormType] = fr.[idfsReference]
							   AND S.[intRowStatus] = 0), 0) AS [HasNestedSections]
				,ISNULL((SELECT TOP 1 
						 CASE WHEN (FT.[idfsFormTemplate] IS NOT NULL)
						 THEN 1
						 ELSE 0
						 END 
						 FROM dbo.ffFormTemplate FT 
						 WHERE FT.[idfsFormType] = fr.[idfsReference]
							   AND FT.[intRowStatus] = 0), 0) AS [HasTemplates]
				,MT.[idfsMatrixType]
		FROM dbo.FN_GBL_Reference_List_GET(@LangID, 19000034 /*'rftFFType'*/) fr
		LEFT JOIN dbo.trtMatrixType MT
		ON fr.[idfsReference] = MT.[idfsFormType]
		WHERE (fr.[idfsReference] = @idfsFormType)
			  OR (@idfsFormType IS NULL)		
		ORDER BY fr.[name]

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

