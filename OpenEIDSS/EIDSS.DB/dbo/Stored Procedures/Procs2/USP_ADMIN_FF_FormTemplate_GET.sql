
-- ================================================================================================
-- Name: USP_ADMIN_FF_FormTemplate_GET
-- Description: Retrieves the List of Form Templates
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_FormTemplate_GET]
(
	@idfsDiagnosis BIGINT,
	@idfsFormType BIGINT
	
)
AS
BEGIN
	DECLARE @idfsFormTemplate BIGINT 
	DECLARE
		@idfsCountry AS BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX)
	DECLARE @tmpTemplate AS TABLE(idfsFormTemplate BIGINT,
							  IsUNITemplate BIT)
	
		BEGIN TRY
			SET @idfsCountry = CAST(dbo.FN_GBL_CURRENTCOUNTRY_GET() AS NVARCHAR)

			INSERT INTO @tmpTemplate
			EXECUTE USP_ADMIN_FF_ActualTemplate_GET 
					@idfsCountry
					,@idfsDiagnosis
					,@idfsFormType

			SELECT TOP 1 @idfsFormTemplate = idfsFormTemplate
			FROM @tmpTemplate

			IF @idfsFormTemplate = -1
				SET @idfsFormTemplate = NULL
		--COMMIT TRANSACTION;
		SELECT @idfsFormTemplate 'idfsFormTemplate'
	END TRY
	BEGIN CATCH
		--IF @@TRANCOUNT > 0 
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

