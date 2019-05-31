
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTypes_SET
-- Description: Insert or Update for Parameter Types
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTypes_SET] 
(
	@DefaultName NVARCHAR(400)	
	,@NationalName  NVARCHAR(600)	
	,@idfsReferenceType BIGINT
	--,@System Int
	/* System
	* idfsReferenceType = -1 -> 2 
	* idfsReferenceType = 19000069 -> 0
	* idfsReferenceType = ID -> 1
	*/	
	,@LangID NVARCHAR(50) = NULL
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success',
		@idfsParameterType BIGINT = 0

	BEGIN TRY

		IF (@LangID IS NULL)
			SET @LangID = 'en';
	
		IF (@idfsParameterType < 0)
			EXEC dbo.[usp_sysGetNewID] @idfsParameterType OUTPUT
	
		EXEC dbo.USP_GBL_BaseReference_SET @idfsParameterType, 19000071/*'rftParameterType'*/,@LangID, @DefaultName, @NationalName, 0

		IF NOT EXISTS (SELECT TOP 1 1
					   FROM dbo.ffParameterType
					   WHERE [idfsParameterType] = @idfsParameterType)
			BEGIN
				INSERT INTO dbo.ffParameterType
					(
						[idfsParameterType]
						,[idfsReferenceType]
					)
				VALUES
					(
						@idfsParameterType
						,@idfsReferenceType
					)
			END
		ELSE
			BEGIN
				UPDATE dbo.ffParameterType
				SET [idfsReferenceType] = @idfsReferenceType
					,[intRowStatus] = 0
				WHERE [idfsParameterType] = @idfsParameterType
			END


		SELECT @returnCode as returnCode, @returnMsg as returnMsg, @idfsParameterType as idfsParameterType

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
