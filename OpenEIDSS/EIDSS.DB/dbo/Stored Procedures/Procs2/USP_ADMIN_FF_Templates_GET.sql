
-- ================================================================================================
-- Name: USP_ADMIN_FF_Templates_GET
-- Description: Return list of Templates
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Templates_GET]
(
	@LangID NVARCHAR(50) = NULL
	,@idfsFormTemplate BIGINT = NULL
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

		SELECT FT.[idfsFormTemplate]
			   ,FT.[idfsFormType]   
			   ,FT.[blnUNI]   
			   ,FT.[rowguid]
			   ,FT.[intRowStatus]
			   ,FT.strNote
			   ,RF.[strDefault] AS [DefaultName]
			   ,RF.[name] AS [NationalName]
			   ,RF.[LongName] AS [NationalLongName]
			   ,@LangID AS [langid]
		FROM [dbo].[ffFormTemplate] FT
		INNER JOIN dbo.fnReference(@LangID, 19000033 /*'rftFFTemplate'*/) RF
		ON FT.[idfsFormTemplate] = RF.idfsReference
		WHERE ((FT.[idfsFormTemplate] = @idfsFormTemplate ) OR (@idfsFormTemplate IS NULL))
			  AND ((FT.[idfsFormType]  = @idfsFormType) OR (@idfsFormType  IS NULL))	  
			  AND (FT.intRowStatus = 0)
		ORDER BY [NationalName]   
		
		SET @returnCode = 0
		SET @returnMsg = 'Success'

		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END

