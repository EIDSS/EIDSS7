
--*************************************************************
-- Name 				: USP_GBL_ASSESSIONTOACTION_SET
-- Description			: Inserts or Updates monitoring session actions related with specific session 
--          
-- Author: M.Jessee
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Michael Jessee	05/10/2018 Initial release.
-- ============================================================================



CREATE PROC	[dbo].[USP_GBL_ASSESSIONTOACTION_SET]
--	 @Action								INT				--##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	 @idfMonitoringSessionAction			bigint output	--##PARAM @idfMonitoringSessionAction - action record ID
	,@idfMonitoringSession					bigint			--##PARAM @idfMonitoringSession - sesson ID
	,@idfPersonEnteredBy					bigint			--##PARAM @idfPersonEnteredBy - ID of person that entered action record
	,@idfsMonitoringSessionActionType		bigint			--##PARAM @idfsMonitoringSessionActionType - session action Type , reference to rftMonitoringSessionActionType (19000127)
	,@idfsMonitoringSessionActionStatus		bigint			--##PARAM @idfsMonitoringSessionActionStatus - status of session action, reference to rftMonitoringSessionActionStatus (19000128)
	,@datActionDate							datetime		--##PARAM @datActionDate - date of session action
	,@strComments							nvarchar(500)	--##PARAM @strComments - expanded description of session action

AS    

DECLARE	@returnCode INT = 0
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS'

BEGIN    
	BEGIN TRY

	SET XACT_ABORT ON

		BEGIN TRANSACTION


			IF EXISTS (SELECT * FROM dbo.tlbMonitoringSessionAction WHERE idfMonitoringSessionAction = @idfMonitoringSessionAction AND intRowStatus = 0)
				BEGIN

					UPDATE   tlbMonitoringSessionAction
					SET		 idfMonitoringSessionAction = @idfMonitoringSessionAction
							,idfMonitoringSession = @idfMonitoringSession
							,idfPersonEnteredBy = @idfPersonEnteredBy
							,idfsMonitoringSessionActionType = @idfsMonitoringSessionActionType
							,idfsMonitoringSessionActionStatus = @idfsMonitoringSessionActionStatus
							,datActionDate = @datActionDate
							,strComments = @strComments
					WHERE 
							 idfMonitoringSessionAction = @idfMonitoringSessionAction	
							
				END

			ELSE
				BEGIN

					IF ISNULL(@idfMonitoringSessionAction,-1) < 0
						BEGIN
							EXEC USP_GBL_NEXTKEYID_GET 'tlbMonitoringSessionAction', @idfMonitoringSessionAction OUTPUT
						END
		
					INSERT INTO tlbMonitoringSessionAction
					       (
							idfMonitoringSessionAction
					       ,idfMonitoringSession
					       ,idfPersonEnteredBy
					       ,idfsMonitoringSessionActionType
					       ,idfsMonitoringSessionActionStatus
					       ,datActionDate
					       ,strComments
					       )
					 VALUES
					       (
							@idfMonitoringSessionAction
					       ,@idfMonitoringSession
					       ,@idfPersonEnteredBy
					       ,@idfsMonitoringSessionActionType
					       ,@idfsMonitoringSessionActionStatus
					       ,@datActionDate
					       ,@strComments
					       )
				END

    
		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT

		SELECT @returnCode, @returnMsg

	END TRY

	BEGIN CATCH

			-- Test XACT_STATE for 0, 1, or -1.

			-- Test whether the transaction is uncommittable.
			IF (XACT_STATE()) = -1
			BEGIN
				PRINT 'The transaction is in an uncommittable state.' +
					  ' Rolling back transaction.'
				ROLLBACK TRANSACTION;
			END;

			-- Test whether the transaction is active and valid.
			IF (XACT_STATE()) = 1
			BEGIN
				PRINT 'The transaction is committable.' + 
					  ' Committing transaction.'
				COMMIT TRANSACTION;   
			END;

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
			  'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			  + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			  + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			  + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			  + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			  + ' ErrorMessage: '+ ERROR_MESSAGE()
			  ----select @LogErrMsg

			SELECT @returnCode, @returnMsg

	END CATCH

END


