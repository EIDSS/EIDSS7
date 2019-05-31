----------------------------------------------------------------------------
-- Name 				: USP_ADMIN_BASEREF_SET
-- Description			: Insert/Update Base Reference Data
--          
-- Author               : Mandar Kulkarni
-- 
-- Revision History
-- Name				Date		Change Detail
--
-- Testing code:
--*/
----------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_ADMIN_BASEREF_SET] 
(
	@LangID		NVARCHAR(50), 
	@BaseRef	tlbBaseRefGetListSPType READONLY
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @returnCode							INT = 0;
	DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';

	DECLARE										@BaseRefTemp dbo.tlbBaseRefGetListSPType;
	INSERT INTO									@BaseRefTemp SELECT * FROM @BaseRef;

	DECLARE @idfsBasereference				BIGINT, 
			@idfsReferenceType				BIGINT, 
			@DefaultName					VARCHAR(2000), -- Default reference name, used if there is no reference translation
			@NationalName					NVARCHAR(2000), -- Reference name in the language defined by @LangID
			@HACode							INT = NULL, -- Bit mask for reference using
			@Order							INT = NULL, -- Reference record order for sorting
			@System							BIT = 0,
			@strMaintenanceFlag				NVARCHAR(20) = NULL, 
			@RecordAction					NCHAR(1) = NULL,
			@RecordID						BIGINT = NULL

	BEGIN TRY
			WHILE EXISTS					(SELECT * FROM @BaseRefTemp)
			BEGIN
				SELECT TOP 1				@RecordID = RecordID,
											@idfsBaseReference = idfsBaseReference,
											@idfsReferenceType = idfsReferenceType,
											@DefaultName = DefaultName, 
											@NationalName= NationalName, 
											@HACode = HACode, 
											@Order = [Order],
											@System = [System],
											@strMaintenanceFlag = strMaintenanceFlag, 
											@RecordAction = RecordAction
				FROM						@BaseRefTemp

				IF							@RecordAction = 'D'
					BEGIN
						EXEC					dbo.USSP_ADMIN_BASEREF_DEL @idfsBaseReference;
					END
				ELSE
					BEGIN
						EXEC					dbo.USSP_ADMIN_BASEREF_SET 
												@LangID, 
												@idfsBaseReference OUTPUT,
												@idfsReferenceType,
												@DefaultName,
												@NationalName,
												@HACode,
												@Order,
												@System,
												@strMaintenanceFlag,
												@RecordAction
					END
				
				DELETE FROM					@BaseRefTemp WHERE RecordID = @RecordID;
			END;

		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT;

		SELECT @returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		IF @@Trancount = 1 
			ROLLBACK;

		SET									@returnCode = ERROR_NUMBER();
		SET									@returnMsg = ' ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
												+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
												+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
												+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A')
												+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), 'N/A'))
												+ ' ErrorMessage: ' + ERROR_MESSAGE() 
												+ ' State: ' + CONVERT(VARCHAR, ISNULL(XACT_STATE(), 'N/A'));

		SELECT								@returnCode, @returnMsg;
	END CATCH;
END

