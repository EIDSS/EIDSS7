
--*************************************************************************
-- Name 				: USP_GBL_AppSessionLog_SET
-- Description			: Write to AppSessionLogLog table
--          
-- Author               : Mark Wilson
-- Revision History
--		Name       Date       Change Detail
--
-- This is only an insert stored proc.
-- Testing code:
--*************************************************************************

CREATE PROCEDURE [dbo].[USP_GBL_AppSessionLog_SET]
	(
		@AppSessionLogUID			BIGINT OUTPUT,
		@AppSessionID				VARCHAR(100),
		@AppModuleGroupID			BIGINT,
		@ModuleConstantID			BIGINT,
		@SessionBeginDTM			DATETIME = NULL,
		@SessionEndDTM				DATETIME = NULL,
		@SessionStatus				VARCHAR(20),
		@SessionDetailDataXML		XML,
		@idfAppUserID				BIGINT,
		@idfSiteID					BIGINT
	)

AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		IF @AppSessionLogUID IS NOT NULL AND LEN(@AppSessionLogUID) > 0 -- If a valid AppSessionLogUID is passed perform the update
		BEGIN
			UPDATE dbo.AppSessionLog
			SET SessionEndDTM = @SessionEndDTM

		END
		
		ELSE
		IF ISNULL(@AppSessionLogUID, -1) < 0 -- This is an Insert
		BEGIN
			EXEC USP_GBL_NEXTKEYID_GET 'AppSessionLog', @AppSessionLogUID OUTPUT
			

			IF @SessionBeginDTM IS NULL
				SET @SessionBeginDTM = GETDATE()

			INSERT
			INTO dbo.AppSessionLog
			(
				AppSessionLogUID,
				AppSessionID,
				AppModuleGroupID,
				ModuleConstantID,
				SessionBeginDTM,
				SessionEndDTM,
				SessionStatus,
				SessionDetailDataXML,
				idfAppUserID,
				idfSiteID,
				AuditCreateDTM
			)
			VALUES
			(	
				@AppSessionLogUID,
				@AppSessionID,
				@AppModuleGroupID,
				@ModuleConstantID,
				@SessionBeginDTM,
				NULL,
				@SessionStatus,
				@SessionDetailDataXML,
				@idfAppUserID,
				@idfSiteID,
				GETDATE()
			)
		END

		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT

		SELECT @returnCode, @returnMsg

	END TRY
	BEGIN CATCH
			IF @@Trancount = 1 
				ROLLBACK
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg = 
			   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			   + ' ErrorMessage: '+ ERROR_MESSAGE()

			  SELECT @returnCode, @returnMsg

	END CATCH
END
