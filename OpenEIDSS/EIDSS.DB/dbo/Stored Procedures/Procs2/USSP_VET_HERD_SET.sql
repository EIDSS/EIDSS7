-- ============================================================================
-- Name: USSP_VET_HERD_SET
--
-- Description:	Inserts or updates herd "snapshot" for the avian and livestock 
-- veterinary disease report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/01/2018 Initial release.
-- Stephen Long     03/28/2019 Changed from V6.1 get next number call to V7.
-- Stephen Long     04/10/2019 Split out the master (actual) and snapshot 
--                             sets.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VET_HERD_SET] (
	@LanguageID NVARCHAR(50),
	@HerdID BIGINT = NULL OUTPUT,
	@HerdMasterID BIGINT = NULL,
	@FarmID BIGINT = NULL,
	@EIDSSHerdID NVARCHAR(200) = NULL,
	@SickAnimalQuantity INT = NULL,
	@TotalAnimalQuantity INT = NULL,
	@DeadAnimalQuantity INT = NULL,
	@Note NVARCHAR(2000) = NULL,
	@RowStatus INT,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbHerd',
				@HerdID OUTPUT;

			EXECUTE dbo.USP_GBL_NextNumber_GET 'Animal Group',
				@EIDSSHerdID OUTPUT,
				NULL;

			INSERT INTO dbo.tlbHerd (
				idfHerd,
				idfHerdActual,
				idfFarm,
				strHerdCode,
				intSickAnimalQty,
				intTotalAnimalQty,
				intDeadAnimalQty,
				strNote,
				intRowStatus
				)
			VALUES (
				@HerdID,
				@HerdMasterID,
				@FarmID,
				@EIDSSHerdID,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Note,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbHerd
			SET idfHerdActual = @HerdMasterID,
				idfFarm = @FarmID,
				strHerdCode = @EIDSSHerdID,
				intSickAnimalQty = @SickAnimalQuantity,
				intTotalAnimalQty = @TotalAnimalQuantity,
				intDeadAnimalQty = @DeadAnimalQuantity,
				strNote = @Note,
				intRowStatus = @RowStatus
			WHERE idfHerd = @HerdID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
GO