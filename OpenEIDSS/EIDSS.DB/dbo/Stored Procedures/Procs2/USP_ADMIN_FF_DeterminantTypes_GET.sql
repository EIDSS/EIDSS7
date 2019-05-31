
-- ================================================================================================
-- Name: USP_ADMIN_FF_DeterminantTypes_GET
-- Description: Retreives the list of Determinant Types
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_DeterminantTypes_GET]
(
	@idfsFormType BIGINT = NULL
	,@LangID NVARCHAR(50) = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL)
		SET @LangID = 'en';

	DECLARE
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)       
	
	BEGIN TRY
	
		SELECT [idfDeterminantType]
			   ,[idfsReferenceType]
			   ,[idfsGISReferenceType]
			   ,[idfsFormType]
			   ,[intOrder]		  
		FROM [dbo].[ffDeterminantType]	
		WHERE (([idfsFormType] = @idfsFormType)
				OR (@idfsFormType IS NULL)) 

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

