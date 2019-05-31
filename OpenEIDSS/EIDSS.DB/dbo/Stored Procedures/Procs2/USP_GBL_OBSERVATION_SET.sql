





-- ============================================================================
-- Name: USP_GBL_OBSERVATION_SET
-- Description:	Inserts or updates observation records for various use cases.
--
-- Author: Stephen Long
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/04/2018 Initial release.
-- LAMONT MITCHELL	1/17/19  Removed idfObservation as Output Parameter, Supressed SPs, and Aliased Return Columns
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_OBSERVATION_SET]
(
	@idfObservation						BIGINT = NULL, 
	@idfsFormTemplate					BIGINT = NULL, 
	@intRowStatus						INT, 
	@strMaintenanceFlag					NVARCHAR(20) = NULL,
	@idfsSite							BIGINT
)
AS

DECLARE @returnCode						INT = 0;
DECLARE	@returnMsg						NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @SupressSelect table
		( 
			retrunCode int,
			returnMessage varchar(200)
		)
    BEGIN TRY
		BEGIN TRANSACTION

		IF NOT EXISTS (SELECT * FROM dbo.tlbObservation WHERE idfObservation = @idfObservation AND intRowStatus = 0)
			BEGIN
			INSERT INTO @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbObservation', @idfObservation OUTPUT;

			INSERT INTO					dbo.tlbObservation
			(						
										idfObservation, 
										idfsFormTemplate, 
										intRowStatus, 
										strMaintenanceFlag, 
										idfsSite
			)
			VALUES
			(
										@idfObservation, 
										@idfsFormTemplate, 
										@intRowStatus, 
										@strMaintenanceFlag, 
										@idfsSite
				);
			END
		ELSE
			BEGIN
			UPDATE						dbo.tlbObservation
			SET 
										idfObservation = @idfObservation, 
										idfsFormTemplate = @idfsFormTemplate, 
										intRowStatus = @intRowStatus,
										strMaintenanceFlag = @strMaintenanceFlag, 
										idfsSite = @idfsSite 
			WHERE						idfObservation = @idfObservation;
			END

		IF @@TRANCOUNT > 0 AND @returnCode = 0
			COMMIT;

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfObservation 'idfObservation'
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
		RollBack Transaction
		THROW;
	END CATCH
END
