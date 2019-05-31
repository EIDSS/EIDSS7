
-- ============================================================================
-- Name: USP_VCTS_VECT_ACTIVITYPARAMETERS_SET
-- Description:	Inserts or updates vector activityparametes
-- create vector surveillance session use case.
--                      
-- Author: Harold Pryor
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Harold Pryor     04/30/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VCTS_VECT_ACTIVITYPARAMETERS_SET]
(
	@idfsParameter Bigint
	,@idfObservation Bigint  
	,@idfsFormTemplate Bigint   
    ,@varValue Sql_variant
	,@idfRow Bigint Output
    ,@IsDynamicParameter Bit = 0
	,@idfActivityParameters BIGINT = NULL OUTPUT
)	
AS
BEGIN	

DECLARE @returnCode							INT = 0;
DECLARE	@returnMsg							NVARCHAR(MAX) = 'SUCCESS';

DECLARE @intRowStatus INT = 0

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;
    BEGIN TRY
		BEGIN TRANSACTION;

			IF NOT EXISTS (	SELECT idfActivityParameters FROM [dbo].[tlbActivityParameters])
			BEGIN
				EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbActivityParameters',@idfActivityParameters OUTPUT
	
					 
					 Insert into [dbo].[tlbActivityParameters]
							 (
							 		idfActivityParameters
			   						,[idfsParameter]
									,[idfObservation]
									,[varValue]
									,[idfRow]
									,[intRowStatus]		
							)
					VALUES
							(
									@idfActivityParameters
									,@idfsParameter
									,@idfObservation
									,@varValue
									,@idfRow
									,@intRowStatus
							)
			End
			 Else BEGIN
				   Update [dbo].[tlbActivityParameters]
							   SET 								
									[varValue] = @varValue
									,[intRowStatus] = 0									
								WHERE [idfsParameter] = @idfsParameter And [idfObservation] = @idfObservation And [idfRow] = @idfRow
			End
		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT;

		SELECT @returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		IF @@Trancount = 1 
			ROLLBACK;

		SET @returnCode = ERROR_NUMBER();
		SET @returnMsg = 
			' ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
		  + ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
		  + ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
		  + ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A')
		  + ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), 'N/A'))
		  + ' ErrorMessage: ' + ERROR_MESSAGE() 
		  + ' State: ' + CONVERT(VARCHAR, ISNULL(XACT_STATE(), 'N/A'));

		SELECT @returnCode, @returnMsg;
	END CATCH
END
END

