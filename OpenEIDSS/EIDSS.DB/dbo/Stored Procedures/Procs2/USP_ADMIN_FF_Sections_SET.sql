
-- ================================================================================================
-- Name: USP_ADMIN_FF_Sections_SET
-- Description: Save the sections.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Sections_SET] 
(
    @idfsParentSection BIGINT = NULL
    ,@idfsFormType BIGINT
    ,@DefaultName NVARCHAR(400)
    ,@NationalName NVARCHAR(600) = Null
    ,@LangID NVARCHAR(50) = Null
    ,@intOrder INT = 0
    ,@blnGrid BIT = 0
    ,@blnFixedRowset BIT = 0
	,@idfsMatrixType BIGINT = null
	,@idfsSection BIGINT OUTPUT
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
	
		IF (@LANGID IS NULL)
			SET @LangID = 'en';
	
		IF (@idfsSection <= 0) 
			EXEC dbo.[usp_sysGetNewID] @idfsSection OUTPUT
	
		IF (@idfsParentSection <= 0)
			SET @idfsParentSection = NULL;

		EXEC dbo.USP_GBL_BaseReference_SET @idfsSection, 19000101 /*'rftSection'*/, @LangID, @DefaultName, @NationalName, 0
	
		IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.ffSection WHERE idfsSection = @idfsSection)
			BEGIN
				INSERT INTO [dbo].[ffSection]
					(
			   			[idfsSection]
						,[idfsParentSection]
						,[idfsFormType]	
						,[intOrder]
						,[blnGrid]
						,[blnFixedRowSet]
						,[idfsMatrixType]
				   )
				VALUES
					(
			   			@idfsSection
						,@idfsParentSection
						,@idfsFormType
						,@intOrder
						,@blnGrid
						,@blnFixedRowset
						,@idfsMatrixType
					)
			END
		ELSE 
			BEGIN
				UPDATE [dbo].[ffSection]
				SET [idfsParentSection] = @idfsParentSection
					,[idfsFormType] = @idfsFormType	
					,[intOrder] = @intOrder
					,[blnGrid] = @blnGrid
					,[blnFixedRowSet] = @blnFixedRowset
					,[intRowStatus] = 0
					,[idfsMatrixType] = @idfsMatrixType
				WHERE [idfsSection] = @idfsSection
			END	

		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
