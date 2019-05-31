
-- ================================================================================================
-- Name: USP_ADMIN_FF_TemplatesByParameter_GET
-- Description: Return list of Templates where Parameter used
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_TemplatesByParameter_GET]
(
	@LangID NVARCHAR(50) = NULL
	,@idfsParameter BIGINT
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

		SELECT FT.[idfsFormTemplate]
			   ,FT.[idfsFormType]   
			   ,FT.[blnUNI]   
			   ,FT.[rowguid]
			   ,FT.[intRowStatus]
			   ,FT.strNote
			   ,RF.[strDefault] AS [DefaultName]
			   ,RF.[name] AS [NationalName]
			   ,RF.[LongName] AS [NationalLongName]
			   ,PT.idfsEditMode
		FROM [dbo].[ffFormTemplate] FT
		INNER JOIN dbo.fnReference(@LangID, 19000033 /*'rftFFTemplate'*/) RF
		ON FT.[idfsFormTemplate] = RF.idfsReference
		INNER JOIN dbo.ffParameterForTemplate PT
		ON FT.[idfsFormTemplate] = PT.[idfsFormTemplate]		
		WHERE (PT.[idfsParameter] = @idfsParameter)
			  AND (PT.intRowStatus = 0)
			  AND (FT.intRowStatus = 0)
		ORDER BY [NationalName]
 
		COMMIT TRANSACTION;
		 
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH; 
END

