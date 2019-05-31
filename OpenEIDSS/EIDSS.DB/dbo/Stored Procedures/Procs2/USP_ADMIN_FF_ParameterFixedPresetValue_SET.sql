
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterFixedPresetValue_SET
-- Description: Insert or update Parameter Fixed Preset Values. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- Lamont Mitchell	01/02/18   Aliased Output columns, remobed Output declarations on @idfsParameterFixedPresetValue and added to Output in Select Statement
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterFixedPresetValue_SET] 
(
	@idfsParameterType BIGINT
	,@DefaultName NVARCHAR(400)	
	,@NationalName  NVARCHAR(600)	
	,@LangID NVARCHAR(50) = NULL
	,@intOrder INT = NULL
	,@idfsParameterFixedPresetValue BIGINT    
)	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' ;

		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)   

	BEGIN TRY

		IF (@LangID IS NULL)
			SET @LangID = 'en';
	
		IF (@idfsParameterFixedPresetValue < 0)
		
			INSERT INTO @SupressSelect
			EXEC dbo.[usp_sysGetNewID] @idfsParameterFixedPresetValue OUTPUT
	
		EXEC dbo.USP_GBL_BaseReference_SET @idfsParameterFixedPresetValue, 19000069, @LangID, @DefaultName, @NationalName, 0, @intOrder

		IF NOT EXISTS (SELECT TOP 1 1
					   FROM dbo.[ffParameterFixedPresetValue]
					   WHERE [idfsParameterFixedPresetValue] = @idfsParameterFixedPresetValue)
			BEGIN
				INSERT INTO dbo.[ffParameterFixedPresetValue]
					(
						[idfsParameterFixedPresetValue]
						,[idfsParameterType]
					)
				VALUES
					(
						@idfsParameterFixedPresetValue
						,@idfsParameterType			
					)
			END
		ELSE
			BEGIN
				UPDATE dbo.[ffParameterFixedPresetValue]
				SET [idfsParameterType] = @idfsParameterType
					,[intRowStatus] = 0
				WHERE [idfsParameterFixedPresetValue] = @idfsParameterFixedPresetValue
			END

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfsParameterFixedPresetValue 'idfsParameterFixedPresetValue'

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
